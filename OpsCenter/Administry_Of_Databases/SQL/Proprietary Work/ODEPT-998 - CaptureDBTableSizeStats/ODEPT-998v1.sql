DECLARE @sqlcmd       VARCHAR(max),
        @TableName    VARCHAR(255)='' ,
        @DatabaseName VARCHAR(100) = '?',       
		@Size VARCHAR(2) = 'GB',
        @DryRun       INT = 0


SELECT @sqlcmd = '
use [' + @DatabaseName + ']

SELECT
	DB_NAME() AS DatabaseName,
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 / 1024 / 1024. AS TotalSpaceGB, 
    SUM(a.used_pages) * 8 / 1024 / 1024. AS UsedSpaceGB, 
    (SUM(a.total_pages) - SUM(a.used_pages))* 8 / 1024 / 1024.  AS UnusedSpaceGB,
	CONCAT(''select TOP 5 * from [''+DB_NAME()+''].[dbo].['',t.NAME,'']'') AS [Example Query]
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
WHERE 
    t.NAME NOT LIKE ''dt%'' 
	AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255
	AND t.[name] like ''%'
                 + @TableName
              +'%''
                
GROUP BY 
    t.Name, s.Name, p.Rows
ORDER BY 
     SUM(a.used_pages) * 8 / 1024 / 1024. DESC'

IF Object_id(N'tempdb..#TableFileSize') IS NOT NULL
              DROP TABLE #TableFileSize

            CREATE TABLE #TableFileSize
              (
                 [DatabaseName]  VARCHAR(100),
                 [TableName]     VARCHAR(100),
                 [SchemaName]    VARCHAR(100),
                 [RowCounts]     BIGINT,
                 [TotalSpaceGB]  INT,
                 [UsedSpaceGB]   INT,
                 [UnusedSpaceGB] INT,
                 [Example Query] VARCHAR(1000)
              );

            INSERT INTO #TableFileSize
            EXEC Sp_msforeachdb
              @SQLcmd

IF @Size = 'GB'
BEGIN 
IF @DryRun = 0
  BEGIN
  
             SELECT [DatabaseName],
                 [TableName] ,
                 [SchemaName],
                 [RowCounts],
                 ([TotalSpaceGB]*1024) ,
                 [UsedSpaceGB] ,
                 [UnusedSpaceGB],
                 [Example Query] 
            FROM   #TableFileSize
			ORDER BY     [TotalSpaceGB] DESC
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd + '
	  
	  exec sp_MSforeachdb @sqlcmd
	  
	    SELECT [DatabaseName],
                 [TableName] ,
                 [SchemaName],
                 [RowCounts],
                 [TotalSpaceGB] ,
                 [UsedSpaceGB] ,
                 [UnusedSpaceGB],
                 [Example Query] 
            FROM   #TableFileSize
			ORDER BY     [TotalSpaceGB] DESC
	  
	  ' )
  END
  END 

