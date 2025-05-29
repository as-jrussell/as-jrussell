DECLARE @SQL VARCHAR(max)
DECLARE @username NVARCHAR(200)
DECLARE @DatabaseName SYSNAME
DECLARE @DryRun INT = 0 --1 preview / 0 executes it 
DECLARE @Verbose INT =1 --1 preview / 0 executes it 


IF Object_id(N'tempdb..#nosysadminusers') IS NOT NULL
  DROP TABLE #nosysadminusers

CREATE TABLE #nosysadminusers
  ( DATABASE_NAME SYSNAME,
     name    NVARCHAR(200),
	 type_desc  NVARCHAR(200),
     create_date date
  )

/* 
-- In a world the DBA maintenance tables doesn't exist this can be used. 
INSERT INTO #TempDatabases (DatabaseName, IsProcessed)
SELECT name, 0 -- SELECT *
FROM   sys.databases
ORDER  BY database_id
*/


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
      SELECT DatabaseName,
             0 -- SELECT *
      FROM   [DBA].[backup].[Schedule]  S
	  join sys.databases D on S.DatabaseName = D.name
	  WHERE DatabaseType = 'USER' AND D.name NOT IN ('PerfStats')

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
USE [' + @DatabaseName
                          + ']
INSERT INTO #nosysadminusers
 select db_name(), name, type_desc, CREATE_DATE  from sys.objects
 where Cast(create_date AS DATE) >= Cast(Getdate()-30 AS DATE)
 and type in (''P'', ''U'')

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
            UPDATE #TempDatabases
            SET    IsProcessed = 1
            WHERE  DatabaseName = @databaseName
        END

      -- Update table



IF @Verbose = 1
BEGIN 
  select * From #nosysadminusers
END