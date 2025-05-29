USE [msdb]
GO

/****** Object:  Job [Alert: Work Items coming up zero]    Script Date: 1/17/2017 10:34:36 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 1/17/2017 10:34:36 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Alert: Work Items coming up zero', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'This will be only needed for a week, but this is to verify check to see if there are any work items that are showing as zero and get them over to ISS for verification.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Work Items are zero]    Script Date: 1/17/2017 10:34:37 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Work Items are zero', 
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
 
SELECT  PD.ID, PL.MSG_TX INTO #tmpSK
FROM    dbo.PROCESS_LOG PL
        JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE   CAST(PL.UPDATE_DT AS DATE) = CAST(GETDATE()-1  AS DATE)
        AND PD.PROCESS_TYPE_CD = ''CYCLEPRC''
        AND (PL.MSG_TX = ''Total WorkItems processed: 0'' OR  PL.MSG_TX IS  NULL)



CREATE TABLE #tmpEmptyPL (PD_ID BIGINT)

INSERT INTO #tmpEmptyPL
SELECT DISTINCT PD.ID FROM #tmpSK T
LEFT JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = T.ID
LEFT JOIN dbo.PROCESS_LOG PL ON PL.PROCESS_DEFINITION_ID = T.ID
WHERE CAST(PL.UPDATE_DT AS DATE) >= CAST(GETDATE() - 8 AS DATE)
AND  CAST(PL.UPDATE_DT AS DATE) <= CAST(GETDATE() - 7 AS DATE)
        AND PROCESS_TYPE_CD = ''CYCLEPRC'' 
        AND PL.MSG_TX <> T.MSG_TX

IF ((select count(*) from #tmpEmptyPL)>= 1)

BEGIN

DECLARE @EmailSubject AS VARCHAR(1000)
declare @EmailSubjectCount AS VARCHAR(1000)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(PD_ID) FROM #tmpEmptyPL)
 

 if @EmailSubjectCount >= 1 
 
 BEGIN
SELECT NAME_TX INTO #tmpOP FROM dbo.PROCESS_DEFINITION
WHERE ID IN (SELECT * FROM #tmpEmptyPL)
		
 

 	SELECT 
					(SELECT 
						  CAST(NAME_TX AS NVARCHAR(1000)) + ''; '' 
					FROM #tmpOP
					FOR XML PATH ('''')) AS OutBatchID
		INTO #tmpO

 	SELECT 
					(SELECT 
						  CAST(PD_ID AS NVARCHAR(1000)) + '', '' 
					FROM #tmpEmptyPL
					FOR XML PATH ('''')) AS PD_ID
		INTO #tmpOO


select @body = ''These Process Definition Names are showing zero work items: 
''  + (SELECT * FROM #tmpO)+

''

The Process Ids are: '' + (SELECT * FROM #tmpOO)
   END 

select @EmailSubject = ''Empty Work Items: ''  +   CONVERT(VARCHAR(1000), @EmailSubjectCount) 
		 

  
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = ''Unitrac-prod'',
						@recipients =''joseph.russell@alliedsolutions.net;wendy.walker@alliedsolutions.net;iss@alliedsolutions.net; jennifer.mitchell@alliedsolutions.net'',
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
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Alert: Cycle Work Items are zero', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20161025, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=235959, 
		@schedule_uid=N'39484a81-dcea-4253-9911-e5f86b849c01'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

