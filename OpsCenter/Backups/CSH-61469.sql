DECLARE @SQL VARCHAR(max)
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 

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
SELECT name--,*
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
      SELECT @SQL = ' USE [' +@DatabaseName+']
IF (
          EXISTS(select top 1 1 from sys.objects where name = ''LOAN'')
        AND    (
                    DB  _NAME() = ''PRL_COMMERCE_2989_PROD''
            )
    )
BEGIN 
    IF (EXISTS(select top 1 1 from proceed where id > 0 and purge_dt is not null))
        BEGIN
            SELECT database_id, [name] from sys.databases where [name] = DB_NAME()

 

            select top 1  id, product_id, reference_number, amount, check_received_dt, check_issue_dt, delivery_type_cd, amount, REMITTANCE_DT FROM PROCEED
        END
END 
'

      -- Get the next database name
      SELECT @DatabaseName = Min(DatabaseName)
      FROM   #TempDatabases
      WHERE  DatabaseName > @DatabaseName

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
  END

