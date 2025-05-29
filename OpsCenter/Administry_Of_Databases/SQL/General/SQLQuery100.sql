IF OBJECT_ID(N'tempdb..#TempTable') IS NOT NULL
DROP TABLE #TempTable
  CREATE TABLE #TempTable ([TableName] VARCHAR(128),[DBName] VARCHAR(128), [RowCount] BIGINT) ;


INSERT INTO #TempTable ([TableName],[DBName], [RowCount])
EXEC sp_MSforeachdb 'USE [?] SELECT DB_NAME() [DBNAME],
      QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + ''.'' + QUOTENAME(sOBJ.name) AS [TableName]
      , SUM(sPTN.Rows) AS [RowCount]
FROM 
      sys.objects AS sOBJ
      INNER JOIN sys.partitions AS sPTN
            ON sOBJ.object_id = sPTN.object_id
WHERE
      sOBJ.type = ''U''
      AND sOBJ.is_ms_shipped = 0x0
      AND index_id < 2 -- 0:Heap, 1:Clustered
	  AND DB_NAME() <> ''tempdb''
GROUP BY 
      sOBJ.schema_id
      , sOBJ.name
ORDER BY [TableName]' ;





SELECT  [TableName],[DBName], [RowCount]
FROM #TempTable
ORDER BY [TableName]
GO



IF OBJECT_ID(N'tempdb..#TempTableCount') IS NOT NULL
DROP TABLE #TempTableCount
  CREATE TABLE #TempTableCount ([DBName] VARCHAR(128), [RowCount] INT) ;


INSERT INTO #TempTableCount ([DBName], [RowCount])
EXEC sp_MSforeachdb 'USE [?] SELECT DB_NAME() [DBNAME],
     count(*) [RowCount] from sys.objects where type = ''U''' ;


	 SELECT   [DBName], [RowCount]
FROM #TempTableCount

GO





IF OBJECT_ID(N'tempdb..#TempSpace') IS NOT NULL
DROP TABLE #TempSpace
  CREATE TABLE #TempSpace ( [File Name] VARCHAR(128), [Total Size in MB] INT) ;


INSERT INTO #TempSpace ([File Name], [Total Size in MB] )
EXEC sp_MSforeachdb 'USE [?]
SELECT f.name AS [File Name] ,
CAST((f.size/128.0) AS DECIMAL(15,2)) AS [Total Size in MB]
FROM sys.database_files AS f WITH (NOLOCK) 
LEFT OUTER JOIN sys.filegroups AS fg WITH (NOLOCK)
ON f.data_space_id = fg.data_space_id
where file_id = 1
OPTION (RECOMPILE);'



	 SELECT DISTINCT  [File Name],  [Total Size in MB]
FROM #TempSpace
