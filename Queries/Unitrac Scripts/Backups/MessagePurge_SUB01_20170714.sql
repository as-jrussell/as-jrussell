USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[MessagePurge]    Script Date: 7/15/2017 12:48:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MessagePurge] (@LFPMOffset AS INTEGER = NULL,
	 @EDIMoffset AS INTEGER = NULL,
	 @DODELETE AS INTEGER = 0,
	 @Batchsize AS INTEGER = NULL,
	 @retrycount AS INTEGER = NULL,
	 @RunDuration AS INTEGER = NULL,
	 @OffsetUnit AS VARCHAR(10) = NULL,
	 @RunOnSubscriber AS INTEGER = 0,
	 @process_log_id BIGINT = NULL OUTPUT

	 )
AS
BEGIN
  SET NOCOUNT ON
 --Set the options to support indexed views.
  SET NUMERIC_ROUNDABORT OFF;
  SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
      QUOTED_IDENTIFIER, ANSI_NULLS ON;
  --SET XACT_ABORT ON

  -- Set deadlock priority low so this process is always the deadlock victim
  SET DEADLOCK_PRIORITY LOW

  -- For replication - if we are not on publisher
  --  and @RunOnSubscriber is not set, invoke MessagePurge job and exit
  IF @@SERVERNAME <> 'UNITRAC-DB01' AND @RunOnSubscriber <> 1
  BEGIN
		IF NOT EXISTS(SELECT 1
					FROM msdb.dbo.sysjobs_view job
					INNER JOIN msdb.dbo.sysjobactivity activity ON job.job_id = activity.job_id
					WHERE
						activity.run_Requested_date IS NOT NULL
					AND activity.stop_execution_date IS NULL
					AND job.name = 'MessagePurge'
					)
		BEGIN
			PRINT 'Starting job MessagePurge';
	  EXEC msdb..sp_start_job 'MessagePurge'
		END
		ELSE
		BEGIN
			PRINT 'MessagePurge Job is already started '
		END
	  RETURN 0
  END

	---- message cleanup


	-- Create temp tables for holding IDs of records to be deleted

		CREATE TABLE #delMessageTempTable(
			[PrimaryKeyID] BIGINT NOT NULL,
			[ObjectType] NVARCHAR(100) NOT NULL,
			[ObjectDescription] NVARCHAR(500) NULL,
			MESSAGE_DIRECTION_CD NCHAR(1) NOT NULL
		)

		CREATE TABLE #delChildTempTable(
			[PrimaryKeyID] BIGINT NOT NULL,
			[ObjectType] NVARCHAR(100) NOT NULL,
			[ObjectDescription] NVARCHAR(500) NULL
		)

		CREATE TABLE #delDocumentTempTable(
			[PrimaryKeyID] BIGINT NOT NULL,
			[ObjectType] NVARCHAR(100) NOT NULL,
			[ObjectDescription] NVARCHAR(500) NULL
		)

		CREATE TABLE #delWorkItemTempTable(
			[PrimaryKeyID] BIGINT NOT NULL,
			[ObjectType] NVARCHAR(100) NOT NULL,
			[ObjectDescription] NVARCHAR(500) NULL
		)

		CREATE TABLE #delLOAN_EXTRACT_TRANSACTION_DETAIL(
			[ID] BIGINT NOT NULL PRIMARY KEY
		)

		CREATE TABLE #delINSURANCE_EXTRACT_TRANSACTION_DETAIL(
			[ID] BIGINT NOT NULL PRIMARY KEY
		)

		CREATE TABLE #delCOLLATERAL_EXTRACT_TRANSACTION_DETAIL(
			[ID] BIGINT NOT NULL PRIMARY KEY
		)

		CREATE TABLE #delOWNER_EXTRACT_TRANSACTION_DETAIL(
			[ID] BIGINT NOT NULL PRIMARY KEY
		)

		CREATE TABLE #delProcessLogTempTable(
			[ID] BIGINT NOT NULL
		)

		CREATE TABLE #delProcessLogItemTempTable(
			[ID] BIGINT NOT NULL PRIMARY KEY
		)

	--- remove lfp messages

	-------	message (inbound and outbound)
	------- document
	------- transaction
	------- LOAN_EXTRACT_TRANSACTION_DETAIL
	------- INSURANCE_EXTRACT_TRANSACTION_DETAIL
	------- blob
	------- RELATED DATA
	------- work item
	------- work item action
	------- TRADING_PARTNER_LOG

   --- remove only blobs for edi messages

	declare @lfpcreatedate datetime
	declare @edicreatedate datetime
