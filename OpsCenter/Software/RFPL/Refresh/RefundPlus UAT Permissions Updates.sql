/* DECLARE ALL variables at the top */
DECLARE @SQL VARCHAR(max)
DECLARE @DryRun INT = 0 --1 preview / 0 executes it 
DECLARE @account1 varchar(50) ='RFPLdbWebApp-UAT'
DECLARE @account2 varchar(50) ='RFPLdbWinSvcs-UAT'
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
WHERE  name like 'PRL%UAT'
ORDER  BY database_id
-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempDatabases WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 
    -- Prepare SQL Statement
    SELECT @SQL = '
USE [' + @DatabaseName + ']
  IF NOT EXISTS (SELECT 1 FROM sys.database_principals where name = '''+@account1+''')
BEGIN 
CREATE USER ['+@account1+'] FOR LOGIN ['+@account1+']
ALTER ROLE [db_datareader] ADD MEMBER ['+@account1+']
ALTER ROLE [db_datawriter] ADD MEMBER ['+@account1+']
GRANT EXECUTE TO ['+@account1+']
END 

IF NOT EXISTS (SELECT 1 FROM sys.database_principals where name = '''+@account2+''')
BEGIN 
CREATE USER ['+@account2+'] FOR LOGIN ['+@account2+']
ALTER ROLE [db_datareader] ADD MEMBER ['+@account2+']
ALTER ROLE [db_datawriter] ADD MEMBER ['+@account2+']
GRANT EXECUTE TO ['+@account2+']
END 

IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''EccdbAppIntegrationPROD'')
BEGIN 
DROP USER [EccdbAppIntegrationPROD] 
END

IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''RFPLdbDeployer-Production'')
BEGIN 
DROP USER [RFPLdbDeployer-Production] 
END

IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''RFPLdbWebApp-Prod'')
BEGIN 
DROP USER [RFPLdbWebApp-Prod] 
END

IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''RFPLdbWinSvcs-Prod'')
BEGIN 
DROP USER [RFPLdbWinSvcs-Prod] 
END


IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''SVC_DTST_PRD01'')
BEGIN 
DROP USER [SVC_DTST_PRD01] 
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