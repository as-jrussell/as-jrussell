/* DECLARE ALL variables at the top */
DECLARE @SQL VARCHAR(max)
DECLARE @FileName nvarchar(100) 
DECLARE @DatabaseName SYSNAME 
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 

SELECT @DatabaseName = name
FROM   sys.databases 
WHERE  database_id = (SELECT DB_ID('tempdb') )


-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases
CREATE TABLE #TempDatabases
  (
     DatabaseName SYSNAME,
     IsProcessed BIT
  )
-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases (DatabaseName, IsProcessed)
SELECT name, 0 -- SELECT *
FROM   sys.master_files
WHERE  database_id = (SELECT DB_ID('tempdb') )
ORDER  BY database_id



-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempDatabases WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @FileName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 
    -- Prepare SQL Statement
    SELECT @SQL = ' USE ['+ @DatabaseName +']  '+ 'DBCC SHRINKFILE (N'''+ @FileName +''' , 0)'


 --   -- You know what we do here if it's 1 then it'll give us code and 0 executes it
    IF @DryRun = 0
        BEGIN
            PRINT ( @DatabaseName )
            EXEC ( @SQL)
        END
    ELSE
        BEGIN
            PRINT ( @SQL )
        END
 --   -- Update table
    UPDATE  T
    SET IsProcessed = 1 --SELECT *
	FROM #TempDatabases T
    WHERE DatabaseName = @FileName
  END


