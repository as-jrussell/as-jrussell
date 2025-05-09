USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[RECEIVE_WORK]    Script Date: 7/15/2017 12:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[RECEIVE_WORK]
(@serviceCapabilityMask BIGINT = NULL,
@service_name nvarchar(100),
@updateUser nvarchar(100))
AS BEGIN

DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER,
		@RecvReqMsg XML,
		@messageType int,
		@queue_name NVARCHAR(100),
		@Sql NVARCHAR(2000),
		@queueSql1 NVARCHAR(2000),
		@queueSql2 NVARCHAR(2000),
		@pid BIGINT,
		@selectedConversationHandle UNIQUEIDENTIFIER,
		@conversationhandle UNIQUEIDENTIFIER;

DECLARE @CONVERSATION TABLE
(CONVERSATION_HANDLE UNIQUEIDENTIFIER NOT NULL,
PID BIGINT NOT NULL,
[PRIORITY] TINYINT NULL)

IF @serviceCapabilityMask IS NULL
RETURN

--Get the queue associated with the input service
SELECT @queue_name = ServiQueue.name 
FROM sys.services AS Servi
INNER JOIN sys.service_queue_usages AS SerQueueUse ON SerQueueUse.service_id = Servi.service_id
INNER JOIN sys.service_queues AS ServiQueue ON ServiQueue.object_id=SerQueueUse.service_queue_id
WHERE UPPER(Servi.name) = UPPER(@service_name)


BEGIN TRANSACTION;

BEGIN TRY

	BEGIN 
		--Retrieve all the queue entries that meet the capability requirement, do not order this SQL due to row locking constraints against the queue
		SET @queueSql1 = '
		SELECT 
			t1.CONVERSATION_HANDLE, 
			CAST(t1.MESSAGE_BODY AS XML).value(N''(/MsgRoot/Id/node())[1]'', N''bigint''),
			PD.PROC_PRIORITY_NO
		FROM ' + CONVERT(VARCHAR(100),@queue_name) + ' AS t1
		JOIN PROCESS_DEFINITION PD ON CAST(t1.MESSAGE_BODY AS XML).value(N''(/MsgRoot/Id/node())[1]'', N''bigint'') = PD.ID
		WHERE CAST(t1.MESSAGE_BODY AS XML).value(N''(/MsgRoot/Capability/node())[1]'', N''bigint'') | ' + CONVERT(VARCHAR(100),@serviceCapabilityMask) + ' =   '+ CONVERT(VARCHAR(100),@serviceCapabilityMask) + ''

		INSERT INTO @CONVERSATION
		EXECUTE sp_executesql @queueSql1

		--Retrieve the first conversation based on the priority setting
		SELECT TOP(1) @selectedConversationHandle = CONVERSATION_HANDLE, @pid = PID
		FROM @CONVERSATION C
		ORDER BY [PRIORITY]

		--Select the record from the queue in order to obtain an exclusive lock.  This can not run against the TargetQueue_View as a lock will be placed on Process_Definition
		SET @queueSql2 = 'select @conversationhandle = conversation_handle
		FROM ' + CONVERT(VARCHAR(100),@queue_name) + ' WITH (ROWLOCK,XLOCK,READPAST)
		WHERE conversation_handle = ''' + CONVERT(VARCHAR(100), @selectedConversationHandle) + ''''

		EXECUTE sp_executesql @queueSql2, N'@conversationhandle UNIQUEIDENTIFIER OUTPUT', @conversationhandle = @conversationhandle OUTPUT

		--Execute the Sevice Broker receive command to pull the record off the queue
		SET @Sql = 'WAITFOR( RECEIVE TOP(1) 
		  @RecvReqDlgHandle = conversation_handle,
		  @messageType = message_type_id,
		  @RecvReqMsg = message_body
		  FROM ' + CONVERT(VARCHAR(100),@queue_name) + '
		  WHERE conversation_handle = ''' + CONVERT(VARCHAR(100), @selectedConversationHandle) + '''), TIMEOUT 100;'

		EXECUTE sp_executesql @Sql
		,N'@RecvReqDlgHandle UNIQUEIDENTIFIER OUTPUT,@messageType int OUTPUT,@RecvReqMsg XML OUTPUT'
		,@RecvReqDlgHandle = @RecvReqDlgHandle OUTPUT
		,@messageType = @messageType OUTPUT
		,@RecvReqMsg = @RecvReqMsg OUTPUT

	END

	SELECT @selectedConversationHandle, @RecvReqMsg AS ReceivedRequestMsg;

	--Update ProcessDefinition status to InProcess.  Conversation_Handle is set for failure processing, and last_heartbeat is set to ensure process is Alive
	UPDATE PROCESS_DEFINITION SET 
		STATUS_CD = 'InProcess',
		CONVERSATION_HANDLE_GUID = @selectedConversationHandle,
		LAST_PROCESS_HEARTBEAT_DT = GETDATE(),
		UPDATE_DT = GETDATE(),
		UPDATE_USER_TX = @updateUser,
		LOCK_ID = (LOCK_ID % 255) + 1
	WHERE ID = @pid;

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;	

	DECLARE @ErrorMessage NVARCHAR(1000) = 'ROLLBACK occured for RECEIVE_WORK. NO RECORDS Updated for PD : ' + CAST(ISNULL(@pid,'') AS NVARCHAR(50))
	RAISERROR (@ErrorMessage, 16, 1) WITH LOG

	SELECT 
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() as ErrorState,
	ERROR_PROCEDURE() as ErrorProcedure,
	ERROR_LINE() as ErrorLine,
	ERROR_MESSAGE() as ErrorMessage;
END CATCH;
		
IF @@TRANCOUNT > 0
	COMMIT TRANSACTION;

END
