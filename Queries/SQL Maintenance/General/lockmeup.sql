

SELECT
    r.session_id AS [waiting_session_id_Who’s currently blocked],
    r.blocking_session_id [	Who’s holding up the line],
    r.status AS waiting_status,
    r.wait_type,
    r.wait_time,
    r.last_wait_type,
    r.cpu_time,
    r.total_elapsed_time,
    DB_NAME(r.database_id) AS database_name,
    wt.text AS [waiting_sql_text_What the blocked session is trying to do] ,
    bt.text AS [blocking_sql_text_What the blocker is doing (or sitting on)],
	
    SWITCHOFFSET(br.start_time, '-04:00') AS blocking_start_time_EDT,
    SWITCHOFFSET(r.start_time, '-04:00') AS waiting_start_time_EDT
 --   br.status AS blocking_status,
--    br.wait_type AS blocking_wait_type
FROM sys.dm_exec_requests r
LEFT JOIN sys.dm_exec_requests br
    ON r.blocking_session_id = br.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) wt
OUTER APPLY sys.dm_exec_sql_text(br.sql_handle) bt
WHERE r.blocking_session_id IS NOT NULL
and r.blocking_session_id <> 0
ORDER BY r.total_elapsed_time DESC;

