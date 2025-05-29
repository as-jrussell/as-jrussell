DECLARE @minutes INT = 0;
DECLARE @ProductLevel NVARCHAR(50);
DECLARE @IsSQL2008 BIT;

-- Get the product level
SET @ProductLevel = CAST(SERVERPROPERTY('ProductLevel') AS NVARCHAR(50));
SET @IsSQL2008 = CASE WHEN CAST(SERVERPROPERTY('ProductMajorVersion') AS INT) = 10 THEN 1 ELSE 0 END;

-- Check if the SQL Server version is RTM or SQL Server 2008
IF @ProductLevel = 'RTM' AND @IsSQL2008 = 1
BEGIN
    PRINT 'The script is bypassed because the SQL Server version is SQL Server 2008 RTM.';
END
ELSE
BEGIN
    IF Object_id(N'tempdb..#LRT') IS NOT NULL
        DROP TABLE #LRT;

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

    -- Insert data into #LRT for newer SQL Server versions
    INSERT INTO #LRT
    SELECT 'Customer Usage', [ServerName] = @@SERVERNAME,
           DatabaseName = DB_NAME(r.database_id),
           r.session_id,
           r.start_time,
           TotalElapsedTime_min = r.total_elapsed_time / 1000 / 60,
           r.[status],
           r.command, 
           wait_type, 
           t.[text]
    FROM   sys.dm_exec_requests r
           CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
           CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) AS p
    WHERE  DB_NAME(r.database_id) IN (SELECT DatabaseName FROM DBA.info.[database] WHERE DatabaseType = 'User');

    SELECT *, 'KILL ', [session_id]
    FROM   #LRT L
    WHERE  L.TotalElapsedTime_min >= @minutes
           AND L.Usage = 'Customer Usage'
    ORDER BY [TotalElapsedTime_min] DESC;

    -- Clean up
    DROP TABLE #LRT;
END;
