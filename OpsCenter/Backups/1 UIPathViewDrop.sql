USE [UiPathInsights]

/* DECLARE ALL variables at the top */
DECLARE @sqlcmd VARCHAR(1000)
DECLARE @DatabaseName SYSNAME = (select DB_NAME()) --Database Name
DECLARE @TableName VARCHAR(1000)--Table Name
DECLARE @FQTN VARCHAR(1000)--Table Name
DECLARE @SchemaName VARCHAR(1000)--Table Name
DECLARE @DryRun INT = 0 --1 to Preview / 0 to Execute 
IF Object_id(N'tempdb..#TempTables') IS NOT NULL
  DROP TABLE #TempTables 
CREATE TABLE #TempTables
  (
     FQTN NVARCHAR(250) ,
	 TableName NVARCHAR(250) ,
	 SchemaName NVARCHAR(250) ,
     IsProcessed BIT
  )

  INSERT INTO #TempTables (FQTN, TableName, SchemaName, IsProcessed)
SELECT SCHEMA_NAME(schema_id)+'.'+ name, Name,SCHEMA_NAME(schema_id),  0 -- SELECT *
FROM   sys.objects
WHERE type= 'V'
ORDER  BY object_id
-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempTables WHERE IsProcessed = 0 )
  BEGIN

    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @TableName = TableName FROM #TempTables WHERE IsProcessed = 0 
    SELECT Top 1 @FQTN = FQTN FROM #TempTables WHERE IsProcessed = 0 
	SELECT Top 1 @SchemaName = SchemaName FROM #TempTables WHERE IsProcessed = 0 


SELECT @SQLCMD = '
USE [' + @DatabaseName
                 + ']

IF EXISTS (SELECT 1 FROM SYS.DATABASES WHERE NAME = '''
                 + @DatabaseName
                 + ''')
BEGIN 
IF EXISTS (SELECT 1 FROM SYS.objects WHERE SCHEMA_NAME(schema_id)+''.''+ name =  '''
                 + @FQTN
                 + ''')
  BEGIN 
    BEGIN TRY   
		DROP VIEW [' + @SchemaName+ '].[' + @TableName+ ']
		  END TRY  
    BEGIN CATCH  
		PRINT ''WARNING: THERE WAS AN ISSUE WITH THE VIEW: ' + @FQTN + '''
   RETURN
    END CATCH  
		PRINT ''SUCCESSFUL: VIEW DROPPED: ' + @FQTN + ' ''
		END 
	ELSE 
		BEGIN 
		PRINT ''WARNING: PLEASE CHECK VIEW: ' + @FQTN + '''
		END 
		
END '

-- You know what we do here if it's 1 then it'll give us code and 0 executes it
IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 


    -- Update table
    UPDATE  #TempTables 
    SET IsProcessed = 1
    WHERE TableName = @TableName
  END


