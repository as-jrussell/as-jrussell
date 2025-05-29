DECLARE @sqlcmd VARCHAR(MAX)
DECLARE @DryRun INT = 0
DECLARE @DatabaseName SYSNAME

-- Create a temporary table to store the combined results
IF OBJECT_ID(N'tempdb..#CombinedResults') IS NOT NULL
  DROP TABLE #CombinedResults

CREATE TABLE #CombinedResults
  (
     InstanceName NVARCHAR(100),
     DatabaseName SYSNAME,
     ProcedureName NVARCHAR(MAX),
     ObjectName NVARCHAR(MAX),
     ObjectTypeDescription NVARCHAR(MAX),
     LastExecutionTime DATETIME,
     ExecutionCount INT
  )

-- Create a temporary table to store the databases
IF OBJECT_ID(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases

CREATE TABLE #TempDatabases
  (
     DatabaseName SYSNAME,
     IsProcessed BIT
  )

-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases (DatabaseName, IsProcessed)
SELECT name, 0
FROM sys.databases
WHERE database_id > 4
ORDER BY database_id

-- Loop through the remaining databases
WHILE EXISTS (SELECT * FROM #TempDatabases WHERE IsProcessed = 0)
BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT TOP 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 

    SET @sqlcmd = '
        USE [' + @DatabaseName + '];
        INSERT INTO #CombinedResults (InstanceName, DatabaseName, ProcedureName, ObjectName,ObjectTypeDescription, LastExecutionTime, ExecutionCount)
      SELECT DISTINCT I.SQLSERVERNAME, DB_NAME(database_id) DatabaseName,  OBJECT_NAME(ST.object_id) ProcedureName , '''',ST.type_desc,ST.last_execution_time, ST.execution_count
FROM sys.procedures P 
LEFT JOIN sys.dm_exec_procedure_stats ST on P.name = OBJECT_NAME(ST.object_id)
CROSS JOIN DBA.INFO.INSTANCE I
WHERE  DB_NAME(database_id) = DB_NAME()
UNION
SELECT DISTINCT I.SQLSERVERNAME, DB_NAME(), CONCAT(OBJECT_NAME(ED.referencing_id), '' stored procedure needs object:''), ED.referenced_entity_name COLLATE SQL_Latin1_General_CP1_CI_AS AS column2_alias, O.type_desc, NULL,  NULL
FROM sys.sql_expression_dependencies ED
LEFT JOIN sys.objects O on O.name = ED.referenced_entity_name
CROSS JOIN DBA.INFO.INSTANCE I
order by ProcedureName asc, execution_count desc;
'
        

    -- Perform DryRun or Execution based on @DryRun value
    IF @DryRun = 0
    BEGIN
        EXEC (@sqlcmd)
    END
    ELSE
    BEGIN
        PRINT (@sqlcmd)
    END

    -- Update table
    UPDATE #TempDatabases 
    SET IsProcessed = 1
    WHERE DatabaseName = @DatabaseName
END

-- Fetch combined results for all databases
SELECT * FROM #CombinedResults
Order by DatabaseName ASC, ProcedureName ASC, LastExecutionTime DESC