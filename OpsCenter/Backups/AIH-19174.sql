USE msdb

/* Set variables */
DECLARE @JobName        VARCHAR(200) = 'Report: UniTrac Escrow Report',
        @EnableNewJobs  BIT = 0,/* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
        @ScheduleID     INT,
        @StepID         INT = 0,
        @StartStep      INT = 1,
        @StepName       VARCHAR(100),
        @ScheduleName   VARCHAR(256),
        @JobCategory    VARCHAR(100),
        @description    VARCHAR(256),
        @notifyOperator VARCHAR(100);

SELECT TOP 1 @ScheduleID = Schedule_ID
FROM   msdb.dbo.sysjobschedules
WHERE  job_id = (SELECT job_id
                 FROM   msdb.dbo.sysjobs
                 WHERE  Name = @JobName)

IF EXISTS (SELECT Schedule_ID
           FROM   msdb.dbo.sysjobschedules
           WHERE  job_id = (SELECT job_id
                            FROM   msdb.dbo.sysjobs
                            WHERE  NAME = @JobName))
  BEGIN
      EXEC msdb.dbo.Sp_attach_schedule
        @job_name= @JobName,
        @schedule_id=@ScheduleID

     EXEC msdb.dbo.sp_update_schedule @schedule_id=@ScheduleID, 
		@freq_type=4, 
		@freq_interval=1

      PRINT 'Success: Time updated'
  END
ELSE
  BEGIN
      PRINT 'Warning: Does not exist!'
  END




 -- DECLARE @JobName NVARCHAR(128) = 'DataHub_PROD-PurgeBlobTable'

--jobs that have a schedule with schedule identifiers
select
sysjobs.job_id
,sysjobs.name job_name
,sysjobs.enabled job_enabled
,sysschedules.name schedule_name
,sysschedules.schedule_id
,sysschedules.schedule_uid
,sysschedules.enabled schedule_enabled,next_run_date,next_run_time
from msdb.dbo.sysjobs
inner join msdb.dbo.sysjobschedules on sysjobs.job_id = sysjobschedules.job_id
inner join msdb.dbo.sysschedules on sysjobschedules.schedule_id = sysschedules.schedule_id
WHERE sysjobs.name = @JobName
order by sysjobs.enabled desc