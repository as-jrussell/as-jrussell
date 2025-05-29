USE [DBA]
GO

SELECT [databaseName]
      ,[confkey]
      ,[confvalue]
--Update DC set confvalue = 'AWS-EC2'
  FROM [info].[databaseConfig] DC
  where confkey = 'Software' and confvalue ='ddboost'
GO

USE [DBA]
GO

SELECT [DatabaseName]
      ,[DatabaseType]
      ,[BackupMethod]
      ,[ExpectedRecoveryModel]
      ,[Sunday]
      ,[Monday]
      ,[Tuesday]
      ,[Wednesday]
      ,[Thursday]
      ,[Friday]
      ,[Saturday]
      ,[NumberOfFiles]
      ,[WithCompression]
      ,[CompressionLevel]
      ,[WithEncryption]
      ,[Exclude]
	  --Update S set BackupMethod =  'AWS-EC2'
  FROM [DBA].[backup].[Schedule] S

GO

