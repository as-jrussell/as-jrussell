Exec [DBA].[backup].[BackupDatabase]   @BackupLevel = 'FULL',   @SQLDatabaseName = 'IND_AlliedSolutions_157GIC109',@DryRun = 0
Exec [DBA].[backup].[BackupDatabase]   @BackupLevel = 'LOG',   @SQLDatabaseName = 'IND_AlliedSolutions_157GIC109',@DryRun = 0
USE [IND_AlliedSolutions_157GIC109] DBCC SHRINKFILE (N'IND_AlliedSolutions_157GIC109_log' , 0)