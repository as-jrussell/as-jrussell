USE [msdb]
GO

/****** Object:  Job [Report: Unitrac Errors (Production)]    Script Date: 10/18/2019 8:32:47 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 10/18/2019 8:32:47 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Report: Unitrac Errors (Production)', 
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
/****** Object:  Step [Remove Old File]    Script Date: 10/18/2019 8:32:48 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Remove Old File', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'PowerShell', 
		@command=N'Remove-Item "E:\SQL\UT_Errors.csv"', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Save File]    Script Date: 10/18/2019 8:32:48 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Save File', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'PowerShell', 
		@command=N'Invoke-SQLcmd -QueryTimeout 0 -Server ''ON-SQLCLSTPRD-1'' -Database Unitrac ''exec UT_Errors '' | Export-Csv -path "E:\SQL\UT_Errors.csv"', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Email]    Script Date: 10/18/2019 8:32:48 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Email', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
use unitrac

set QUOTED_IDENTIFIER on 



CREATE TABLE #Temp 
( [pd_id]  [varchar](40),
  [pd_name_tx]  [varchar](40),
  [days_pend_rematch_now] [varchar](40) )

INSERT INTO #Temp
exec UT_MessageTypeBreakDown




DECLARE @xml NVARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)

SET @xml = CAST(( SELECT [pd_id]  AS ''td'','''',
[pd_name_tx] AS ''td'','''',
[days_pend_rematch_now] AS ''td'',''''

FROM #Temp 
 ORDER BY pd_id
FOR XML PATH(''tr''), ELEMENTS ) AS NVARCHAR(MAX))


SET @xml = CAST(( SELECT [pd_id]  AS ''td'','''',
[pd_name_tx] AS ''td'','''',
[days_pend_rematch_now] AS ''td'',''''

FROM #Temp 
 ORDER BY pd_id
FOR XML PATH(''tr''), ELEMENTS ) AS NVARCHAR(MAX))

SET @body =''Please check the errors to see if there are any major consistency that needs to be researched (see attachment above)
also please be mindful of the last run was has been recent (below graph)

<html><body><H3>Unitrac Errors</H3>
<table border = 1> 
<tr>
<th> Message Type </th> <th>LAST RUN </th><th> Count </th></tr>''


SET @body = @body + @xml +''</table></body></html>''


            EXEC msdb.dbo.sp_send_dbmail 
			@Subject= ''Report of Errors (Production)'',
			@profile_name = ''Unitrac-prod'',
			@body = @body,
			@body_format =''HTML'',			
            @recipients = ''joseph.russell@alliedsolutions.net;noc@alliedsolutions.net'',
			 @file_attachments= ''E:\SQL\UT_Errors.csv'';
', 
		@database_name=N'model', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Unitrac Errors Report', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=8, 
		@freq_subday_interval=4, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20181105, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959, 
		@schedule_uid=N'8c96db6b-1faf-4e21-8691-e381bd0afe0f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


