/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [DatabaseName]
      ,[SchemaName]
      ,[TableName]
      ,[CreateDate]
      ,[ModifyDate]
      ,[maxUserSeek]
      ,[maxUserScan]
      ,[maxUserLookup]
      ,[maxUserUpdate]
      ,[DiscoverDate]
      ,[HarvestDate]
  FROM [DBA].[info].[TableUsage]


  SELECT*
			FROM sys.tables as T 
				LEFT JOIN sys.dm_db_index_usage_stats AS IUS 
					ON (T.object_id = IUS.object_id)
				GROUP BY SCHEMA_NAME(schema_ID), T.Name, T.Create_date, T.modify_date