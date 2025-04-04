USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[ProcessLogPurge]    Script Date: 7/15/2017 12:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ProcessLogPurge] @Batchsize INT = 2000,
	 @MaxretryCount INT = 5,
		@errornum INT = NULL OUTPUT,
		@errormsg NVARCHAR(255) = NULL OUTPUT,
		@errorseverity INT = NULL OUTPUT,
		@errorstate INT = NULL OUTPUT,
		@errorline INT = NULL OUTPUT,
		@ErrorTable NVARCHAR(128) = NULL OUTPUT,
		@RunDuration INT = 120,
	    @RunOnSubscriber AS INTEGER = 0

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

  -- For replication - if we are not on publisher
  --  and @RunOnSubscriber is not set, invoke ProcessLogPurge job and exit
  IF @@SERVERNAME <> 'UNITRAC-DB01' AND @RunOnSubscriber <> 1
  BEGIN
		IF NOT EXISTS(SELECT 1
					FROM msdb.dbo.sysjobs_view job
					INNER JOIN msdb.dbo.sysjobactivity activity ON job.job_id = activity.job_id
					WHERE
						activity.run_Requested_date IS NOT NULL
					AND activity.stop_execution_date IS NULL
					AND job.name = 'ProcessLogPurge'
					)
		BEGIN
			PRINT 'Starting job ProcessLogPurge';
	  		EXEC msdb..sp_start_job 'ProcessLogPurge'
		END
		ELSE
		BEGIN
			PRINT 'ProcessLogPurge Job is already started '
		END
	  RETURN 0
  END


DECLARE @RowsDeleted INT,
		@TABLE NVARCHAR(128),
		@start DATETIME,
		@totalRows BIGINT

DECLARE @retry CHAR(1),
		@rowcount INT,
		@Query NVARCHAR(MAX),
		@totaltime BIGINT,
		@runtime BIGINT,
		@StartID BIGINT,
		@lastID BIGINT,
		@retryCount INT,
		@Runstart DATETIME,
	    @Process_Log_ID BIGINT,
	    @now DATETIME = GETDATE(),
		@info_xml XML,
		@rows_to_delete BIGINT

DECLARE @Process_Definition_ID BIGINT

--- Get setting for parameters from PROCESS_DEFINITON if explicit values not provided
---   to parameters
SELECT
	@Process_Definition_ID = ID
	FROM PROCESS_DEFINITION
	WHERE NAME_TX = 'Message Purge'
		AND PROCESS_TYPE_CD = 'MSGPURGE'

	--- Log the running of this purge process instance
IF @@SERVERNAME = 'Unitrac-DB01'
BEGIN
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
			N'Process Log Purge. Batch Size: '+ CONVERT(NVARCHAR(20), @BatchSize)
							+ N'. RetryCount: ' + CONVERT(NVARCHAR(20), @MaxRetryCount)
							+ N'. RunDuration: ' + CONVERT(NVARCHAR(20), @RunDuration),
			@now,
			@now,
			CONVERT(NVARCHAR(15), SUSER_SNAME()),
			1)
END
ELSE
BEGIN
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
			N'Process Log Purge. Batch Size: '+ convert(nvarchar(20), @BatchSize)
							+ N'. RetryCount: ' + convert(nvarchar(20), @MaxRetryCount)
							+ N'. RunDuration: ' + convert(nvarchar(20), @RunDuration),
			@now,
			@now,
			convert(nvarchar(15), suser_sname()),
			1)
end

	select @process_log_id = scope_identity()

	select @process_log_id as '@process_log_id'

set @StartID = (select top 1 ID from perfstats..delProcessLogItem d where exists (select 1 from PROCESS_LOG_ITEM pli where pli.ID = d.ID) order by ID)

select @rows_to_delete = count(*)
	from perfstats..delProcessLog
	where ID >= (select top 1 ID from perfstats..delProcessLog d where exists (select 1 from PROCESS_LOG pl where pl.ID = d.ID) order by ID)
