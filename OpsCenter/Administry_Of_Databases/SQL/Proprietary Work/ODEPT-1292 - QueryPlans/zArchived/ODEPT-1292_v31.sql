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
    AND qs.execution_count >= 100
    AND DATEDIFF(DAY, qs.creation_time, GETDATE()) = 1;

-- Insert current data into the temporary table
DECLARE @ElapsedTimeThreshold BIGINT = 60000; -- Adjust the threshold as needed (in microseconds)

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
    AND (qs.total_elapsed_time / qs.execution_count) > @ElapsedTimeThreshold
    AND DATEDIFF(MINUTE, qs.creation_time, GETDATE()) <= 30
    AND qs.execution_count >= 100;


	WITH MaxHistoricalStats AS (
    SELECT 
        DatabaseName,
        QueryText,
        MAX(AverageElapsedTime) AS MaxHistoricalAverageElapsedTime,
        ProcedureName
    FROM 
        #historical_query_stats
    GROUP BY 
        DatabaseName, QueryText, ProcedureName
),
RecentHistoricalPlans AS (
    SELECT 
        DatabaseName,
        QueryText,
        ProcedureName,
        PlanXML,
        ROW_NUMBER() OVER (PARTITION BY DatabaseName, QueryText ORDER BY CollectionTime DESC) AS rn
    FROM 
        #historical_query_stats
),
MaxHistoricalStatsByProc AS (
    SELECT 
        DatabaseName,
        ProcedureName AS QueryText,
        MAX(AverageElapsedTime) AS MaxHistoricalAverageElapsedTime,
        ProcedureName
    FROM 
        #historical_query_stats
    GROUP BY 
        DatabaseName, ProcedureName
),
RecentHistoricalPlansByProc AS (
    SELECT 
        DatabaseName,
        ProcedureName AS QueryText,
        PlanXML,
        ROW_NUMBER() OVER (PARTITION BY DatabaseName, ProcedureName ORDER BY CollectionTime DESC) AS rn
    FROM 
        #historical_query_stats
),
StatsComparison AS (
    SELECT 
        c.DatabaseName,
        c.QueryText,
        c.ExecutionCount AS CurrentExecutionCount,
        c.TotalElapsedTime AS CurrentTotalElapsedTime,
        c.AverageElapsedTime AS CurrentAverageElapsedTime,
        h.MaxHistoricalAverageElapsedTime AS HistoricalAverageElapsedTime,
        COALESCE(
            ((c.AverageElapsedTime - h.MaxHistoricalAverageElapsedTime) * 100.0) 
            / NULLIF(h.MaxHistoricalAverageElapsedTime, 0), 
            NULL
        ) AS PercentageChangeInAverageElapsedTime,
        c.ProcedureName AS CurrentProcedureName,
        c.PlanXML AS CurrentPlanXML,
        rp.PlanXML AS HistoricalPlanXML
    FROM 
        #current_query_stats c
        LEFT JOIN MaxHistoricalStats h 
            ON c.DatabaseName = h.DatabaseName 
            AND c.QueryText = h.QueryText
        LEFT JOIN RecentHistoricalPlans rp 
            ON c.DatabaseName = rp.DatabaseName 
            AND c.QueryText = rp.QueryText 
            AND rp.rn = 1
),
StatsComparisonByProc AS (
    SELECT 
        c.DatabaseName,
        c.ProcedureName AS QueryText,
        c.ExecutionCount AS CurrentExecutionCount,
        c.TotalElapsedTime AS CurrentTotalElapsedTime,
        c.AverageElapsedTime AS CurrentAverageElapsedTime,
        h.MaxHistoricalAverageElapsedTime AS HistoricalAverageElapsedTime,
        COALESCE(
            ((c.AverageElapsedTime - h.MaxHistoricalAverageElapsedTime) * 100.0) 
            / NULLIF(h.MaxHistoricalAverageElapsedTime, 0), 
            NULL
        ) AS PercentageChangeInAverageElapsedTime,
        c.ProcedureName AS CurrentProcedureName,
        c.PlanXML AS CurrentPlanXML,
        rp.PlanXML AS HistoricalPlanXML
    FROM 
        #current_query_stats c
        LEFT JOIN MaxHistoricalStatsByProc h 
            ON c.DatabaseName = h.DatabaseName 
            AND c.ProcedureName = h.ProcedureName
        LEFT JOIN RecentHistoricalPlansByProc rp 
            ON c.DatabaseName = rp.DatabaseName 
            AND c.ProcedureName = rp.QueryText 
            AND rp.rn = 1
)
SELECT 
    DatabaseName,
    QueryText,
    CurrentExecutionCount,
    CurrentTotalElapsedTime,
    CurrentAverageElapsedTime,
    HistoricalAverageElapsedTime,
    PercentageChangeInAverageElapsedTime,
    CASE 
        WHEN CurrentProcedureName IS NULL OR CurrentProcedureName = 'Ad-Hoc Query' THEN 'Ad-Hoc'
        ELSE CurrentProcedureName 
    END AS CurrentQueryType,
    'Ad-Hoc' AS HistoricalQueryType,
    CurrentPlanXML,
    HistoricalPlanXML
FROM 
    StatsComparison

UNION ALL

SELECT 
    DatabaseName,
    QueryText,
    CurrentExecutionCount,
    CurrentTotalElapsedTime,
    CurrentAverageElapsedTime,
    HistoricalAverageElapsedTime,
    PercentageChangeInAverageElapsedTime,
    CASE 
        WHEN CurrentProcedureName IS NULL OR CurrentProcedureName = 'Ad-Hoc Query' THEN 'Ad-Hoc'
        ELSE CurrentProcedureName 
    END AS CurrentQueryType,
    'Stored Procedure' AS HistoricalQueryType,
    CurrentPlanXML,
    HistoricalPlanXML
FROM 
    StatsComparisonByProc