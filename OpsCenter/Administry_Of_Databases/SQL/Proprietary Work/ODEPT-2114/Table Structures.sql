DECLARE @SQL NVARCHAR(MAX);
DECLARE @DatabaseName SYSNAME;
DECLARE @DryRun INT = 1; -- 1: Preview, 0: Execute
DECLARE @Verbose INT = 1; -- 1: Verbose output, 0: Minimal output

-- Drop and recreate the temporary table
IF OBJECT_ID(N'tempdb..#DatabaseCycle') IS NOT NULL
    DROP TABLE #DatabaseCycle;

CREATE TABLE #DatabaseCycle
(
    DatabaseName SYSNAME,
    IsProcessed BIT DEFAULT 0
);

-- Global temporary table for results
IF OBJECT_ID('tempdb..##TempResults') IS NOT NULL
    DROP TABLE ##TempResults;

CREATE TABLE ##TempResults
(
    DatabaseName SYSNAME,
    TableName NVARCHAR(200),
    ColumnName NVARCHAR(200),
    DataType NVARCHAR(50),
    MaxLength INT,
    Precision INT,
    Scale INT,
    IsNullable BIT,
    IsPrimaryKey BIT
);

-- Populate the table with database names
INSERT INTO #DatabaseCycle (DatabaseName)
SELECT D.name
      FROM   [DBA].[backup].[Schedule]  S
	  join sys.databases D on S.DatabaseName = D.name
	  WHERE state_desc = 'ONLINE' -- Only process online databases
AND DatabaseType = 'USER'


-- Process databases
WHILE EXISTS (SELECT 1 FROM #DatabaseCycle WHERE IsProcessed = 0)
BEGIN
    -- Fetch the next unprocessed database
    SELECT TOP 1 
        @DatabaseName = DatabaseName
    FROM #DatabaseCycle
    WHERE IsProcessed = 0;

    -- Construct the dynamic SQL to collect data
    SET @SQL = 'USE [' + @DatabaseName + ']; 
                INSERT INTO ##TempResults (DatabaseName, TableName, ColumnName, DataType, MaxLength, Precision, Scale, IsNullable, IsPrimaryKey)
                SELECT 
                    DB_NAME() AS DatabaseName,
                    OBJECT_NAME(c.object_id) AS TableName,
                    c.name AS ColumnName,
                    t.name AS DataType,
                    c.max_length AS MaxLength,
                    c.precision AS Precision,
                    c.scale AS Scale,
                    c.is_nullable AS IsNullable,
                    ISNULL(i.is_primary_key, 0) AS IsPrimaryKey
                FROM sys.columns c
                INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
                LEFT OUTER JOIN sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
                LEFT OUTER JOIN sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id;';

    -- Output the SQL command if verbose mode is enabled
    IF @Verbose = 1
        PRINT N'Executing for Database: ' + @DatabaseName;

    -- Execute or preview
    IF @DryRun = 0
    BEGIN
        PRINT 'Executing: ' + @SQL; -- Log for debugging
        EXEC(@SQL); -- Executes the constructed SQL


    END
    ELSE
    BEGIN
        PRINT 'Preview: ' + @SQL; -- Preview the SQL
    END;

    -- Mark the database as processed
    UPDATE #DatabaseCycle
    SET IsProcessed = 1
    WHERE DatabaseName = @DatabaseName;
END;

    IF @DryRun = 0
    BEGIN
-- Show combined results
SELECT *
FROM ##TempResults;
END
