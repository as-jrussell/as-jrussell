USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[UTL_LoanPurgeInner]    Script Date: 7/15/2017 12:23:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UTL_LoanPurgeInner] @Batchsize INT,
	 @MaxretryCount INT = 5,
	 @Process_Log_ID BIGINT,
		@errornum INT = NULL OUTPUT,
		@errormsg NVARCHAR(255) = NULL OUTPUT,
		@errorseverity INT = NULL OUTPUT,
		@errorstate INT = NULL OUTPUT,
		@errorline INT = NULL OUTPUT,
		@ErrorTable NVARCHAR(128) = NULL OUTPUT,
		@RunDuration INT = NULL OUTPUT

WITH RECOMPILE
AS
  SET NOCOUNT ON
  SET NUMERIC_ROUNDABORT OFF;
  SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
      QUOTED_IDENTIFIER, ANSI_NULLS ON;
--  SET XACT_ABORT ON

-- Set deadlock priority low so this process is always the deadlock victim
  SET DEADLOCK_PRIORITY LOW

-- set lock timeout to 5 minutes
  SET LOCK_TIMEOUT 300000


DECLARE @RowsDeleted INT,
		@TABLE NVARCHAR(128),
		@start DATETIME,
		@totalRows BIGINT,
		@rval INT = 0

DECLARE @retry CHAR(1),
		@rowcount INT,
		@delQuery NVARCHAR(MAX),
		@lastIDQuery NVARCHAR(MAX),
		@totaltime BIGINT,
		@runtime BIGINT,
		@lastID BIGINT,
		@retryCount INT,
		@Runstart DATETIME,
		@ObjectType VARCHAR(50),
		@IDColName NVARCHAR(128)

-- Create and populate the table variable containing the list of tables to be deleted from
---  VERY IMPORTANT that the seq number be set so that child tables (lower numbers) are processed first
---   before deleting any parent tables which they may be dependent upon
--  The query column contains the delete statement to use to delete the records from the table
---  the dynamic query is executed via sp_executesql
DECLARE @TableList TABLE
		(seq INT NOT NULL,
		 ObjectType VARCHAR(50) NOT NULL, 
		 tablename NVARCHAR(128) NULL,
		 delquery NVARCHAR(MAX) NULL,
		 lastidquery NVARCHAR(MAX) NULL,
		 IDColName NVARCHAR(128) NULL
		 )

/*
VUT_KEY_MAP from LOAN, COLLATERAL, OWNER_LOAN_RELATE, OWNER, OWNER_POLICY, POLICY_COVERAGE, PROPERTY, REQUIRED_COVERAGE, NOTICE, IMPAIRMENT, WAIVE_TRACK

NOTICE from LOAN, NOTICE_REQUIRED_COVERAGE_RELATE
ALTERNATE_MATCH from OWNER, PROPERTY

NOTICE_REQUIRED_COVERAGE_RELATE from REQUIRED_COVERAGE --, NOTICE
FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE from REQUIRED_COVERAGE
UTLMATCH_REQ_COV_RELATE from REQUIRED_COVERAGE
EVALUATION_QUEUE from REQUIRED_COVERAGE

DBO.EVALUATION_EVENT
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'EVALUATION_EVENT')
DELETE FROM ESCROW_EVENT
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'ESCROW_EVENT')
DELETE FROM ESCROW_REQUIRED_COVERAGE_RELATE
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'ESCROW_REQUIRED_COVERAGE_RELATE')
DELETE FROM ESCROW
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'ESCROW')
DELETE FROM REQUIRED_ESCROW
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'REQUIRED_ESCROW')
DELETE FROM DBO.CERTIFICATE_DETAIL
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'CERTIFICATE_DETAIL')
DELETE FROM DBO.CPI_ACTIVITY
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'CPI_ACTIVITY')
DELETE FROM DBO.FINANCIAL_TXN_APPLY
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'FINANCIAL_TXN_APPLY')
DELETE FROM DBO.FINANCIAL_TXN_DETAIL
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'FINANCIAL_TXN_DETAIL')
DELETE FROM DBO.FINANCIAL_TXN
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'FINANCIAL_TXN')
DELETE FROM DBO.FORCE_PLACED_CERTIFICATE
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'FORCE_PLACED_CERTIFICATE')
DELETE FROM DBO.CPI_QUOTE
		WHERE ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'CPI_QUOTE')
		
IMPAIRMENT from REQUIRED_COVERAGE
WAIVE_TRACK from REQUIRED_COVERAGE
REQUIRED_COVERAGE from PROPERTY

POLICY_COVERAGE from OWNER_POLICY
OWNER_POLICY from PROPERTY_OWNER_POLICY_RELATE (COLLATERAL, OWNER_LOAN_RELATE)

PROPERTY_ADDRESS from PROPERTY, COLLATERAL, OWNER_LOAN_RELATE, OWNER_ADDRESS
PROPERTY_OWNER_POLICY_RELATE from COLLATERAL (OWNER_LOAN_RELATE)
PROPERTY from COLLATERAL

OWNER_ADDRESS from OWNER
OWNER from OWNER_LOAN_RELATE

DELETE FROM DBO.SEARCH_FULLTEXT
		WHERE PROPERTY_ID IN (SELECT PRIMARYKEYID FROM delObjTempTable WHERE ObjectType = 'SEARCH_FULLTEXT')

COLLATERAL from LOAN
OWNER_LOAN_RELATE from LOAN
UTL_MATCH_RESULT from LOAN
UTL_QUEUE from LOAN
LOAN_NUMBER from LOAN
LOAN
*/

