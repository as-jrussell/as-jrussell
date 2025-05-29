USE [msdb];

/* Set variables */
DECLARE @JobName VARCHAR(200) = 'DataHub_PROD-PurgeBlobTable',
	@EnableNewJobs BIT = 1, /* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
	@ScheduleID INT, 
	@StepID INT = 0, 
	@StartStep INT = 1,
	@StepName varchar(100),
	@ScheduleName VARCHAR(256)='DataHub_PROD-PurgeBlobTable_Schedule',
	@JobCategory VARCHAR(100) = ' DataHub_PROD',
	@description VARCHAR(256)



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
	@active_start_time=63000, -- 6:30AM
	@active_end_time=235959
