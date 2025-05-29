USE [msdb]
GO

/****** Object:  Job [Alert: Daily console check]    Script Date: 1/17/2017 12:28:51 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 1/17/2017 12:28:52 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Alert: Daily console check', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'To check to ensure there are no batches that are coming up in error if so update then send email', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Daily console check]    Script Date: 1/17/2017 12:28:52 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Daily console check', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Use Unitrac

 Begin

 
CREATE TABLE #TMP (OUTBATCH_ID BIGINT)

INSERT INTO #TMP
 SELECT ID  FROM dbo.OUTPUT_BATCH WHERE STATUS_CD = ''ERR'' AND CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
   AND EXTERNAL_ID not LIKE ''RPT%''


IF ((select count(*) from #TMP) >=1 )
BEGIN


DECLARE @EmailSubject AS NVARCHAR(100)
declare @EmailSubjectCount AS VARCHAR(100)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(OUTBATCH_ID) FROM #tmp)
 

 if @EmailSubjectCount >= 1 
 
 
 UPDATE dbo.OUTPUT_BATCH
 SET STATUS_CD = ''PEND'', LOCK_ID = LOCK_ID+1
 WHERE ID IN (SELECT OUTBATCH_ID FROM #tmp)

 	SELECT 
					(SELECT 
						  CAST(OUTBATCH_ID AS VARCHAR(20)) + '', '' 
					FROM #tmp
					FOR XML PATH ('''')) AS OutBatchID
		INTO #tmpO

		
select @body = ''These batches ID were in error: ''  + (SELECT * FROM #tmpO)


select @EmailSubject = ''Batches in Error ''  +   CONVERT(VARCHAR(20), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = ''Unitrac-prod'',
						@recipients = ''joseph.russell@alliedsolutions.net; anthony.newbern@alliedsolutions.net'',
						@subject = @EmailSubject,
						@body = @body
					RETURN
END

END', 
		@database_name=N'UniTrac', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily Check', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=8, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20161013, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=160000, 
		@schedule_uid=N'7f4e4fb0-e31f-4027-9a12-7d4a379aef3f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

