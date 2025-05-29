USE [msdb];

/* Set variables */
DECLARE @JobName VARCHAR(200) = 'GreatPlains-AccountingBackup-FULL',
	@EnableNewJobs BIT = 0, /* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
	@ScheduleID INT, 
	@StepID INT = 4, 
	@StartStep INT = 1,
	@StepName varchar(100),
	@ScheduleName VARCHAR(256),
	@description VARCHAR(256);




SELECT @StepID = @StepID + 1;
SET @StepName = 'StepName' -- Can be poetic - can be EXEC dbo.StoreProcedure 
IF NOT EXISTS (SELECT * FROM sysjobsteps jb INNER JOIN sysjobs j ON j.job_id = jb.job_id WHERE j.name = @JobName AND jb.step_name = @StepName)
BEGIN
EXEC msdb.dbo.sp_update_jobstep  @job_name = @JobName, @step_id=1 , 
		@command=N'EXEC [backup].[BackupDatabase] @BackupLevel = ''FULL'', @SQLDatabaseName = ''USER_Databases'', @backupSoftware = ''SQLNative'', @SQLBackupPath = ''I:\Backups\I01\Accounting'', @force = 1, @RetentionDays= 14, @DryRun = 0
'



END;


