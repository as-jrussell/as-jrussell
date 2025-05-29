USE [Shavlik];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetShavlikPrep]') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetShavlikPrep] AS RETURN 0;';
END;
GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[GetShavlikPrep] (  @DatabaseName SYSNAME = 'Shavlik',   @AppName VARCHAR(50) = 'SHAV',      @WhatIF       NVARCHAR(10) = 1,        @Verbose      BIT =0 )
WITH EXECUTE AS OWNER  
AS 


DECLARE @sqlcmd       NVARCHAR(max)

DECLARE @SQL VARCHAR(max), @ServerENV VARCHAR(1000), @ServerName VARCHAR(1000),@newname NVARCHAR(128),@TargetName VARCHAR(128), @ExecCommand   VARCHAR(150),
        @ProcedureName NVARCHAR(128),  @DryRun INT = @WhatIF


SELECT @ProcedureName = Quotename(Db_name()) + '.'
                        + Quotename(Object_schema_name(@@PROCID, Db_id()))
                        + '.'
                        + Quotename(Object_name(@@PROCID, Db_id()));

SELECT @sqlcmd = 'USE [' + @DatabaseName
                 + ']




DBCC SHRINKFILE (N''' + @DatabaseName
                 + ''' , 0, TRUNCATEONLY)

     WAITFOR DELAY ''00:05:00:00''

USE [DBA] 
Exec [DBA].[backup].[BackupDatabase]   @BackupLevel = ''FULL'',   @SQLDatabaseName = '''
                 + @DatabaseName + ''',@DryRun = ''' + @WhatIF
                 + ''''


SET @ExecCommand = 'EXEC '+ @ProcedureName +' @AppName = '''+ @AppName  +''',@TargetDB = '''+@DatabaseName+''', @WhatIf = '+ CONVERT(CHAR(1), @WhatIF) +';'

    IF( @WhatIF = 1 )
        BEGIN
            /* Record zero execution - result zero is "unknown" */
            INSERT INTO [DBA].[deploy].[ExecHistory]
                ( [TimeStampUTC], [UserName], [Command], [ErrorMessage], [Result] )
            VALUES
                ( Getdate(), Original_login(), @ExecCommand, 'No error handling - DryRun', 0 )
        END
    ELSE
        BEGIN
            /* Record zero execution - result one is success */
            INSERT INTO [DBA].[deploy].[ExecHistory]
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





IF @Verbose = 0
  BEGIN
      IF @WhatIF = 0
        BEGIN
            EXEC( @sqlcmd )
			PRINT ( @sqlcmd )
        END
      ELSE
        BEGIN
            PRINT ( @sqlcmd )
        END
  END
ELSE
  BEGIN
      PRINT ( @sqlcmd )
  END 
