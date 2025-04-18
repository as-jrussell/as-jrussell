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

 
*/
select MachineName+'.'+DomainName [FDQN]
from dba.info.host 


select SQLServerName, MachineName, ServerEnvironment, ServerLocation from dba.info.Instance
/*Shows server information*/ 
EXEC [DBA].[info].[GetInstance] @DryRun = 1
/*Shows Database with owner, and Database type*/ 
EXEC [DBA].[info].[getDatabase] @DryRun = 1
/*Shows all agent jobs */ 
EXEC [DBA].[info].[getAgentJob] @DryRun = 1
/*Shows drives usage*/ 
EXEC [DBA].[info].[getDriveUsage] @DryRun = 1
/* Shows drives usage and how close we are to running out of space*/ 
EXEC [PerfStats].[dbo].[CaptureDriveUsage] @WhatIf = 1
/*Shows all the linked servers*/ 
EXEC [DBA].[info].[getLinkedServer] @DryRun = 1

/*Shows the AG information*/ 
EXEC [PerfStats]. [dbo].[CaptureAGLagStats] 


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
