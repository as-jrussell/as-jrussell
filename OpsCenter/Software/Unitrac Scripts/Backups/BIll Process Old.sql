USE [msdb]
GO

/****** Object:  Job [Alert: Bill Process Verification]    Script Date: 12/30/2015 12:38:01 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/30/2015 12:38:01 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Alert: Bill Process Verification', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Number of failed bill processes that are being resubmitted', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ProcessMonitor]    Script Date: 12/30/2015 12:38:01 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ProcessMonitor', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET QUOTED_IDENTIFIER ON

declare @lastDate datetime;
--set @lastDate = ''2015-01-19''  --ends with the last second before this date

select @lastDate =(SELECT DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()-31)))


--drop table #Temp1
select pd.ID as PDId, MAX(pl.id) as PLId
into #Temp1
from PROCESS_DEFINITION pd
inner join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
	and pl.PURGE_DT is null
	and pl.CREATE_DT > @lastDate
	and pl.STATUS_CD != ''Reset''
where
pd.PROCESS_TYPE_CD = ''BILLING''
and pd.LAST_RUN_DT > @lastDate
--and pd.ID = 137840
group by pd.ID
order by pd.ID

--select ''t1'',* from #Temp1

--drop table #Temp2

select pli.PROCESS_LOG_ID as PLId
into #Temp2
from PROCESS_LOG_ITEM pli
inner join #Temp1 t1 on t1.PLId = pli.PROCESS_LOG_ID
where
pli.PURGE_DT is null

--select * from #Temp2

--drop table #Temp3

select pd.ID as PDId, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt, 
settings_xml_im.value (''(//ProcessDefinitionSettings/OriginatorWorkItemId)[1]'', ''varchar(50)'') as CycleWorkItem,
pd.* 
into #Temp3
from #Temp1 t1
inner join PROCESS_DEFINITION pd on pd.ID = t1.PDId
INNER JOIN PROCESS_LOG pl ON pl.ID = t1.PLId
WHERE
t1.PLId NOT IN (SELECT PLId FROM #Temp2)

--select * from #Temp3
--The following step takes those Billing Process Definitions that resulted
-- in no process log items and looks to see if they got realted to another Billing Work Item
--drop table #Temp4
SELECT List.Col AS CycleWorkItem
INTO #Temp4
FROM work_item_action wia
INNER JOIN work_item wi ON wi.id = wia.work_item_id
	AND wi.relate_type_cd = ''Allied.UniTrac.BillingGroup''
INNER JOIN
    	(
    		SELECT	t3.CycleWorkItem AS Col FROM #Temp3 t3
    	) List ON wia.action_note_tx LIKE ''%''+List.Col+''%''

CREATE TABLE #TMP_PDId (
		PD_ID BIGINT
	)

INSERT INTO #TMP_PDId
SELECT t3.PDId FROM #Temp3 t3
WHERE
t3.CycleWorkItem NOT IN (SELECT t4.CycleWorkItem FROM #Temp4 t4)


INSERT INTO #TMP_PDId
SELECT pd.ID AS PDId--, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt, pli.ID as PLIId, pli.*
FROM PROCESS_DEFINITION pd
INNER JOIN PROCESS_LOG pl ON pl.PROCESS_DEFINITION_ID = pd.ID
	AND pl.CREATE_DT > @lastDate
	AND pl.PURGE_DT IS NULL
INNER JOIN #Temp1 t1 ON t1.PLId = pl.ID
INNER JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = pl.ID
	AND pli.PURGE_DT IS NULL
	AND pli.STATUS_CD = ''ERR''
	AND pli.RELATE_TYPE_CD = ''Allied.UniTrac.BillingGroup''
WHERE
pd.PROCESS_TYPE_CD = ''BILLING''
AND pd.LAST_RUN_DT > @lastDate

--drop table #Temp5
SELECT DISTINCT(pd.ID) 
INTO #Temp5
FROM BILLING_GROUP bg
INNER JOIN PROCESS_LOG_ITEM pli ON pli.RELATE_ID = bg.ID
	AND pli.RELATE_TYPE_CD = ''Allied.UniTrac.BillingGroup''
	AND pli.PURGE_DT IS NULL
INNER JOIN PROCESS_LOG pl ON pl.ID = pli.PROCESS_LOG_ID
	AND pli.PURGE_DT IS NULL
INNER JOIN PROCESS_DEFINITION pd ON pd.ID = pl.PROCESS_DEFINITION_ID
INNER JOIN #Temp1 t1 ON t1.PLId = pl.ID
WHERE bg.CREATE_DT > @lastDate AND bg.TYPE_CD = ''PEND''

INSERT INTO #TMP_PDId
SELECT pd.ID AS PDId--, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt
FROM PROCESS_DEFINITION pd
INNER JOIN PROCESS_LOG pl ON pl.PROCESS_DEFINITION_ID = pd.ID
INNER JOIN #Temp5 t5 ON t5.ID = pd.ID
WHERE pd.DESCRIPTION_TX = ''REGENERATE''

SELECT * FROM #TMP_PDId

DECLARE @EmailSubject AS VARCHAR(100)
DECLARE @EmailSubjectCount AS INT
DECLARE @body NVARCHAR(MAX)

 SELECT @EmailSubjectCount =
( SELECT COUNT(PD_ID) FROM #TMP_PDId)

 IF @EmailSubjectCount > 0
 BEGIN
 
 UPDATE pd
SET STATUS_CD = ''Complete''
     , OVERRIDE_DT = GETDATE()
     , [LOCK_ID] = ([LOCK_ID] % 255) + 1
 ,[UPDATE_DT] = GETDATE()
 ,[UPDATE_USER_TX] = ''ADMIN''
--select *
FROM PROCESS_DEFINITION pd
INNER JOIN #TMP_PDId t1 ON t1.PD_ID = pd.ID

UPDATE pli
SET pli.purge_dt = GETDATE(),
pli.UPDATE_DT = GETDATE(),
pli.UPDATE_USER_TX = ''ADMIN'',
pli.LOCK_ID = (pli.LOCK_ID % 255) + 1
--select *
FROM PROCESS_LOG_ITEM pli
WHERE
pli.ID IN (
	SELECT pli.ID 
	FROM PROCESS_DEFINITION pd
	INNER JOIN PROCESS_LOG pl ON pl.PROCESS_DEFINITION_ID = pd.ID
		AND pl.PURGE_DT IS NULL
	INNER JOIN PROCESS_LOG_ITEM pli ON pli.PROCESS_LOG_ID = pl.ID
		AND pli.PURGE_DT IS NULL
		AND pli.STATUS_CD = ''ERR''
		AND pli.RELATE_TYPE_CD = ''Allied.UniTrac.BillingGroup''
	WHERE
	pd.ID IN (SELECT PD_ID FROM #TMP_PDId)
)

		SELECT 
					(SELECT 
						  CAST(PD_ID AS VARCHAR(20)) + '', '' 
					FROM #TMP_PDId
					FOR XML PATH ('''')) AS PDIds
		INTO #tmp



		SELECT @body = ''PROCESS ID(s): '' + (SELECT * FROM #tmp)
		 
		SELECT @EmailSubject = ''The number OF failed bill processes that ARE being resubmitted : '' +  CONVERT(VARCHAR(20), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = ''Unitrac-prod'',
						@recipients = ''richard.wood@ospreysoftware.com;joseph.russell@alliedsolutions.net;wendy.walker@alliedsolutions.net;mike.breitsch@alliedsolutions.net'',
						@subject = @EmailSubject,
						@body = @body
					RETURN
END', 
		@database_name=N'UniTrac', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every 2 HOURS, FROM 12:10 AM CST', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=2, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20151111, 
		@active_end_date=99991231, 
		@active_start_time=1000, 
		@active_end_time=230959, 
		@schedule_uid=N'1c257e07-a3da-4681-b01f-f793ecb905d0'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(LOCAL)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


