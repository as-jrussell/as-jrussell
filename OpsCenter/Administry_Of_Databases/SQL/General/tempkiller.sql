-- WARNING: Run this script only in a controlled test environment. It can consume all tempdb space, causing performance issues.

USE tempdb;
GO

-- Create a large temporary table with a recursive CTE and a cross join
CREATE TABLE #LargeTempTable (ID INT IDENTITY(1,1), Data CHAR(8000));
GO

DECLARE @i INT = 0;

-- Loop to insert large data sets to fill up tempdb
WHILE @i < 100000
BEGIN
    -- Insert large amounts of data to #LargeTempTable
    INSERT INTO #LargeTempTable (Data)
    SELECT REPLICATE('X', 8000)
    FROM (SELECT TOP (1000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
          FROM sys.objects a CROSS JOIN sys.objects b) AS LargeDataSet;

    SET @i += 1;
END;

-- Check tempdb space usage by file
SELECT
    name AS FileName,
    size * 8 / 1024 AS SizeMB,
    size * 8 / 1024 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT) * 8 / 1024 AS FreeSpaceMB,
    physical_name AS FilePath
FROM sys.master_files
WHERE database_id = DB_ID('tempdb');
GO

-- Clean up to release space
--DROP TABLE #LargeTempTable;
GO

