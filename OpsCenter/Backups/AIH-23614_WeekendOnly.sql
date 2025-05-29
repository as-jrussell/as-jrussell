USE [msdb];

/* Set variables */
DECLARE @JobName        VARCHAR(200) = 'Unitrac-ArchivePropertyChange_WeekendOnly_Archive',
        @EnableNewJobs  BIT = 1,/* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
        @ScheduleID     INT,
        @StepID         INT = 2,
        @StartStep      INT = 1,
        @StepName       VARCHAR(100),
        @ScheduleName   VARCHAR(256),
        @JobCategory    VARCHAR(100) = 'Unitrac',
        @description    VARCHAR(256),
        @notifyOperator VARCHAR(100) = 'NOCAlert';

/* Update the job */
EXEC msdb.dbo.Sp_update_job
  @job_name= @JobName,
  @start_step_id = @StartStep,
  @enabled= @EnableNewJobs,
  @notify_level_eventlog=2,
  @notify_level_email=2,
  @notify_level_netsend=0,
  @notify_level_page=0,
  @delete_level=0,
  @description= @description,
  @category_name= @JobCategory,
  @owner_login_name=N'sa',
  @notify_email_operator_name=@notifyOperator

/* Update the job step */
EXEC msdb.dbo.Sp_update_jobstep
  @job_name= @JobName,
  @step_name= @StepName,
  @step_id=@StepID,
  @cmdexec_success_code=0,
  @on_success_action=1,-- 3=go to next step, 1=quit with succes
  @on_success_step_id=0,
  @on_fail_action=2,
  @on_fail_step_id=0,
  @retry_attempts=0,
  @retry_interval=0,
  @os_run_priority=0,
  @subsystem=N'TSQL',
  @command=N'use unitrac


SET NOCOUNT ON;



-- Declare local variables
DECLARE @NumberOfLoops AS int;
DECLARE @CurrentLoop AS int;
DECLARE @RC int
DECLARE @Batchsize int
DECLARE @createdateoffset int
DECLARE @DoDELETE int
DECLARE @process_log_id bigint



SET @NumberOfLoops = 1;




WHILE ( @NumberOfLoops <= 15000)
    BEGIN
        -- Just delete any xxx rows that are below the HighWaterMark
   EXECUTE @RC = [dbo].[ArchivePropertyChange] 
   @Batchsize = 3000
  ,@createdateoffset = 450
  ,@DoDELETE = 1
  ,@process_log_id = NULL  
        WAITFOR DELAY ''00:00:01:00'';
          
        SET @NumberOfLoops = @NumberOfLoops + 1;
    END


	',
  @database_name= @JobCategory,
  @flags=0; 
