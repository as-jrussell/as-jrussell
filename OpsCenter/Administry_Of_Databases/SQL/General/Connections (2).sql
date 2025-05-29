SELECT DB_NAME(dbid) AS DBNAME, COUNT(dbid) AS NumberOfConnections, loginame AS LoginName FROM sys.sysprocesses
WHERE dbid > 0 AND DB_NAME(dbid) IN ('VehicleCT', 'VehicleUC')
GROUP BY dbid, loginame
ORDER BY DBNAME



SELECT DB_NAME(dbid) AS DBNAME, loginame AS LoginName, 'kill',spid FROM sys.sysprocesses
WHERE dbid > 0 AND DB_NAME(dbid) IN ('VehicleCT', 'VehicleUC')


select * FROM sys.sysprocesses
WHERE dbid > 0 AND DB_NAME(dbid) IN ('VehicleCT', 'VehicleUC')




