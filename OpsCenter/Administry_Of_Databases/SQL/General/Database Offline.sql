DECLARE @SQL VARCHAR(1000)
DECLARE @DatabaseName SYSNAME
DECLARE @DBName NVARCHAR(10) = ''
DECLARE @DryRun BIT = 1 --1 preview / 0 executes it 
DECLARE @Revert BIT = 1 -- 0 reverts back ONLINE
IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases

CREATE TABLE #TempDatabases
  (
     DatabaseName SYSNAME,
     IsProcessed  BIT
  )

IF @DBName IS NULL
    OR @DBName = ''
  BEGIN
      INSERT INTO #TempDatabases
                  (DatabaseName,
                   IsProcessed)
      SELECT DatabaseName,
             0 -- SELECT *
      FROM   [DBA].[backup].[Schedule] S
             LEFT JOIN sys.databases D
                    ON S.DatabaseName = D.name
      WHERE  state_desc = ( CASE
                              WHEN @Revert = 0 THEN 'OFFLINE'
                              ELSE 'ONLINE'
                            END )
             AND DatabaseType = 'USER'  
  END
ELSE
  BEGIN
      INSERT INTO #TempDatabases
                  (DatabaseName,
                   IsProcessed)
      SELECT DatabaseName,
             0 -- SELECT *
      FROM   [DBA].[backup].[Schedule] S
             LEFT JOIN sys.databases D
                    ON S.DatabaseName = D.name
      WHERE  state_desc = ( CASE
                              WHEN @Revert = 0 THEN 'OFFLINE'
                              ELSE 'ONLINE'
                            END )
             AND DatabaseName = @DBName
  END

WHILE EXISTS(SELECT *
             FROM   #TempDatabases
             WHERE  IsProcessed = 0)
  BEGIN
      SELECT TOP 1 @DatabaseName = DatabaseName
      FROM   #TempDatabases
      WHERE  IsProcessed = 0

      IF @Revert = 0
        BEGIN
            SELECT @SQL = '
USE [master]

IF NOT EXISTS(select * from sys.databases where name = '''
                          + @DatabaseName + ''' AND state_desc = ''ONLINE'')
BEGIN
 ALTER DATABASE ['
                          + @DatabaseName + '] ' + 'SET ONLINE
 END
'
        END
      ELSE
        BEGIN
            SELECT @SQL = '
USE [master]

IF EXISTS(select * from sys.databases where name = '''
                          + @DatabaseName + ''' AND state_desc = ''ONLINE'')
BEGIN
 ALTER DATABASE ['
                          + @DatabaseName + '] ' + 'SET OFFLINE
 END
'
        END

      IF @DryRun = 0
        BEGIN
            PRINT ( @DatabaseName )

            EXEC ( @SQL)
        END
      ELSE
        BEGIN
            PRINT ( @SQL )
        END

      UPDATE #TempDatabases
      SET    IsProcessed = 1
      WHERE  DatabaseName = @databaseName
  END 
