USE [PerfStats]

GO

/****** Object:  StoredProcedure [dbo].[CaptureDBRowStats]    Script Date: 10/11/2023 12:35:05 PM ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[Capturedbrowstats] (@DatabaseName VARCHAR(100) = '',
                                           @WhatIf       INT = 1,
                                           @Verbose      INT =0)
AS
    DECLARE @query      NVARCHAR(1000),
            @SQLMerge   NVARCHAR(4000),
            @sqlcmd     NVARCHAR(1000),
            @SchemaName VARCHAR(255)

  BEGIN
      IF( @DatabaseName = '' )
        BEGIN
            SET @SchemaName = 'dbo'
        END
      ELSE
        BEGIN
            SET @SchemaName = @DatabaseName

            SELECT @query = 'CREATE SCHEMA [' + @SchemaName + '];';

            IF NOT EXISTS (SELECT *
                           FROM   sys.schemas
                           WHERE  NAME = @SchemaName)
              BEGIN
                  PRINT @query

                  IF( @WhatIf = 0 )
                    EXEC( @query)
              END
        END

      -- Top Cached SPs By resource usage (SQL 2008 and later only).
      SELECT @query = N'SELECT * into PerfStats.' + @SchemaName
                      + '.TableSizeStats FROM PerfStats.PerfStats.TableSizeStats WHERE 1=0;'

      IF NOT EXISTS (SELECT *
                     FROM   INFORMATION_SCHEMA.TABLES
                     WHERE  TABLE_SCHEMA = @SchemaName
                            AND TABLE_NAME = 'TableSizeStats')
        BEGIN
            PRINT @query

            IF( @WhatIf = 0 )
              EXEC Sp_executesql
                @query,
                N'@SchemaName nvarchar(128)',
                @SchemaName
        END

      SELECT @sqlcmd = '
use [' + @DatabaseName
                       + ']

SELECT
	DB_NAME() AS DatabaseName,
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 / 1024 / 1024. AS TotalSpaceGB, 
    SUM(a.used_pages) * 8 / 1024 / 1024. AS UsedSpaceGB, 
	   NULL  AS [PreviousDayUsedSpaceGB],
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

                
GROUP BY 
    t.Name, s.Name, p.Rows
ORDER BY 
     SUM(a.used_pages) * 8 / 1024 / 1024. DESC'

      IF Object_id(N'tempdb..#TableFileSize') IS NOT NULL
        DROP TABLE #TableFileSize

      CREATE TABLE #TableFileSize
        (
           [DatabaseName]           VARCHAR(100),
           [TableName]              VARCHAR(100),
           [SchemaName]             VARCHAR(100),
           [RowCounts]              BIGINT,
           [TotalSpaceGB]           BIGINT,
           [UsedSpaceGB]            BIGINT,
           [PreviousDayUsedSpaceGB] BIGINT,
           [AmountGrown]            BIGINT,
           [HarvestDate]            DATE
        );

      IF @Verbose = 1
        BEGIN
            PRINT ( @SQLcmd )
        END

      INSERT INTO #TableFileSize
      EXEC (@SQLcmd)

      SELECT @sqlMerge = 'MERGE [Perfstats].[' + @SchemaName
                         + '].[TableSizeStats] AS TARGET
          USING (SELECT DISTINCT [DatabaseName],
                                 [TableName],
                                 [SchemaName],
                                 [RowCounts],
                                 [TotalSpaceGB],
                                 [UsedSpaceGB],
                                 NULL,
                                 NULL,
                                 Getdate()
                 FROM   #TableFileSize) AS SOURCE ([DatabaseName], [TableName], [SchemaName], [RowCounts], [TotalSpaceGB], [UsedSpaceGB], [PreviousDayUsedSpaceGB], [AmountGrown], [HarvestDate])
          ON TARGET.[TableName] = SOURCE.[TableName]
          WHEN MATCHED AND (TARGET.[DatabaseName] = SOURCE.[DatabaseName] AND  Cast(TARGET.[HarvestDate] AS DATE) <> Cast(SOURCE.[HarvestDate] AS DATE) OR TARGET.[TotalSpaceGB] <> SOURCE.[TotalSpaceGB] OR TARGET.[UsedSpaceGB] <> SOURCE.[UsedSpaceGB]) THEN
            UPDATE SET TARGET.[PreviousDayUsedSpaceGB] = TARGET.[UsedSpaceGB],
                       TARGET.[RowCounts] = SOURCE.[RowCounts],
                       TARGET.[TotalSpaceGB] = SOURCE.[TotalSpaceGB],
                       TARGET.[UsedSpaceGB] = SOURCE.[UsedSpaceGB],
                       TARGET.[AmountGrown] = ( SOURCE.[UsedSpaceGB] - TARGET.[UsedSpaceGB] )
                                           
          WHEN NOT MATCHED THEN
            INSERT ([DatabaseName],
                    [TableName],
                    [SchemaName],
                    [RowCounts],
                    [TotalSpaceGB],
                    [UsedSpaceGB],
                    [PreviousDayUsedSpaceGB],
                    [AmountGrown],
                    [HarvestDate])
            VALUES (SOURCE.[DatabaseName],
                    SOURCE.[TableName],
                    SOURCE.[SchemaName],
                    SOURCE.[RowCounts],
                    SOURCE.[TotalSpaceGB],
                    SOURCE.[UsedSpaceGB],
                    SOURCE.[PreviousDayUsedSpaceGB],
                    ( [UsedSpaceGB] - [PreviousDayUsedSpaceGB] ),
                    SOURCE.[HarvestDate])
          WHEN NOT MATCHED BY SOURCE THEN
            DELETE;'

      IF @Verbose = 1
        BEGIN
            PRINT ( @sqlMerge )
        END

      IF @WhatIf = 0
        BEGIN
               EXEC ( @sqlMerge)
        END;
      ELSE
        BEGIN
            EXEC ( @SQLcmd )
        END
  END 
