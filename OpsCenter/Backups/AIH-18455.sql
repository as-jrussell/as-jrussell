USE [msdb];

/* Set variables */
DECLARE @JobName VARCHAR(200) = 'IVOS-ISO_Reprocess', 
	@EnableNewJobs BIT = 0, /* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
	@ScheduleID INT, 
	@StepID INT, 
	@StartStep INT,
	@StepName varchar(100),
	@ScheduleName VARCHAR(256),
	@JobCategory VARCHAR(100),
	@description VARCHAR(256),
	@notifyOperator varchar(100);




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
	@notify_email_operator_name=@notifyOperator

