USE [msdb]
GO

/****** Object:  Job [Work: LFP Message Move for Consumers Credit Union]    Script Date: 4/8/2019 9:44:55 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 4/8/2019 9:44:55 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Work: LFP Message Move for Consumers Credit Union', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'LFP Message Move to ADHOC for lender Consumers Credit Union it was promised to the lender that the files would be processed as early as possible.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'JC', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [LFP Message]    Script Date: 4/8/2019 9:44:56 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'LFP Message', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
Use Unitrac


SET QUOTED_IDENTIFIER ON 

CREATE TABLE #tmpM (ID BIGINT)

INSERT INTO #tmpM
SELECT WI.RELATE_ID 
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = ''Approve'' AND 
WORKFLOW_DEFINITION_ID = ''1''  AND WI.CONTENT_XML.value(''(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]'', ''varchar (50)'') IS NULL 
AND WI.LENDER_ID = ''867''


IF ((select count(*) from #tmpM) >=1 )
BEGIN 


DECLARE @EmailSubject AS VARCHAR(MAX )
declare @EmailSubjectCount AS VARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(ID) FROM #tmpM)
  BEGIN

 if @EmailSubjectCount >= 1 
 

SELECT ID INTO #tmpMM FROM dbo.MESSAGE
WHERE RELATE_ID_TX IN (SELECT * FROM #tmpM
)


UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = ''OBADHOC''
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   ID IN (SELECT * FROM #tmpMM)



SELECT TP.NAME_TX INTO #tmpOPP FROM dbo.MESSAGE M
JOIN dbo.TRADING_PARTNER TP ON TP.ID = M.RECEIVED_FROM_TRADING_PARTNER_ID
WHERE M.ID IN (SELECT ID FROM #tmpMM)
		
SELECT ID INTO #tmpOP FROM dbo.MESSAGE
WHERE ID IN (SELECT ID FROM #tmpMM)

 	SELECT 
					(SELECT 
						  CAST(NAME_TX AS NVARCHAR(max)) + ''; '' 
					FROM #tmpOPP
					FOR XML PATH ('''')) AS OutBatchID
		INTO #tmpO

 	SELECT 
					(SELECT 
						  CAST(ID AS NVARCHAR(max)) + '', '' 
					FROM #tmpOP
					FOR XML PATH ('''')) AS OutBatchID
		INTO #tmpOO



select @body = ''The Message Id(s) that is were moved to ADHOC: 
''  + (SELECT * FROM #tmpOO) + 
''

Lender : '' + (SELECT * FROM #tmpO) 

  

select @EmailSubject = ''Messages: ''  +   CONVERT(VARCHAR(MAX), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = ''Unitrac-prod'',
						@recipients = ''joseph.russell@alliedsolutions.net;'',
						@subject = @EmailSubject,
						@body = @body
					RETURN

END END 
', 
		@database_name=N'UniTrac', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Schedule 3', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170307, 
		@active_end_date=99991231, 
		@active_start_time=80000, 
		@active_end_time=235959, 
		@schedule_uid=N'1cfc73ec-1240-40ee-978b-3857046fc228'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Scheduled', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170307, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959, 
		@schedule_uid=N'af6c1abe-7ecb-4662-8182-e7bb90bf9c8c'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Scheduled 2', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170307, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=235959, 
		@schedule_uid=N'4b20deff-11e1-422a-a48e-5f5e1c2b79a7'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Scheduled 4', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170307, 
		@active_end_date=99991231, 
		@active_start_time=90000, 
		@active_end_time=235959, 
		@schedule_uid=N'61792c50-2b51-4169-8ac4-c5be3ec65f95'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Scheduled 5', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170308, 
		@active_end_date=99991231, 
		@active_start_time=100000, 
		@active_end_time=235959, 
		@schedule_uid=N'090319e2-db3d-4070-a4d6-6efe377e5cb9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Scheduled 6', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170912, 
		@active_end_date=99991231, 
		@active_start_time=110000, 
		@active_end_time=235959, 
		@schedule_uid=N'ee870dc2-d0e3-4e54-a4b5-410b21bcb5f8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

