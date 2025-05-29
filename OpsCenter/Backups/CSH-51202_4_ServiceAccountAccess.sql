DECLARE @sqluser VARCHAR(MAX)
DECLARE @sqlcmd VARCHAR(MAX)
DECLARE @sqlcmd2 VARCHAR(MAX)
DECLARE @sqlcmd3 VARCHAR(MAX)
DECLARE @AppRole VARCHAR(100) = 'SAIL_APP_ACCESS'
DECLARE @AppRole2 VARCHAR(100) = 'db_datareader'
DECLARE @AppRole3 VARCHAR(100) = 'db_datawriter'
DECLARE @TargetDB VARCHAR(100) = 'IVOS_tools'
DECLARE @StoredProc1 VARCHAR(100) = 'CREATE_IVOS_USER'
DECLARE @StoredProc2 VARCHAR(100) = 'DISABLE_IVOS_USER'
DECLARE @AccountRoot VARCHAR(100) = 'IVOSAuditTest'
DECLARE @Type VARCHAR(10) = 'EX'
DECLARE @Permission VARCHAR(100)
DECLARE @DryRun INT = 1

SELECT @Permission = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @Type


SELECT @sqlcmd = 'USE [' + @TargetDB
                  + ']; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''
                 + @AppRole + ''')
BEGIN
		CREATE ROLE [' + @AppRole
                 + ']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ' + @AppRole + ' ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;

'

SELECT @sqlcmd2 = '
USE [' + @TargetDB
                  + ']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @StoredProc1 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @StoredProc1 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + ' for ' + @StoredProc1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd3 = '


USE [' + @TargetDB
                  + ']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @StoredProc2 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @StoredProc2 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + ' for ' + @StoredProc2 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqluser = ' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''
                  + @AccountRoot + ''')
BEGIN
		CREATE LOGIN ['
                  + @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END

USE [' + @TargetDB
                  + ']
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
		ALTER ROLE [' + @AppRole2
                  + ']  ADD MEMBER [' + @AccountRoot
                  + '] ;
		ALTER ROLE [' + @AppRole3
                  + ']  ADD MEMBER [' + @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
	  EXEC ( @SQLcmd2)
      EXEC ( @SQLcmd3)
      EXEC ( @sqluser)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
      PRINT ( @SQLcmd2 )
      PRINT ( @SQLcmd3 )
      PRINT ( @sqluser )
  END 
