  USE [DBA]
GO

SELECT * FROM DBA.[info].[databaseConfig]


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [databaseName]
      ,[confkey]
      ,[confvalue]
	    FROM [DBA].[info].[databaseConfig]


update  D  
SET D.confvalue = 'DBK-DD9300-01'   --ON-DD9300-01
--SELECT *
  FROM [DBA].[info].[databaseConfig] D
  WHERE confkey = 'Host'


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
  

  SELECT recovery_model, recovery_model_desc FROM sys.databases 

  SELECT top 1
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



 Exec [backup].[BackupDatabase] 
	@BackupLevel = 'LOG',
	@SQLDatabaseName = 'SYSTEM_DATABASES',
	@DryRun = 0