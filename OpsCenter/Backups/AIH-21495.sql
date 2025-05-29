USE [msdb]
GO


DECLARE @JobName VARCHAR(200) = 'HDTStorage-PurgeTableMaintenance';
DECLARE @command VARCHAR(350) = 'EXEC HDTStorage.archive.CreateStorageSchema @WhatIf = 0, @Debug = 1';
DECLARE @stepID INT = 1;

IF NOT EXISTS(select 1from msdb.dbo.sysjobsteps sjs join msdb.dbo.sysjobs sj on sjs.job_id = sj.job_id where name ='HDTStorage-PurgeTableMaintenance' and step_id =@stepID  and command = @command) 
BEGIN 
EXEC msdb.dbo.sp_update_jobstep @job_name= @JobName , @step_id=@stepID , 
		@command=@command

	PRINT 'SUCCESS: Agent Job has been successfully updated!!!!'
END


select sj.name, sjs.command 
from msdb.dbo.sysjobsteps sjs
join msdb.dbo.sysjobs sj on sjs.job_id = sj.job_id
where name = @JobName
and step_id = @stepID
ORDER BY date_created desc