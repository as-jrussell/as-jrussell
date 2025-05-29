USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[MessagePurgeInner]    Script Date: 9/8/2017 5:54:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--------------------------------------------------------------------------------------------------------------------
---- Procedure is invoked from MessagePurge to perform the actual deletion of
----   messages, documents, transactions, blobs, related data and work items
----   based upon IDs stored in temporary tables
----
---- Data is deleted in chunks deleting from child records first and working up through to the top most tables
----  the size of the chunks is determined by the @Batchsize parameter (or via the Batchsize setting in the PROCESS_DEFINITON
----  table SETTINGS_XML_IM column). Larger batch sizes should run faster, but will hold locks for Delete statement longer
----  Recommended batch size is 1000 or 2000 rows at a time.
----  Records are deleted from on table at a time in chunks in a loop until there are no more qualifying records to be deleted
----   from that table. The process then goes on to delete from the next table
----
---- Table deletion order is controlled seq value in the table variable which is created and populated in this proc
----  lowest level child tables are deleted from first, working up through to the top level parent tables
----
---- If the deletion of a chunk is involved in a deadlock, the error is trapped and the delete is retried after a 1 minute delay
---- If a lock timeout occurs,  it will also retry the delete after a 1 minute delay
----  the default number of retries is 5
---- Any other error during deletion will cause the process to abort
----
---- the Purge Process is resumable if it should fail to do error or need to be manually stopped. It will pick up where it left off for
----   for table(s) it was in the process of deleting from
---- The specifics on number or records deleted from each table
----  and time to delete them will be recorded in the PROCESS_LOG_INFO table
----
---- the proc has been modified to support procedure replication - if not running on DB01, the Purge history and status
----  is logged to PURGE_LOG and PURGE_LOG_ITEM on the subscriber database
--   Also  removed hard coded references to the Unitrac database


CREATE PROCEDURE [dbo].[MessagePurgeInner]
	 @Batchsize int,
	 @MaxretryCount int = 5,
	 @Process_Log_ID bigint,
		@errornum int = null output,
		@errormsg nvarchar(255) = null output,
		@errorseverity int = null output,
		@errorstate int = null output,
		@errorline int = null output,
		@ErrorTable nvarchar(128) = null output,
		@RunDuration int = null

with recompile
AS
  set nocount on
  SET NUMERIC_ROUNDABORT OFF;
  SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
      QUOTED_IDENTIFIER, ANSI_NULLS ON;
--  SET XACT_ABORT ON

-- Set deadlock priority low so this process is always the deadlock victim
  SET DEADLOCK_PRIORITY LOW

-- set lock timeout to 5 minutes
  set lock_timeout 300000


declare @RowsDeleted int,
		@TABLE nvarchar(128),
		@start datetime,
		@totalRows bigint

declare @retry char(1),
		@rowcount int,
		@Query nvarchar(max),
		@totaltime bigint,
		@runtime bigint,
		@lastID bigint,
		@retryCount int,
		@Runstart datetime

-- Create and populate the table variable containing the list of tables to be deleted from
---  VERY IMPORTANT that the seq number be set so that child tables (lower numbers) are processed first
---   before deleting any parent tables which they may be dependent upon
--  The query column contains the delete statement to use to delete the records from the table
---  the dynamic query is executed via sp_executesql
declare @TableList TABLE
		(seq int,
		 tablename nvarchar(128),
		 query nvarchar(max)
		 )