select @info_xml = '<INFO>PROCESS_LOG: ' + convert(varchar(20), @rows_to_delete) + ' rows to be purged</INFO>'
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

select @rows_to_delete = count(*)
	from perfstats..delProcessLogItem
	where ID >= @StartID
select @info_xml = '<INFO>PROCESS_LOG_ITEM: ' + convert(varchar(20), @rows_to_delete) + ' rows to be purged</INFO>'
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

declare @TableList TABLE
		(seq int,
		 tablename nvarchar(128),
		 query nvarchar(max)
		 )

insert @TableList (seq, tablename, query)
values
(1, 'PROCESS_LOG_ITEM',
    'declare @output table (ID bigint)
     DELETE  FROM DBO.[PROCESS_LOG_ITEM]
     OUTPUT deleted.ID into @output
	 WHERE ID IN (SELECT TOP (' + convert(varchar(8), @Batchsize) + ') d.ID
	 FROM DBO.[PROCESS_LOG_ITEM] pli
		join perfstats..delProcessLogItem d
		on d.ID = pli.ID
		where d.ID >= @lastid order by ID)
	 select @rowcount = @@rowcount, @lastID = isnull(max(ID), @lastID) from @output'
	 ),
(2, 'PROCESS_LOG', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.PROCESS_LOG
     WHERE ID IN (SELECT ID FROM perfstats..delProcessLog)
	 select @rowcount = @@rowcount'
	 )

-- define cursor to loop through tables in order of the seq value
declare tablecursor cursor local for select tablename, query
from @TableList
order by seq

open tablecursor

-- begin looping through list of tables
fetch tablecursor into @TABLE, @Query


-- Get the start time for checking run duration
select @Runstart = getdate()

SET @LastID = isnull(@StartID, 0)

