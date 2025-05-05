DECLARE @DatabaseName VARCHAR(100) ='ThePlayPen',
        @TableName    VARCHAR(255) ='',
		@FileGroup    VARCHAR(255) ='',
        @sqlcmd       VARCHAR(max),
        @DryRun       INT = 0

SELECT @sqlcmd = '
use [' + @DatabaseName + ']

SELECT
	DB_NAME() AS DatabaseName,


    t.NAME AS TableName,
    s.Name AS SchemaName,
	fg.name AS [File_Group],
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
	    SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,
    SUM(a.total_pages) * 8 / 1024 / 1024. AS TotalSpaceGB, 
       CASE
         WHEN i.[type] = 1 THEN ''Clustered index''
         WHEN i.[type] = 2 THEN ''Nonclustered unique index''
         WHEN i.[type] = 3 THEN ''XML index''
         WHEN i.[type] = 4 THEN ''Spatial index''
         WHEN i.[type] = 5 THEN ''Clustered columnstore index''
         WHEN i.[type] = 6 THEN ''Nonclustered columnstore index''
         WHEN i.[type] = 7 THEN ''Nonclustered hash index''
		 ELSE ''HEAP''
       END                                        AS index_type,


       CASE
         WHEN i.is_unique = 1 THEN ''Unique''
         ELSE ''Not unique''
       END                                               AS [unique],
	CONCAT(''select TOP 5 * from [''+DB_NAME()+''].[dbo].['',t.NAME,'']'') AS [Example Query], 
concat(''DROP TABLE ['',t.name, '']'') [Do you need a drop]
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
	   INNER JOIN sys.data_spaces AS ds ON a.data_space_id = ds.data_space_id
    INNER JOIN sys.filegroups AS fg ON ds.data_space_id = fg.data_space_id
LEFT OUTER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
WHERE 
    t.NAME NOT LIKE ''dt%'' 
	AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255
	AND t.[name] like ''%'
                 + @TableName
                 + '%''
    	AND  fg.name like ''%'
                 + @FileGroup
                 + '%''

                
GROUP BY 
    t.Name, s.Name, p.Rows, i.[type],i.is_unique, fg.name
ORDER BY 
     SUM(a.used_pages) * 8 / 1024 / 1024. DESC'




IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
		
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd + 'in
	  
	  exec @sqlcmd')
  END

  


