USE [msdb];
GO

DECLARE @JobName VARCHAR(200) = 'DBA-TempDBFileMonitor', -- Unique job name
        @EnableNewJobs BIT = 1, -- Enable new job (1 for Enabled, 0 for Disabled)
        @TargetDatabase VARCHAR(100) = 'tempdb', -- Replace with actual database name
        @Description VARCHAR(256) = 'Monitors tempdb file usage and alerts if space is low',
        @NotifyOperator VARCHAR(100) = 'DBAlert'; -- Replace with an existing operator

-- Command for the stored procedure, set @DryRun to 1 to display data and 0 to identify files out of space
DECLARE @Step1Command NVARCHAR(MAX) = N'EXEC DBA.dbo.GetTempDBFiles @DryRun = 0;';

-- Schedule and category parameters
DECLARE @ScheduleID INT,
        @StepID INT = 0,
        @StepName VARCHAR(100),
        @ScheduleName VARCHAR(256),
        @JobCategory VARCHAR(100) = 'Database Maintenance';

SET @ScheduleName = @JobName + '_Schedule';

-- Add job category if it doesn’t already exist
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name = @JobCategory AND category_class = 1)
BEGIN
    EXEC msdb.dbo.sp_add_category @class = N'JOB', @type = N'LOCAL', @name = @JobCategory;
END;

-- Check if the job exists and create if it doesn’t
IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = @JobName)
BEGIN
    EXEC msdb.dbo.sp_add_job 
        @job_name = @JobName,
        @enabled = @EnableNewJobs,
        @notify_level_email = 2, 
        @notify_email_operator_name = @NotifyOperator,
        @description = @Description,
        @category_name = @JobCategory,
		@owner_login_name=N'sa';
END;

-- Define the job step for executing the stored procedure
SET @StepID = @StepID + 1;
SET @StepName = 'Run TempDB File Monitor';

-- Check if the job step exists, add it if it doesn't
IF NOT EXISTS (SELECT * 
               FROM msdb.dbo.sysjobsteps 
               WHERE job_id = (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = @JobName) 
                 AND step_name = @StepName)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name = @JobName,
        @step_name = @StepName,
        @subsystem = N'TSQL',
        @command = @Step1Command,
        @database_name = @TargetDatabase,
        @on_success_action = 1, -- Quit with success
        @on_fail_action = 2;    -- Quit with failure
END;

-- Schedule the job if it doesn't already exist
IF NOT EXISTS (SELECT * FROM msdb.dbo.sysschedules WHERE name = @ScheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_jobschedule
        @job_name = @JobName,
        @name = @ScheduleName,
        @enabled = @EnableNewJobs,
        @freq_type = 4,               -- Daily schedule
        @freq_interval = 1,           -- Every day
        @freq_subday_type = 1,        -- Minutes
        @freq_subday_interval = 1,    -- Every 1 minute
        @active_start_date = 20240101, -- Start date, modify if needed
        @active_start_time = 0;       -- Start at midnight (00:00:00)
END;


-- Add job to the target local server if not already added
IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobservers WHERE job_id = (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = @JobName))
BEGIN
    EXEC msdb.dbo.sp_add_jobserver @job_name = @JobName, @server_name = N'(local)';
END;

PRINT 'Job created or updated successfully.';
GO
