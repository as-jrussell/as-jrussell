DECLARE @DatabaseName VARCHAR(100) ='Syslog',
        @TableName    VARCHAR(255) ='Syslog',
        @sqlcmd       VARCHAR(max),
        @DryRun       INT = 0

SELECT @sqlcmd = ' USE ' + @DatabaseName
                 + '
SELECT t.create_date,
       t.modify_date,
       Schema_name(t.schema_id) + ''.'' + t.[name]         AS table_view,
       CASE
         WHEN t.[type] = ''U'' THEN ''Table''
         WHEN t.[type] = ''V'' THEN ''View''
       END                                               AS [object_type],
	   
	   CASE WHEN is_disabled = 0 THEN ''Enabled''
	   ELSE ''Disabled''end AS [Index Enabled/Disabled] ,
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
       END                                               AS [unique]
FROM   sys.objects t
       INNER JOIN sys.indexes i
               ON t.object_id = i.object_id
       CROSS apply (SELECT col.[name] + '', ''
                    FROM   sys.index_columns ic
                           INNER JOIN sys.columns col
                                   ON ic.object_id = col.object_id
                                      AND ic.column_id = col.column_id
                    WHERE  ic.object_id = t.object_id
                           AND ic.index_id = i.index_id
                    ORDER  BY key_ordinal
                    FOR xml path ('''')) D (column_names)
WHERE  t.is_ms_shipped <> 1
   --    AND t.[name] like ''%'
                 + @TableName + '%''
	   AND t.[name] IN ('''
                 + @TableName + ''')
       AND index_id > 0
ORDER  BY i.[name] '
IF @DatabaseName  ='?'
BEGIN 
IF @DryRun = 0
  BEGIN
  
		exec sp_MSforeachdb @sqlcmd 
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd + '
	  
	  exec sp_MSforeachdb @sqlcmd' )
  END
  END 
  ELSE 
  BEGIN 
IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
		
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd + '
	  
	  exec @sqlcmd')
  END

  END



