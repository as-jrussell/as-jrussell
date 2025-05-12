DECLARE @SQLcmd VARCHAR(MAX)
DECLARE @data VARCHAR(MAX)
DECLARE @DatabaseName SYSNAME  
DECLARE @logicalname NVARCHAR(50) 
DECLARE @TYPE NVARCHAR(10) = 'log' --rows (databases) , log (logs) 
DECLARE @DryRun INT = 0


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
WHERE database_id = 2
ORDER BY database_id



-- Loop through the remaining databases
WHILE EXISTS (SELECT * FROM #TempDatabases WHERE IsProcessed = 0)
BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT TOP 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 

	select @logicalname = name from sys.master_files
where DB_NAME(database_id) = @DatabaseName
AND type_desc = @TYPE

SELECT @SQLcmd ='
USE ['+ @DatabaseName +']  '+ 'DBCC SHRINKFILE (N'''+ @logicalname +''' , 0)'

 


    -- Perform DryRun or Execution based on @DryRun value
    IF @DryRun = 0
    BEGIN
        EXEC (@sqlcmd)
		PRINT (@DatabaseName)
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
/*
---Setting a database to SIMPLE
select name,  CONCAT('USE MASTER',' ','ALTER DATABASE',' ',Name,' ', 'SET RECOVERY SIMPLE WITH NO_WAIT')
FROM sys.database_files
where type_desc = 'ROWS'


---Setting a database to FULL
select name,  CONCAT('USE MASTER',' ','ALTER DATABASE',' ',Name,' ', 'SET RECOVERY FULL WITH NO_WAIT')
FROM sys.database_files
where type_desc = 'ROWS'


select CONCAT('Exec [DBA].[backup].[BackupDatabase]
	@BackupLevel = ''FULL'',
	@SQLDatabaseName = ''',name,''',@DryRun = 0')
FROM sys.databases

select CONCAT('Exec [DBA].[backup].[BackupDatabase]
	@BackupLevel = ''LOG'',
	@SQLDatabaseName = ''',name,''',@DryRun = 0')
FROM sys.databases

*/



