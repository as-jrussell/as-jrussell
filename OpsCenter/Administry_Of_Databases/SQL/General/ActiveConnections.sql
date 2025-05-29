SELECT count(*) as ConnectionCount,
CASE when is_user_process =1 then 'UserProcess' else 'System Process' end
FROM sys.dm_exec_sessions
GROUP by is_user_process

SELECT login_name ,COUNT(session_id) AS session_count
--select *
FROM sys.dm_exec_sessions   
GROUP BY login_name;

SELECT count(*) as ConnectionCount
FROM sys.dm_exec_sessions
WHERE is_user_process = 1



SELECT DB_NAME(dbid) as DBName, COUNT(dbid) as NumberOfConnections,loginame as LoginName
FROM sys.sysprocesses
WHERE dbid > 0
GROUP BY dbid, loginame

-- This script returns the status, login name and host name for the database you specify.

SELECT spid, status, loginame, hostname, blocked, db_name(dbid), cmd
FROM sys.sysprocesses
WHERE db_name(dbid) = 'UniTrac'