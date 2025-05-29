/* DECLARE ALL variables at the top */
DECLARE @sqlcmd VARCHAR(max)
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 
DECLARE @DatabaseName SYSNAME = 'Tfs_Configuration'
DECLARE @Date                DATETIME2 = CURRENT_TIMESTAMP,
        @path                NVARCHAR(max),
        @ServerName          VARCHAR(100),
        @S3bucketEnvironment NVARCHAR(3) = 'prd',
        @type                NVARCHAR(50) ='log'

SELECT @ServerName = SQLServerName
FROM   DBA.Info.Instance

IF @DatabaseName = '?'
   AND @type IN ( 'LOG', 'log' )
  BEGIN
      -- Create a temporary table to store the databases
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
                             + CONVERT(VARCHAR(23), @Date, 23) + '.trn'''

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
ELSE
  BEGIN
            SELECT @path = Concat(confvalue, '\', @ServerName, '\', @DatabaseName, '\LOG\')
            FROM   dba.info.databaseConfig
            WHERE  confkey = 'StorageGatewayPath'

WHILE EXISTS (SELECT 1 --LEFT(SUBSTRING(physical_device_name,LEN(physical_device_name) - CHARINDEX('\', REVERSE(physical_device_name)) + 2,LEN(physical_device_name)),LEN(physical_device_name) - CHARINDEX('.', REVERSE(physical_device_name)) + 1)
FROM     msdb.dbo.backupset bs INNER JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id WHERE bs.[type] = 'L'  AND bs.[database_name] = @DatabaseName) 
BEGIN 
DECLARE @count INT = 1;
    SET @count = @count + 1;

      SELECT @sqlcmd = '
BACKUP LOG [' + @DatabaseName + ']
TO DISK = '''
                       + @path + '' + @DatabaseName + '_migration_log_'
                       + CONVERT(VARCHAR(23), @Date, 23) +'_'+CAST(@Count AS VARCHAR(4)) +'.trn'''
END 
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
