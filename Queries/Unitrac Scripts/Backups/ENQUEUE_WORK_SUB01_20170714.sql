USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[ENQUEUE_WORK]    Script Date: 7/15/2017 12:41:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ENQUEUE_WORK](
@processDefinitionId BIGINT, 
@capabilityRequirements BIGINT, 
@targetServiceName NVARCHAR(100),
@updateUser NVARCHAR(100))
AS BEGIN

	DECLARE 
	@InitDlgHandle UNIQUEIDENTIFIER,
	@queue_name NVARCHAR(100),
	@queueSql1 NVARCHAR(2000),
	@counts int = 0;

	--Get the queue associated with the input service
	SELECT @queue_name = ServiQueue.name 
	FROM sys.services AS Servi
	INNER JOIN sys.service_queue_usages AS SerQueueUse ON SerQueueUse.service_id = Servi.service_id
	INNER JOIN sys.service_queues AS ServiQueue ON ServiQueue.object_id=SerQueueUse.service_queue_id
	WHERE UPPER(Servi.name) = UPPER(@targetServiceName)

	SET @queueSql1 = '
		SELECT @cnt=COUNT(*)
		FROM ' + CONVERT(VARCHAR(100),@queue_name) + ' AS t1
		WHERE CAST(t1.MESSAGE_BODY AS XML).value(N''(/MsgRoot/Id/node())[1]'', N''bigint'') = ' + CONVERT(VARCHAR(100),@processDefinitionId) + ''

		EXECUTE sp_executesql @queueSql1, N'@cnt int OUTPUT',  @cnt=@counts OUTPUT

	IF @counts = 0
	BEGIN
		BEGIN TRANSACTION;

		BEGIN TRY
			
			BEGIN DIALOG CONVERSATION @InitDlgHandle
				 FROM SERVICE [//UNITRAC/StatusService] 
				 TO SERVICE @targetServiceName
				 ON CONTRACT [//UNITRAC/Contract]
				 WITH ENCRYPTION = OFF;

			DECLARE @requestMsg NVARCHAR(256)
			SELECT @requestMsg = N'<MsgRoot>' + N'<Capability>' + CAST(@capabilityRequirements AS NVARCHAR(50)) + N'</Capability>' + N'<Id>' + CAST(@processDefinitionId AS NVARCHAR(50)) + N'</Id>' + N'</MsgRoot>';

			SEND ON CONVERSATION @InitDlgHandle 
			MESSAGE TYPE [//UNITRAC/RequestMessage] 
			(@requestMsg);

			--Set ProcessDefinition to InQueue status for the Distributor to pick up for processing
			UPDATE PROCESS_DEFINITION 
			SET STATUS_CD = 'InQueue', 
			LAST_PROCESS_HEARTBEAT_DT = NULL, 
			CONVERSATION_HANDLE_GUID = NULL,
			UPDATE_DT = GETDATE(),
			UPDATE_USER_TX = @updateUser,
			LOCK_ID = (LOCK_ID % 255) + 1
			WHERE ID = @processDefinitionId;
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;

			
			DECLARE @ErrorMessage NVARCHAR(1000) = 'ROLLBACK occured for ENQUEUE_WORK. NO RECORDS Updated for PD : ' + CAST(ISNULL(@processDefinitionId,'') AS NVARCHAR(50))

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
END