--	declare @process_log_id bigint
	declare @Process_Definition_ID bigint
	declare @now datetime

	--- Get setting for parameters from PROCESS_DEFINITON if explicit values not provided
	---   to parameters
	select
		@Process_Definition_ID = ID,
		@BatchSize = case when @BatchSize is null
		                  then SETTINGS_XML_IM.value('(/Settings/@BatchSize)[1]', 'int')
						  else @BatchSize end,
		@RetryCount = case when @RetryCount is null
		                  then SETTINGS_XML_IM.value('(/Settings/@RetryCount)[1]', 'int')
						  else @RetryCount end,
		@LFPMOffset = case when @LFPMOffset is null
		                  then SETTINGS_XML_IM.value('(/Settings/@LFPMOffset)[1]', 'int')
						  else @LFPMOffset end,
		@EDIMOffset = case when @EDIMOffset is null
		                  then SETTINGS_XML_IM.value('(/Settings/@EDIMOffset)[1]', 'int')
						  else @EDIMOffset end,
		@RunDuration = case when @RunDuration is null
		                  then SETTINGS_XML_IM.value('(/Settings/@RunDuration)[1]', 'int')
						  else @RunDuration end,
		@OffsetUnit = case when @OffsetUnit is null
		                  then SETTINGS_XML_IM.value('(/Settings/@OffsetUnit)[1]', 'varchar')
						  else @OffsetUnit end


		from PROCESS_DEFINITION
		where NAME_TX = 'Message Purge'
		  and PROCESS_TYPE_CD = 'MSGPURGE'

    if @OffsetUnit = 'Day'
	begin
		set @lfpcreatedate = convert(date, dateadd(day, 1, dateadd(day, @LFPMOffset, getdate())))
		set @edicreatedate = convert(date, dateadd(day, 1, dateadd(day, @EDIMOffset, getdate())))
	end
	else if @OffsetUnit = 'Week'
	begin
		set @lfpcreatedate = convert(date, dateadd(day, 1, dateadd(week, @LFPMOffset, getdate())))
		set @edicreatedate = convert(date, dateadd(day, 1, dateadd(week, @EDIMOffset, getdate())))
	end
	else -- default to months
	begin
		set @lfpcreatedate = convert(date, dateadd(day, 1, dateadd(month, @LFPMOffset, getdate())))
		set @edicreatedate = convert(date, dateadd(day, 1, dateadd(month, @EDIMOffset, getdate())))
	end

	set @now = getdate()

	print 'Lender File Message offset: ' + Convert(varchar(20),@LFPMOffset)
	print 'EDI Message offset: ' + Convert(varchar(20), @EDIMOffset)

	print 'Lender File Message Create Date: ' + Convert(varchar(20), @lfpcreatedate, 120)
	print 'EDI Message Create Date: ' + Convert(varchar(20), @edicreatedate, 120)

	if @LFPMOffset > -1 or @EDIMOffset > -1
	begin
		Print '-----Error: offset in valid: can not be greater than -1 and -1'
		return
	end

	select 'Process_Definition_id' = @Process_Definition_id

	--- Log the running of this purge process instance
	if @@SERVERNAME = 'Unitrac-DB01'
	begin
		INSERT PROCESS_LOG
			(PROCESS_DEFINITION_ID,
			 START_DT,
			 STATUS_CD,
			 MSG_TX,
			 CREATE_DT,
			 UPDATE_DT,
			 UPDATE_USER_TX,
			 LOCK_ID)
		VALUES (@Process_Definition_ID,
				@now,
				N'InProcess',
				N'Message Purge. LFPMOffset: ' + convert(nvarchar(20), @LFPMOffset)
								+ N'. LFPMDateThreshold: ' + convert(nvarchar(10), @lfpcreatedate, 120)
								+ N'. EDIMOffset: ' + convert(nvarchar(20), @EDIMOffset)
								+ N'. EDIMDateThreshold: ' + convert(nvarchar(10), @edicreatedate, 120)
								+ N'. Batch Size: '+ convert(nvarchar(20), @BatchSize)
								+ N'. RetryCount: ' + convert(nvarchar(20), @RetryCount)
								+ N'. RunDuration: ' + convert(nvarchar(20), @RunDuration)
								+ N'. OffsetUnit: ' + convert(nvarchar(20), @OffsetUnit),
				@now,
				@now,
				convert(nvarchar(15), suser_sname()),
				1)
	end
	else
	begin
		INSERT PURGE_LOG
			(PROCESS_DEFINITION_ID,
			 START_DT,
			 STATUS_CD,
			 MSG_TX,
			 CREATE_DT,
			 UPDATE_DT,
			 UPDATE_USER_TX,
			 LOCK_ID)
		VALUES (@Process_Definition_ID,
				@now,
				N'InProcess',
				N'Message Purge. LFPMOffset: ' + convert(nvarchar(20), @LFPMOffset)
								+ N'. LFPMDateThreshold: ' + convert(nvarchar(10), @lfpcreatedate, 120)
								+ N'. EDIMOffset: ' + convert(nvarchar(20), @EDIMOffset)
								+ N'. EDIMDateThreshold: ' + convert(nvarchar(10), @edicreatedate, 120)
								+ N'. Batch Size: '+ convert(nvarchar(20), @BatchSize)
								+ N'. RetryCount: ' + convert(nvarchar(20), @RetryCount)
								+ N'. RunDuration: ' + convert(nvarchar(20), @RunDuration),
				@now,
				@now,
				convert(nvarchar(15), suser_sname()),
				1)
	end

	select @process_log_id = scope_identity()

	select @process_log_id as '@process_log_id'


	--- Capture IDs of records to be deleted
	----------------------------------------------------------------------
	---- INBOUND MESSAGE
	INSERT INTO #delMessageTempTable(ObjectType,PrimaryKeyID,ObjectDescription, MESSAGE_DIRECTION_CD )
		SELECT
			'MESSAGE',
			M.ID,
			'TYPE: ' + TP.TYPE_CD
			+ ', DIRECTION: ' + M.MESSAGE_DIRECTION_CD
			+ ', RELATE_ID: ' + M.RELATE_ID_TX
			+ ', RELATE_CLASS: ' + M.RELATE_TYPE_CD,
			M.MESSAGE_DIRECTION_CD
		FROM
			DBO.MESSAGE M
			INNER JOIN DBO.TRADING_PARTNER TP
			ON TP.ID=M.RECEIVED_FROM_TRADING_PARTNER_ID
		WHERE
			M.MESSAGE_DIRECTION_CD = 'I'
			AND TP.TYPE_CD = 'LFP_TP'
			AND M.CREATE_DT < @LFPCREATEDATE

