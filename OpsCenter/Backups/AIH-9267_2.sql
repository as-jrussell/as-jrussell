/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [DatabaseName]
      ,[SchemaName]
      ,[TableName]
      ,[CreateDate]
      ,[ModifyDate]
      ,[maxUserSeek]
      ,[maxUserScan]
      ,[maxUserLookup]
      ,[maxUserUpdate]
      ,[HarvestDate]
      ,[DiscoverDate]
--SELECT COUNT (*)
  FROM [DBA].[info].[TableUsage]
  WHERE DatabaseName IN ('VUT', 'Unitrac')
 AND maxUserLookup is null 
 and maxUserScan is null 
 and maxUserSeek is null 
 and maxUserUpdate is null 