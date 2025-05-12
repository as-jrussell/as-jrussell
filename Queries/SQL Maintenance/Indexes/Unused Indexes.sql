DECLARE @SQL VARCHAR(max)
DECLARE @DatabaseName SYSNAME 
DECLARE @DBName SYSNAME =''
DECLARE  @TableName    VARCHAR(255) =''
DECLARE	@IndexName  VARCHAR(255) =''
DECLARE @DryRun INT = 0 --1 preview / 0 executes it 
DECLARE @Verbose INT =0 --1 preview / 0 executes it 
    DECLARE @IsRDS INT
      /*
      ######################################################################
      Is this an RDS instance ?
      ######################################################################
      */
      DECLARE @RDSsql NVARCHAR(MAX) = 'USE MSDB; SELECT @IsRDS = count(name) FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.rds_backup_database'') AND type in (N''P'', N''PC'')'

      EXEC Sp_executesql
        @RDSsql,
        N'@IsRDS int out',
        @IsRDS OUT;


IF OBJECT_ID(N'tempdb..#UselessIndexes') IS NOT NULL
DROP TABLE #UselessIndexes

CREATE TABLE #UselessIndexes ([ServerName] varchar(100), [DatabaseName] varchar(100),[TableName] varchar(100), [IndexName] varchar(100) , [UserSeek] varchar(100) , [UserScans] varchar(100), [UserLookups] varchar(100), [UserUpdates] varchar(100) , [TableRows] varchar(100), [drop statement] varchar(max))


      IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
        DROP TABLE #TempDatabases

      CREATE TABLE #TempDatabases
        (
           DatabaseName SYSNAME,
           IsProcessed  BIT
        )

IF( @IsRDS != 1 )
BEGIN
      -- Insert the databases to exclude into the temporary table
      INSERT INTO #TempDatabases
                  (DatabaseName,
                   IsProcessed)
SELECT name, 0 -- SELECT *
      FROM   [DBA].[backup].[Schedule]  S
	  join sys.databases D on S.DatabaseName = D.name
	  WHERE state_desc = 'ONLINE' -- Only process online databases
AND DatabaseType = 'USER'
END
ELSE 
BEGIN
      -- Insert the databases to exclude into the temporary table
      INSERT INTO #TempDatabases
                  (DatabaseName,
                   IsProcessed)
SELECT name, 0 -- SELECT *
   FROM   [DBA].[backup].[Schedule]  S
	  join sys.databases D on S.DatabaseName = D.name
	  WHERE state_desc = 'ONLINE' -- Only process online databases
AND DatabaseType = 'USER'AND database_id >= 6
ORDER  BY database_id
END

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
SELECT @SQL = ' USE [' + @DatabaseName
                 + ']


INSERT INTO #UselessIndexes
SELECT  (SELECT TOP 1 SQLSERVERNAME FROM DBA.INFO.Instance ORDER BY HARVESTDATE DESC) [ServerName],
DB_NAME() [Database Name],
o.name AS ObjectName
, i.name AS IndexName
, dm_ius.user_seeks AS UserSeek
, dm_ius.user_scans AS UserScans
, dm_ius.user_lookups AS UserLookups
, dm_ius.user_updates AS UserUpdates
, p.TableRows
, ''DROP INDEX '' + QUOTENAME(i.name)
+ '' ON '' + QUOTENAME(s.name) + ''.'' + QUOTENAME(OBJECT_NAME(dm_ius.object_id)) as ''drop statement''
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id AND dm_ius.object_id = i.object_id
INNER JOIN sys.objects o on dm_ius.object_id = o.object_id
INNER JOIN sys.schemas s on o.schema_id = s.schema_id
INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.object_id
FROM sys.partitions p GROUP BY p.index_id, p.object_id) p
ON p.index_id = dm_ius.index_id AND dm_ius.object_id = p.object_id
WHERE OBJECTPROPERTY(dm_ius.object_id,''IsUserTable'') = 1
AND dm_ius.database_id = DB_ID()
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
AND dm_ius.user_seeks = 0
AND dm_ius.user_scans = 0
AND dm_ius.user_lookups = 0
AND o.name NOT LIKE ''MS%''
AND DB_NAME() NOT IN (''msdb'', ''master'', ''tempdb'', ''model'', ''HDTStorage'', ''DBA'', ''Perfstats'')
ORDER BY p.TableRows DESC'



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




IF @Verbose = 0 AND @DryRun =0
BEGIN 
IF @DBName <> '' AND @TableName = ''
BEGIN
  select * From #UselessIndexes
  WHERE DatabaseName = @DBName
END 
ELSE IF @TableName <> '' AND @DBName = '' 
BEGIN
SELECT * FROM #UselessIndexes
WHERE TableName = @TableName
END
ELSE IF @TableName <>'' AND @DBName <> '' 
BEGIN
SELECT * FROM #UselessIndexes
WHERE DatabaseName = @DBName AND TableName = @TableName
END
ELSE 
BEGIN
  select * From #UselessIndexes
END
  end 
