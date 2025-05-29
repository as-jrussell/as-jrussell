DECLARE @cmd1 VARCHAR(500)
DECLARE @cmd2 VARCHAR(500)
DECLARE @table VARCHAR(100) ='dbo.Service_Statistics'
		DECLARE @DryRun INT = 0

SET @cmd1 ='USE [?]
SELECT DISTINCT DB_NAME(), CONCAT( ''Tables that '', OBJECT_NAME(referenced_id),'' depends on to work appropriately is: '' ,OBJECT_NAME(referencing_id) ), OBJECT_NAME(referenced_id)  
FROM sys.sql_expression_dependencies  
WHERE referenced_id = OBJECT_ID(N'''
           + @Table + ''') '
SET @cmd2 ='USE [?]
SELECT DISTINCT DB_NAME(), CONCAT(''Tables that depends on  '', OBJECT_NAME(referenced_id),'' to work appropriately is: '' ,OBJECT_NAME(referencing_id) ), OBJECT_NAME(referenced_id)  

FROM sys.sql_expression_dependencies  
WHERE referencing_id =OBJECT_ID(N'''
           + @Table + ''') '

IF @DryRun = 0
  BEGIN
      IF Object_id(N'tempdb..#1') IS NOT NULL
        DROP TABLE #1

      CREATE TABLE #1
        (
           [databasename]          VARCHAR(100),
           [Table]                 VARCHAR(max),
           [Object] VARCHAR(100)
        )

      INSERT INTO #1
      EXEC Sp_msforeachdb
        @cmd1

      INSERT INTO #1
      EXEC Sp_msforeachdb
        @cmd2

      SELECT *
      FROM   #1
  END
ELSE
  BEGIN
      PRINT ( @cmd1 )

      PRINT ( @cmd2 )
  END
/*
exec   sp_depends  [APPLOG]

AutoIMSData

SELECT  * FROM sys.sql_expression_dependencies  
WHERE referencing_id = OBJECT_ID(N'ref.cp_ref');   
GO



SELECT OBJECT_NAME(referenced_id), * FROM sys.sql_expression_dependencies  
WHERE referenced_id = OBJECT_ID(N'APP_LOG');   
ORDER BY OBJECT_NAME(referenced_id) ASC
*/
