USE [msdb]
GO

/****** Object:  Job     Script Date: 3/17/2020 2:12:22 PM ******/
DECLARE @JobName        VARCHAR(200) = 'PerfStats-CaptureAGLagStats',
        @EnableNewJobs  BIT,/* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
        @ScheduleID     INT,
        @StepID         INT = 0,
        @StepName       VARCHAR(100),
        @StartStep      INT = 1,
        @ScheduleName   VARCHAR(256),
        @JobCategory    VARCHAR(100) = 'Data Collector',-- Was PerfStats 
        @description    VARCHAR(256),
        @notifyOperator VARCHAR(100) = 'dbAlert';
/* JOB required parameter */
DECLARE @Version NUMERIC(18, 10),
        @cmd     NVARCHAR(MAX),
        @output  NVARCHAR(MAX)

IF EXISTS (SELECT rs.role_desc
           FROM   sys.dm_hadr_availability_replica_cluster_nodes n
                  JOIN sys.dm_hadr_availability_replica_cluster_states cs
                    ON n.replica_server_name = cs.replica_server_name
                  JOIN sys.dm_hadr_availability_replica_states rs
                    ON rs.replica_id = cs.replica_id
           WHERE  role_desc = 'PRIMARY')
  BEGIN
      SET @EnableNewJobs = 1 /* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
  END
ELSE
  BEGIN
      SET @EnableNewJobs = 0 /* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
  END

/* Create Standard job schedule */
SELECT @ScheduleName = @jobName + '_Schedule'

SELECT @description = 'This AG (Availability Group) stats document contains the synchronization status, 
the health status, and the performance of each database in the AG'

/* Add necessary categories */
IF NOT EXISTS (SELECT name
               FROM   msdb.dbo.syscategories
               WHERE  name = @JobCategory
                      AND category_class = 1)
  BEGIN
      EXEC msdb.dbo.Sp_add_category
        @class=N'JOB',
        @type=N'LOCAL',
        @name=@JobCategory
  END

/* Check if the job exists and create if it doesn't */
IF NOT EXISTS (SELECT *
               FROM   msdb..sysjobs
               WHERE  name = @JobName)
  BEGIN
      EXEC msdb.dbo.Sp_add_job
        @job_name = @JobName,
        @enabled=0;
  END
ELSE
  BEGIN
      IF EXISTS (SELECT *
                 FROM   sys.objects
                 WHERE  object_id = Object_id(N'dbo.rds_backup_database')
                        AND type IN ( N'P', N'PC' ))
        BEGIN
            IF NOT EXISTS(SELECT *
                          FROM   msdb..sysjobs
                          WHERE  name = @JobName
                                 AND owner_SID = (SELECT sid
                                                  FROM   syslogins
                                                  WHERE  name = 'RDSAgentJobUser'))
              BEGIN
                  PRINT '[ALERT] RDS Job is Not owned by RDSAgentJobUser'

                  RAISERROR (15600,-1,-1,'Find Owner and Drop Job');
              END
        END
  END

/* Collect step info*/
IF Object_id('tempdb..#sysjobsteps', 'U') IS NOT NULL
  DROP TABLE #sysjobsteps

/*Source Table*/
CREATE TABLE #sysjobsteps
  (
     [step_id]              [INT] NOT NULL,
     [step_name]            [SYSNAME] NOT NULL,
     [subsystem]            [NVARCHAR](40) NOT NULL,
     [command]              [NVARCHAR](max) NULL,
     [flags]                [NVARCHAR](4000),
     [cmdexec_success_code] [INT] NOT NULL,
     [on_success_action]    [NVARCHAR](4000),
     [on_success_step_id]   [INT] NOT NULL,
     [on_fail_action]       [NVARCHAR](4000),
     [on_fail_step_id]      [INT] NOT NULL,
     [server]               [SYSNAME] NULL,
     [database_name]        [SYSNAME] NULL,
     [database_user_name]   [SYSNAME] NULL,
     [retry_attempts]       [INT] NOT NULL,
     [retry_interval]       [INT] NOT NULL,
     [os_run_priority]      [NVARCHAR](4000),
     [output_file_name]     [NVARCHAR](200) NULL,
     [last_run_outcome]     [INT] NOT NULL,
     [last_run_duration]    [INT] NOT NULL,
     [last_run_retries]     [INT] NOT NULL,
     [last_run_date]        [INT] NOT NULL,
     [last_run_time]        [INT] NOT NULL,
     [proxy_id]             [INT] NULL
  )

INSERT INTO #sysjobsteps
EXEC Sp_help_job
  @job_name = @JobName,
  @job_aspect = 'steps'

/* Update the job */
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = Object_id(N'dbo.rds_backup_database')
                  AND type IN ( N'P', N'PC' ))
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name= @JobName,
        @enabled= @EnableNewJobs,
        @notify_level_eventlog=0,
        @notify_level_email=2,
        @notify_level_netsend=0,
        @notify_level_page=2,
        @delete_level=0,
        @description= @description,
        @category_name= @JobCategory,
        --@owner_login_name=N'sa',
        @notify_email_operator_name='';
  END