insert @TableList (seq, ObjectType, tablename, delquery, lastidquery, IDColName)
values
(1, 'WORK_ITEM_ACTION', null,  '', '', null),
(2, 'WORK_ITEM_PROCESS_LOG_ITEM_RELATE', null,  '', '', null),
(3, 'WORK_QUEUE_WORK_ITEM_RELATE', null,  '', '', null),
(4, 'LENDER_INTENT', null,  '', '', null),
(5, 'SUB_WORK_ITEM_BUSINESS_OBJECT_ITEM_RELATE', null,  '', '', null),
(6, 'WORK_ITEM', null,  '', '', null),

(10, 'VUT_KEY_MAP', null,  '', '', null),
(15, 'INTERACTION_HISTORY', null,  '', '', null),
(20, 'NOTICE_REQUIRED_COVERAGE_RELATE', null,  '', '', null),
(30, 'ALTERNATE_MATCH', null,  '', '', null),
(40, 'NOTICE', null,  '', '', null),
(50, 'FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE', null,  '', '', null),
(60, 'UTLMATCH_REQ_COV_RELATE', null,  '', '', null),

(70, 'EVALUATION_QUEUE', null,  '', '', null),
(71, 'EVALUATION_EVENT', null,  '', '', null),
(72, 'ESCROW_EVENT', null,  '', '', null),
(73, 'ESCROW_REQUIRED_COVERAGE_RELATE', null,  '', '', null),
(74, 'ESCROW', null,  '', '', null),
(75, 'REQUIRED_ESCROW', null,  '', '', null),
(76, 'CERTIFICATE_DETAIL', null,  '', '', null),
(77, 'CPI_ACTIVITY', null,  '', '', null),
(78, 'FINANCIAL_TXN_APPLY', null,  '', '', null),
(79, 'FINANCIAL_TXN_DETAIL', null,  '', '', null),
(80, 'FINANCIAL_TXN', null,  '', '', null),
(81, 'FORCE_PLACED_CERTIFICATE', null,  '', '', null),

(85, 'IMPAIRMENT', null,  '', '', null),
(90, 'WAIVE_TRACK', null,  '', '', null),

(100, 'REQUIRED_COVERAGE', null,  '', '', null),

(105, 'CPI_QUOTE', null,  '', '', null),

(110, 'POLICY_COVERAGE', null,  '', '', null),
(120, 'PROPERTY_OWNER_POLICY_RELATE', null,  '', '', null),

(130, 'OWNER_POLICY', null,  '', '', null),

(140, 'SEARCH_FULLTEXT', null,  '', '', 'PROPERTY_ID'),

(145, 'UTL_MATCH_RESULT', null,  '', '', null),

(146, 'COLLATERAL', null,  '', '', null),

(150, 'PROPERTY', null,  '', '', null),

(155, 'OWNER_LOAN_RELATE', null,  '', '', null),

(160, 'OWNER', null,  '', '', null),

(165, 'PROPERTY_ADDRESS', 'OWNER_ADDRESS',  '', '', null),

(170, 'OWNER_ADDRESS', null,  '', '', null),

(210, 'UTL_QUEUE', null,  '', '', 'LOAN_ID'),