while @@fetch_status = 0
begin


	SET @retryCount = 1
	SET @retry = 'Y'
	SET @totalRows = 0
	SET @TotalTime = 0
	if @TABLE = 'PROCESS_LOG_ITEM'
		if @@SERVERNAME = 'Unitrac-DB01'
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
						'<INFO>Starting purge of ' + @TABLE + ' starting at ID ' + cast (@LastID as varchar(max)) + '</INFO>',
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
						'<INFO>Starting purge of ' + @TABLE + ' starting at ID ' + cast (@LastID as varchar(max)) + '</INFO>',
						getdate(),
						getdatE(),
						convert(nvarchar(15), suser_sname()),
						1)
		end
	else
		if @@SERVERNAME = 'Unitrac-DB01'
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
	While @retry = 'Y' and datediff(minute, @Runstart, getdate()) <= @RunDuration  -- haven't exceeded the configured RunDuration
	begin
		BEGIN TRY
			select @RowsDeleted = @Batchsize

			while @RowsDeleted = @Batchsize -- loop until number of rows deleted is less than the batchsize
			                                -- which indicates the last chunk of qualifying records has been removed
                  and datediff(minute, @Runstart, getdate()) <= @RunDuration  -- haven't exceeded the configured RunDuration
			BEGIN
				select @start = getdate()

				--if @TABLE = 'INSURANCE_EXTRACT_TRANSACTION_DETAIL'
				--	select count(*) FROM DBO.INSURANCE_EXTRACT_TRANSACTION_DETAIL WHERE ID IN (SELECT ID FROM #delINSURANCE_EXTRACT_TRANSACTION_DETAIL)

				-- execute the delete statement, which optionally passes back the lastID deleted and the number of rows deleted as output parameters
				print @query
				exec sp_executesql @query, N'@lastID bigint output, @rowcount bigint output', @lastID output, @rowcount output

				select @RowsDeleted = @rowcount
				select @runtime = datediff(ss,@start,getdate())
				select @totalRows = @TotalRows + @RowsDeleted,
					   @totalTime = @totalTime + @runtime
				print convert(varchar(20), @RowsDeleted) + ' rows deleted from ' + @TABLE  + ' in ' + convert(varchar(20),@runtime) + ' seconds'
				SET @retryCount = 1 -- reset retry count after successful deletion
				-- Log the deletion of the current batch in the PROCESS_LOG_INFO table
				if @@SERVERNAME = 'Unitrac-DB01'
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
				if @@SERVERNAME = 'Unitrac-DB01'
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
				if @@SERVERNAME = 'Unitrac-DB01'
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

				PRINT 'ERROR ' + convert(varchar(20), @errornum) + ' OCCURED DELETING FROM TABLE ' + @TABLE + ' at line: ' + convert(varchar(20), @errorLine) + '. PURGE ABORTED!'

				-- log the error in the PROCESS_LOG_ITEM Table
				if @@SERVERNAME = 'Unitrac-DB01'
				begin
					insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'ERROR',
								'<INFO>' + 'ERROR ' + convert(varchar(20), @errornum) + ' OCCURED DELETING FROM TABLE ' + @TABLE + ' at line: ' + convert(varchar(20), @errorLine) + '. PURGE ABORTED!</INFO>',
								getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
				end
				else
				begin
					insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@Process_Log_ID, 'ERROR',
								'<INFO>' + 'ERROR ' + convert(varchar(20), @errornum) + ' OCCURED DELETING FROM TABLE ' + @TABLE + ' at line: ' + convert(varchar(20), @errorLine) + '. PURGE ABORTED!</INFO>',
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
		if @@SERVERNAME = 'Unitrac-DB01'
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
		if @@SERVERNAME = 'Unitrac-DB01'
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
			   @TotalTime = 0
	end

	fetch tablecursor into @TABLE, @Query

END -- while @@fetch_Status = 0

close tablecursor
deallocate tablecursor


-- Cleanup deleted IDs from the delProcessLog and delProcessLogItem tables

set @start = getdate()
delete from perfstats..delProcessLogItem
	where ID <= @LastID  -- the last record we deleted from PROCESS_LOG_ITEM
select @RowsDeleted = @@rowcount
select @runtime = datediff(ss,@start,getdate())
select @info_xml = '<INFO>' + convert(varchar(20), @RowsDeleted) + ' rows less than ID ' + convert(varchar(20), isnull(@LastID,0)) + ' deleted from perfstats..delProcessLogItem in ' + convert(varchar(20),@runtime) + ' seconds</INFO>'
print convert(varchar(max), @info_xml)
if @@SERVERNAME = 'Unitrac-DB01'
begin
	insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
		values (@Process_Log_ID, 'Complete',
				@info_xml,
				getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
end
else
begin
	insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
		values (@Process_Log_ID, 'Complete',
				@info_xml,
				getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
end


set @start = getdate()
delete from perfstats..delProcessLog
	where ID not in (select ID from PROCESS_LOG pli)
select @RowsDeleted = @@rowcount
select @runtime = datediff(ss,@start,getdate())
select @info_xml = '<INFO>' + convert(varchar(20), @RowsDeleted) + ' rows deleted from perfstats..delProcessLog in ' + convert(varchar(20),@runtime) + ' seconds</INFO>'
print convert(varchar(max), @info_xml)
if @@SERVERNAME = 'Unitrac-DB01'
begin
	insert PROCESS_LOG_ITEM (PROCESS_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
		values (@Process_Log_ID, 'Complete',
				@info_xml,
				getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)
	update PROCESS_LOG 
			set END_DT = Getdate(),
				STATUS_CD = 'Complete',
				UPDATE_DT = getdate()
			where ID = @Process_Log_ID

end
else
begin
	insert PURGE_LOG_ITEM (PURGE_LOG_ID, STATUS_CD, INFO_XML, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
		values (@Process_Log_ID, 'Complete',
				@info_xml,
				getdate(), getdatE(), convert(nvarchar(15), suser_sname()), 1)

	update PURGE_LOG
			set END_DT = Getdate(),
				STATUS_CD = 'Complete',
				UPDATE_DT = getdate()
			where ID = @Process_Log_ID

end

set lock_timeout -1

return

