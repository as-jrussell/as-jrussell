USE [msdb];

DECLARE @JobName VARCHAR(200) = 'LIMC-MultipolicyProcessedDate',
	@EnableNewJobs BIT = 0, 
	@ScheduleID INT, 
	@StepID INT = 0, 
	@StartStep INT = 1,
	@StepName varchar(100),
	@ScheduleName VARCHAR(256),
	@JobCategory VARCHAR(100) = 'LIMC',
	@description VARCHAR(256),
	@notifyOperator varchar(100) = 'NOCAlert';

IF NOT EXISTS(select 1 FROM msdb.dbo.sysjobs where name = @JobName)
BEGIN
IF EXISTS(select 1 from LIMC.sys.objects where name = 'MultipolicyProcessedDate')
BEGIN 
/* Set variables */

SELECT @description = 'update nulled processed dates that failed to get updated by the RPA multipolicy workflow so that they can continue to LIMC Export' 

/* Create Standard job schedule */
SELECT @ScheduleName = @jobName +'_Schedule'
/* JOB required parameter */
DECLARE @Version numeric(18,10), @cmd NVARCHAR(MAX), @output NVARCHAR(MAX)

/* Add necessary categories */
IF NOT EXISTS (SELECT * FROM msdb.dbo.syscategories WHERE name= @JobCategory AND category_class=1)
BEGIN
	EXEC msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name= @JobCategory
END

/*Check if the job exists and create if it doesn't */
IF NOT EXISTS (SELECT * FROM msdb..sysjobs WHERE name = @JobName)
	BEGIN
		EXEC msdb.dbo.sp_add_job @job_name= @JobName, @enabled=0;
	END
ELSE
	BEGIN
		/* Does job exist - maintain current enabled status */
		SELECT @EnableNewJobs=enabled from msdb..sysjobs where name = @JobName
	END; 

/* Update the job */
EXEC msdb.dbo.sp_update_job 
	@job_name= @JobName, 
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

/* Check if the job step exists and create if it doesn't */
SELECT @StepID = @StepID + 1;
SET @StepName = 'MultipolicyProcessedDate_Execution'
IF NOT EXISTS (SELECT * FROM sysjobsteps jb INNER JOIN sysjobs j ON j.job_id = jb.job_id WHERE j.name = @JobName AND jb.step_name = @StepName)
BEGIN
	EXEC msdb.dbo.sp_add_jobstep @job_name= @JobName, @step_name= @StepName;
END;

/* Update the job step */
EXEC msdb.dbo.sp_update_jobstep 
	@job_name= @JobName, 
	@step_name= @StepName, 
	@step_id=@StepID, 
	@cmdexec_success_code=0, 
	@on_success_action=1, -- 3=go to next step, 1=quit with succes
	@on_success_step_id=0, 
	@on_fail_action=2, 
	@on_fail_step_id=0, 
	@retry_attempts=0, 
	@retry_interval=0, 
	@os_run_priority=0, 
	@subsystem=N'TSQL',
	@command= N'exec report.MultipolicyProcessedDate @whatif=0',  
	@database_name=N'LIMC',
	@flags=0;

/* Set Start Step */
EXEC msdb.dbo.sp_update_job @job_name= @JobName, @start_step_id = @StartStep

/* Check if the job schedule exists and create if it doesn't */
IF NOT EXISTS(  SELECT * 
		FROM sysjobschedules js
			INNER JOIN sysjobs j ON js.job_id = j.job_id
			INNER JOIN sysschedules s ON js.schedule_id = s.schedule_id
		WHERE j.name = @JobName AND s.name = @ScheduleName)
BEGIN
	EXEC msdb.dbo.sp_add_jobschedule @job_name = @JobName, @name=@ScheduleName;
END;
	
/* Update the job schedule */
EXEC msdb.dbo.sp_update_jobschedule 
	@job_name = @JobName, 
	@name= @ScheduleName, 
	@enabled= @EnableNewJobs, 
	@freq_type=4, -- 4 = daily
	@freq_interval=1, 
	@freq_subday_type=1, 
	@freq_subday_interval=0, 
	@freq_relative_interval=0, 
	@freq_recurrence_factor=0, 
	@active_start_date=20190227, 
	@active_end_date=99991231, 
	@active_start_time=060000, -- 6:30AM
	@active_end_time=235959

/* Detach any existing "wrong" schedules */
WHILE EXISTS (SELECT * FROM msdb.dbo.sysjobschedules WHERE job_id = (SELECT job_id FROM msdb.dbo.sysjobs WHERE Name = @JobName)
	AND Schedule_id <> (SELECT Schedule_id FROM msdb.dbo.sysschedules WHERE Name = @ScheduleName))
	BEGIN
		SELECT TOP 1 @ScheduleID = Schedule_ID FROM msdb.dbo.sysjobschedules WHERE job_id = (SELECT job_id FROM msdb.dbo.sysjobs WHERE Name = @JobName)
  		AND Schedule_id <> (SELECT Schedule_id FROM msdb.dbo.sysschedules WHERE Name = @ScheduleName);
		EXEC msdb.dbo.sp_detach_schedule @job_name = @JobName, @schedule_id = @ScheduleID, @delete_unused_schedule = 1;
	END;

/* Add job to target local server if it is not already */ 
IF (NOT EXISTS
	(
		SELECT *
		FROM msdb.dbo.sysjobservers js
		join msdb..sysjobs j on js.job_id=j.job_id
		WHERE name = @JobName
	)
		)
BEGIN
	EXEC msdb.dbo.sp_add_jobserver @job_name = @JobName, @server_name = N'(local)';
END;

	PRINT 'Success: Agent Job Created'
END
ELSE 
BEGIN
	PRINT 'WARNING: No Stored Procedures by name'
END;
END 
ELSE 
BEGIN
	PRINT 'FAIL: Job exists'
END;