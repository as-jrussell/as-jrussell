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

