BEGIN
    DECLARE @ElapsedTimeThreshold BIGINT = 10000; -- Adjust the threshold as needed (in microseconds)

    SELECT 
        DB_NAME(st.dbid) AS DatabaseName,
        SUBSTRING(st.text, (qs.statement_start_offset / 2) + 1, 
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
        END - qs.statement_start_offset) / 2) + 1) AS QueryText,
        qs.execution_count,
        qs.total_elapsed_time,
        qs.total_elapsed_time / qs.execution_count AS AverageElapsedTime,
        COALESCE(OBJECT_NAME(st.objectid, st.dbid), 'Ad-Hoc Query') AS ProcedureName,
        qs.creation_time,
        qs.last_execution_time,
        qp.query_plan
    FROM sys.dm_exec_query_stats qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
    CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
    WHERE 
        (qs.total_elapsed_time / qs.execution_count) > @ElapsedTimeThreshold
        AND qs.execution_count >= 100
        AND DB_NAME(st.dbid) NOT IN (SELECT DatabaseName FROM DBA.INFO.[Database] WHERE DatabaseType <> 'USER');
END;



