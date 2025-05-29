--DECLARE @ElapsedTimeThreshold BIGINT = 2000000; -- Adjust the threshold as needed (in microseconds)


IF OBJECT_ID(N'tempdb..#historical_query_stats') IS NOT NULL
    DROP TABLE #historical_query_stats;

CREATE TABLE #historical_query_stats (
    DatabaseName NVARCHAR(128),
    QueryText NVARCHAR(MAX),
    ExecutionCount BIGINT,
    TotalElapsedTime BIGINT,
    AverageElapsedTime BIGINT,
    CollectionTime DATETIME,
    ProcedureName NVARCHAR(128),
    PlanXML XML
);

IF OBJECT_ID(N'tempdb..#current_query_stats') IS NOT NULL
    DROP TABLE #current_query_stats;

CREATE TABLE #current_query_stats (
    DatabaseName NVARCHAR(128),
    QueryText NVARCHAR(MAX),
    ExecutionCount BIGINT,
    TotalElapsedTime BIGINT,
    AverageElapsedTime BIGINT,
    CollectionTime DATETIME,
    ProcedureName NVARCHAR(128),
    PlanXML XML
);


DECLARE @ElapsedTimeThreshold BIGINT = 2000000; -- Adjust the threshold as needed (in microseconds)

-- Insert historical data into the temporary table
INSERT INTO #historical_query_stats (DatabaseName, QueryText, ExecutionCount, TotalElapsedTime, AverageElapsedTime, CollectionTime, ProcedureName, PlanXML)
SELECT 
    Db_name(st.dbid) AS DatabaseName,
    Substring(st.text, (qs.statement_start_offset / 2) + 1, 
              ((CASE qs.statement_end_offset
                  WHEN -1 THEN Datalength(st.text)
                  ELSE qs.statement_end_offset
               END - qs.statement_start_offset) / 2) + 1) AS QueryText,
    qs.execution_count AS ExecutionCount,
    qs.total_elapsed_time AS TotalElapsedTime,
    qs.total_elapsed_time / qs.execution_count AS AverageElapsedTime,
    qs.creation_time AS CollectionTime,
    COALESCE(OBJECT_NAME(st.objectid, st.dbid), 'Ad-Hoc Query') AS ProcedureName,
    qp.query_plan AS PlanXML
FROM 
    sys.dm_exec_query_stats qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
    CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE  
    (Db_name(st.dbid) NOT IN (
        SELECT DatabaseName
        FROM DBA.INFO.[Database]
        WHERE DatabaseType <> 'USER')
     OR OBJECT_NAME(st.objectid, st.dbid) IS NULL)
    AND DATEDIFF(DAY, qs.creation_time, GETDATE()) = 1
       AND ( qs.total_elapsed_time / qs.execution_count ) > @ElapsedTimeThreshold
	--   	AND OBJECT_NAME(st.objectid, st.dbid) <> 'Ad-Hoc Query';


-- Insert current data into the temporary table


INSERT INTO #current_query_stats (DatabaseName, QueryText, ExecutionCount, TotalElapsedTime, AverageElapsedTime, CollectionTime, ProcedureName, PlanXML)
SELECT 
    Db_name(st.dbid) AS DatabaseName,
    Substring(st.text, (qs.statement_start_offset / 2) + 1, 
              ((CASE qs.statement_end_offset
                  WHEN -1 THEN Datalength(st.text)
                  ELSE qs.statement_end_offset
               END - qs.statement_start_offset) / 2) + 1) AS QueryText,
    qs.execution_count AS ExecutionCount,
    qs.total_elapsed_time AS TotalElapsedTime,
    qs.total_elapsed_time / qs.execution_count AS AverageElapsedTime,
    GETDATE() AS CollectionTime, -- Current collection time
    COALESCE(OBJECT_NAME(st.objectid, st.dbid), 'Ad-Hoc Query') AS ProcedureName,
    qp.query_plan AS PlanXML
FROM   sys.dm_exec_query_stats qs
       CROSS APPLY sys.Dm_exec_sql_text(qs.sql_handle) st
       CROSS APPLY sys.Dm_exec_query_plan(qs.plan_handle) qp
WHERE  ( Db_name(st.dbid) NOT IN (SELECT DatabaseName
                                  FROM   DBA.INFO.[Database]
                                  WHERE  DatabaseType <> 'USER')
          OR Object_name(st.objectid, st.dbid) IS NULL )
       AND ( qs.total_elapsed_time / qs.execution_count ) > @ElapsedTimeThreshold
	   AND DATEDIFF(MINUTE, creation_time, GETDATE()) <= 30
--	     	AND OBJECT_NAME(st.objectid, st.dbid) <> 'Ad-Hoc Query';


SELECT * FROM #historical_query_stats H
JOIN #current_query_stats C on H.ProcedureName = C.ProcedureName
where H.ProcedureName <> 'Ad-Hoc Query'
	


	---tomorrow goal to detrmine how to minimize the highest wait time 
