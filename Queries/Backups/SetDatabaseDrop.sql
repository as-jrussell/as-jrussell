USE [DBA]
GO
/****** Object:  StoredProcedure [deploy].[SetDatabaseDrop]    Script Date: 5/22/2024 1:46:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Alter Stored Procedure */
ALTER PROCEDURE [deploy].[SetDatabaseDrop] (@AppName VARCHAR(50) = 'RFPL', @new VARCHAR(128)= '_UAT',   @WhatIF BIT = 1)
WITH EXECUTE AS OWNER /* Should be replaced with limited account */
AS
BEGIN
DECLARE @SQL VARCHAR(max), @ServerENV VARCHAR(1000), @ServerName VARCHAR(1000),@newname NVARCHAR(128),@TargetName VARCHAR(128), @ExecCommand   VARCHAR(150),
        @ProcedureName NVARCHAR(128), @DatabaseName SYSNAME, @DryRun INT = @WhatIF





SELECT @ProcedureName = Quotename(Db_name()) + '.'
                        + Quotename(Object_schema_name(@@PROCID, Db_id()))
                        + '.'
                        + Quotename(Object_name(@@PROCID, Db_id()));

-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases

CREATE TABLE #TempDatabases
  (
     DatabaseName SYSNAME,
     IsProcessed  BIT
  )

-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases
            (DatabaseName,
             IsProcessed)
SELECT NAME,
       0 -- SELECT *
FROM   sys.databases
WHERE  NAME LIKE '%' + @new 
ORDER  BY database_id

-- Loop through the remaining databases
WHILE EXISTS(SELECT *
             FROM   #TempDatabases
             WHERE  IsProcessed = 0)
  BEGIN
      -- Fetch 1 DatabaseName where IsProcessed = 0
      SELECT TOP 1 @DatabaseName = DatabaseName
      FROM   #TempDatabases
      WHERE  IsProcessed = 0
  
        SET @TargetName =(SELECT TOP 1 NAME
                        FROM   sys.databases
                        WHERE  NAME LIKE '%' + @new + '');

      SELECT @SQL = 'EXEC sp_executesql N''DROP DATABASE '+@TargetName+''';			  
                PRINT ''The ' + @TargetName+ ' has been dropped'''

     
    SET @ExecCommand = 'EXEC '+ @ProcedureName +' @AppName = '''+ @AppName  +''',@TargetDB = '''+@DatabaseName+''', @DryRun = '+ CONVERT(CHAR(1), @Dryrun) +';'


 /*
    ######################################################################
					    Record entry - no error handling
    ######################################################################
    */
    IF( @DryRun = 1 )
        BEGIN
            /* Record zero execution - result zero is "unknown" */
            INSERT INTO [deploy].[ExecHistory]
                ( [TimeStampUTC], [UserName], [Command], [ErrorMessage], [Result] )
            VALUES
                ( Getdate(), Original_login(), @ExecCommand, 'No error handling - DryRun', 0 )
        END
    ELSE
        BEGIN
            /* Record zero execution - result one is success */
            INSERT INTO [deploy].[ExecHistory]
                ( [TimeStampUTC], [UserName], [Command], [ErrorMessage], [Result] )
            VALUES
                ( Getdate(), Original_login(), @ExecCommand, 'No error handling', 1 )
        END

    SELECT  @ServerName = @@SERVERNAME,
		    @ServerENV = CASE WHEN @@SERVERNAME LIKE '%-DEVTEST%' THEN 'DEV'
						      WHEN @@SERVERNAME LIKE '%-PREPROD%' THEN 'TEST'
						      WHEN @@SERVERNAME LIKE '%-PROD%' THEN 'PROD'
						      ELSE ( SELECT confValue FROM dba.info.Systemconfig WHERE confkey = 'Server.Environment' )
					     END






        -- You know what we do here if it's 1 then it'll give us code and 0 executes it
        IF @WhatIF = 0
          BEGIN
              PRINT ( @DatabaseName )

              EXEC ( @SQL)

          END
        ELSE
          BEGIN
              PRINT ( @SQL )
		   
		    PRINT ( @DatabaseName )
          END

      -- Update table
      UPDATE #TempDatabases
      SET    IsProcessed = 1
      WHERE  DatabaseName = @databaseName
  END
END
