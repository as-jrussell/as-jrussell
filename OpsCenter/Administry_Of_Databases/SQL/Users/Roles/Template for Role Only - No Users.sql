DECLARE @sqlcmd varchar(MAX)
DECLARE @AppRole varchar(100) = ''
DECLARE @TargetDB varchar(100) = '' 
DECLARE @AccountRoot varchar(100) = ''
DECLARE @Type varchar(10) = ''
DECLARE @Permission varchar(100) 
DECLARE @DryRun INT = 1 

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


IF @DryRun = 0
	BEGIN 
		EXEC ( @SQLcmd)
	END
ELSE
	BEGIN 
		PRINT ( @SQLcmd)
	END



