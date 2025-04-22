/*
					EXEC DBA.deploy.SetDatabaseRole @databaseType  = 'ADMIN', @debug = 1 , @force = 1 , @DryRun = 0 
					EXEC DBA.deploy.SetDatabaseRole @databaseType  = 'USER', @debug = 1 , @force = 1 , @DryRun = 0 
					EXEC [HDTStorage].[archive].[CreateStorageSchema] @WhatIf = 1, @Debug =1 

	/*Shows Agent log files */
	EXEC [PerfStats].[dbo].[CaptureErrorLogFile] 

	EXEC [DBA].[harvester].[HarvestLocal] @DryRun = 1

SELECT * FROM [PerfStats].[utag].[AGLAgStats]
WHERE CURRENT_DT >= CAST(GETDATE()-62 AS DATE)
order by current_dt desc



SELECT * FROM DBA.[deploy].[ExecHistory]
ORDER BY TIMESTAMPUTC DESC


			select D.DatabaseName,D.[State], D.ServerType, S.DatabaseType, S.BackupMethod, S.Exclude , D.RecoveryModel
			from DBA.info.[Database] D
			JOIN  DBA.[backup].SCHEDULE S ON S.[DatabaseName]= D.DatabaseName
			WHERE EXCLUDE <> 0 AND S.BackupMethod = 'AWS-EC2'
			AND D.[State] = 'ONLINE'


			select D.DatabaseName,D.[State], D.ServerType, S.DatabaseType, S.BackupMethod, D.RecoveryModel
			--select *
			from DBA.info.[Database] D
			left JOIN  DBA.[backup].SCHEDULE S ON S.[DatabaseName]= D.DatabaseName
			WHERE D.[State] = 'ONLINE'AND S.DatabaseType = 'USER' 

 EXEC DBA.policy.IsTempDBCorrect @fORCE=0,  @Debug = 1, @Verbose = 1, @DryRun=0

*/
SELECT (SELECT MachineName + '.' + DomainName
        FROM   dba.info.host) [FDQN],
       SQLServerName,
       MachineName,
       ServerEnvironment,
       ServerLocation
FROM   dba.info.Instance

/*Shows server information*/
EXEC [DBA].[info].[Getinstance]
  @DryRun = 1

/*Shows Database with owner, and Database type*/
EXEC [DBA].[info].[Getdatabase]
  @DryRun = 1

/*Shows all agent jobs */
EXEC [DBA].[info].[Getagentjob]
  @DryRun = 1

/*Shows drives usage*/
EXEC [DBA].[info].[Getdriveusage]
  @DryRun = 1

/* Shows drives usage and how close we are to running out of space*/
EXEC [PerfStats].[dbo].[Capturedriveusage]
  @WhatIf = 1

/*Shows all the linked servers*/
EXEC [DBA].[info].[Getlinkedserver]
  @DryRun = 1

/*Shows the AG information*/
EXEC [PerfStats]. [dbo].[Captureaglagstats]

--EXEC DBA.DBO.SP_WHOISACTIVE  @get_task_info =2,@get_plans =2 ,  @get_avg_time=1;
--EXEC master.dbo.sp_who3
/*

PurgeConfig
PurgeHistory
PK_TableCleanupHistory
CreateStorageSchema -
GetStorageSchema - 
GetStorageTable -
PurgeStorageSchema -
SetPurgeConfig - 

*/

