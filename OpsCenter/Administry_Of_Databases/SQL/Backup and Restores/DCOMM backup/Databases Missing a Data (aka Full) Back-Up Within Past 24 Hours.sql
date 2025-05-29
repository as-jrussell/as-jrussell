------------------------------------------------------------------------------------------- 
--Databases Missing a Data (aka Full) Back-Up Within Past 24 Hours 
------------------------------------------------------------------------------------------- 
--Databases with data backup over 24 hours old 
SELECT 
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name, msdb.dbo.backupset.type,
   MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date, 
   DATEDIFF(hh, MAX(msdb.dbo.backupset.backup_finish_date), GETDATE()) AS [Backup Age (Hours)] 
FROM    msdb.dbo.backupset 
--WHERE     msdb.dbo.backupset.type = 'F'  
GROUP BY msdb.dbo.backupset.database_name ,msdb.dbo.backupset.type
HAVING      (MAX(msdb.dbo.backupset.backup_finish_date) < DATEADD(hh, - 24, GETDATE()))  

UNION  

--Databases without any backup history 
SELECT      
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server,  
   master.dbo.sysdatabases.NAME AS database_name,  msdb.dbo.backupset.type,
   NULL AS [Last Data Backup Date],  
   9999 AS [Backup Age (Hours)]  
FROM 
   master.dbo.sysdatabases LEFT JOIN msdb.dbo.backupset 
       ON master.dbo.sysdatabases.name  = msdb.dbo.backupset.database_name 
WHERE msdb.dbo.backupset.database_name IS NULL AND master.dbo.sysdatabases.name <> 'tempdb' 
ORDER BY  
   msdb.dbo.backupset.database_name ,msdb.dbo.backupset.type