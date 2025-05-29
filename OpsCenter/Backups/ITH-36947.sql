USE [msdb];

/* Set variables */
DECLARE @JobName VARCHAR(200) = 'Report: UniTrac Escrow Report',
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
EXEC msdb.dbo.sp_update_jobstep  @job_name = @JobName, @step_id=4 , 
		@command=N'use unitrac

set QUOTED_IDENTIFIER on 





DECLARE @filenames varchar(max)
DECLARE @file1 VARCHAR(MAX) = ''C:\Reports\EscrowWebReport.csv''
DECLARE @file2 VARCHAR(MAX) = '';C:\Reports\EscrowVerificationCounts.csv'' 
SELECT @filenames = @file1

-- Optional new attachments

-- Create list from optional files
SELECT @filenames = @file1 + @file2

              EXEC msdb.dbo.sp_send_dbmail 
			@Subject= ''UniTrac Escrow Web Report'',
			@profile_name = ''Unitrac-prod'',
			@body = ''Please see attached report that is attached'',
			@body_format =''HTML'',			
             @recipients =  ''Escrow.Leaders@alliedsolutions.net;QASupport@alliedsolutions.net;unitracescrowreport@alliedsolutions.net'',
  @file_attachments = @filenames;'

END;