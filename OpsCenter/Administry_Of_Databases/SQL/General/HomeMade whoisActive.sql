DECLARE @minutes INT = 0

IF Object_id(N'tempdb..#LRT') IS NOT NULL
  DROP TABLE #LRT

CREATE TABLE #LRT (
    [Usage] VARCHAR(255),  
    [ServerName] VARCHAR(255),
    [DatabaseName] VARCHAR(255),
    [session_id] SMALLINT,
    [start_time] DATETIME,
    [TotalElapsedTime_min] INT,
    [status] VARCHAR(30), 
    [command] VARCHAR(32),
    [wait_type] NVARCHAR(128),
    [text] NVARCHAR(MAX)  
);



INSERT INTO #LRT
SELECT 'Customer Usage', [ServerName]         =@@SERVERNAME,
       DatabaseName         = Db_name(r.database_id),
       r.session_id,
       r.start_time,
       TotalElapsedTime_min = r.total_elapsed_time / 1000 / 60,
       r.[status],
       r.command, wait_type, t.[text]--, p.query_plan
FROM   sys.dm_exec_requests r
       CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS t
       CROSS APPLY sys.Dm_exec_query_plan(r.plan_handle) AS p
	   WHERE Db_name(r.database_id) IN (select DatabaseName from DBA.info.[database] where DatabaseType = 'User')
UNION
SELECT 'System Usage',[ServerName]         =@@SERVERNAME,
       DatabaseName         = Db_name(r.database_id),
       r.session_id,
       r.start_time,
       TotalElapsedTime_min = r.total_elapsed_time / 1000 / 60,
       r.[status],
       r.command, wait_type, t.[text]--, p.query_plan
FROM   sys.dm_exec_requests r
       CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS t
       CROSS APPLY sys.Dm_exec_query_plan(r.plan_handle) AS p
	   WHERE Db_name(r.database_id) IN (select DatabaseName from DBA.info.[database] where DatabaseType != 'User')
UNION
SELECT 'System Usage - Sleeping',[ServerName]         =@@SERVERNAME,
       DatabaseName         = Db_name(s.database_id),
       s.session_id,
       s.login_time,
       TotalElapsedTime_min = s.total_elapsed_time / 1000,
       s.[status],
       r.command, wait_type, 'No Data'--, p.query_plan
FROM sys.dm_exec_sessions AS s
LEFT JOIN sys.dm_exec_requests AS r ON s.session_id = r.session_id
WHERE s.is_user_process = 1 AND s.open_transaction_count > 0

		   AND  Db_name(s.database_id) IN (select DatabaseName from DBA.info.[database] where DatabaseType != 'User')
		     AND s.session_id not in ( SELECT
       r.session_id
FROM   sys.dm_exec_requests r
       CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS t
       CROSS APPLY sys.Dm_exec_query_plan(r.plan_handle) AS p
	   WHERE Db_name(r.database_id) IN (select DatabaseName from DBA.info.[database] where DatabaseType != 'User'))
UNION
SELECT 'Customer Usage - Sleeping',[ServerName]         =@@SERVERNAME,
       DatabaseName         = Db_name(s.database_id),
       s.session_id,
       s.login_time,
       TotalElapsedTime_min =ABS(s.total_elapsed_time / 1000 ),
       s.[status],
       r.command, wait_type, 'No Data'--, p.query_plan
FROM sys.dm_exec_sessions AS s
LEFT JOIN sys.dm_exec_requests AS r ON s.session_id = r.session_id
WHERE s.is_user_process = 1 AND s.open_transaction_count > 0
		   AND  Db_name(s.database_id) IN (select DatabaseName from DBA.info.[database] where DatabaseType = 'User')
		   AND s.session_id not in ( SELECT
       r.session_id
FROM   sys.dm_exec_requests r
       CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS t
       CROSS APPLY sys.Dm_exec_query_plan(r.plan_handle) AS p
	   WHERE Db_name(r.database_id) IN (select DatabaseName from DBA.info.[database] where DatabaseType = 'User'))




SELECT *,CONCAT('KILL ', [session_id])
FROM   #LRT L
WHERE  L.TotalElapsedTime_min >= @minutes
AND L.Usage = 'Customer Usage'
ORDER BY [TotalElapsedTime_min] desc 


-- SELECT
--       r.session_id 
--FROM   sys.dm_exec_requests r
--       CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS t
--       CROSS APPLY sys.Dm_exec_query_plan(r.plan_handle) AS p
--	   WHERE Db_name(r.database_id) IN (select DatabaseName from DBA.info.[database] where DatabaseType = 'User')


--   SELECT   
--       s.session_id
--FROM sys.dm_exec_sessions AS s
--LEFT JOIN sys.dm_exec_requests AS r ON s.session_id = r.session_id
--WHERE s.is_user_process = 1 AND s.open_transaction_count > 0
--		   AND  Db_name(s.database_id) IN (select DatabaseName from DBA.info.[database] where DatabaseType = 'User')


--EXEC DBA.DBO.sp_WhoIsActive



