DECLARE @DatabaseName VARCHAR(100) ='UniTracArchive',
        @TableName    VARCHAR(255) ='INTERACTION_HISTORY',
        @sqlcmd       VARCHAR(max),
        @DryRun       INT = 0

--For Disabled AutoGrowth or Unlimited Autogrowth it is set stats are mathematical expression is to the Current Size with the Unlimited it will grow as needed. 
SELECT @sqlcmd = ' USE ' + @DatabaseName
                 + '

SELECT 
    t.NAME AS TableName,
   ISNULL(i.name, case when i.type =0 then ''HEAP Index''  ELSE NULL END ) as IndexName,
    SUM(s.used_page_count) * 8.0 / 1024.0 as IndexSizeMB,
    SUM(s.used_page_count) * 8.0 / 1024.0  / 1024.0 as IndexSizeGB,
      CASE 
        WHEN i.type = 0 THEN ''BOO!!!! HEAP index (we always go query from these tables making HEAPs useless)''
		WHEN i.type = 1 THEN ''Clustered index''
        WHEN i.type = 2 THEN ''Nonclustered unique index''
        WHEN i.type = 3 THEN ''XML index''
        WHEN i.type = 4 THEN ''Spatial index''
        WHEN i.type = 5 THEN ''Clustered columnstore index''
        WHEN i.type = 6 THEN ''Nonclustered columnstore index''
        WHEN i.type = 7 THEN ''Nonclustered hash index''
        ELSE ''Unknown''
    END as IndexType,       Substring(column_names, 1, Len(column_names) - 1) AS [columns]
FROM 
    sys.dm_db_partition_stats AS s 
JOIN 
    sys.tables AS t ON s.object_id = t.object_id
JOIN 
    sys.indexes AS i ON i.object_id = t.object_id AND s.index_id = i.index_id
JOIN sys.objects o ON t.object_id = o.object_id
  CROSS apply (SELECT col.[name] + '', ''
                    FROM   sys.index_columns ic
                           INNER JOIN sys.columns col
                                   ON ic.object_id = col.object_id
                                      AND ic.column_id = col.column_id
									 WHERE  ic.object_id = t.object_id
                           AND ic.index_id = i.index_id
                    ORDER  BY key_ordinal
                    FOR xml path ('''')) D (column_names)
WHERE 
    t.NAME =  '''+@TableName+'''  -- replace with your table name

GROUP BY 
     t.NAME, i.name, i.type, column_names
ORDER BY 
    IndexSizeMB DESC;
'
IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
		
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END


