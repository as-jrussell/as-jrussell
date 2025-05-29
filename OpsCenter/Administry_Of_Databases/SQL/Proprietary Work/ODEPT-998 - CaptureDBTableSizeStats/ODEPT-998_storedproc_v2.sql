USE [PerfStats]
GO
/****** Object:  StoredProcedure [dbo].[CaptureDBRowStats]    Script Date: 3/20/2023 6:13:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CaptureDBRowStats]') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CaptureDBRowStats] AS RETURN 0;';
END;
GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[CaptureDBRowStats] (@WhatIf BIT = 1, @Verbose BIT = 0,   @TableName    VARCHAR(255)='', @SchemaName   VARCHAR(255)='', @DatabaseName VARCHAR(100) = '')
AS


DECLARE @sqlcmd       VARCHAR(max)


SELECT @sqlcmd = '
use [?]

SELECT
	DB_NAME() AS DatabaseName,
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows AS RowCounts,
    SUM(a.total_pages) *8 /1024. AS TotalSpaceMB, 
    SUM(a.used_pages) *8 /1024. AS UsedSpaceMB, 
	   NULL  AS [PreviousDayUsedSpaceMB],
	   NULL  AS [AmountGrown],
GETDATE()
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
	AND t.[name] like ''%' + @TableName
                 + '%''
                
GROUP BY 
    t.Name, s.Name, p.Rows
ORDER BY 
     SUM(a.used_pages)*8 /1024. DESC'

IF Object_id(N'tempdb..#TableFileSize') IS NOT NULL
  DROP TABLE #TableFileSize

CREATE TABLE #TableFileSize
  (
     [DatabaseName]           VARCHAR(100),
     [TableName]              VARCHAR(100),
     [SchemaName]             VARCHAR(100),
     [RowCounts]              BIGINT,
     [TotalSpaceMB]           INT,
     [UsedSpaceMB]            INT,
     [PreviousDayUsedSpaceMB] INT,
     [AmountGrown]            INT,
     [HarvestDate]            DATE
  );

INSERT INTO #TableFileSize
EXEC Sp_msforeachdb
  @SQLcmd


IF @WhatIf = 0
  BEGIN

      MERGE [Perfstats].[dbo].[CaptureDBTableSize] AS old
      USING (SELECT DISTINCT [DatabaseName],
                             [TableName],
                             [SchemaName],
                             [RowCounts],
                             [TotalSpaceMB],
                             [UsedSpaceMB],
                             [PreviousDayUsedSpaceMB],
                             ( [UsedSpaceMB] - [PreviousDayUsedSpaceMB] ) [AmountGrown],
                             Getdate()
             FROM   #TableFileSize) AS new ([DatabaseName], [TableName], [SchemaName], [RowCounts], [TotalSpaceMB], [UsedSpaceMB], [PreviousDayUsedSpaceMB], [AmountGrown], [HarvestDate])
      ON old.[TableName] = new.[TableName]
      WHEN MATCHED AND (old.[DatabaseName] = new.[DatabaseName] AND old.[SchemaName] = new.[SchemaName] AND Cast(old.[HarvestDate] AS DATE) <> Cast(new.[HarvestDate] AS DATE) OR old.[TotalSpaceMB] <> new.[TotalSpaceMB] OR old.[UsedSpaceMB] <> new.[UsedSpaceMB]) THEN
        UPDATE SET old.[PreviousDayUsedSpaceMB] = old.[UsedSpaceMB]
                                                  ,
                   old.[RowCounts] = new.[RowCounts],
                   old.[TotalSpaceMB] = new.[TotalSpaceMB],
                   old.[UsedSpaceMB] = new.[UsedSpaceMB],
                   old.[AmountGrown] = (new.[UsedSpaceMB]-old.[PreviousDayUsedSpaceMB] ) 
      WHEN NOT MATCHED THEN
        INSERT ([DatabaseName],
                [TableName],
                [SchemaName],
                [RowCounts],
                [TotalSpaceMB],
                [UsedSpaceMB],
                [PreviousDayUsedSpaceMB],
                [AmountGrown],
                [HarvestDate])
        VALUES (new.[DatabaseName],
                new.[TableName],
                new.[SchemaName],
                new.[RowCounts],
                new.[TotalSpaceMB],
                new.[UsedSpaceMB],
                new.[PreviousDayUsedSpaceMB],
                ( [UsedSpaceMB] - [PreviousDayUsedSpaceMB] ),
                new.[HarvestDate])
      WHEN NOT MATCHED BY SOURCE THEN
        DELETE;
  END;
ELSE
  BEGIN
      SELECT DISTINCT [DatabaseName],
                      [TableName],
                      [SchemaName],
                      [RowCounts],
                      [TotalSpaceMB],
                      [UsedSpaceMB],
                      [HarvestDate]
      FROM   #TableFileSize
      WHERE  DatabaseName LIKE '%' + @DatabaseName + '%'
             AND TableName LIKE '%' + @TableName + '%'
             AND SchemaName LIKE '%' + @SchemaName + '%'
      ORDER  BY [TotalSpaceMB] DESC

      IF @Verbose = 1
        BEGIN
            PRINT ( @SQLcmd + '
	  
	  exec sp_MSforeachdb @sqlcmd
	      SELECT [DatabaseName],
[TableName] ,
[SchemaName],
[RowCounts],
[TotalSpaceMB] ,
[UsedSpaceMB] ,
                [HarvestDate]
            FROM   #TableFileSize
			ORDER BY     [TotalSpaceMB] DESC
	
	   SELECT DISTINCT [DatabaseName],
[TableName] ,
[SchemaName],
[RowCounts],
[TotalSpaceMB] ,
[UsedSpaceMB] ,    [HarvestDate]
            FROM   #TableFileSize
			WHERE DatabaseName LIKE ''%'
                    + @DatabaseName + '%''
			AND TableName LIKE''%'
                    + @TableName + '%''
			AND SchemaName LIKE''%'
                    + @SchemaName
                    + '%''
			ORDER BY     [TotalSpaceMB] DESC' )
        END
  END 
