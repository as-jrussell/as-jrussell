DECLARE @sqlrole VARCHAR(MAX)
DECLARE @sqluser VARCHAR(MAX)
DECLARE @sqlcmdPermission1 VARCHAR(MAX)
DECLARE @sqlcmdPermission2 VARCHAR(MAX)
DECLARE @AppRole VARCHAR(100) = 'SWINDS_APP_ACCESS'
DECLARE @TargetDB VARCHAR(100) = 'UTL'
DECLARE @TargetTable1 VARCHAR(100) = 'PROCESS_DEFINITION'
DECLARE @AccountRoot VARCHAR(100) = 'solarwinds_sql'
DECLARE @Type VARCHAR(10) = 'SL'
DECLARE @Permission VARCHAR(100)
DECLARE @Type2 VARCHAR(10) = 'UP'
DECLARE @Permission2 VARCHAR(100)
DECLARE @DryRun INT = 0

SELECT @Permission = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @Type

SELECT @Permission2 = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @Type2

SELECT @sqlrole = 'USE ' + @TargetDB
                  + '; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''
                  + @AppRole + ''')
BEGIN
		CREATE ROLE [' + @AppRole + ']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;'

SELECT @sqlcmdPermission1 = '
USE ' + @TargetDB
                            + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                            + @TargetTable1 + '''AND TYPE = ''' + @TYPE
                            + ''' AND USER_NAME(grantee_principal_id) ='''
                            + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                            + ' ON [dbo]. [' + @TargetTable1 + '] TO  ['
                            + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                            + @Permission + ' was issued to ' + @AppRole
                            + ' on ' + @TargetDB + ' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission2 = '
USE ' + @TargetDB
                            + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                            + @TargetTable1 + '''AND TYPE = ''' + @TYPE2
                            + ''' AND USER_NAME(grantee_principal_id) ='''
                            + @AppRole + ''')
BEGIN
		GRANT ' + @Permission2
                            + ' ON [dbo]. [' + @TargetTable1 + '] TO  ['
                            + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                            + @Permission2 + ' was issued to ' + @AppRole
                            + ' on ' + @TargetDB + ' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqluser = '

USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''
                  + @AccountRoot + ''')
BEGIN
		CREATE USER [' + @AccountRoot
                  + '] FOR LOGIN [' + @AccountRoot
                  + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
		DROP USER [' + @AccountRoot
                  + '] 
		CREATE USER [' + @AccountRoot
                  + '] FOR LOGIN [' + @AccountRoot
                  + '] 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = ''' + @AccountRoot
                  + ''')

BEGIN
		
		ALTER ROLE [' + @AppRole + ']  ADD MEMBER ['
                  + @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END
'

IF @DryRun = 0
  BEGIN
      EXEC (@sqlrole)

      EXEC (@sqlcmdPermission1)

      EXEC (@sqlcmdPermission2)

      EXEC (@sqluser)
  END
ELSE
  BEGIN
      PRINT ( @sqlrole )

      PRINT ( @sqlcmdPermission1 )

      PRINT ( @sqlcmdPermission2 )

      PRINT ( @sqluser )
  END 
