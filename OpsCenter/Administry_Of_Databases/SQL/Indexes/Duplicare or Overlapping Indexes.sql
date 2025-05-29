DECLARE @SQL VARCHAR(max)
DECLARE @DatabaseName SYSNAME =''
DECLARE @DBName SYSNAME =''
DECLARE @TableName VARCHAR(255) =''
DECLARE @DryRun INT = 0 --1 preview / 0 executes it 
DECLARE @Verbose INT =0 --1 preview / 0 executes it 
DECLARE @IsRDS INT

DECLARE @RDSsql NVARCHAR(MAX) = 'USE MSDB; SELECT @IsRDS = count(name) FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.rds_backup_database'') AND type in (N''P'', N''PC'')'

EXEC Sp_executesql
  @RDSsql,
  N'@IsRDS int out',
  @IsRDS OUT;

IF Object_id('tempdb..#DuplicateIndexes') IS NOT NULL
  DROP TABLE #DuplicateIndexes;

CREATE TABLE #DuplicateIndexes
  (
     DatabaseName        SYSNAME,
     schema_name         SYSNAME,
     TableName          SYSNAME,
     IndexName          SYSNAME,
     key_column_list     NVARCHAR(MAX),
     include_column_list NVARCHAR(MAX),
     is_disabled         BIT
  );

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
      SELECT @SQL = ' USE [' + @DatabaseName + ']

INSERT INTO #DuplicateIndexes
SELECT db_NAME(), 
    s.name AS schema_name,
    t.name AS table_name,
    i1.name AS index_name,
    key_cols.key_column_list,
    inc_cols.include_column_list,
    i1.is_disabled
FROM sys.schemas s
INNER JOIN sys.tables t ON s.schema_id = t.schema_id
INNER JOIN sys.indexes i1 ON t.object_id = i1.object_id
CROSS APPLY (
    SELECT STUFF((
        SELECT '', '' + c.name + '' '' + 
               CASE ic.is_descending_key WHEN 1 THEN ''DESC'' ELSE ''ASC'' END
        FROM sys.index_columns ic
        INNER JOIN sys.columns c 
            ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i1.object_id
          AND ic.index_id = i1.index_id
          AND ic.is_included_column = 0
        ORDER BY ic.key_ordinal
        FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)'')
    ,1,2,'''') AS key_column_list
) AS key_cols
CROSS APPLY (
    SELECT STUFF((
        SELECT '', '' + c.name
        FROM sys.index_columns ic
        INNER JOIN sys.columns c 
            ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i1.object_id
          AND ic.index_id = i1.index_id
          AND ic.is_included_column = 1
        ORDER BY ic.index_column_id
        FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)'')
    ,1,2,'''') AS include_column_list
) AS inc_cols
WHERE t.is_ms_shipped = 0
  AND i1.type_desc IN (''CLUSTERED'', ''NONCLUSTERED'')
  AND EXISTS (
    SELECT 1
    FROM sys.indexes i2
    CROSS APPLY (
        SELECT STUFF((
            SELECT '', '' + c.name + '' '' + 
                   CASE ic.is_descending_key WHEN 1 THEN ''DESC'' ELSE ''ASC'' END
            FROM sys.index_columns ic
            INNER JOIN sys.columns c 
                ON ic.object_id = c.object_id AND ic.column_id = c.column_id
            WHERE ic.object_id = i2.object_id
              AND ic.index_id = i2.index_id
              AND ic.is_included_column = 0
            ORDER BY ic.key_ordinal
            FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)'')
        ,1,2,'''') AS key_column_list
    ) AS k2
    CROSS APPLY (
        SELECT STUFF((
            SELECT '', '' + c.name
            FROM sys.index_columns ic
            INNER JOIN sys.columns c 
                ON ic.object_id = c.object_id AND ic.column_id = c.column_id
            WHERE ic.object_id = i2.object_id
              AND ic.index_id = i2.index_id
              AND ic.is_included_column = 1
            ORDER BY ic.index_column_id
            FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)'')
        ,1,2,'''') AS include_column_list
    ) AS inc2
    WHERE i2.object_id = i1.object_id
      AND i2.index_id <> i1.index_id
      AND k2.key_column_list = key_cols.key_column_list
      AND ISNULL(inc2.include_column_list, '''') = ISNULL(inc_cols.include_column_list, '''')
);';

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

IF @Verbose = 0
   AND @DryRun = 0
  BEGIN
      IF @DBName <> ''
         AND @TableName = ''
        BEGIN
            SELECT *
            FROM   #DuplicateIndexes
            WHERE  DatabaseName = @DBName
        END
      ELSE IF @TableName <> ''
         AND @DBName = ''
        BEGIN
            SELECT *
            FROM   #DuplicateIndexes
            WHERE  TableName = @TableName
        END
      ELSE IF @TableName <> ''
         AND @DBName <> ''
        BEGIN
            SELECT *
            FROM   #DuplicateIndexes
            WHERE  DatabaseName = @DBName
                   AND TableName = @TableName
        END
      ELSE
        BEGIN
            SELECT *
            FROM   #DuplicateIndexes
        END
  END 
