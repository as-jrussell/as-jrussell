  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[TableName]) AS maxUserUpdate,maxUserUpdate
 FROM [DBA].[info].[TableUsage] 
WHERE CAST(maxUserUpdate AS DATE) >= cast(getdate()-1 AS date)


  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[TableName]) AS maxUserSeek,maxUserSeek
 FROM [DBA].[info].[TableUsage] 
WHERE CAST(maxUserSeek AS DATE) >= cast(getdate()-1 AS date)


  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[TableName]) AS maxUserScan,maxUserScan
 FROM [DBA].[info].[TableUsage] 
WHERE CAST(maxUserScan AS DATE) >= cast(getdate()-1 AS date)


  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[TableName]) AS maxUserLookup,maxUserLookup
--select [DatabaseName],*
 FROM [DBA].[info].[TableUsage] 
WHERE CAST(maxUserLookup AS DATE) >= cast(getdate()-1 AS date)


  SELECT CONCAT([DatabaseName],'.', [SchemaName],'.'  ,[ProcedureName]) AS StoredProcLastExecDate,LastExecDate AS StoredProcLastExecDate
--select [DatabaseName],*
FROM [DBA].[info].[ProcedureUsage] 
WHERE CAST(LastExecDate AS DATE) >= cast(getdate()-1 AS date)

SELECT * FROM [DBA].[info].[AuditLogin] 
WHERE CAST(TimeStampUTC AS DATE) >= cast(getdate()-1 AS date)
ORDER BY TimeStampUTC DESC

SELECT clienthostname, databasename, count(*),  
               MIN(BackupDate), MAX(BackupDate)  
FROM DBA.ddbma.SaveSets  
GROUP BY clienthostname, databasename 


---Active users
SELECT  dec.client_net_address ,
        des.program_name ,
        des.host_name ,
      des.login_name ,
        COUNT(dec.session_id) AS connection_count
		--select *
FROM    sys.dm_exec_sessions AS des
        INNER JOIN sys.dm_exec_connections AS dec
                       ON des.session_id = dec.session_id
GROUP BY dec.client_net_address ,
         des.program_name ,
         des.host_name,
       des.login_name
ORDER BY des.program_name,
         dec.client_net_address 

/*

ddbmexptool.exe -n mssql -a "DDBOOST_USER=ddboost" -a "DEVICE_PATH=/SQL_PROD" -a "DEVICE_HOST=ON-DD9300-01" -a "CLIENT=UT-SQLDEV-01.as.local" -a MSSQL -e "6/13/2022" 

*/