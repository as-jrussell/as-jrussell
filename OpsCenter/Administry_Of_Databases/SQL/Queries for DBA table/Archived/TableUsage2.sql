 'RepoPlusAnalytics'
 --Any Table searches
  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[TableName]) AS maxUserUpdate,maxUserUpdate
 FROM [DBA].[info].[TableUsage] 
WHERE CAST(maxUserUpdate AS DATE) >= cast(getdate()-1 AS date)
AND  DatabaseName not in ('DBA', 'Perfstats', 'HDTStorage', 'msdb','master', 'tempdb', 'model')
AND DatabaseName in (@Database)


  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[TableName]) AS maxUserSeek,maxUserSeek
 FROM [DBA].[info].[TableUsage] 
WHERE CAST(maxUserSeek AS DATE) >= cast(getdate()-1 AS date)
AND  DatabaseName not in ('DBA', 'Perfstats', 'HDTStorage', 'msdb','master', 'tempdb', 'model')
AND DatabaseName in (@Database)


  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[TableName]) AS maxUserScan,maxUserScan
 FROM [DBA].[info].[TableUsage] 
WHERE CAST(maxUserScan AS DATE) >= cast(getdate()-1 AS date)
AND  DatabaseName not in ('DBA', 'Perfstats', 'HDTStorage', 'msdb','master', 'tempdb', 'model')
AND DatabaseName in (@Database)


  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[TableName]) AS maxUserLookup,maxUserLookup
--select [DatabaseName],*
 FROM [DBA].[info].[TableUsage] 
WHERE CAST(maxUserLookup AS DATE) >= cast(getdate()-1 AS date)
AND  DatabaseName not in ('DBA', 'Perfstats', 'HDTStorage', 'msdb','master', 'tempdb', 'model')
AND DatabaseName in (@Database)

---Last time a Stored Proc was executed 

  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[ProcedureName]) AS StoredProcLastExecDate,LastExecDate AS StoredProcLastExecDate
--select [DatabaseName],*
FROM [DBA].[info].[ProcedureUsage] 
WHERE CAST(LastExecDate AS DATE) >= cast(getdate()-1 AS date)
AND DatabaseName in (@Database)
