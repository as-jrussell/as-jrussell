DECLARE @SQL VARCHAR(max)
DECLARE @username NVARCHAR(200)
DECLARE @DatabaseName SYSNAME
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 
DECLARE @Verbose INT =1 --1 preview / 0 executes it 

	EXEC DBA.[deploy].[CreateSQLAUTHUser] @AppName = 'UTRC', @FirstName = 'Nancy', @LastName = 'Yu', @DryRun = 1

IF Object_id(N'tempdb..#nosysadminusers') IS NOT NULL
  DROP TABLE #nosysadminusers

CREATE TABLE #nosysadminusers
  (
     username    NVARCHAR(200),
     IsProcessed BIT
  )

INSERT INTO #nosysadminusers
SELECT name,
       0 -- SELECT *
FROM   master.sys.server_principals
WHERE  name = 'UTRCdbNancy.Yu'

WHILE EXISTS(SELECT *
             FROM   #nosysadminusers
             WHERE  IsProcessed = 0)
  BEGIN
      -- Fetch 1 DatabaseName where IsProcessed = 0
      SELECT TOP 1 @username = username
      FROM   #nosysadminusers
      WHERE  IsProcessed = 0

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
      WHERE  databasetype = 'USER' AND DatabaseName != 'Perfstats'

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

						  IF EXISTS(SELECT *  FROM sys.database_permissions	where USER_NAME(grantee_principal_id)= ''db_executor'' AND type = ''EX'')
							BEGIN
								REVOKE EXECUTE TO [db_executor];
								GRANT VIEW DEFINITION TO [db_executor];
							END
								 ALTER ROLE [db_executor] ADD MEMBER [UTRCdbNancy.Yu];

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
      UPDATE #nosysadminusers
      SET    IsProcessed = 1
      WHERE  username = @username
  END 


IF @Verbose = 1
BEGIN 
  select username From #nosysadminusers
END