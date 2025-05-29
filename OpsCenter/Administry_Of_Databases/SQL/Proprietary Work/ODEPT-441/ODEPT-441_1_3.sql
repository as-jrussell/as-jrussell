/* DECLARE ALL variables at the top */
DECLARE @sqlcmd VARCHAR(max)
DECLARE @DryRun INT = 1 --1 preview / 0 executes it 
DECLARE @DatabaseName SYSNAME = '?'
DECLARE @Date                DATETIME2 = CURRENT_TIMESTAMP,
@FormattedDate VARCHAR(40),
        @path                NVARCHAR(max),
        @ServerName          VARCHAR(100),
        @type                NVARCHAR(50) ='LOG'


SET @FormattedDate = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(40), @Date, 121), '-', ''), ' ', ''), ':', '')

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
                             + CONVERT(VARCHAR(40),@FormattedDate) + '.trn'''

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



      SELECT @sqlcmd = '
BACKUP LOG [' + @DatabaseName + ']
TO DISK = '''
                       + @path + '' + @DatabaseName + '_migration_log_'
                       +  CONVERT(VARCHAR(40),@FormattedDate) +'.trn'''

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
   