ELSE
  BEGIN
      EXEC msdb.dbo.Sp_update_job
        @job_name= @JobName,
        @enabled= @EnableNewJobs,
        @notify_level_eventlog=0,
        @notify_level_email=2,
        @notify_level_netsend=0,
        @notify_level_page=2,
        @delete_level=0,
        @description= @description,
        @category_name= @JobCategory,
        @owner_login_name=N'sa',
        @notify_email_operator_name=@notifyOperator
  END

/* Check if the job step exists and create if it doesn't */
SELECT @StepID = @StepID + 1;

SET @StepName = 'Run PerfStats..CaptureAGLagStats'

IF NOT EXISTS (SELECT *
               FROM   #sysjobsteps
               WHERE  step_ID = @StepID
                      AND step_name = @StepName)
  BEGIN
      EXEC msdb.dbo.Sp_add_jobstep
        @job_name= @JobName,
        @step_name= @StepName;
  END;

EXEC msdb.dbo.Sp_update_jobstep
  @job_name = @JobName,
  @step_name=@StepName,
  @step_id=@StepID,
  @cmdexec_success_code=0,
  @on_success_action=1,
  @on_success_step_id=0,
  @on_fail_action=2,
  @on_fail_step_id=0,
  @retry_attempts=0,
  @retry_interval=0,
  @os_run_priority=0,
  @subsystem=N'TSQL',
  @command=N'exec PerfStats..CaptureAGLagStats @DryRun = 0',
  @database_name=N'PerfStats',
  @flags=4

/* Set Start Step */
EXEC msdb.dbo.Sp_update_job
  @job_name = @JobName,
  @start_step_id = @StartStep

/* Collect Job Schedules */
IF Object_id('tempdb..#sysSchedules', 'U') IS NOT NULL
  DROP TABLE #sysSchedules

CREATE TABLE #sysSchedules
  (
     [schedule_id]            [INT],
     [schedule_name]          [SYSNAME] NOT NULL,
     [enabled]                [INT] NOT NULL,
     [freq_type]              [INT] NOT NULL,
     [freq_interval]          [INT] NOT NULL,
     [freq_subday_type]       [INT] NOT NULL,
     [freq_subday_interval]   [INT] NOT NULL,
     [freq_relative_interval] [INT] NOT NULL,
     [freq_recurrence_factor] [INT] NOT NULL,
     [active_start_date]      [INT] NOT NULL,
     [active_end_date]        [INT] NOT NULL,
     [active_start_time]      [INT] NOT NULL,
     [active_end_time]        [INT] NOT NULL,
     [date_created]           [DATETIME] NOT NULL,
     [SCHEDULE_DESCRIPTIOON]  NVARCHAR(4000),
     [next_run_date]          [INT] NOT NULL,
     [next_run_time]          [INT] NOT NULL,
     [schedule_uid]           [UNIQUEIDENTIFIER] NOT NULL,
     JOB_COUNT                INT
  )

INSERT INTO #sysSchedules
EXEC Sp_help_job
  @job_name = @JobName,
  @job_aspect = 'SCHEDULES'

/* Check if the job schedule exists and create if it doesn't */
IF NOT EXISTS(SELECT *
              FROM   #sysSchedules
              WHERE  schedule_name = @ScheduleName)
  BEGIN
      EXEC msdb.dbo.Sp_add_jobschedule
        @job_name = @JobName,
        @name=@ScheduleName;
  END;

/* Update the job schedule */
EXEC msdb.dbo.Sp_update_jobschedule
  @job_name = @JobName,
  @name= @ScheduleName,
  @enabled= @EnableNewJobs,-- not scheduled - started from alert
  @freq_type=4,-- 4 = daily
  @freq_interval=1,
  @freq_subday_type=4,
  @freq_subday_interval=1,
  @freq_relative_interval=0,
  @freq_recurrence_factor=1,
  @active_start_date=20211028,
  @active_end_date=99991231,
  @active_start_time=0,
  @active_end_time=235959

/* Detach any existing "wrong" schedules */
WHILE EXISTS (SELECT *
              FROM   #sysschedules
              WHERE  Schedule_Name != @ScheduleName)
  BEGIN
      SELECT TOP 1 @ScheduleID = Schedule_ID
      FROM   #sysschedules
      WHERE  Schedule_Name != @ScheduleName

      EXEC msdb.dbo.Sp_detach_schedule
        @job_name = @JobName,
        @schedule_id = @ScheduleID,
        @delete_unused_schedule = 1;

      DELETE FROM #sysschedules
      WHERE  schedule_id = @ScheduleID
  END;

/* Collect target job server */
IF Object_id('tempdb..#JobServer', 'U') IS NOT NULL
  DROP TABLE #JobServer

CREATE TABLE #JobServer
  (
     Server_ID            NVARCHAR(100),
     Server_Name          NVARCHAR(50),
     Enlist_date          DATETIME,
     Last_poll_Date       DATETIME,
     last_run_date        NVARCHAR(100),
     last_run_time        NVARCHAR(100),
     last_run_duration    NVARCHAR(100),
     last_run_outcome     TINYINT,
     last_outcome_message NVARCHAR(1024)
  )

/*Add job to target local server if it is not already*/
INSERT INTO #JobServer
EXEC Sp_help_job
  @job_name = @JobName,
  @job_aspect = 'Targets'

IF ( @@ROWCOUNT = 0 )
  BEGIN
      EXEC msdb.dbo.Sp_add_jobserver
        @job_name = @JobName,
        @server_name = N'(local)';
  END;

/* Remove Previous version */