insert @TableList (seq, tablename, query)
values
--(1, 'PROCESS_LOG_ITEM',
--    'declare @output table (ID bigint)
--     DELETE  FROM UNITRAC.DBO.[PROCESS_LOG_ITEM]
--     OUTPUT deleted.ID into @output
--	 WHERE ID IN (SELECT TOP (' + convert(varchar(8), @Batchsize) + ') ID FROM #delProcessLogItemTempTable where ID > @lastid order by ID)
--	 select @rowcount = @@rowcount, @lastID = isnull(max(ID), @lastID) from @output'
--	 ),

--(2, 'PROCESS_LOG', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM UNITRAC.DBO.PROCESS_LOG
--     WHERE ID IN (SELECT ID FROM #delProcessLogTempTable)
--	 select @rowcount = @@rowcount'
--	 ),

(3, 'WORK_ITEM_ACTION',
    'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.WORK_ITEM_ACTION
	 WHERE ID IN (SELECT PRIMARYKEYID FROM #delWorkItemTempTable WHERE ObjectType = ''WORK_ITEM_ACTION'')
	 select @rowcount = @@rowcount'
	 ),
(4, 'WORK_QUEUE_WORK_ITEM_RELATE', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.WORK_QUEUE_WORK_ITEM_RELATE
	 WHERE WORK_ITEM_ID IN (SELECT PRIMARYKEYID FROM #delWorkItemTempTable WHERE ObjectType = ''WORK_ITEM'')
	 select @rowcount = @@rowcount'
	 ),
(5, 'WORK_ITEM', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.WORK_ITEM
	 WHERE ID IN (SELECT PRIMARYKEYID FROM #delWorkItemTempTable WHERE ObjectType = ''WORK_ITEM'')
	 select @rowcount = @@rowcount'
	 ),
(6, 'TRADING_PARTNER_LOG', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.TRADING_PARTNER_LOG
	 WHERE ID IN (SELECT PRIMARYKEYID FROM #delChildTempTable WHERE ObjectType = ''TRADING_PARTNER_LOG'')
	 select @rowcount = @@rowcount'
	 ),
(7, 'RELATED_DATA', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.RELATED_DATA
	 WHERE ID IN (SELECT PRIMARYKEYID FROM #delChildTempTable WHERE ObjectType = ''RELATED_DATA'')
	 select @rowcount = @@rowcount'
	 ),
(8, 'INSURANCE_EXTRACT_TRANSACTION_DETAIL', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.INSURANCE_EXTRACT_TRANSACTION_DETAIL
	 WHERE ID IN (SELECT ID FROM #delINSURANCE_EXTRACT_TRANSACTION_DETAIL)
	 select @rowcount = @@rowcount'
	 ),
(9, 'LOAN_EXTRACT_TRANSACTION_DETAIL',
    'declare @output table (ID bigint)
     DELETE  FROM DBO.[LOAN_EXTRACT_TRANSACTION_DETAIL]
     OUTPUT deleted.ID into @output
	 WHERE ID IN (SELECT TOP (' + convert(varchar(8), @Batchsize) + ') ID FROM #delLOAN_EXTRACT_TRANSACTION_DETAIL where ID > @lastid order by ID)
	 select @rowcount = @@rowcount, @lastID = isnull(max(ID), @lastID) from @output'
	 ),
(10, 'COLLATERAL_EXTRACT_TRANSACTION_DETAIL',
    'declare @output table (ID bigint)
     DELETE  FROM DBO.[COLLATERAL_EXTRACT_TRANSACTION_DETAIL]
     OUTPUT deleted.ID into @output
	 WHERE ID IN (SELECT TOP (' + convert(varchar(8), @Batchsize) + ') ID FROM #delCOLLATERAL_EXTRACT_TRANSACTION_DETAIL where ID > @lastid order by ID)
	 select @rowcount = @@rowcount, @lastID = isnull(max(ID), @lastID) from @output'
	 ),
(11, 'OWNER_EXTRACT_TRANSACTION_DETAIL',
    'declare @output table (ID bigint)
     DELETE  FROM DBO.[OWNER_EXTRACT_TRANSACTION_DETAIL]
     OUTPUT deleted.ID into @output
	 WHERE ID IN (SELECT TOP (' + convert(varchar(8), @Batchsize) + ') ID FROM #delOWNER_EXTRACT_TRANSACTION_DETAIL where ID > @lastid order by ID)
	 select @rowcount = @@rowcount, @lastID = isnull(max(ID), @lastID) from @output'
	 ),

(20, 'TRANSACTION', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.[TRANSACTION]
	  WHERE ID IN (SELECT PRIMARYKEYID FROM #delChildTempTable WHERE ObjectType = ''TRANSACTION'')
	  select @rowcount = @@rowcount'
	  ),
(21, 'BLOB', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.BLOB
	  WHERE ID IN (SELECT PRIMARYKEYID FROM #delChildTempTable WHERE ObjectType = ''BLOB'')
	  select @rowcount = @@rowcount'
	  ),
(22, 'DOCUMENT', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.DOCUMENT
	  WHERE ID IN (SELECT PRIMARYKEYID FROM #delDocumentTempTable WHERE ObjectType = ''DOCUMENT'')
	  select @rowcount = @@rowcount'
	  ),
(23, 'EDI BLOB', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.BLOB
	  WHERE ID IN (SELECT PRIMARYKEYID FROM #delMessageTempTable WHERE ObjectType = ''EDIBLOB'')
	  select @rowcount = @@rowcount'
	  ),
(24, 'BSS BLOB', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.BLOB
	  WHERE ID IN (SELECT PRIMARYKEYID FROM #delMessageTempTable WHERE ObjectType = ''BSSBLOB'')
	  select @rowcount = @@rowcount'
	  ),
(25, 'Outbound MESSAGES', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.MESSAGE
	  WHERE ID IN (SELECT PRIMARYKEYID FROM #delMessageTempTable WHERE ObjectType = ''MESSAGE'' AND MESSAGE_DIRECTION_CD = ''O'')
	  select @rowcount = @@rowcount'
	  ),
(26, 'MESSAGE', 'DELETE TOP (' + convert(varchar(8), @Batchsize) + ') FROM DBO.MESSAGE
      WHERE ID IN (SELECT PRIMARYKEYID FROM #delMessageTempTable WHERE ObjectType = ''MESSAGE'' AND MESSAGE_DIRECTION_CD = ''I'')
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

while @@fetch_status = 0
begin

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

	SET @retryCount = 1
	SET @retry = 'Y'
	SET @totalRows = 0
	SET @TotalTime = 0
	SET @LastID = 1

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
				--	select count(*) FROM UNITRAC.DBO.INSURANCE_EXTRACT_TRANSACTION_DETAIL WHERE ID IN (SELECT ID FROM #delINSURANCE_EXTRACT_TRANSACTION_DETAIL)

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

  set lock_timeout -1

return


GO

