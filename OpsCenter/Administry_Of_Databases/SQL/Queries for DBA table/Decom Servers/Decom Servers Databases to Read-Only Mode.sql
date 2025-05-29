/* DECLARE ALL variables at the top */
DECLARE @SQL VARCHAR(4000)
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 
DECLARE @DatabaseName SYSNAME

-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases

CREATE TABLE #TempDatabases
  (
     DatabaseName SYSNAME,
     IsProcessed  BIT
  )

-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases
            (DatabaseName,
             IsProcessed)
SELECT name,
       0 -- SELECT  is_read_only, *
FROM   sys.databases
WHERE  database_id > 4
       AND name NOT IN ( 'DBA', 'Perfstats', 'HDTStorage' )
ORDER  BY database_id

-- Loop through the remaining databases
WHILE EXISTS(SELECT *
             FROM   #TempDatabases
             WHERE  IsProcessed = 0)
  BEGIN
      -- Fetch 1 DatabaseName where IsProcessed = 0
      SELECT TOP 1 @DatabaseName = DatabaseName
      FROM   #TempDatabases
      WHERE  IsProcessed = 0

      -- Prepare SQL Statement
      SELECT @SQL = '
USE [master]
  IF EXISTS (SELECT 1 FROM sys.databases where name = '''
                    + @DatabaseName + '''AND is_read_only = ''0'')
BEGIN 
ALTER DATABASE ['
                    + @DatabaseName + '] SET READ_ONLY WITH NO_WAIT
PRINT ''SUCCESS: THE ['
                    + @DatabaseName + '] DATABASE SET TO READ_ONLY MODE''


END 
ELSE
BEGIN 
PRINT ''WARNING: THE ['
                    + @DatabaseName + '] DATABASE IS ALREADY SET TO READ_ONLY MODE''
END '

      -- You know what we do here if it's 1 then it'll give us code and 0 executes it
      IF @DryRun = 0
        BEGIN
            EXEC ( @SQL)
        END
      ELSE
        BEGIN
            PRINT ( @SQL )
        END

      -- Update table
      UPDATE #TempDatabases
      SET    IsProcessed = 1
      WHERE  DatabaseName = @databaseName
  END 
