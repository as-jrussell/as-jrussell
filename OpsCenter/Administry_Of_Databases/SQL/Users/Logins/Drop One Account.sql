DECLARE @DatabaseName nvarchar(100)
DECLARE @Acct nvarchar(100) = 'ELDREDGE_A\svc_lidl_dev01'
DECLARE @sqlcmd nvarchar(MAX)
DECLARE @DryRun INT = 1

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
ORDER  BY database_id

-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempDatabases WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0  

   SELECT @sqlcmd = 'USE '+ @DatabaseName +';


		IF EXISTS (select * from sys.database_principals where name ='''+@Acct+''')
		BEGIN 
		DROP USER ['+@Acct+']
		END



		IF EXISTS (select * from sys.server_principals where name ='''+@Acct+''')
		BEGIN 
		DROP LOGIN ['+@Acct+']
		END'




IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)

  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )

  END 

    -- Update table
    UPDATE  #TempDatabases 
    SET IsProcessed = 1
    WHERE DatabaseName = @databaseName


  END

  




