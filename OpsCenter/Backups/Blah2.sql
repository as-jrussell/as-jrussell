USE [msdb]
GO

/****** Object:  Job [Alert: Failed Messages]    Script Date: 10/3/2016 12:47:35 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 10/3/2016 12:47:35 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Alert: Failed Messages', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Failed Messages]    Script Date: 10/3/2016 12:47:36 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Failed Messages', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE [UniTrac]
GO 

SET QUOTED_IDENTIFIER ON


SELECT * INTO #TMP_PDId FROM dbo.MESSAGE M
WHERE   M.RECEIVED_STATUS_CD = ''ERR''
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)


SELECT COUNT(ID) FROM #TMP_PDId






DECLARE @EmailSubject AS VARCHAR(100)
declare @EmailSubjectCount AS int
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount =
( SELECT count(ID) from #TMP_PDId)

 if @EmailSubjectCount > 5
 Begin

		SELECT 
					(SELECT 
						  CAST(ID AS VARCHAR(20)) + '', '' 
					FROM #TMP_PDId
					FOR xml PATH ('''')) AS PDIds
		INTO #tmp


		select @body = ''Failed Message Count: '' + (select * from #tmp)
		
		select @EmailSubject = ''The number of failed message count : '' +  CONVERT(VARCHAR(20), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = ''Unitrac-prod'',
						@recipients = ''joseph.russell@alliedsolutions.net; wendy.walker@alliedsolutions.net; mike.breitsch@alliedsolutions.net'',
						@subject = @EmailSubject,
						@body = @body
					RETURN
End', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Checks', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=65, 
		@freq_subday_type=8, 
		@freq_subday_interval=4, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20160112, 
		@active_end_date=99991231, 
		@active_start_time=1000, 
		@active_end_time=959, 
		@schedule_uid=N'3084e000-3c35-4ac5-8353-36e19a613520'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

