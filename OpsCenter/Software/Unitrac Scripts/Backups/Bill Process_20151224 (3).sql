USE [msdb]
GO

/****** Object:  Job [Alert: Bill Process Verification]    Script Date: 12/24/2015 9:13:25 AM ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'b5516753-d91c-4376-b4d7-5b150e6f3286', @delete_unused_schedule=1
GO

/****** Object:  Job [Alert: Bill Process Verification]    Script Date: 12/24/2015 9:13:25 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/24/2015 9:13:25 AM ******/
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
/****** Object:  Step [ProcessMonitor]    Script Date: 12/24/2015 9:13:26 AM ******/
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
and pd.STATUS_CD != ''InProcess''
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
inner join PROCESS_LOG pl on pl.ID = t1.PLId
where
t1.PLId not in (select PLId from #Temp2)

--select * from #Temp3
--The following step takes those Billing Process Definitions that resulted
-- in no process log items and looks to see if they got realted to another Billing Work Item
--drop table #Temp4
select List.Col as CycleWorkItem
into #Temp4
from work_item_action wia
inner join work_item wi on wi.id = wia.work_item_id
	and wi.relate_type_cd = ''Allied.UniTrac.BillingGroup''
INNER JOIN
    	(
    		SELECT	t3.CycleWorkItem as Col from #Temp3 t3
    	) List ON wia.action_note_tx like ''%''+List.Col+''%''

CREATE TABLE #TMP_PDId (
		PD_ID bigint
	)

INSERT INTO #TMP_PDId
select t3.PDId from #Temp3 t3
where
t3.CycleWorkItem not in (select t4.CycleWorkItem from #Temp4 t4)


INSERT INTO #TMP_PDId
select pd.ID as PDId--, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt, pli.ID as PLIId, pli.*
from PROCESS_DEFINITION pd
inner join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
	and pl.CREATE_DT > @lastDate
	and pl.PURGE_DT is null
inner join #Temp1 t1 on t1.PLId = pl.ID
inner join PROCESS_LOG_ITEM pli on pli.PROCESS_LOG_ID = pl.ID
	and pli.PURGE_DT is null
	and pli.STATUS_CD = ''ERR''
	and pli.RELATE_TYPE_CD = ''Allied.UniTrac.BillingGroup''
where
pd.PROCESS_TYPE_CD = ''BILLING''
and pd.STATUS_CD != ''InProcess''
and pd.LAST_RUN_DT > @lastDate

--drop table #Temp5
select distinct(pd.ID) 
into #Temp5
from BILLING_GROUP bg
inner join PROCESS_LOG_ITEM pli on pli.RELATE_ID = bg.ID
	and pli.RELATE_TYPE_CD = ''Allied.UniTrac.BillingGroup''
	and pli.PURGE_DT is null
inner join PROCESS_LOG pl on pl.ID = pli.PROCESS_LOG_ID
	and pli.PURGE_DT is null
inner join PROCESS_DEFINITION pd on pd.ID = pl.PROCESS_DEFINITION_ID
inner join #Temp1 t1 on t1.PLId = pl.ID
where bg.CREATE_DT > @lastDate and bg.TYPE_CD = ''PEND''

INSERT INTO #TMP_PDId
select pd.ID as PDId--, pl.ID as PLId, pl.STATUS_CD PLStatus_Cd, pd.OVERRIDE_DT as PDOverrideDt
from PROCESS_DEFINITION pd
inner join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
inner join #Temp5 t5 on t5.ID = pd.ID
where pd.DESCRIPTION_TX = ''Regenerate''

select * from #TMP_PDId

DECLARE @EmailSubject AS VARCHAR(100)
declare @EmailSubjectCount AS int
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount =
( SELECT count(PD_ID) from #TMP_PDId)

 if @EmailSubjectCount > 0
 Begin
 
 UPDATE pd
SET STATUS_CD = ''Complete''
     , OVERRIDE_DT = GETDATE()
     , [LOCK_ID] = ([LOCK_ID] % 255) + 1
 ,[UPDATE_DT] = GetDate()
 ,[UPDATE_USER_TX] = ''ADMIN''
--select *
from PROCESS_DEFINITION pd
inner join #TMP_PDId t1 on t1.PD_ID = pd.ID

update pli
set pli.purge_dt = GETDATE(),
pli.UPDATE_DT = GETDATE(),
pli.UPDATE_USER_TX = ''ADMIN'',
pli.LOCK_ID = (pli.LOCK_ID % 255) + 1
--select *
from PROCESS_LOG_ITEM pli
where
pli.ID in (
	select pli.ID 
	from PROCESS_DEFINITION pd
	inner join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
		and pl.PURGE_DT is null
	inner join PROCESS_LOG_ITEM pli on pli.PROCESS_LOG_ID = pl.ID
		and pli.PURGE_DT is null
		and pli.STATUS_CD = ''ERR''
		and pli.RELATE_TYPE_CD = ''Allied.UniTrac.BillingGroup''
	where
	pd.ID in (select PD_ID from #TMP_PDId)
)

		SELECT 
					(SELECT 
						  CAST(PD_ID AS VARCHAR(20)) + '', '' 
					FROM #TMP_PDId
					FOR xml PATH ('''')) AS PDIds
		INTO #tmp



		select @body = ''Process ID(s): '' + (select * from #tmp)
		 
		select @EmailSubject = ''The number of failed bill processes that are being resubmitted : '' +  CONVERT(VARCHAR(20), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = ''Unitrac-prod'',
						@recipients = ''richard.wood@ospreysoftware.com;joseph.russell@alliedsolutions.net;wendy.walker@alliedsolutions.net;mike.breitsch@alliedsolutions.net'',
						@subject = @EmailSubject,
						@body = @body
					RETURN
End', 
		@database_name=N'UniTrac', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every 2 hours, from 12:10 AM CST', 
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
		@active_end_time=120959, 
		@schedule_uid=N'1c257e07-a3da-4681-b01f-f793ecb905d0'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

