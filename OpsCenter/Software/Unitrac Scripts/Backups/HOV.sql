USE [msdb]
GO

/****** Object:  Job [Alert: HOV Batch Alerts]    Script Date: 12/4/2019 7:49:09 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/4/2019 7:49:10 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Alert: HOV Batch Alerts', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Job that queries the output batch tables every 15 minutes during business hours to determine if batches are being picked up by HOV', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ELDREDGE_A\MBreitsch', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Check If AG Secondary]    Script Date: 12/4/2019 7:49:11 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Check If AG Secondary', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=4, 
		@on_success_step_id=3, 
		@on_fail_action=3, 
		@on_fail_step_id=3, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @database_name nvarchar(50)=''UniTrac''
If sys.fn_hadr_is_primary_replica (@database_name) <> 1

BEGIN
  PRINT ''Secondary - Job can proceed''
END
ELSE 
BEGIN
  -- Deliberately cause a Failure
;THROW 51000, ''This is not a Secondary Replica'', 1
 END
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Check If AG Primary]    Script Date: 12/4/2019 7:49:11 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Check If AG Primary', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=3, 
		@on_fail_action=1, 
		@on_fail_step_id=1, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @database_name nvarchar(50)=''UniTrac''
If (sys.fn_hadr_is_primary_replica (@database_name) = 1 and  (SELECT COUNT(*)
		FROM sys.availability_groups_cluster AS C
        INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS CS
            ON CS.group_id = C.group_id
        INNER JOIN sys.dm_hadr_availability_replica_states AS RS
            ON RS.replica_id = CS.replica_id
		WHERE RS.synchronization_health=2)=1)
    BEGIN
       PRINT ''Primary - Job can proceed''
    END
    ELSE
    BEGIN	
   -- Deliberately cause a Failure
 ;THROW 51000, ''This Primary Replica has secondaries'', 1
    END', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Script to monitor Output Batch Logs]    Script Date: 12/4/2019 7:49:11 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Script to monitor Output Batch Logs', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Declare @LastAckDt as datetime

select Top 1 CREATE_DT into #tmpAck
from OUTPUT_BATCH_LOG
WHERE LOG_TXN_TYPE_CD IN (''ACK'',''Verify'') and CREATE_DT >= DateAdd(mi, -30, getdate())
order by CREATE_DT desc

select @LastAckDt = CREATE_DT
from #tmpAck

DROP TABLE #tmpAck

If @LastAckDt is null 
        BEGIN
            EXEC msdb.dbo.sp_send_dbmail @profile_name = ''Unitrac-prod'',
                @recipients =''ITAdmins-UniTrac@alliedsolutions.net;sharlene.bruinsma@alliedsolutions.net'',
                @subject = ''Alert: No HOV Batches have been picked up in the past 30 minutes'',
                @body = ''No entries have been added into the UniTrac OUTPUT_BATCH_LOG table in the past 30 minutes with ACK or Verify status. Please review the UnitracHOV folder on the FTP server to make sure that batches are indeed waiting. If they are, then we currently notify HOV and request they restart their retrieval service.  

http://connections.alliedsolutions.net/forums/html/topic?id=f613db80-3c07-48c8-ae9c-c5206bb18cf6
This alert is active from 8am CST to 5pm CST and runs every 15 minutes.

(SQL Agent Job named Alert: HOV Batch Alerts   on UNITRAC AG Secondary''
            RETURN
        END', 
		@database_name=N'UniTrac', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every 15 minutes from 6:00 AM CST to 5:00 PM CST', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=4, 
		@freq_subday_interval=15, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20170818, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=170000, 
		@schedule_uid=N'f4009d4c-c6ae-4409-a980-536b95ebc6ff'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

