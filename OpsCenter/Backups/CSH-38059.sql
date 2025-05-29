DECLARE @sqlcmd varchar(MAX)
DECLARE @AppRole varchar(100) = 'DataStore_APP_ACCESS'
DECLARE @TargetDB varchar(100) = 'QCModule' 
DECLARE @TargetTable varchar(100) = 'PROCESS_DEFINITION' 
DECLARE @Type varchar(10) = 'SL'
DECLARE @Type2 varchar(10) = 'UP'
DECLARE @Type3 varchar(10) = 'IN'
DECLARE @Permission varchar(100)
DECLARE @Permission2 varchar(100)
DECLARE @Permission3 varchar(100) 
DECLARE @DryRun INT = 0 

SELECT @Permission = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type 
SELECT @Permission2 = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type2
SELECT @Permission3 = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type3


SELECT @sqlcmd = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END


USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable + '''AND TYPE = '''+ @TYPE3  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission3 + ' ON [dbo]. [' + @TargetTable +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission3 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'



IF @DryRun = 0
	BEGIN 
		EXEC ( @SQLcmd)
	END
ELSE
	BEGIN 
		PRINT ( @SQLcmd)
	END



