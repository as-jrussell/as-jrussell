/* DECLARE ALL variables at the top */
DECLARE @SQL VARCHAR(max)
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 
DECLARE @AccountRoot varchar(50) =''
DECLARE @DatabaseName SYSNAME
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
FROM   sys.databases
WHERE  name like 'PRL%'
ORDER  BY database_id
-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempDatabases WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 
    -- Prepare SQL Statement
    SELECT @SQL = '
 USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] FROM EXTERNAL PROVIDER WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english]
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END

USE [' + @DatabaseName + ']
  IF NOT EXISTS (SELECT 1 FROM sys.database_principals where name = '''+@AccountRoot+''')
BEGIN 
CREATE USER ['+@AccountRoot+'] FOR LOGIN ['+@AccountRoot+']
ALTER ROLE [db_datareader] ADD MEMBER ['+@AccountRoot+']
ALTER ROLE [db_datawriter] ADD MEMBER ['+@AccountRoot+']
GRANT EXECUTE TO ['+@AccountRoot+']
END 

'
    -- You know what we do here if it's 1 then it'll give us code and 0 executes it
    IF @DryRun = 0
        BEGIN
            PRINT ( @DatabaseName )
            EXEC ( @SQL)
        END
    ELSE
        BEGIN
            PRINT ( @SQL )
        END
    -- Update table
    UPDATE  #TempDatabases 
    SET IsProcessed = 1
    WHERE DatabaseName = @databaseName
  END