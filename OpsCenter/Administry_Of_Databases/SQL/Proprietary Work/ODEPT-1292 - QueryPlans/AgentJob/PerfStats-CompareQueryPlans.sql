USE [msdb]
GO

/****** Object:  Job     Script Date: 3/17/2020 2:12:22 PM ******/
DECLARE @JobName        VARCHAR(200) = 'Perfstats-CompareQueryPlans',
        @EnableNewJobs  BIT =1,/* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
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
/* Create Standard job schedule */
SELECT @ScheduleName = @jobName + '_Schedule'

SELECT @description = 'This job compares the Query Plan History table and if there is a plan that changed and it is 4x the average time notification will be sent out. 
Users will have a note in the email that will ask them to research if this is a performance hinderance or not. If it is not they can ignore the email'

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

SET @StepName = 'Run PerfStats..CompareQueryPlans'

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
	@command=N'DECLARE @TargetDB nvarchar(100), @ProductVersion int, @serverType varchar(100)
SELECT @ProductVersion = convert(int, LEFT(convert(varchar(100),SERVERPROPERTY(''ProductVersion'')),charindex(''.'',convert(varchar(100),SERVERPROPERTY(''ProductVersion'')))-1 ))

PRINT ''EXEC msdb..sp_help_jobstep @Job_ID = $(ESCAPE_NONE(JOBID)), @Step_ID = $(ESCAPE_NONE(STEPID));''

/* Collect step info*/
IF OBJECT_ID(''tempdb..#sysjobsteps'', ''U'') IS NOT NULL
	DROP TABLE #sysjobsteps

/*Source Table*/
CREATE TABLE #sysjobsteps(
	    [step_id] [int] NOT NULL,
	    [step_name] [sysname] NOT NULL,
	    [subsystem] [nvarchar](40) NOT NULL,
	    [command] [nvarchar](max) NULL,
	    [flags] [nvarchar](4000), 
	    [cmdexec_success_code] [int] NOT NULL,
	    [on_success_action] [nvarchar](4000) ,
	    [on_success_step_id] [int] NOT NULL,
	    [on_fail_action] [nvarchar](4000) , 
	    [on_fail_step_id] [int] NOT NULL,
	    [server] [sysname] NULL,
	    [database_name] [sysname] NULL,
	    [database_user_name] [sysname] NULL,
	    [retry_attempts] [int] NOT NULL,
	    [retry_interval] [int] NOT NULL,
	    [os_run_priority] [nvarchar](4000) ,
	    [output_file_name] [nvarchar](200) NULL,
	    [last_run_outcome] [int] NOT NULL,
	    [last_run_duration] [int] NOT NULL,
	    [last_run_retries] [int] NOT NULL,
	    [last_run_date] [int] NOT NULL,
	    [last_run_time] [int] NOT NULL,
	    [proxy_id] [int] NULL
)

INSERT INTO #sysjobsteps
EXEC msdb..sp_help_jobstep @Job_ID = $(ESCAPE_NONE(JOBID)), @Step_ID = $(ESCAPE_NONE(STEPID)) 

SELECT @TargetDB = database_name
FROM #sysjobsteps

IF( @ProductVersion > 10 AND (select SERVERPROPERTY(''IsHadrEnabled'')) = 1 )
	BEGIN
		IF( (SELECT sys.fn_hadr_is_primary_replica (@TargetDB)) = 1 )
			BEGIN
                PRINT ''SELECT sys.fn_hadr_is_primary_replica (''''''+ @TargetDB +'''''');''
				SET @ServerType = ''PRIMARY''
			END
		ELSE IF( (SELECT IsNull(sys.fn_hadr_is_primary_replica (@TargetDB), 1)) = 1 )
			BEGIN
                /* DB is in instance with AGs - just not part of AG */
                PRINT ''SELECT IsNull(sys.fn_hadr_is_primary_replica (''''''+ @TargetDB +''''''), 1);''
				SET @ServerType = ''PRIMARY''
			END
		ELSE
			BEGIN	
                PRINT ''SELECT sys.fn_hadr_is_primary_replica (''''''+ @TargetDB +'''''');''
				SET @ServerType = ''SECONDARY''
			END
	END
ELSE	/* Non AG instance - Standalone */
	BEGIN
        PRINT ''StandAlone Instance''
		SET @ServerType = ''PRIMARY''
	END

IF( @ServerType = ''PRIMARY'' ) 
	BEGIN
		/* Quietly exit */
		PRINT ''Job does not run on ''+ @ServerType  +''  instance.''
	END
ELSE
	BEGIN	
		/* Execute Stored Procedure */
		PRINT ''Running Job on ''+ @ServerType  +'' instance.''
        		--SELECT @@ServerName
		EXEC PerfStats.dbo.CompareQueryPlans @WhatIf=0
	END',
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
  @freq_subday_type=8,
  @freq_subday_interval=1,
  @freq_relative_interval=0,
  @freq_recurrence_factor=1,
  @active_start_date=20211028,
  @active_end_date=99991231,
  @active_start_time=70000, 
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
