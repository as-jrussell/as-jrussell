USE MASTER ALTER DATABASE UniTrac SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE archiveEDI SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE EDI SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE LetterGen SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE OperationalDashboard SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE OspreyDashboard SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE QCModule SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE SADashboard SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE UniTrac_DW SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE UniTracArchive SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE VUT SET RECOVERY SIMPLE WITH NO_WAIT
USE MASTER ALTER DATABASE PerfStats SET RECOVERY SIMPLE WITH NO_WAIT




EXEC msdb.dbo.sp_update_job @job_name=N'DBA-AuditLogin',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-AuditSpecificTable',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupDatabases-Alert',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupDatabases-DIFF',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupDatabases-FULL',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupDatabases-LOG',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupMaintenance',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupNon-UniTrac-Full',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupNon-UniTrac-LOG',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupUniTrac-Full',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupVehicleCT/UC-Monthly',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-CaptureAlerts',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-Create IH Index',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-CycleErrorLog',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-DBCC CheckDB UniTrac and UniTrac_DW',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-DeleteBackupHistory',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-DeleteJobHistory',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-HarvestDaily',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-MonitorRestore Database_VUT',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-Non Unitrac Backup file Maintenance.Subplan_1',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-OutputFileCleanup',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-PurgeTableMaintenance',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-SendAlerts',@enabled=1
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-ShrinkLogfile',@enabled=1