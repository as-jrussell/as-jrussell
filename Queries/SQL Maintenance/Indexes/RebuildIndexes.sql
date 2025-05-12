DECLARE @SQL VARCHAR(max)
DECLARE @DatabaseName SYSNAME =''; --cannot be null
DECLARE  @TableName    VARCHAR(255) ='' --to get exact table 
DECLARE @Table NVARCHAR(1) = '' --to get exact table 
DECLARE @DryRun INT = 0 --1 preview / 0 executes it 


SELECT @SQL = ' USE [' + @DatabaseName
                 + ']

SELECT
    t.create_date,
    t.modify_date,
    Schema_name(t.schema_id) + ''.'' + t.[name]         AS table_view,
    CASE
        WHEN t.[type] = ''U'' THEN ''Table''
        WHEN t.[type] = ''V'' THEN ''View''
    END                                               AS [object_type],
    CASE
        WHEN i.is_disabled = 0 THEN ''Enabled''
        ELSE ''Disabled''
    END                                               AS [Index_Enabled_Disabled],
    i.[name]                                          AS index_name,
    Substring(column_names, 1, Len(column_names) - 1) AS [columns],
    CASE
        WHEN i.[type] = 1 THEN ''Clustered index''
        WHEN i.[type] = 2 THEN ''Nonclustered unique index''
        WHEN i.[type] = 3 THEN ''XML index''
        WHEN i.[type] = 4 THEN ''Spatial index''
        WHEN i.[type] = 5 THEN ''Clustered columnstore index''
        WHEN i.[type] = 6 THEN ''Nonclustered columnstore index''
        WHEN i.[type] = 7 THEN ''Nonclustered hash index''
    END                                               AS index_type,
    CASE
        WHEN i.is_unique = 1 THEN ''Unique''
        ELSE ''Not unique''
    END                                               AS [unique],
   ''CREATE '' COLLATE DATABASE_DEFAULT +
CASE WHEN i.is_unique = 1 THEN ''UNIQUE '' COLLATE DATABASE_DEFAULT ELSE '''' END +
i.type_desc COLLATE DATABASE_DEFAULT + '' INDEX ['' +
i.name COLLATE DATABASE_DEFAULT + ''] ON ['' +
Schema_name(t.schema_id) COLLATE DATABASE_DEFAULT + ''].['' +
t.name COLLATE DATABASE_DEFAULT + ''] ('' +
Substring(column_names, 1, Len(column_names) - 1) COLLATE DATABASE_DEFAULT + '');'' AS create_index_script

FROM sys.objects t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
CROSS APPLY (
    SELECT
        col.[name] COLLATE DATABASE_DEFAULT +
        CASE WHEN ic.is_descending_key = 1 THEN '' DESC'' ELSE '' ASC'' END COLLATE DATABASE_DEFAULT +
        '', '' COLLATE DATABASE_DEFAULT
    FROM sys.index_columns ic
    INNER JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
    WHERE ic.object_id = t.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0
    ORDER BY ic.key_ordinal
    FOR XML PATH('''')
) D (column_names)
';

IF @DryRun = 0
BEGIN 
IF @Table = 'Y'
BEGIN 
 EXEC (@SQL + ' WHERE   i.[name] IS NOT NULL AND   t.is_ms_shipped <> 1 AND t.[name] IN (''' + @TableName + ''')')
END 
ELSE
BEGIN 
 EXEC  (@SQL + ' WHERE i.[name] IS NOT NULL AND  t.is_ms_shipped <> 1')
END 
END 
ELSE 
IF @Table = 'Y'
BEGIN 
 PRINT (@SQL + ' WHERE  i.[name] IS NOT NULL AND  t.is_ms_shipped <> 1 AND t.[name] IN (''' + @TableName + ''')')
END 
ELSE
BEGIN 
 PRINT (@SQL + ' WHERE i.[name] IS NOT NULL AND   t.is_ms_shipped <> 1')
END 
