DECLARE @TableRowCounts TABLE ([TableName] VARCHAR(128), [RowCount] INT) ;
INSERT INTO @TableRowCounts ([TableName], [RowCount])
EXEC sp_MSforeachtable 'SELECT ''?'' [TableName], COUNT(*) [RowCount] FROM ?' ;
SELECT [TableName], [RowCount]
FROM @TableRowCounts
ORDER BY [TableName]
GO



SELECT
      QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [TableName]
      , SUM(sPTN.Rows) AS [RowCount]
FROM 
      sys.objects AS sOBJ
      INNER JOIN sys.partitions AS sPTN
            ON sOBJ.object_id = sPTN.object_id
WHERE
      sOBJ.type = 'U'
      AND sOBJ.is_ms_shipped = 0x0
      AND index_id < 2 -- 0:Heap, 1:Clustered
GROUP BY 
      sOBJ.schema_id
      , sOBJ.name
ORDER BY [TableName]
GO

EXEC sp_MSforeachdb 'use [?] select DB_NAME(), * from sys.objects where name = ''AlliedWorkItemMetaDataTable'''

DECLARE @Name nvarchar(100) = 'LENDER'
--EXEC sp_MSforeachdb
PRINT
'EXEC sp_MSforeachdb ''USE [?] select DB_NAME(), * from sys.tables where name = ''''' + @Name +''''''''


EXEC sp_MSforeachdb 'USE [?] select DB_NAME(), * from sys.tables where name = ''LENDER'''
