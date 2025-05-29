USE [DBA];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[deploy].[SetRFPLDatabasePermission]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [deploy].[SetRFPLDatabasePermission] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [deploy].[SetRFPLDatabasePermission] (@AppName VARCHAR(50) = 'RFPL', @old VARCHAR(128)= '_UAT',  @account1 varchar(50) ='RFPLdbWebApp-UAT', @account2 varchar(50) ='RFPLdbWinSvcs-UAT' ,@WhatIF BIT = 1)
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
WHERE  NAME LIKE '%' + @old 
ORDER  BY database_id

-- Loop through the remaining databases
WHILE EXISTS(SELECT *
             FROM   #TempDatabases
             WHERE  IsProcessed = 0)
  BEGIN
      -- Fetch 1 DatabaseName where IsProcessed = 0
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 
    -- Prepare SQL Statement
    SELECT @SQL = '
USE [' + @DatabaseName + ']
  IF NOT EXISTS (SELECT 1 FROM sys.database_principals where name = '''+@account1+''')
BEGIN 
CREATE USER ['+@account1+'] FOR LOGIN ['+@account1+']
ALTER ROLE [db_datareader] ADD MEMBER ['+@account1+']
ALTER ROLE [db_datawriter] ADD MEMBER ['+@account1+']
GRANT EXECUTE TO ['+@account1+']
END 

IF NOT EXISTS (SELECT 1 FROM sys.database_principals where name = '''+@account2+''')
BEGIN 
CREATE USER ['+@account2+'] FOR LOGIN ['+@account2+']
ALTER ROLE [db_datareader] ADD MEMBER ['+@account2+']
ALTER ROLE [db_datawriter] ADD MEMBER ['+@account2+']
GRANT EXECUTE TO ['+@account2+']
END 

IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''EccdbAppIntegrationPROD'')
BEGIN 
DROP USER [EccdbAppIntegrationPROD] 
END

IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''RFPLdbDeployer-Production'')
BEGIN 
DROP USER [RFPLdbDeployer-Production] 
END

IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''RFPLdbWebApp-Prod'')
BEGIN 
DROP USER [RFPLdbWebApp-Prod] 
END

IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''RFPLdbWinSvcs-Prod'')
BEGIN 
DROP USER [RFPLdbWinSvcs-Prod] 
END


IF EXISTS (SELECT 1 FROM sys.database_principals where name = ''SVC_DTST_PRD01'')
BEGIN 
DROP USER [SVC_DTST_PRD01] 
END

IF EXISTS(select 1 from sys.objects where name = ''CONNECTION_DESCRIPTOR'')
BEGIN 
update CONNECTION_DESCRIPTOR 
set SERVER_TX = ''rfpl-sql-preprod-02.c07da6b21265.database.windows.net'',
USERNAME_TX = '''+@account1+''',
PASSWORD_TX = ''e12dab7e3fdea2216228d27eb0741a3f''
where PURGE_DT is null and SERVER_TX != ''''
END 


IF EXISTS(select 1 from sys.objects where name = ''REF_CODE'')
BEGIN
update REF_CODE 
set MEANING_TX = ''asrefundplusuat'' 
where DOMAIN_CD = ''AzureFileStorageBlob'' 
and CODE_CD = ''AccountName''
END 

IF EXISTS(select 1 from sys.objects where name = ''REF_CODE'')
BEGIN
update REF_CODE 
set MEANING_TX = ''T/xQdEEcS9fA/+k9hdX1BBg1zXNwc8HQAMae3Q0BtgioIiN3f9MJJNeKCkChQ4tcNP+995SSGd6SCJSNLhEq4w=='' 
where DOMAIN_CD = ''AzureFileStorageBlob'' 
and CODE_CD = ''AccountKey''
END 

'



     
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
