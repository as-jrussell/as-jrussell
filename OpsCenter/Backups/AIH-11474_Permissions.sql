--DECLARE @tableupdate varchar(MAX) 
DECLARE @sqlpermissions varchar(MAX) 
DECLARE @AppRole varchar(100) = 'IDPM_APP_ACCESS'
DECLARE @TargetDB varchar(100) ='^'
DECLARE @Target varchar(100) ='?'
DECLARE @Type varchar(10) = 'SL'
DECLARE @Permission varchar(100) 
DECLARE @DryRun INT = 1 

SELECT @Permission = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type 




IF @DryRun = 1
BEGIN 

SET @sqlpermissions = 'USE '+ @TargetDB +'; EXEC sp_MSforeachtable @command1 ="
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @Target + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
GRANT '+  @Permission + ' ON ' + @Target +' TO  ['+ @AppRole +']
	PRINT ''SUCCESS: GRANT SELECT added on '+ @Target +' and was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END"'

		EXEC sp_msforeachdb  @command1 =@sqlpermissions, @replacechar = '^'
	END
ELSE
	BEGIN 
		PRINT ( @sqlpermissions)
	END

	--303