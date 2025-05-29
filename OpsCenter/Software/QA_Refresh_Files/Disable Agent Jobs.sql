EXEC msdb.dbo.sp_update_job @job_name=N'DBA-AuditLogin',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-AuditSpecificTable',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupDatabases-Alert',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupDatabases-DIFF',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupDatabases-FULL',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupDatabases-LOG',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupMaintenance',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupNon-UniTrac-Full',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupNon-UniTrac-LOG',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupUniTrac-Full',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-BackupVehicleCT/UC-Monthly',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-CaptureAlerts',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-Create IH Index',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-CycleErrorLog',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-DBCC CheckDB UniTrac and UniTrac_DW',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-DeleteBackupHistory',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-DeleteJobHistory',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-HarvestDaily',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-MonitorRestore Database_VUT',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-Non Unitrac Backup file Maintenance.Subplan_1',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-OutputFileCleanup',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-PurgeTableMaintenance',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-SendAlerts',@enabled=0
EXEC msdb.dbo.sp_update_job @job_name=N'DBA-ShrinkLogfile',@enabled=0