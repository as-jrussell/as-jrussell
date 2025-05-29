DECLARE @SQL VARCHAR(max)
DECLARE @WhatIf INT = 1 --1 preview / 0 executes it 
DECLARE @account varchar(50) ='enter_username_here'


-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases

CREATE TABLE #TempDatabases
  (
     DatabaseName SYSNAME
  )

-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases
            (DatabaseName)
SELECT name
FROM   sys.databases
WHERE  database_id > 5
and name not in ('Perfstats', 'HDTStorage')
ORDER  BY database_id

-- Declare variables
DECLARE @DatabaseName SYSNAME

-- Initialize variables
SELECT @DatabaseName = Min(DatabaseName)
FROM   #TempDatabases

-- Loop through the remaining databases
WHILE @DatabaseName IS NOT NULL
  BEGIN
      SELECT @SQL = '
USE [' + @DatabaseName + ']
  IF NOT EXISTS (SELECT 1 FROM sys.database_principals where name = '''+@account+''')
BEGIN 
DROP USER ['+@account+'] 
END 
		PRINT ''SUCCESS: '''+@account+'''Dropped from '''+@DatabaseName+''' database ''
'

      -- Get the next database name
      SELECT @DatabaseName = Min(DatabaseName)
      FROM   #TempDatabases
      WHERE  DatabaseName > @DatabaseName

-- You know what we do here if it's 1 then it'll give us code and 0 executes it
	  IF @WhatIf = 0
        BEGIN
            PRINT ( @DatabaseName )

            EXEC ( @SQL)
        END
      ELSE
        BEGIN
            PRINT ( @SQL )
        END
  END

