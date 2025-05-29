USE [msdb];

/* Set variables */
DECLARE @JobName VARCHAR(200) = 'PerMon-IOerror',
	@EnableNewJobs BIT = 1, /* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
	@ScheduleID INT, 
	@StepID INT = 0, 
	@StartStep INT = 1,
	@StepName varchar(100),
	@ScheduleName VARCHAR(256),
	@JobCategory VARCHAR(100) = 'PerfStats',
	@description VARCHAR(256),
	@notifyOperator varchar(100) = 'DBAdmins';

SELECT @description = 'Capture of data when called by ALERT PerfMon-IOerror 
Documentation for fixing errors can be found:  
https://alliedsolutions.sharepoint.com/:w:/r/teams/DatabaseServices/_layouts/15/Doc.aspx?sourcedoc=%7B664725A3-4785-4DC5-8323-164FCBE0CFF1%7D&file=PerMon-IOerror%20.docx&action=default&mobileredirect=true
' 

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
	@notify_level_eventlog=0, 
	@notify_level_email=1, 
	@notify_level_netsend=0, 
	@notify_level_page=2, 
	@delete_level=0, 
	@description= @description, 
	@category_name= @JobCategory, 
	@owner_login_name=N'sa',
	@notify_email_operator_name=@notifyOperator

/* Check if the job step exists and create if it doesn't */
SELECT @StepID = @StepID + 1;
SET @StepName = 'exec dbo.CaptureIOError' -- Can be poetic - can be EXEC dbo.StoreProcedure 
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
	@on_success_step_id=1, 
	@on_fail_action=2, 
	@on_fail_step_id=0, 
	@retry_attempts=0, 
	@retry_interval=0, 
	@os_run_priority=0, 
	@subsystem=N'TSQL',
	@command= N'EXEC [dbo].[storeprocedureneeded] @DryRun = 0',  
	@database_name=N'PerfStats',
	@flags=4;


/* Make certain last step to be executed @on_success_action=1, */

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
	@enabled= 0, 
	@freq_type=4, -- 4 = daily
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
