USE msdb

/* Set variables */
DECLARE @JobName        VARCHAR(200) = 'DataHub_PROD-PurgeBlobTable',
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

      EXEC msdb.dbo.Sp_update_schedule
        @schedule_id=@ScheduleID,
        @active_start_time=60000

      PRINT 'Success: Time updated'
  END
ELSE
  BEGIN
      PRINT 'Warning: Does not exist!'
  END
