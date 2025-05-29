IF OBJECT_ID(N'tempdb..#ExecutingQueries') IS NOT NULL
DROP TABLE #ExecutingQueries

DECLARE @Database VARCHAR(100) = NULL 
DECLARE @EntityName VARCHAR(100) = NULL
DECLARE @ExcludeMyQueries BIT = 0
DECLARE @RunningThreadsOnly BIT = 0
DECLARE @LocksOnly BIT = 0
DECLARE @MinDuration INT = 0
DECLARE @OutputMode INT = 0 -- TODO: Setup formally documented modes, and clean up usage below, can even have different kinds of modes like Verbose, vs EmergenciesOnly, etc

DECLARE @ExecutionDate DATETIME = GETDATE();

SELECT 
    SP.HostName,
    SP.SPID,    
    ER.request_id AS RequestId,
    ER.percent_complete AS PercentComplete, 
    DATEDIFF(s, start_time, @ExecutionDate) AS Duration,
    CAST(((DATEDIFF(s, start_time, @ExecutionDate)) / 3600) AS VARCHAR) + ' hour(s), '
        + CAST((DATEDIFF(s, start_time, @ExecutionDate) % 3600) / 60 AS VARCHAR) + 'min, ' 
        + CAST((DATEDIFF(s, start_time, @ExecutionDate) % 60) AS VARCHAR) + ' sec' AS RunningTime, 
    CAST((estimated_completion_time / 3600000) AS VARCHAR) + ' hour(s), ' 
        + CAST((estimated_completion_time % 3600000) / 60000 AS VARCHAR) + 'min, ' 
        + CAST((estimated_completion_time % 60000) / 1000 AS VARCHAR) + ' sec' AS EstimatedTimeRemaining, 
    DATEADD(SECOND, estimated_completion_time/1000, @ExecutionDate) AS EstimatedCompletionDate, 
    ER.Command,
    ER.blocking_session_id AS BlockingSessionId, 
    LastWaitType,  
    SP.[DBID],  
    DB_NAME(SP.[DBID]) AS DbName,   
    CPU,
    ER.plan_handle AS PlanHandle,
    ER.query_plan_hash AS QueryPlanHash,
    LOGIN_TIME AS LoginTime,
    LOGINAME AS LoginName, 
    SP.[Status],
    [PROGRAM_NAME] AS ProgramName,
    NT_DOMAIN AS NT_Domain, 
    NT_USERNAME AS NT_Username, 
    @@SERVERNAME AS ServerName,
    @ExecutionDate AS ExecutionDate 
INTO #ExecutingQueries
FROM sys.sysprocesses SP  
INNER JOIN sys.dm_exec_requests ER 
    ON sp.spid = ER.session_id 
WHERE --TEXT NOT LIKE N'%spGetRunningQueries%'
    --AND 
    DB_NAME(SP.dbid) NOT IN ('msdb','master','Distribution') 
	AND SP.SPID > 50
    AND
    (
        @Database IS NULL
        OR (@Database IS NOT NULL AND @Database = DB_NAME(SP.[DBID]))
    )
    AND
    (
        @ExcludeMyQueries = 0
        OR (@ExcludeMyQueries = 1 AND hostname <> HOST_NAME())
    )   
    AND
    (
        @RunningThreadsOnly = 0
        OR (@RunningThreadsOnly = 1 AND SP.[Status] = 'RUNNABLE')
    )
    AND 
    (
        @LocksOnly = 0
        OR (@LocksOnly = 1 AND ER.blocking_session_id <> 0) -- TODO: Show the source running query that IS the blocking session ID (will need to join / union this in somehow?)
    )
    AND DATEDIFF(s, start_time, @ExecutionDate) >= @MinDuration

-- TODO: Clean this up and DON'T USE SELECT *
IF (@OutputMode = 0) -- Everything mode
BEGIN
    SELECT *
    FROM #ExecutingQueries
END
ELSE IF (@OutputMode = 1) -- Lightweight mode
BEGIN
    SELECT 
        HostName,
        SPID,
        RequestId,
        RunningTime,
        BlockingSessionId,
        LastWaitType,
        DbName,
        PlanHandle,
        [Status]
    FROM #ExecutingQueries
END

SELECT sp.open_tran, sp.spid,st.text,sp.status,sp.login_time,sp.last_batch,
sp.hostname,sp.loginame FROM sys.sysprocesses sp 
CROSS APPLY sys.dm_exec_sql_text(sp.sql_handle) st
WHERE open_tran >= 1 --and sp.dbid=DB_ID('your_db_name')
order by login_time asc