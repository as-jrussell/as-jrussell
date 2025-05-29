USE [msdb]

GO

/****** Object:  Job [IVOS-ISO_Reprocess]    Script Date: 12/19/2022 4:17:41 PM ******/
BEGIN TRANSACTION

DECLARE @ReturnCode INT

SELECT @ReturnCode = 0

/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/19/2022 4:17:41 PM ******/
IF NOT EXISTS (SELECT name
               FROM   msdb.dbo.syscategories
               WHERE  name = N'[Uncategorized (Local)]'
                      AND category_class = 1)
  BEGIN
      EXEC @ReturnCode = msdb.dbo.Sp_add_category
        @class=N'JOB',
        @type=N'LOCAL',
        @name=N'[Uncategorized (Local)]'

      IF ( @@ERROR <> 0
            OR @ReturnCode <> 0 )
        GOTO QuitWithRollback
  END

DECLARE @jobId BINARY(16)

EXEC @ReturnCode = msdb.dbo.Sp_add_job
  @job_name=N'IVOS-ISO_Reprocess',
  @enabled=1,
  @notify_level_eventlog=0,
  @notify_level_email=0,
  @notify_level_netsend=0,
  @notify_level_page=0,
  @delete_level=0,
  @description=N'This job will great things based on JIRA AIH-17460.',
  @category_name=N'[Uncategorized (Local)]',
  @owner_login_name=N'RDSAgentJobUser',
  @job_id = @jobId OUTPUT

IF ( @@ERROR <> 0
      OR @ReturnCode <> 0 )
  GOTO QuitWithRollback

/****** Object:  Step [IVOS-ISO_Reprocess]    Script Date: 12/19/2022 4:17:42 PM ******/
EXEC @ReturnCode = msdb.dbo.Sp_add_jobstep
  @job_id=@jobId,
  @step_name=N'IVOS-ISO_Reprocess',
  @step_id=1,
  @cmdexec_success_code=0,
  @on_success_action=1,
  @on_success_step_id=0,
  @on_fail_action=2,
  @on_fail_step_id=0,
  @retry_attempts=0,
  @retry_interval=0,
  @os_run_priority=0,
  @subsystem=N'TSQL',
  @command=N'
SET NOCOUNT ON;
-- Declare local variables
DECLARE @NumberOfLoops AS int;
SET @NumberOfLoops = 1;
WHILE ( @NumberOfLoops <= 10)
    BEGIN
EXEC IVOS.dbo.ISO_Reprocess @Count = ''100'', @WhatIf = 0
 WAITFOR DELAY ''00:00:00:50'';
 SET @NumberOfLoops = @NumberOfLoops + 1;
    END
',
  @database_name=N'IVOS',
  @flags=0

IF ( @@ERROR <> 0
      OR @ReturnCode <> 0 )
  GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.Sp_update_job
  @job_id = @jobId,
  @start_step_id = 1

IF ( @@ERROR <> 0
      OR @ReturnCode <> 0 )
  GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.Sp_add_jobschedule
  @job_id=@jobId,
  @name=N'IVOS-ISO_Reprocess_Schedule',
  @enabled=1,
  @freq_type=4,
  @freq_interval=1,
  @freq_subday_type=1,
  @freq_subday_interval=0,
  @freq_relative_interval=0,
  @freq_recurrence_factor=0,
  @active_start_date=20221219,
  @active_end_date=99991231,
  @active_start_time=210000,
  @active_end_time=235959,
  @schedule_uid=N'ef5a9439-cca8-4713-a33c-47785132dc2e'

IF ( @@ERROR <> 0
      OR @ReturnCode <> 0 )
  GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.Sp_add_jobserver
  @job_id = @jobId,
  @server_name = N'(local)'

IF ( @@ERROR <> 0
      OR @ReturnCode <> 0 )
  GOTO QuitWithRollback

COMMIT TRANSACTION

GOTO EndSave

QUITWITHROLLBACK:

IF ( @@TRANCOUNT > 0 )
  ROLLBACK TRANSACTION

ENDSAVE:

GO 
