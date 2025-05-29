DECLARE @sqlrole varchar(MAX)
DECLARE @sqlrole2 varchar(MAX)
DECLARE @sqlrole3 varchar(MAX)
DECLARE @sqlrole4 varchar(MAX)
DECLARE @sqlrole5 varchar(MAX)
DECLARE @sqlcmdPermission1 varchar(MAX)
DECLARE @sqlcmdPermission2 varchar(MAX)
DECLARE @sqlcmdPermission3 varchar(MAX)
DECLARE @sqlcmdPermission4 varchar(MAX)
DECLARE @sqlcmdPermission5 varchar(MAX)
DECLARE @sqlcmdPermission6 varchar(MAX)
DECLARE @sqlcmdPermission7 varchar(MAX)
DECLARE @sqlcmdPermission8 varchar(MAX)
DECLARE @sqlcmdPermission9 varchar(MAX)
DECLARE @sqlcmdPermission10 varchar(MAX)
DECLARE @sqluser varchar(MAX)
DECLARE @AppRole varchar(100) = 'SWINDS_APP_ACCESS'
DECLARE @TargetDB varchar(100) = 'LIMC' 
DECLARE @TargetDB2 varchar(100) = 'VUT' 
DECLARE @TargetDB3 varchar(100) = 'QCModule' 
DECLARE @TargetDB4 varchar(100) = 'OspreyDashboard' 
DECLARE @TargetDB5 varchar(100) = 'OperationalDashboard' 
DECLARE @TargetTable1 varchar(100) = 'PROCESS_DEFINITION' 
DECLARE @TargetTable2 varchar(100) = 'lkuVINLookup' 
DECLARE @TargetTable3 varchar(100) = 'LIBatch' 
DECLARE @TargetTable4 varchar(100) = 'lilog' 
DECLARE @TargetTable5 varchar(100) = 'log' 
DECLARE @AccountRoot varchar(100) = 'solarwinds_sql'
DECLARE @Type varchar(10) = 'SL'
DECLARE @Permission varchar(100) 
DECLARE @Type2 varchar(10) = 'UP'
DECLARE @Permission2 varchar(100) 

SELECT @Permission = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type 
SELECT @Permission2 = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type2

SELECT @sqlrole = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
BEGIN
		CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;'



SELECT @sqlrole2 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
BEGIN
		CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;'



SELECT @sqlrole3 = 'USE '+ @TargetDB3 +'; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
BEGIN
		CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;'


SELECT @sqlrole4 = 'USE '+ @TargetDB4 +'; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
BEGIN
		CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;'


SELECT @sqlrole5 = 'USE '+ @TargetDB5 +'; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
BEGIN
		CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;'


SELECT @sqlcmdPermission1 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable5 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable5 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable5 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission2 = '
USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable4 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable4 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +' for ' + @TargetTable4 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission3 = '
USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable3 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable3 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +' for ' + @TargetTable3 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission4 = '
USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable2 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable2 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +' for ' + @TargetTable2 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission5 = '
USE '+ @TargetDB3 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB3  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission6 = '
USE '+ @TargetDB4 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB4  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission7 = '
USE '+ @TargetDB5 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB5  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'



SELECT @sqlcmdPermission8 = '
USE '+ @TargetDB3 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB3  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission9 = '
USE '+ @TargetDB4 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB4  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission10 = '
USE '+ @TargetDB5 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB5  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


select @sqluser ='

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
		DROP USER ['+  @AccountRoot + '] 
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END


USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
		DROP USER ['+  @AccountRoot + '] 
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END


USE '+ @TargetDB3 +'
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
		DROP USER ['+  @AccountRoot + '] 
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END



USE '+ @TargetDB4 +'
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
		DROP USER ['+  @AccountRoot + '] 
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END



USE '+ @TargetDB5 +'
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
		DROP USER ['+  @AccountRoot + '] 
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END
'















EXEC (@sqlrole)
EXEC (@sqlrole2)
EXEC (@sqlrole3)
EXEC (@sqlrole4)
EXEC (@sqlrole5)
EXEC (@sqlcmdPermission1)
EXEC (@sqlcmdPermission2)
EXEC (@sqlcmdPermission3)
EXEC (@sqlcmdPermission4)
EXEC (@sqlcmdPermission5)
EXEC (@sqlcmdPermission6)
EXEC (@sqlcmdPermission7)
EXEC (@sqlcmdPermission8)
EXEC (@sqlcmdPermission9)
EXEC (@sqlcmdPermission10)
EXEC (@sqluser)