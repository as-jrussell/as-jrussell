USE [msdb];

/* Set variables */
DECLARE @JobName VARCHAR(200) = 'IQQ ALERT: ADR Sales\Cancellations waiting',
	@EnableNewJobs BIT = 0, /* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
	@ScheduleID INT, 
	@StepID INT = 4, 
	@StartStep INT = 1,
	@StepName varchar(100),
	@ScheduleName VARCHAR(256),
	@description VARCHAR(256);





BEGIN
EXEC msdb.dbo.sp_update_job  @job_name = @JobName,
		@enabled=0
END;




/* Set variables */
DECLARE @JobName2 VARCHAR(200) = 'IQQ ALERT: Sync Transactions'




BEGIN
EXEC msdb.dbo.sp_update_job  @job_name = @JobName2,
		@enabled=0
END;



/* Set variables */
DECLARE @JobName3 VARCHAR(200) = 'IQQ Month End iQQ Report'


BEGIN
EXEC msdb.dbo.sp_update_job  @job_name = @JobName3,
		@enabled=0
END;