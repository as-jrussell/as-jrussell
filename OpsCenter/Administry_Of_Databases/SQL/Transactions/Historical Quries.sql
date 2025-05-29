
SELECT dest.text, last_elapsed_time, last_execution_time, max_worker_time
FROM    sys.dm_exec_query_stats AS deqs
        CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
WHERE   deqs.last_execution_time > '8/11/2016 23:25 '
ORDER BY last_execution_time ASC 