--exclude EDI messages. This is the reason the code is commented out
--	INSERT INTO #delObjTempTable(ObjectType,PrimaryKeyID,ObjectDescription)
--		SELECT
--			'MESSAGE',
--			M.ID,
--			'TYPE: ' + TP.TYPE_CD
--			+ ', DIRECTION: ' + M.MESSAGE_DIRECTION_CD
--			+ ', RELATE_ID: ' + M.RELATE_ID_TX
--			+ ', RELATE_CLASS: ' + M.RELATE_TYPE_CD
--		FROM
--			DBO.MESSAGE M
--			INNER JOIN DBO.TRADING_PARTNER TP ON TP.ID=M.RECEIVED_FROM_TRADING_PARTNER_ID
--		WHERE
--			M.MESSAGE_DIRECTION_CD = 'I'
--			AND TP.TYPE_CD = 'EDI_TP'
--			AND M.CREATE_DT <= @EDICREATEDATE

	---- RELATED OUTBOUND MESSAGE
	INSERT INTO #delMessageTempTable(ObjectType,PrimaryKeyID,ObjectDescription, MESSAGE_DIRECTION_CD )
		SELECT
			'MESSAGE',
			M.ID,
			'TYPE: ' + TP.TYPE_CD
			+ ', DIRECTION: ' + M.MESSAGE_DIRECTION_CD
			+ ', RELATE_ID: ' + M.RELATE_ID_TX
			+ ', RELATE_CLASS: ' + M.RELATE_TYPE_CD,
			M.MESSAGE_DIRECTION_CD
		FROM
			DBO.MESSAGE M
			INNER JOIN DBO.TRADING_PARTNER TP
			ON TP.ID=M.RECEIVED_FROM_TRADING_PARTNER_ID
			INNER JOIN #delMessageTempTable OTT
			ON OTT.PrimaryKeyID = M.RELATE_ID_TX
			AND OTT.ObjectType = 'MESSAGE'
		WHERE
			M.MESSAGE_DIRECTION_CD = 'O'
			AND M.RELATE_TYPE_CD = 'MESSAGE'
			AND TP.TYPE_CD = 'LFP_TP'
			AND M.CREATE_DT < @LFPCREATEDATE

	----------------------------------------------------------------------
	---- TRADING_PARTNER_LOG
	INSERT INTO #delChildTempTable(ObjectType,PrimaryKeyID,ObjectDescription)
		SELECT
			'TRADING_PARTNER_LOG',
			TPL.ID,
			'LOG_TYPE_CD: ' + TPL.LOG_TYPE_CD
			+ 'LOG_SEVERITY_CD: ' + TPL.LOG_SEVERITY_CD
			+ ', MESSAGE_ID: ' + CONVERT(VARCHAR(20), TPL.MESSAGE_ID)
		FROM
			DBO.TRADING_PARTNER_LOG TPL
			INNER JOIN #delMessageTempTable OTT
			ON OTT.PrimaryKeyID = TPL.MESSAGE_ID
			AND OTT.ObjectType = 'MESSAGE'

	----------------------------------------------------------------------
	---- DOCUMENT
	INSERT INTO #delDocumentTempTable(ObjectType,PrimaryKeyID,ObjectDescription)
		SELECT
			'DOCUMENT',
			D.ID,
			'NAME_TX: ' + D.NAME_TX
			+ ', MESSAGE_ID: ' + CONVERT(VARCHAR(20), D.MESSAGE_ID)
		FROM
			DBO.DOCUMENT D
			INNER JOIN #delMessageTempTable OTT
			ON OTT.PrimaryKeyID = D.MESSAGE_ID
			AND OTT.ObjectType = 'MESSAGE'

	----------------------------------------------------------------------
	---- TRANSACTION
	INSERT INTO #delChildTempTable(ObjectType,PrimaryKeyID,ObjectDescription)
		SELECT
			'TRANSACTION',
			T.ID,
			'DOCUMENT_ID: ' + CONVERT(VARCHAR(20), T.DOCUMENT_ID)
		FROM
			DBO.[TRANSACTION] T
			INNER JOIN #delDocumentTempTable OTT
			ON OTT.PrimaryKeyID = T.DOCUMENT_ID
			AND OTT.ObjectType = 'DOCUMENT'

	----------------------------------------------------------------------
	---- BLOBS
	INSERT INTO #delChildTempTable(ObjectType,PrimaryKeyID,ObjectDescription)
		SELECT
			'BLOB',
			B.ID,
			'DOCUMENT_ID: ' + CONVERT(VARCHAR(20), B.RELATE_ID_TX)
		FROM
			DBO.BLOB B
			INNER JOIN #delDocumentTempTable OTT
			ON OTT.PrimaryKeyID = B.RELATE_ID_TX
			AND OTT.ObjectType = 'DOCUMENT'
			and B.RELATE_TYPE_CD = 'DOCUMENT'

	----------------------------------------------------------------------
	---- EDI message blobs only
	INSERT INTO #delMessageTempTable(ObjectType,PrimaryKeyID,ObjectDescription, MESSAGE_DIRECTION_CD)
		SELECT
			'EDIBLOB',
			B.ID,
			'DOCUMENT_ID: ' + CONVERT(VARCHAR(20), B.RELATE_ID_TX),
			M.MESSAGE_DIRECTION_CD
		FROM
         DBO.BLOB B
         INNER JOIN DBO.DOCUMENT D ON D.ID = B.DOCUMENT_ID
			INNER JOIN DBO.MESSAGE M
			ON M.ID = D.MESSAGE_ID
			INNER JOIN DBO.TRADING_PARTNER TP
			ON TP.ID=M.RECEIVED_FROM_TRADING_PARTNER_ID
		WHERE
			M.MESSAGE_DIRECTION_CD = 'I'
			AND TP.TYPE_CD = 'EDI_TP'
			AND M.CREATE_DT < @EDICREATEDATE

	----------------------------------------------------------------------
	---- BSS message blobs only
	INSERT INTO #delMessageTempTable(ObjectType,PrimaryKeyID,ObjectDescription, MESSAGE_DIRECTION_CD)
		SELECT
			'BSSBLOB',
			B.ID,
			'DOCUMENT_ID: ' + CONVERT(VARCHAR(20), B.RELATE_ID_TX),
			M.MESSAGE_DIRECTION_CD
		FROM
         DBO.BLOB B
         INNER JOIN DBO.DOCUMENT D ON D.ID = B.DOCUMENT_ID
			INNER JOIN DBO.MESSAGE M ON M.ID = D.MESSAGE_ID
			INNER JOIN DBO.TRADING_PARTNER TP ON TP.ID=M.RECEIVED_FROM_TRADING_PARTNER_ID
         LEFT JOIN DBO.[TRANSACTION] T ON T.DOCUMENT_ID = D.ID
		WHERE
			M.MESSAGE_DIRECTION_CD = 'I'
			AND TP.TYPE_CD = 'BSS_TP'
			AND (T.STATUS_CD = 'SENT' or T.STATUS_CD is NULL)
			AND M.CREATE_DT < @EDICREATEDATE
			AND B.ID <> 11601032 -- this is a bad BLOB record that's raising an 852 error when attempting to delete it.
		OPTION(MAXDOP 1)

	---- RELATED_DATA
	INSERT INTO #delChildTempTable(ObjectType,PrimaryKeyID,ObjectDescription)
		SELECT
			'RELATED_DATA',
			RD.ID,
			'RELATE_ID: ' + CONVERT(VARCHAR(20), RD.RELATE_ID)
			+ ', RELATE_TYPE: ' + RDD.RELATE_CLASS_NM
			+ ', DEF_ID: ' + CONVERT(VARCHAR(20), RD.DEF_ID)
		FROM
			DBO.RELATED_DATA RD
			INNER JOIN DBO.RELATED_DATA_DEF RDD
			ON RDD.ID = RD.DEF_ID
			AND RDD.RELATE_CLASS_NM = 'MESSAGE'
			INNER JOIN #delMessageTempTable OTT
			ON OTT.PrimaryKeyID = RD.RELATE_ID
			AND OTT.ObjectType = 'MESSAGE'

	INSERT INTO #delChildTempTable(ObjectType,PrimaryKeyID,ObjectDescription)
		SELECT
			'RELATED_DATA',
			RD.ID,
			'RELATE_ID: ' + CONVERT(VARCHAR(20), RD.RELATE_ID)
			+ ', RELATE_TYPE: ' + RDD.RELATE_CLASS_NM
			+ ', DEF_ID: ' + CONVERT(VARCHAR(20), RD.DEF_ID)
		FROM
			DBO.RELATED_DATA RD
			INNER JOIN DBO.RELATED_DATA_DEF RDD
			ON RDD.ID = RD.DEF_ID
			AND RDD.RELATE_CLASS_NM = 'DOCUMENT'
			INNER JOIN #delDocumentTempTable OTT
			ON OTT.PrimaryKeyID = RD.RELATE_ID
			AND OTT.ObjectType = 'DOCUMENT'


	----------------------------------------------------------------------
	---- WORK ITEM
	INSERT INTO #delWorkItemTempTable(ObjectType,PrimaryKeyID,ObjectDescription)
		SELECT
			'WORK_ITEM',
			WI.ID,
			'RELATE_ID: ' + CONVERT(VARCHAR(20), WI.RELATE_ID)
			+ ', RELATE_TYPE: ' + WI.RELATE_TYPE_CD
		FROM
			DBO.WORK_ITEM WI
			INNER JOIN DBO.WORKFLOW_DEFINITION WFD
			ON WFD.WORKFLOW_TYPE_CD = 'LenderExtract'
			AND WFD.ID = WI.WORKFLOW_DEFINITION_ID
			INNER JOIN #delMessageTempTable OTT
			ON OTT.PrimaryKeyID = WI.RELATE_ID
			AND OTT.ObjectType = 'MESSAGE'


	----------------------------------------------------------------------
	---- WORK ITEM ACTION
	INSERT INTO #delWorkItemTempTable(ObjectType,PrimaryKeyID,ObjectDescription)
		SELECT
			'WORK_ITEM_ACTION',
			WIA.ID,
			'WORK_ITEM_ID: ' + CONVERT(VARCHAR(20), WIA.WORK_ITEM_ID)
			+ ', ACTION_CD: ' + WIA.ACTION_CD
		FROM
			DBO.WORK_ITEM_ACTION WIA
			INNER JOIN #delWorkItemTempTable OTT
			ON OTT.PrimaryKeyID = WIA.WORK_ITEM_ID
			AND OTT.ObjectType = 'WORK_ITEM'



	----------------------------------------------------------------------
	---- Process_Log

	Insert #delProcessLogTempTable (ID)
		select
			P.TAB.value('@Id' , 'BIGINT')
		 from
			WORK_ITEM WI (NOLOCK)
			CROSS APPLY
			WI.CONTENT_XML.nodes('/Content/Information/ProcessLogs/ProcessLog') AS P (TAB)
		where
			WI.ID in (select PrimaryKeyID from #delWorkItemTempTable where ObjectType = 'WORK_ITEM')

	----------------------------------------------------------------------
	---- Process_Log_Item

	Insert #delProcessLogItemTempTable (ID)
		select
			PLI.ID
		 from
            DBO.PROCESS_LOG_ITEM PLI (NOLOCK)
			INNER JOIN #delProcessLogTempTable P
			ON P.ID = PLI.PROCESS_LOG_ID
		order by PLI.ID



/*
	if @DoDelete = 0
	begin
		SELECT '#delMessageTempTable' as '#delMessageTempTable', * FROM #delMessageTempTable order by ObjectType, PrimaryKeyID
		SELECT '#delChildTempTable' as '#delChildTempTable', * FROM #delChildTempTable order by ObjectType, PrimaryKeyID

		SELECT '#delDocumentTempTable' as '#delDocumentTempTable', * FROM #delDocumentTempTable order by ObjectType, PrimaryKeyID
		SELECT '#delWorkItemTempTable' as '#delWorkItemTempTable', * FROM #delWorkItemTempTable order by ObjectType, PrimaryKeyID
	end
*/
	SELECT '#delMessageTempTable' as '#delMessageTempTable', ObjectType, count(*) FROM #delMessageTempTable group by ObjectType order by ObjectType
	SELECT '#delChildTempTable' as '#delChildTempTable', ObjectType, count(*)  FROM #delChildTempTable  group by ObjectType order by ObjectType
	SELECT '#delDocumentTempTable' as '#delDocumentTempTable', ObjectType, count(*)  FROM #delDocumentTempTable  group by ObjectType order by ObjectType
	SELECT '#delWorkItemTempTable' as '#delWorkItemTempTable', ObjectType, count(*)  FROM #delWorkItemTempTable  group by ObjectType order by ObjectType
	SELECT '#delProcessLogTempTable' as '#delProcessLogTempTable', count(*)  FROM #delProcessLogTempTable
	SELECT '#delProcessLogItemTempTable' as '#delProcessLogItemTempTable', count(*)  FROM #delProcessLogItemTempTable

	-- Create indexes on temp tables for improved performance in inner proc
	create index idx1 on #delMessageTempTable (ObjectType, MESSAGE_DIRECTION_CD, PrimaryKeyID)
	create index idx1 on #delChildTempTable (ObjectType, PrimaryKeyID)
	create index idx1 on #delDocumentTempTable (ObjectType, PrimaryKeyID)
	create index idx1 on #delWorkItemTempTable (ObjectType, PrimaryKeyID)
--	create index idx1 on #delProcessLogTempTable (ObjectType, PrimaryKeyID)


	--- Get IDs for LOAN_EXTRACT_TRANSACTION_DETAIL records to be deleted

	insert into #delLOAN_EXTRACT_TRANSACTION_DETAIL
		select ID from LOAN_EXTRACT_TRANSACTION_DETAIL
	    WHERE TRANSACTION_ID IN (SELECT PRIMARYKEYID FROM #delChildTempTable
		                          WHERE ObjectType = 'TRANSACTION')
		order by ID
	insert into #delLOAN_EXTRACT_TRANSACTION_DETAIL
		select ID from LOAN_EXTRACT_TRANSACTION_DETAIL
	    WHERE TRANSACTION_ID not in (select ID FROM
			DBO.[TRANSACTION] T)
			order by ID

	--- Get IDs for INSURANCE_EXTRACT_TRANSACTION_DETAIL records to be deleted

	insert into #delINSURANCE_EXTRACT_TRANSACTION_DETAIL
		select ID from INSURANCE_EXTRACT_TRANSACTION_DETAIL
	    WHERE TRANSACTION_ID IN (SELECT PRIMARYKEYID FROM #delChildTempTable
		                          WHERE ObjectType = 'TRANSACTION')
		order by ID
	insert into #delINSURANCE_EXTRACT_TRANSACTION_DETAIL
		select ID from INSURANCE_EXTRACT_TRANSACTION_DETAIL
	    WHERE TRANSACTION_ID not in (select ID FROM
			DBO.[TRANSACTION] T)
			order by ID

	--- Get IDs for COLLATERAL_EXTRACT_TRANSACTION_DETAIL records to be deleted

	insert into #delCOLLATERAL_EXTRACT_TRANSACTION_DETAIL
		select ID from COLLATERAL_EXTRACT_TRANSACTION_DETAIL
	    WHERE TRANSACTION_ID IN (SELECT PRIMARYKEYID FROM #delChildTempTable
		                          WHERE ObjectType = 'TRANSACTION')
		order by ID
	insert into #delCOLLATERAL_EXTRACT_TRANSACTION_DETAIL
		select ID from COLLATERAL_EXTRACT_TRANSACTION_DETAIL
	    WHERE TRANSACTION_ID not in (select ID FROM
			DBO.[TRANSACTION] T)
			order by ID

	--- Get IDs for OWNER_EXTRACT_TRANSACTION_DETAIL records to be deleted

	insert into #delOWNER_EXTRACT_TRANSACTION_DETAIL
		select ID from OWNER_EXTRACT_TRANSACTION_DETAIL
	    WHERE TRANSACTION_ID IN (SELECT PRIMARYKEYID FROM #delChildTempTable
		                          WHERE ObjectType = 'TRANSACTION')
		order by ID
	insert into #delOWNER_EXTRACT_TRANSACTION_DETAIL
		select ID from OWNER_EXTRACT_TRANSACTION_DETAIL
	    WHERE TRANSACTION_ID not in (select ID FROM
			DBO.[TRANSACTION] T)
			order by ID



	SELECT '#delLOAN_EXTRACT_TRANSACTION_DETAIL' as '#delLOAN_EXTRACT_TRANSACTION_DETAIL', count(*)
	FROM #delLOAN_EXTRACT_TRANSACTION_DETAIL
	SELECT '#delINSURANCE_EXTRACT_TRANSACTION_DETAIL' as '#delINSURANCE_EXTRACT_TRANSACTION_DETAIL', count(*)
	FROM #delINSURANCE_EXTRACT_TRANSACTION_DETAIL
	SELECT '#delCOLLATERAL_EXTRACT_TRANSACTION_DETAIL' as '#delCOLLATERAL_EXTRACT_TRANSACTION_DETAIL', count(*)
	FROM #delCOLLATERAL_EXTRACT_TRANSACTION_DETAIL
	SELECT '#delOWNER_EXTRACT_TRANSACTION_DETAIL' as '#delOWNER_EXTRACT_TRANSACTION_DETAIL', count(*)
	FROM #delOWNER_EXTRACT_TRANSACTION_DETAIL



	declare @object_type nvarchar(128),
			@rowcount bigint,
			@Info_xml xml

	declare c1 cursor local for
		select ObjectType, count(*) FROM #delMessageTempTable group by ObjectType
		union all
		select ObjectType, count(*)  FROM #delChildTempTable  group by ObjectType
		union all
		select ObjectType, count(*)  FROM #delDocumentTempTable  group by ObjectType
		union all
		select ObjectType, count(*)  FROM #delWorkItemTempTable  group by ObjectType
		union all
		select 'PROCESS_LOG', count(*)  FROM #delProcessLogTempTable
		union all
		select 'PROCESS_LOG_ITEM', count(*)  FROM #delProcessLogItemTempTable
		union all
		select 'LOAN_EXTRACT_TRANSACTION_DETAIL', count(*) FROM #delLOAN_EXTRACT_TRANSACTION_DETAIL
		union all
		select 'INSURANCE_EXTRACT_TRANSACTION_DETAIL', count(*)	FROM #delINSURANCE_EXTRACT_TRANSACTION_DETAIL
		union all
		select 'COLLATERAL_EXTRACT_TRANSACTION_DETAIL', count(*) FROM #delCOLLATERAL_EXTRACT_TRANSACTION_DETAIL
		union all
		select 'OWNER_EXTRACT_TRANSACTION_DETAIL', count(*)	FROM #delOWNER_EXTRACT_TRANSACTION_DETAIL
		order by ObjectType

	open c1
	fetch c1 into @object_type, @rowcount
	while @@fetch_status = 0
	begin

		select @info_xml = '<INFO>' + @object_type + ': ' + convert(varchar(20), @rowcount) + ' rows to be purged</INFO>'
		if @@SERVERNAME = 'UNITRAC-DB01'
		begin
			insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
			values (@Process_Log_ID, 'Info',
					@info_xml,
					getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end
		else
		begin
			insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
			values (@Process_Log_ID, 'Info',
					@info_xml,
					getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end


		fetch c1 into @object_type, @rowcount
	end

	close c1
	deallocate c1


	-- Call inner proc to perform the deletes
	--
	declare @rval int = 0

	declare @errornum int,
			@errormsg nvarchar(255),
			@errorseverity int,
			@errorstate int,
			@errorline int,
			@Status_CD nvarchar(10),
			@MSG_TX nvarchar(4000),
			@ErrorTable nvarchar(128)

	IF @DoDelete > 0
	BEGIN
			--- capture IDs associated with Purged Work_Items into tables in PerfStats database
			-- for cleanup by ProcessLogPurge process
		insert perfstats.dbo.delProcessLog select ID FROM #delProcessLogTempTable
		where ID not in (select ID from perfstats.dbo.delProcessLog )
		select @rowcount = @@rowcount
		select @info_xml = '<INFO>' + convert(varchar(20), @rowcount) + ' rows inserted into perfstats..delProcessLog </INFO>'
		print convert(varchar(max), @info_xml)
		if @@SERVERNAME = 'Unitrac-DB01'
		begin
			insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
				values (@Process_Log_ID, 'COMPLETE',
						@info_xml,
						getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end
		else
		begin
			insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
				values (@Process_Log_ID, 'COMPLETE',
						@info_xml,
						getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end

		insert perfstats.dbo.delProcessLogItem select ID  FROM #delProcessLogItemTempTable
		select @rowcount = @@rowcount
		select @info_xml = '<INFO>' + convert(varchar(20), @rowcount) + ' rows inserted into perfstats..delProcessLogItem </INFO>'
		print convert(varchar(max), @info_xml)

		if @@SERVERNAME = 'Unitrac-DB01'
		begin
			insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
				values (@Process_Log_ID, 'COMPLETE',
						@info_xml,
						getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end
		else
		begin
			insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
				values (@Process_Log_ID, 'COMPLETE',
						@info_xml,
						getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end

		exec @rval = MessagePurgeInner @Batchsize = @Batchsize,
									   @MaxretryCount = @retryCount,
									   @Process_Log_ID = @Process_Log_ID,
									   @errornum = @errornum output,
									   @errormsg  = @errormsg output,
									   @errorseverity = @errorseverity output,
									   @errorstate = @errorstate output,
									   @errorline = @errorline output,
									   @ErrorTable = @ErrorTable output,
									   @RunDuration = @RunDuration


	END

	-- check for errors

	if @rval <> 0
	begin
		select @status_CD = 'Error',
				@MSG_TX = 'ERROR ' + convert(nvarchar(20), @errornum)
				            + ' OCCURED DELETING FROM TABLE ' + @ErrorTable
							+ ' at line: ' + convert(varchar(20), @errorLine) + ':'
							+ char(10) + @errormsg
		raiserror (@ErrorMsg, @ErrorSeverity, @errorstate)
	end
	else
	begin
		select @Status_CD = 'Complete'
	end



	-- Update status in process_log
	set @Now = getdate()
	if @@SERVERNAME = 'Unitrac-DB01'
		update PROCESS_LOG
			set END_DT = @now,
				STATUS_CD = @Status_CD,
				UPDATE_DT = @now
	--			,MSG_TX = @MSG_TX
			where ID = @Process_Log_ID
	else
		update PURGE_LOG
			set END_DT = @now,
				STATUS_CD = @Status_CD,
				UPDATE_DT = @now
	--			,MSG_TX = @MSG_TX
			where ID = @Process_Log_ID

RETURN @rval
END



