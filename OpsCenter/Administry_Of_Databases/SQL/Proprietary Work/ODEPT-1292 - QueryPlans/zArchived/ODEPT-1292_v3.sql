DECLARE @ElapsedTimeThreshold BIGINT = 60000; -- Adjust the threshold as needed (in microseconds)


SELECT Db_name(st.dbid)                                                                                           AS DatabaseName,
       Substring(st.text, ( qs.statement_start_offset / 2 ) + 1, ( ( CASE qs.statement_end_offset
                                                                       WHEN -1 THEN Datalength(st.text)
                                                                       ELSE qs.statement_end_offset
                                                                     END - qs.statement_start_offset ) / 2 ) + 1) AS QueryText,
       qs.execution_count,
       qs.total_elapsed_time,
       qs.total_elapsed_time / qs.execution_count                                                                 AS AverageElapsedTime,
       COALESCE(Object_name(st.objectid, st.dbid), 'Ad-Hoc Query')                                                AS ProcedureName,
       qs.creation_time,
       qs.last_execution_time,
       qp.query_plan
FROM   sys.dm_exec_query_stats qs
       CROSS APPLY sys.Dm_exec_sql_text(qs.sql_handle) st
       CROSS APPLY sys.Dm_exec_query_plan(qs.plan_handle) qp
WHERE  ( Db_name(st.dbid) NOT IN (SELECT DatabaseName
                                  FROM   DBA.INFO.[Database]
                                  WHERE  DatabaseType <> 'USER')
          OR Object_name(st.objectid, st.dbid) IS NULL )
       AND ( qs.total_elapsed_time / qs.execution_count ) > @ElapsedTimeThreshold
	   AND DATEDIFF(MINUTE, creation_time, GETDATE()) <= 30
       AND qs.execution_count >= 100 
