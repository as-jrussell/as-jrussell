DECLARE @SQL VARCHAR(max)
DECLARE @DatabaseName SYSNAME =''
DECLARE @DBName SYSNAME =''
DECLARE  @TableName    VARCHAR(255) =''
DECLARE @DryRun INT = 0 --1 preview / 0 executes it 
DECLARE @Verbose INT =0 --1 preview / 0 executes it 

    DECLARE @IsRDS INT

      DECLARE @RDSsql NVARCHAR(MAX) = 'USE MSDB; SELECT @IsRDS = count(name) FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.rds_backup_database'') AND type in (N''P'', N''PC'')'

      EXEC Sp_executesql
        @RDSsql,
        N'@IsRDS int out',
        @IsRDS OUT;



IF Object_id(N'tempdb..#HEAPs') IS NOT NULL
  DROP TABLE #HEAPs
CREATE TABLE #HEAPs (DatabaseName nvarchar(100), TableName nvarchar(max)
, user_seeks INT, user_scans INT, user_lookups INT, IndexType nvarchar(max)
, Row_Counts nvarchar(max))



      IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
        DROP TABLE #TempDatabases

      CREATE TABLE #TempDatabases
        (
           DatabaseName SYSNAME,
           IsProcessed  BIT
        )
/* IF( @IsRDS != 1 )
BEGIN
      -- Insert the databases to exclude into the temporary table
      INSERT INTO #TempDatabases
                  (DatabaseName,
                   IsProcessed)
SELECT name, 0 -- SELECT *
FROM   sys.databases
ORDER  BY database_id
END
ELSE 
BEGIN
      -- Insert the databases to exclude into the temporary table
      INSERT INTO #TempDatabases
                  (DatabaseName,
                   IsProcessed)
SELECT name, 0 -- SELECT *
FROM   sys.databases
WHERE database_id >= 6
ORDER  BY database_id
END
*/

IF( @IsRDS != 1 )
  BEGIN
      -- Insert the databases to exclude into the temporary table
      INSERT INTO #TempDatabases
                  (DatabaseName,
                   IsProcessed)
      SELECT name,
             0 -- SELECT *
      FROM   [DBA].[backup].[Schedule] S
             JOIN sys.databases D
               ON S.DatabaseName = D.name
      WHERE  state_desc = 'ONLINE' -- Only process online databases
             AND DatabaseType = 'USER'
  END
ELSE
  BEGIN
      -- Insert the databases to exclude into the temporary table
      INSERT INTO #TempDatabases
                  (DatabaseName,
                   IsProcessed)
      SELECT name,
             0 -- SELECT *
      FROM   [DBA].[backup].[Schedule] S
             JOIN sys.databases D
               ON S.DatabaseName = D.name
      WHERE  state_desc = 'ONLINE' -- Only process online databases
             AND DatabaseType = 'USER'
             AND database_id >= 6
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

INSERT INTO #HEAPs
  SELECT DB_NAME(),  TBL.name AS TableName,
 user_seeks, user_scans, user_lookups,  IDX.type_desc,
 SUM(sPTN.Rows) AS [RowCount]
  from sys.indexes IDX
  INNER JOIN sys.tables AS TBL ON TBL.object_id = IDX.object_id 
  INNER JOIN sys.schemas AS SCH ON TBL.schema_id = SCH.schema_id 
  INNER JOIN sys.dm_db_index_usage_stats ST on OBJECT_NAME(st.object_id) =tbl.name
  INNER JOIN sys.partitions AS sPTN     ON tbl.object_id = sPTN.object_id
  WHERE IDX.index_id = 0 AND
  user_seeks <> ''0''OR user_scans <> ''0''OR user_lookups  <> ''0''
GROUP BY 
      TBL.name,user_seeks, user_scans, user_lookups,  IDX.type_desc
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



IF @Verbose = 0 AND @DryRun =0
BEGIN 
IF @DBName <> '' AND @TableName = ''
BEGIN
  select * From #HEAPs
  WHERE DatabaseName = @DBName
END 
ELSE IF @TableName <> '' AND @DBName = '' 
BEGIN
SELECT * FROM #HEAPs
WHERE TableName = @TableName
END
ELSE IF @TableName <>'' AND @DBName <> '' 
BEGIN
SELECT * FROM #HEAPs
WHERE DatabaseName = @DBName AND TableName = @TableName
END
ELSE 
BEGIN
  select * From #HEAPs
END
  end 
