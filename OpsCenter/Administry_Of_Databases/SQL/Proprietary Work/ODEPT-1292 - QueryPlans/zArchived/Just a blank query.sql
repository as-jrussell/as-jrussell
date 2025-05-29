     DECLARE @ElapsedTimeThreshold BIGINT = 2000000; 

 SELECT 
        NEWID() AS QueryID,  -- Generate a new unique identifier for each query
        qs.plan_handle AS PlanID,  -- Use plan handle as the unique identifier for the plan
        Db_name(st.dbid) AS DatabaseName,
        Substring(st.text, (qs.statement_start_offset / 2) + 1, 
                  ((CASE qs.statement_end_offset
                      WHEN -1 THEN Datalength(st.text)
                      ELSE qs.statement_end_offset
                   END - qs.statement_start_offset) / 2) + 1) AS QueryText,
        qs.execution_count AS ExecutionCount,
        COALESCE(OBJECT_NAME(st.objectid, st.dbid), 'Ad-Hoc Query') AS ProcedureName,
        qs.creation_time AS ExecutionTime,
        qp.query_plan AS QueryPlan
    FROM 
        sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
        CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
    WHERE  
        Db_name(st.dbid) NOT IN  
        (
            SELECT DatabaseName
            FROM DBA.INFO.[Database]
            WHERE DatabaseType <> 'USER'
        )

        AND (qs.total_elapsed_time / qs.execution_count) > @ElapsedTimeThreshold