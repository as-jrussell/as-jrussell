USE [msdb];

/* Set variables */
DECLARE @JobName VARCHAR(200) = 'DBA-PurgeTableMaintenance',
	@EnableNewJobs BIT = 0, /* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
	@ScheduleID INT, 
	@StepID INT = 2, 
	@StartStep INT = 1,
	@StepName varchar(100),
	@ScheduleName VARCHAR(256),
	@JobCategory VARCHAR(100) = N'DBA', 
	@description VARCHAR(256)



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
	@command=N'IF( Has_perms_by_name (''sys.dm_hadr_availability_replica_states'', ''OBJECT'', ''execute'') = 1 )
  BEGIN
      -- if this is not an AG server then return ''PRIMARY''
      IF NOT EXISTS(SELECT 1
                    FROM   sys.DATABASES d
                           INNER JOIN sys.dm_hadr_availability_replica_states hars
                                   ON d.replica_id = hars.replica_id)
        BEGIN
            EXEC [DBA].[archive].[Purgestoragetable]
              @DatabaseName = ''UnitracHDStorage'',
              @WhatIf = 0

            EXEC [DBA].[archive].[Purgestoragetable]
              @DatabaseName = ''HDTStorage'',
              @WhatIf = 0
        END
      ELSE
      -- else return if there is AN PRIMARY availability group PRIMARY else ''SECONDARY
      IF EXISTS(SELECT hars.role_desc
                FROM   sys.DATABASES d
                       INNER JOIN sys.dm_hadr_availability_replica_states hars
                               ON d.replica_id = hars.replica_id
                WHERE  hars.role_desc = ''PRIMARY'')
        BEGIN
            EXEC [DBA].[archive].[Purgestoragetable]
              @DatabaseName = ''UnitracHDStorage'',
              @WhatIf = 0

            EXEC [DBA].[archive].[Purgestoragetable]
              @DatabaseName = ''HDTStorage'',
              @WhatIf = 0
        END
      ELSE
        BEGIN
            PRINT ''DO NOTHING''
        END
  END 
',
	@database_name=N'DBA',
	@flags=0;
