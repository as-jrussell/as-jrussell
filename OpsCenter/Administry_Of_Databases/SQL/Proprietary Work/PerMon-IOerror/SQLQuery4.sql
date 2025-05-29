

--TABLE 1
SELECT
    DB_NAME(t.[dbid]) AS [Database Name],
    TA.session_id, TA.wait_type, RE.start_time,
    CO.last_read, CO.last_write,
    last_execution_time, execution_count, RE.[status], RE.command, SE.LOGIN_Name, SE.[host_name], SE.[program_name],
    TA.blocking_session_id,
    t.[text] AS [Query Text]
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
    JOIN sys.dm_exec_requests RE ON RE.query_plan_hash = qs.query_plan_hash
    JOIN SYS.dm_exec_connections CO ON RE.session_id = CO.session_id
    JOIN sys.dm_os_waiting_tasks TA ON CO.session_id = TA.session_id
    JOIN sys.dm_exec_sessions SE on SE.session_id = TA.session_id
GROUP BY DB_NAME(t.[dbid]),RE.start_time, TA.session_id,TA.wait_type,CO.last_read, CO.last_write,execution_count, last_execution_time, RE.[status], RE.command,SE.LOGIN_Name, SE.[host_name], SE.[program_name],TA.blocking_session_id,t.[text]
ORDER BY start_time DESC
OPTION
(RECOMPILE);



--TABLE 2
SELECT
    DB_NAME(t.[dbid]) AS [Database Name],
    TA.session_id, TA.wait_type, RE.start_time,
    CO.last_read, CO.last_write,
    last_execution_time, execution_count, RE.[status], RE.command, SE.LOGIN_Name, SE.[host_name], SE.[program_name],
    TA.blocking_session_id,
    t.[text] AS [Query Text], qp.query_plan AS [Query Plan]
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t 
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
    JOIN sys.dm_exec_requests RE ON RE.query_plan_hash = qs.query_plan_hash
    JOIN SYS.dm_exec_connections CO ON RE.session_id = CO.session_id
    JOIN sys.dm_os_waiting_tasks TA ON CO.session_id = TA.session_id
    JOIN sys.dm_exec_sessions SE on SE.session_id = TA.session_id
ORDER BY RE.start_time DESC
OPTION
(RECOMPILE);



