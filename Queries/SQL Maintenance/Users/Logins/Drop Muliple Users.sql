DECLARE @SQL VARCHAR(max)
DECLARE @username NVARCHAR(200)
DECLARE @DatabaseName SYSNAME
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 
DECLARE @Verbose INT =1 --1 preview / 0 executes it 

IF Object_id(N'tempdb..#accountsdrop') IS NOT NULL
  DROP TABLE #accountsdrop

CREATE TABLE #accountsdrop
  (
     username    NVARCHAR(200),
     IsProcessed BIT
  )

INSERT INTO #accountsdrop
SELECT name,
       0 -- SELECT *
FROM   master.sys.server_principals   --define your accounts that you want dropped
WHERE  name in ('ELDREDGE_A\SQL_UniTracArchive_ReadOnly',
'ELDREDGE_A\SQL_DataStore_ReadOnly',
'ELDREDGE_A\SQL_IQQ_ReadOnly',
'ELDREDGE_A\SQL_CenterPoint_Development_Team',
'ELDREDGE_A\SQL_Unitrac_SSIS',
'ELDREDGE_A\SQL_BOND_ReadOnly',
'ELDREDGE_A\SQL_UniTrac_ReadOnly',
'ELDREDGE_A\SQL_IVOS_ReadOnly',
'ELDREDGE_A\SQL_RFPL_ReadOnly',
'ELDREDGE_A\SQL_INFR_ReadOnly',
'ELDREDGE_A\SQL_SURF_ReadOnly',
'ELDREDGE_A\SQL_IDCO_ReadOnly')



WHILE EXISTS(SELECT *
             FROM   #accountsdrop
             WHERE  IsProcessed = 0)
  BEGIN
      -- Fetch 1 DatabaseName where IsProcessed = 0
      SELECT TOP 1 @username = username
      FROM   #accountsdrop
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
      WHERE  databasetype = 'USER'

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
  IF NOT EXISTS (SELECT 1 FROM sys.database_principals where name = '''
                          + @username + ''')
BEGIN 
ALTER ROLE [db_datareader] DROP MEMBER ['
                          + @username
                          + ']

DROP USER [' + @username
                          + ']

END 

USE [MASTER] 
DROP LOGIN ['
                          + @username + '] 
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
      UPDATE #accountsdrop
      SET    IsProcessed = 1
      WHERE  username = @username
  END 


IF @Verbose = 1
BEGIN 
  select username From #accountsdrop
END