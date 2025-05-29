--------------------------------------------------------------------------------- 
--Database Backups for all databases For Previous Week 
--------------------------------------------------------------------------------- 

SELECT 
CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
msdb.dbo.backupset.database_name, 
msdb.dbo.backupset.backup_start_date, 
msdb.dbo.backupset.backup_finish_date, 
msdb.dbo.backupset.expiration_date, 
CASE msdb..backupset.type 
WHEN 'D' THEN 'Database' 
WHEN 'L' THEN 'Log' 
WHEN 'i'  THEN 'DIFFERNTIAL'
END AS backup_type, 
msdb.dbo.backupset.backup_size, 
msdb.dbo.backupmediafamily.logical_device_name, 
msdb.dbo.backupmediafamily.physical_device_name, 
msdb.dbo.backupset.name AS backupset_name, 
msdb.dbo.backupset.description 
FROM msdb.dbo.backupmediafamily 
INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7)  and database_name = 'UTL'
ORDER BY 
msdb.dbo.backupset.database_name, 
msdb.dbo.backupset.backup_finish_date 



/*
(local)_master_1AM_Nightly-SQL_Servers_nightly_full-1533272400066-3006-SQL
{C89DF99A-6A69-48B9-9257-AC44FD6FE7BD}3
*/