(220, 'LOAN_NUMBER', null,  '', '', null),

(999, 'LOAN', null, 'declare @output table (ID bigint)
	  DELETE FROM DBO.LOAN
  	  OUTPUT deleted.ID into @output
	  WHERE ID IN (SELECT TOP (' + convert(varchar(8), @Batchsize) 
	  + ') LOAN_ID FROM UniTrac_Maintenance.dbo.delLoan 
	  WHERE LOAN_ID > @lastid and delflag = 0 order by LOAN_ID)  
	   option (optimize for (@lastid = 1))
	  select @rowcount = @@rowcount, @lastID = isnull(max(ID), @lastID) from @output
	  update UniTrac_Maintenance.dbo.delLoan set delflag = 1 where LOAN_ID in (select ID from @output)',
	  'declare @minID bigint = null
		select top 1 @minID = LOAN_ID from UniTrac_Maintenance.dbo.delLoan where delflag = 0 order by LOAN_ID
		select @lastID = isnull((select top 1 ID from DBO.LOAN where ID >= @minID) - 1, @lastID)', null)


-- define cursor to loop through tables in order of the seq value
declare tablecursor cursor local for 
select ObjectType, ISNULL(tablename, ObjectType),  delquery, lastidquery, IDColName
from @TableList
order by seq

open tablecursor

-- begin looping through list of tables
fetch tablecursor into @ObjectType, @TABLE, @delQuery, @lastIDQuery, @IDColName


-- Get the start time for checking run duration
select @Runstart = getdate()

while @@fetch_status = 0
begin

	if @@SERVERNAME <> 'UTPROD-SUB-01'
	begin
		insert PROCESS_LOG_ITEM
				(PROCESS_LOG_ID,
				 STATUS_CD,
				 INFO_XML,
				 CREATE_DT,
				 UPDATE_DT,
				 UPDATE_USER_TX,
				 LOCK_ID)
			values (@Process_Log_ID,
					'STARTING',
					'<INFO>Starting purge of ' + @TABLE + '</INFO>',
					getdate(),
					getdatE(),
					convert(nvarchar(15), suser_sname()),
					1)
	end
	else
	begin
		insert PURGE_LOG_ITEM
				(PURGE_LOG_ID,
				 STATUS_CD,
				 INFO_XML,
				 CREATE_DT,
				 UPDATE_DT,
				 UPDATE_USER_TX,
				 LOCK_ID)
			values (@Process_Log_ID,
					'STARTING',
					'<INFO>Starting purge of ' + @TABLE + '</INFO>',
					getdate(),
					getdatE(),
					convert(nvarchar(15), suser_sname()),
					1)
	end
	
	SET @retryCount = 1
	SET @retry = 'Y'
	SET @totalRows = 0
	SET @TotalTime = 0
	SET @LastID = 1

	IF ISNULL(@lastIDquery, '') = ''
	begin
		select @lastIDquery = 'declare @minID bigint = null
		select top 1 @minID = PRIMARYKEYID from UniTrac_Maintenance.dbo.delObjTempTable WHERE ObjectType = ''' + @ObjectType + ''' and delflag = 0 order by PRIMARYKEYID
		select @lastID = isnull((select top 1 ' +  isnull(@IDColName, 'ID') + ' from  DBO.[' + @TABLE + ']  where ' +  isnull(@IDColName, 'ID') + ' >= @minID) - 1, @lastID)'
	end
	print @lastIDQuery
	exec sp_executesql @LastIDQUery, N'@lastID bigint output', @lastID output
	print 'Starting ID for table [' + @TABLE + '] = ' + convert(varchar(20), @LastID)

	While @retry = 'Y' and datediff(minute, @Runstart, getdate()) <= @RunDuration  -- haven't exceeded the configured RunDuration
	begin
		BEGIN TRY
			select @RowsDeleted = @Batchsize

			while @RowsDeleted > 0  -- loop until no more rows are deleted
                  and datediff(minute, @Runstart, getdate()) <= @RunDuration  -- haven't exceeded the configured RunDuration
			BEGIN
				select @start = getdate()

				IF ISNULL(@delquery, '') = ''
				begin
					select @delquery = 'declare @output table (ID bigint) ' + char(10)
									 + 'DELETE FROM DBO.[' + @TABLE + '] ' + char(10)
					                 + 'OUTPUT deleted.' +  isnull(@IDColName, 'ID') + ' into @output ' + char(10) 
									 + ' WHERE ' +  isnull(@IDColName, 'ID') + ' IN (SELECT TOP (' + convert(varchar(8), @Batchsize) 
									 + ') PRIMARYKEYID FROM UniTrac_Maintenance.dbo.delObjTempTable WHERE ObjectType = ''' + @ObjectType + '''' + char(10) 
									 + ' AND PRIMARYKEYID > @lastid and delflag = 0 order by PRIMARYKEYID) ' + char(10)
									 + ' option (optimize for (@lastid = 1)) ' + char(10)
									 + 'select @rowcount = @@rowcount, @lastID = isnull(max(ID), @lastID) from @output' + CHAR(10)
									 + 'update UniTrac_Maintenance.dbo.delObjTempTable set delflag = 1 where ObjectType = ''' + @ObjectType + ''' AND PRIMARYKEYID IN (select ID from @output)'
				end
				-- execute the delete statement, which optionally passes back the lastID deleted and the number of rows deleted as output parameters
				print @delquery
				exec sp_executesql @delquery, N'@lastID bigint output, @rowcount bigint output', @lastID output, @rowcount output

				select @RowsDeleted = @rowcount
				select @runtime = datediff(ss,@start,getdate())
				select @totalRows = @TotalRows + @RowsDeleted,
					   @totalTime = @totalTime + @runtime
				print convert(varchar(20), @RowsDeleted) + ' rows deleted from ' + @TABLE  + ' in ' + convert(varchar(20),@runtime) + ' seconds'
				SET @retryCount = 1 -- reset retry count after successful deletion
				-- Log the deletion of the current batch in the PROCESS_LOG_INFO table
				if @@SERVERNAME <> 'UTPROD-SUB-01'
				begin
					insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'InProcess',
								'<INFO>' + convert(varchar(20), @RowsDeleted) + ' rows deleted from ' + @TABLE  + ' in ' + convert(varchar(20),@runtime) + ' seconds</INFO>',
								getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
				end
				else
				begin
					insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'InProcess',
								'<INFO>' + convert(varchar(20), @RowsDeleted) + ' rows deleted from ' + @TABLE  + ' in ' + convert(varchar(20),@runtime) + ' seconds</INFO>',
								getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
				end
			END
			set @retry = 'N'
		end TRY
		BEGIN CATCH
			select @errornum = Error_number(),
					@ErrorMsg = error_message(),
					@ErrorSeverity = error_severity(),
					@errorstate = error_state(),
					@errorLine = error_line(),
					@ErrorTable = @TABLE

			IF (@retryCount <= @MaxretryCount) and @errorNum = 1205 -- retry on deadlock
			begin
				SET @retry = 'Y'
				if @@SERVERNAME <> 'UTPROD-SUB-01'
				begin
					insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'InProcess',
								'<INFO>Deadlock occurred deleting from ' + @TABLE + '. Retrying</INFO>',
								getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
				end
				else
				begin
					insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'InProcess',
								'<INFO>Deadlock occurred deleting from ' + @TABLE + '. Retrying</INFO>',
								getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
				end
				-- wait 1 second before retry
				waitfor delay '00:00:01'
			end
			ELSE IF (@retryCount <= @MaxretryCount) and @errorNum = 1222 -- retry on lock timeout
			begin
				SET @retry = 'Y'
				if @@SERVERNAME <> 'UTPROD-SUB-01'
				begin
					insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'InProcess',
								'<INFO>Lock timeout occurred deleting from ' + @TABLE + '. Retrying</INFO>',
								getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
				end
				else
				begin
					insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'InProcess',
								'<INFO>Lock timeout occurred deleting from ' + @TABLE + '. Retrying</INFO>',
								getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
				end

				-- wait 1 minute before retry
				waitfor delay '00:01:00'
			end
			ELSE
			begin  -- other error or retry count has been exceeded
				SET @retry = 'N'

				PRINT 'ERROR ' + convert(varchar(20), @errornum) + ' OCCURED DELETING FROM TABLE ' + @TABLE + ' from lastID ' + isnull(convert(varchar(20), @lastID),'') + ' at line: ' + convert(varchar(20), @errorLine) + '. PURGE ABORTED!'

				-- log the error in the PROCESS_LOG_ITEM Table
				if @@SERVERNAME <> 'UTPROD-SUB-01'
				begin
					insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'ERROR',
								'<INFO>' + 'ERROR ' + convert(varchar(20), @errornum) + ' OCCURED DELETING FROM TABLE ' + @TABLE + ' from lastID ' + isnull(convert(varchar(20), @lastID),'') + ' at line: ' + convert(varchar(20), @errorLine) + '. PURGE ABORTED!</INFO>',
								getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
				end
				else
				begin
					insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'ERROR',
								'<INFO>' + 'ERROR ' + convert(varchar(20), @errornum) + ' OCCURED DELETING FROM TABLE ' + @TABLE + ' from lastID ' + isnull(convert(varchar(20), @lastID),'') + ' at line: ' + convert(varchar(20), @errorLine) + '. PURGE ABORTED!</INFO>',
								getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
				end

				if @errorNum = 1205 -- if a deadlock occurred and we've exceeded the retry count, roll back any open tran as would
									--  happen if deadlock were not being trapped by TRY..CATCH and return deadlock error message
				begin
					if @@trancount > 0
						rollback tran
					if cursor_status('local', 'tablecursor') >= 0
					begin
						close tablecursor
						deallocate tablecursor
					end
					raiserror (@ErrorMsg, @ErrorSeverity, @errorstate)
					return -3
				end
				else  -- raise the error that was encountered and exit with error status
				begin
					if cursor_status('local', 'tablecursor') >= 0
					begin
						close tablecursor
						deallocate tablecursor
					end
					raiserror (@ErrorMsg, @ErrorSeverity, @errorstate)
					return -101
				end
			end
			-- increment retry count
			--  and set @RowsDeleted to the configured @Batchsize so that it doesn't fail the
			--   "while @RowsDeleted = @Batchsize" check on the retry since @rowsdeleted is likely 0
			--    after an error occurs
			SELECT @retryCount = @retryCount + 1,
				   @RowsDeleted = @Batchsize

		END CATCH
	END -- while @retry = 'Y'

	print convert(varchar(20), isnull(@TotalRows, 0)) + ' total rows deleted from ' + @TABLE  + ' in ' + convert(varchar(20),isnull(@totalTime, 0)) + ' seconds'

	-- Log the completion of the deletion from the current table in the PROCESS_LOG_INFO table
	if datediff(minute, @Runstart, getdate()) <= @RunDuration  -- haven't exceeded the configured RunDuration
	begin
		if @@SERVERNAME <> 'UTPROD-SUB-01'
		begin
			insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
				values (@Process_Log_ID, 'COMPLETE',
						'<INFO>' + convert(varchar(20), isnull(@TotalRows,0)) + ' total rows deleted from ' + @TABLE  + ' in ' + convert(varchar(20),isnull(@totalTime, 0)) + ' seconds</INFO>',
						getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end
		else
		begin
			insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
				values (@Process_Log_ID, 'COMPLETE',
						'<INFO>' + convert(varchar(20), isnull(@TotalRows,0)) + ' total rows deleted from ' + @TABLE  + ' in ' + convert(varchar(20),isnull(@totalTime, 0)) + ' seconds</INFO>',
						getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end
	END
	else
	begin
		if @@SERVERNAME <> 'UTPROD-SUB-01'
		begin
			insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
				values (@Process_Log_ID, 'ABORTED',
						'<INFO>RunDuration of ' + convert(varchar(4), isnull(@RunDuration,0)) + ' minutes exceeded. ' + convert(varchar(20), isnull(@TotalRows,0)) + ' rows deleted from ' + @TABLE  + ' in ' + convert(varchar(20),isnull(@totalTime, 0)) + ' seconds</INFO>',
						getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end
		else
		begin
			insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
				values (@Process_Log_ID, 'ABORTED',
						'<INFO>RunDuration of ' + convert(varchar(4), isnull(@RunDuration,0)) + ' minutes exceeded. ' + convert(varchar(20), isnull(@TotalRows,0)) + ' rows deleted from ' + @TABLE  + ' in ' + convert(varchar(20),isnull(@totalTime, 0)) + ' seconds</INFO>',
						getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
		end

		select @RowsDeleted = @Batchsize,
		       @totalRows = 0,
			   @TotalTime = 0,
			   @rval = -102
	end

	fetch tablecursor into @ObjectType, @TABLE, @delQuery, @lastIDQuery, @IDColName

END -- while @@fetch_Status = 0

close tablecursor
deallocate tablecursor

  set lock_timeout -1

return @rval


