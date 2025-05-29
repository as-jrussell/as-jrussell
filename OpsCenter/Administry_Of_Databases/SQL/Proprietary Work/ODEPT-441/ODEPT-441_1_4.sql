/* DECLARE ALL variables at the top */
DECLARE @sqlcmd        VARCHAR(max),
        @Date          DATETIME2 = CURRENT_TIMESTAMP,
        @FormattedDate VARCHAR(40),
        @path          NVARCHAR(max),
        @ServerName    VARCHAR(100),
        @DatabaseName  SYSNAME = 'DBA',
        @type          NVARCHAR(50) ='full',
        @DryRun        INT = 1 --1 preview / 0 executes it 
SET @FormattedDate = Replace(Replace(Replace(CONVERT(VARCHAR(40), @Date, 121), '-', '_'), ' ', '_'), ':', '')

SELECT @ServerName = SQLServerName
FROM   DBA.Info.Instance

IF @DatabaseName = '?'
  BEGIN
      -- Create a temporary table to store the databases
      IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
        DROP TABLE #TempDatabases

      CREATE TABLE #TempDatabases
        (
           DatabaseName SYSNAME,
           IsProcessed  BIT
        )

      IF @type IN ( 'LOG', 'log' )
        BEGIN
            -- Insert the databases to exclude into the temporary table
            INSERT INTO #TempDatabases
                        (DatabaseName,
                         IsProcessed)
            SELECT name,
                   0 -- SELECT *
            FROM   sys.databases
            WHERE  recovery_model_desc != 'SIMPLE'

            -- Loop through the remaining databases
            WHILE EXISTS(SELECT *
                         FROM   #TempDatabases
                         WHERE  IsProcessed = 0)
              BEGIN
                  -- Fetch 1 DatabaseName where IsProcessed = 0
                  SELECT TOP 1 @DatabaseName = DatabaseName
                  FROM   #TempDatabases
                  WHERE  IsProcessed = 0

                  SELECT @path = Concat(confvalue, '\', @ServerName, '\', @DatabaseName, '\LOG\')
                  FROM   dba.info.databaseConfig
                  WHERE  confkey = 'StorageGatewayPath'

                  -- Prepare SQL Statement
                  SELECT @sqlcmd = '
BACKUP LOG [' + @DatabaseName + ']
TO DISK = '''
                                   + @path + '' + @DatabaseName + '_migration_log_'
                                   + CONVERT(VARCHAR(40), @FormattedDate)
                                   + '.trn'''

                  ---- You know what we do here if it's 1 then it'll give us code and 0 executes it
                  IF @DryRun = 0
                    BEGIN
                        PRINT ( @DatabaseName )

                        EXEC ( @sqlcmd)
                    END
                  ELSE
                    BEGIN
                        PRINT ( @sqlcmd )
                    END

                  -- Update table
                  UPDATE #TempDatabases
                  SET    IsProcessed = 1
                  WHERE  DatabaseName = @databaseName
              END
        END
      ELSE IF @type IN ( 'FULL', 'full' )
        BEGIN
            -- Insert the databases to exclude into the temporary table
            INSERT INTO #TempDatabases
                        (DatabaseName,
                         IsProcessed)
            SELECT name,
                   0 -- SELECT *
            FROM   sys.databases
            WHERE  NAME != 'tempdb'

            -- Loop through the remaining databases
            WHILE EXISTS(SELECT *
                         FROM   #TempDatabases
                         WHERE  IsProcessed = 0)
              BEGIN
                  -- Fetch 1 DatabaseName where IsProcessed = 0
                  SELECT TOP 1 @DatabaseName = DatabaseName
                  FROM   #TempDatabases
                  WHERE  IsProcessed = 0

                  SELECT @path = Concat(confvalue, '\', @ServerName, '\', @DatabaseName, '\FULL\')
                  FROM   dba.info.databaseConfig
                  WHERE  confkey = 'StorageGatewayPath'

                  IF EXISTS (SELECT 1
                             FROM   [DBA].[INFO].[Database]
                             WHERE  DatabaseName = @DatabaseName
                                    AND DataConsumedSizeMB >= '700000')
                    BEGIN
                        SELECT @sqlcmd = '
  BACKUP DATABASE [' + @DatabaseName
                                         + '] TO
DISK = ''' + @path + '' + @DatabaseName
                                         + '_migration_full_'
                                         + CONVERT(VARCHAR(23), @Date, 23) + '_1.bak'',
DISK = '''
                                         + @path + '' + @DatabaseName + '_migration_full_'
                                         + CONVERT(VARCHAR(23), @Date, 23) + '_2.bak'',
DISK = '''
                                         + @path + '' + @DatabaseName + '_migration_full_'
                                         + CONVERT(VARCHAR(23), @Date, 23) + '_3.bak'',
DISK = '''
                                         + @path + '' + @DatabaseName + '_migration_full_'
                                         + CONVERT(VARCHAR(23), @Date, 23) + '_4.bak'',
DISK = '''
                                         + @path + '' + @DatabaseName + '_migration_full_'
                                         + CONVERT(VARCHAR(23), @Date, 23) + '_5.bak'',
DISK = '''
                                         + @path + '' + @DatabaseName + '_migration_full_'
                                         + CONVERT(VARCHAR(23), @Date, 23) + '_6.bak'',
DISK = '''
                                         + @path + '' + @DatabaseName + '_migration_full_'
                                         + CONVERT(VARCHAR(23), @Date, 23) + '_7.bak'',
DISK = '''
                                         + @path + '' + @DatabaseName + '_migration_full_'
                                         + CONVERT(VARCHAR(23), @Date, 23)
                                         + '_8.bak''

WITH INIT , NOUNLOAD , NAME = '''
                                         + @DatabaseName
                                         + '_Backup, NOSKIP , STATS = 10, COMPRESSION, NOFORMAT'''
                    END
                  ELSE
                    BEGIN
                        SELECT @sqlcmd = '
  BACKUP DATABASE [' + @DatabaseName
                                         + '] TO
DISK = ''' + @path + '' + @DatabaseName
                                         + '_migration_full_'
                                         + CONVERT(VARCHAR(23), @Date, 23)
                                         + '.bak''
				   
WITH INIT , NOUNLOAD , NAME = '''
                                         + @DatabaseName
                                         + '_FULL, NOSKIP , STATS = 10, COMPRESSION, NOFORMAT'''
                    END

                  -- You know what we do here if it's 1 then it'll give us code and 0 executes it
                  IF @DryRun = 0
                    BEGIN
                        PRINT ( @DatabaseName )

                        EXEC ( @sqlcmd)
                    END
                  ELSE
                    BEGIN
                        PRINT ( @sqlcmd )
                    END

                  -- Update table
                  UPDATE #TempDatabases
                  SET    IsProcessed = 1
                  WHERE  DatabaseName = @databaseName
              END
        END
  END
ELSE
  BEGIN
      IF @type IN ( 'LOG', 'log' )
        BEGIN
            SELECT @path = Concat(confvalue, '\', @ServerName, '\', @DatabaseName, '\LOG\')
            FROM   dba.info.databaseConfig
            WHERE  confkey = 'StorageGatewayPath'

            SELECT @sqlcmd = '
BACKUP LOG [' + @DatabaseName + ']
TO DISK = '''
                             + @path + '' + @DatabaseName + '_migration_log_'
                             + CONVERT(VARCHAR(40), @FormattedDate)
                             + '.trn'''
        END
      ELSE
        BEGIN
            SELECT @path = Concat(confvalue, '\', @ServerName, '\', @DatabaseName, '\FULL\')
            FROM   dba.info.databaseConfig
            WHERE  confkey = 'StorageGatewayPath'

            SELECT @sqlcmd = '
  BACKUP DATABASE [' + @DatabaseName
                             + '] TO
DISK = ''' + @path + '' + @DatabaseName
                             + '_migration_full_'
                             + CONVERT(VARCHAR(23), @Date, 23)
                             + '.bak''
				   
WITH INIT , NOUNLOAD , NAME = '''
                             + @DatabaseName
                             + '_FULL, NOSKIP , STATS = 10, COMPRESSION, NOFORMAT'''
        END

      IF @DryRun = 0
        BEGIN
            PRINT ( @DatabaseName )

            EXEC ( @sqlcmd)
        END
      ELSE
        BEGIN
            PRINT ( @sqlcmd )
        END
  END 
