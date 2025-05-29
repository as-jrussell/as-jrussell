DECLARE @sqluser VARCHAR(2000)
DECLARE @sqlcmd VARCHAR(2000)
DECLARE @AppRole VARCHAR(100) = ''
DECLARE @AccountRoot VARCHAR(100) =  ''
DECLARE @DryRun INT = 0
DECLARE @DatabaseName SYSNAME




IF @AppRole IS NULL OR @AppRole = ''
BEGIN
select @AccountRoot = CASE WHEN ServerEnvironment = 'TST' THEN 'ELDREDGE_A\svc_PIMS_TST01'
WHEN ServerEnvironment = 'STG' THEN 'ELDREDGE_A\svc_PIMS_STG01'
WHEN ServerEnvironment = 'PRD' THEN 'ELDREDGE_A\svc_PIMS_PRD01'
ELSE 'ELDREDGE_A\svc_PIMS_DEV01'
END 
FROM DBA.INFO.INSTANCE
END




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
WHERE  name IN ('RepoPlusAnalytics','PremAcc3')
ORDER  BY database_id
-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempDatabases WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 



select @sqluser ='
USE ['+ @DatabaseName +']
IF EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN


		DROP USER ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER DROPPED CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER NOT DROPPED !!!!''
END


 USE [master]
 IF EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		DROP LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: LOGIN DROPPED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: LOGIN NOT DROPPED !!!!''
	
END'







    -- You know what we do here if it's 1 then it'll give us code and 0 executes it

IF @DryRun = 0
  BEGIN
	  EXEC ( @sqluser)

  END
ELSE
  BEGIN

	  PRINT ( @sqluser )

  END 

    -- Update table
    UPDATE  #TempDatabases 
    SET IsProcessed = 1
    WHERE DatabaseName = @databaseName


  END

  