USE [msdb]
GO

/****** Object:  Job [SendAlerts]    Script Date: 3/17/2020 2:12:22 PM ******/
DECLARE @JobName VARCHAR(200) = 'DBA-ShrinkLogfile',
		@EnableNewJobs BIT = 1, /* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
		@ScheduleID INT, @StepID int = 1,
		@StepName varchar(100),
		@StartStep int = 1,
		@JobId UNIQUEIDENTIFIER,
		@ScheduleName VARCHAR(256),
		@JobCategory VARCHAR(100) = 'Database Maintenance',
		@description VARCHAR(256),
		@notifyOperator varchar(100) = 'dbAlert';

SELECT @ScheduleName = @jobName +'_Schedule'
SELECT @description = 'Shrinks log files.
' 
/* Add necessary categories */
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=@JobCategory AND category_class=1)
BEGIN
	EXEC msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=@JobCategory
END

/* Collect step info*/
IF OBJECT_ID('tempdb..#sysjobsteps', 'U') IS NOT NULL
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
    exec sp_help_job @job_name = @JobName, @job_aspect = 'steps'

/*Check if the job exists and create if it doesn't */
IF NOT EXISTS (SELECT * FROM msdb..sysjobs WHERE name = @JobName)
    BEGIN
	SET @EnableNewJobs = 0 	

    EXEC msdb.dbo.sp_add_job @job_name= @JobName, @enabled=@EnableNewJobs;
    END


/* Update the job *//* Update the job */
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.rds_backup_database') AND type in (N'P', N'PC'))
    BEGIN
        EXEC msdb.dbo.sp_update_job 
		        @job_name=@JobName, 
		        @enabled=@EnableNewJobs, 
		        @notify_level_eventlog=0, 
		        @notify_level_email=2, 
		        @notify_level_netsend=0, 
		        @notify_level_page=0, 
		        @delete_level=0, 
		        @description=@description, 
		        @category_name=@JobCategory, 
		        --@owner_login_name=N'RDSAgentJobUser', 
		        @notify_email_operator_name=''
    END
ELSE
    BEGIN
        EXEC msdb.dbo.sp_update_job 
		        @job_name=@JobName, 
		        @enabled=@EnableNewJobs, 
		        @notify_level_eventlog=0, 
		        @notify_level_email=2, 
		        @notify_level_netsend=0, 
		        @notify_level_page=0, 
		        @delete_level=0, 
		        @description=@description, 
		        @category_name=@JobCategory, 
		        @owner_login_name=N'sa', 
		        @notify_email_operator_name=@notifyOperator
    END

