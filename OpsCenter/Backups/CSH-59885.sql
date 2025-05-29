DECLARE @sqluser varchar(MAX)
DECLARE @sqlcmd varchar(MAX)
DECLARE @sqlcmdTable varchar(MAX)
DECLARE @AppRole varchar(100) = ''
DECLARE @TargetDB varchar(100) = 'SVSalesMgmt_Allied' 
DECLARE @AccountRoot varchar(100) = 'ELDREDGE_A\Positrac-Daemon-PROD'
DECLARE @Type varchar(10) = 'EX'
DECLARE @TargetTable varchar(100) = 'SV_TransferDataBetweenINums'
DECLARE @Permission varchar(100) 
DECLARE @DryRun INT = 0 

SELECT @Permission = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type 



SELECT @sqlcmd = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
BEGIN
		CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;

'

select @sqluser =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ACCOUNT LOGIN ALREADY EXISTS''
END

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: ACCOUNT USER ALREADY EXISTS ''

END

'


SELECT @sqlcmdTable = '


USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AccountRoot +''')
BEGIN
IF EXISTS(SELECT 1 FROM sys.objects where name = '''+ @TargetTable +''')
BEGIN

		GRANT '+ @Permission + ' ON [dbo].[' + @TargetTable +'] TO ['+ @AccountRoot +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to [' + @AccountRoot + '] on ' + @TargetDB  +' for ' + @TargetTable + '''
END
ELSE
BEGIN
		PRINT ''WARNING: STORED PROC DOES NOT EXISTS''


END
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''


END
'


IF @DryRun = 0
	BEGIN 
		EXEC ( @sqluser)
		EXEC (@sqlcmdTable) 
	END
ELSE
	BEGIN 
		PRINT ( @sqluser)
		PRINT (@sqlcmdTable)
	END



