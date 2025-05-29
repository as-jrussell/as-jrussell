  USE [DBA]
GO

SELECT * FROM DBA.[info].[databaseConfig]


INSERT INTO [info].[databaseConfig]
           ([databaseName]
           ,[confkey]
           ,[confvalue])
     VALUES
           ('DataDomain'
           ,'Host'
           ,'ON-DD9300-01')
GO




/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [JobName]
      ,[JobDescription]
      ,[JobCategory]
      ,[JobEnabled]
      ,[JobStatus]
      ,[StatusDesc]
      ,[JobDurationSec]
      ,[RunDateTime]
      ,[EndDateTime]
      ,[CreateDate]
      ,[ModifiedDate]
      ,[HarvestDate]
  FROM [DBA].[info].[AgentJob]
  WHERE JobName in ('DBA-BackupDatabases-FULL','DBA-BackupDatabases-LOG')
  and JobEnabled = '1'


  SELECT  TOP 1
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, msdb..backupset.type,
   msdb.dbo.backupset.database_name,  
   MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date 
FROM   msdb.dbo.backupmediafamily  
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
WHERE msdb..backupset.type = 'L' 
GROUP BY 
   msdb.dbo.backupset.database_name  , msdb..backupset.type
ORDER BY  
 MAX(msdb.dbo.backupset.backup_finish_date) DESC