/* Check if the job step exists and create if it doesn't */
SET @StepName = 'Execute sproc - ShrinkLogs'
IF NOT EXISTS (SELECT * FROM #sysjobsteps WHERE step_id = @StepID AND step_name = @StepName)
BEGIN
	EXEC msdb.dbo.sp_add_jobstep @job_name= @JobName, @step_name= @StepName;
END;

/* Update the job step */
EXEC msdb.dbo.sp_update_jobstep 
		@job_name=@JobName, 
		@step_name=@StepName, 
		@step_id=@StepID, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec [DBA].[dbo].[ShrinkLogs] @dryRun = 0', 
		@database_name=N'master', 
		@flags=0

/* Check if the job step exists and create if it doesn't */
SELECT @StepID = @StepID + 1;
SET @StepName = 'EXEC DBA.dbo.CheckpointTempdb'
IF NOT EXISTS (SELECT * FROM #sysjobsteps WHERE step_id = @StepID AND step_name = @StepName)
BEGIN
	EXEC msdb.dbo.sp_add_jobstep @job_name= @JobName, @step_name= @StepName;
END;

/* Update the job step */
EXEC msdb.dbo.sp_update_jobstep 
		@job_name= @JobName, 
		@step_name= @StepName, 
		@step_id= @StepID, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, 
		@subsystem=N'TSQL', 
		@command=N'EXEC [DBA].[dbo].[CheckpointTempdb]',
		@database_name=N'DBA',
		@flags=0;

/* Check if the job step exists and create if it doesn't */
SELECT @StepID = @StepID + 1;
SET @StepName = 'EXEC DBA.dbo.ShrinkTempDB'
IF NOT EXISTS (SELECT * FROM #sysjobsteps WHERE step_id = @StepID AND step_name = @StepName)
BEGIN
	EXEC msdb.dbo.sp_add_jobstep @job_name= @JobName, @step_name= @StepName;
END;


/* Update the job step */
EXEC msdb.dbo.sp_update_jobstep 
		@job_name= @JobName, 
		@step_name= @StepName, 
		@step_id= @StepID, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, 
		@subsystem=N'TSQL', 
		@command=N'EXEC [DBA].[dbo].[ShrinkTempDB]',
		@database_name=N'DBA',
		@flags=0;

-- no more steps at this time.
/* Make certain last step @on_success_action=1, */

/* Set Start Step */
EXEC msdb.dbo.sp_update_job @job_name= @JobName, @start_step_id = @StartStep

/* Collect Job Schedules */
IF OBJECT_ID('tempdb..#sysSchedules', 'U') IS NOT NULL
	DROP TABLE #sysSchedules

CREATE TABLE #sysSchedules(
	[schedule_id] [int] ,
	[schedule_name] [sysname] NOT NULL,
	[enabled] [int] NOT NULL,
	[freq_type] [int] NOT NULL,
	[freq_interval] [int] NOT NULL,
	[freq_subday_type] [int] NOT NULL,
	[freq_subday_interval] [int] NOT NULL,
	[freq_relative_interval] [int] NOT NULL,
	[freq_recurrence_factor] [int] NOT NULL,
	[active_start_date] [int] NOT NULL,
	[active_end_date] [int] NOT NULL,
	[active_start_time] [int] NOT NULL,
	[active_end_time] [int] NOT NULL,
	[date_created] [datetime] NOT NULL,
    [SCHEDULE_DESCRIPTIOON] nvarchar(4000),
    [next_run_date] [int] NOT NULL,
	[next_run_time] [int] NOT NULL,
    [schedule_uid] [uniqueidentifier] NOT NULL,
    JOB_COUNT INT
)

INSERT INTO #sysSchedules
    exec sp_help_job @job_name = @JobName, @job_aspect = 'SCHEDULES'

/* Check if the job schedule exists and create if it doesn't */
IF NOT EXISTS(SELECT * FROM #sysSchedules WHERE schedule_name = @ScheduleName)
BEGIN
	EXEC msdb.dbo.sp_add_jobschedule @job_name = @JobName, @name=@ScheduleName;
END;

/* Update the job schedule */
EXEC msdb.dbo.sp_update_jobschedule 
		@job_name = @JobName, 
		@name= @ScheduleName, 
		@enabled= @EnableNewJobs, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=20, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190904, 
		@active_end_date=99991231, 
		@active_start_time=40000, 
		@active_end_time=235959

/* Detach any existing "wrong" schedules */
WHILE EXISTS (SELECT * FROM #sysschedules WHERE Schedule_Name != @ScheduleName)
	BEGIN
		SELECT TOP 1 @ScheduleID = Schedule_ID FROM #sysschedules WHERE Schedule_Name != @ScheduleName
		EXEC msdb.dbo.sp_detach_schedule @job_name = @JobName, @schedule_id = @ScheduleID, @delete_unused_schedule = 1;

        DELETE FROM #sysschedules WHERE schedule_id = @ScheduleID
	END;

/* Collect target job server */
IF OBJECT_ID('tempdb..#JobServer', 'U') IS NOT NULL
	DROP TABLE #JobServer

CREATE TABLE #JobServer(
    Server_ID nvarchar(100),
    Server_Name nvarchar(150),
    Enlist_date datetime,
    Last_poll_Date datetime,
    last_run_date nvarchar(100),
    last_run_time nvarchar(100),
    last_run_duration nvarchar(100),
    last_run_outcome tinyint,
    last_outcome_message nvarchar(1024)
)

/*Add job to target local server if it is not already*/ 
INSERT INTO #JobServer
    exec sp_help_job @job_name = @JobName, @job_aspect = 'Targets'

IF ( @@RowCount = 0 )
BEGIN
    EXEC msdb.dbo.sp_add_jobserver @job_name = @JobName, @server_name = N'(local)';
END;

/* Remove Previous version */
IF EXISTS (SELECT * FROM sysjobs WHERE name = 'DBA-ShrinkLogfiles')
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name= 'DBA-ShrinkLogfiles', @delete_unused_schedule=1;
END;


