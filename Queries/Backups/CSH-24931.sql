DECLARE @sqluser varchar(MAX)
DECLARE @sqlcmd varchar(MAX)
DECLARE @sqlcmd2 varchar(MAX)
DECLARE @sqlcmd3 varchar(MAX)
DECLARE @sqlcmd4 varchar(MAX)
DECLARE @sqlcmd5 varchar(MAX)
DECLARE @sqlcmd6 varchar(MAX)
DECLARE @sqlcmd7 varchar(MAX)
DECLARE @sqlcmd8 varchar(MAX)
DECLARE @sqlcmd9 varchar(MAX)
DECLARE @AppRole varchar(100) = 'PIMS_APP_ACCESS'
DECLARE @TargetDB varchar(100) = 'UTL' 
DECLARE @TargetTable1 varchar(100) = 'LENDER' 
DECLARE @TargetTable2 varchar(100) = 'LOAN' 
DECLARE @TargetTable3 varchar(100) = 'ADDRESS' 
DECLARE @TargetTable4 varchar(100) = 'PROPERTY' 
DECLARE @TargetTable5 varchar(100) = 'REQUIRED_COVERAGE' 
DECLARE @TargetTable6 varchar(100) = 'OWNER_POLICY' 
DECLARE @TargetTable7 varchar(100) = 'OWNER' 
DECLARE @TargetTable8 varchar(100) = 'POLICY_COVERAGE' 
DECLARE @TargetFunction1 varchar(100) = 'GetCurrentCoverageUTL' 
DECLARE @AccountRoot varchar(100) = 'PIMSAppService'
DECLARE @Type varchar(10) = 'SL'
DECLARE @Permission varchar(100) 

SELECT @Permission = permission_name  FROM UTL.sys.database_permissions WHERE type = @Type 

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


USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd2 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable2 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable2 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd3 = '


USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable3 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable3 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd4 = '

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable4 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable4 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd5 = '

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable5 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable5 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd6 = 'USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable6 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable6 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd7 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable7 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable7 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd9 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable8 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable8 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'



SELECT @sqlcmd8 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetFunction1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetFunction1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


select @sqluser =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] WITH PASSWORD= '''+  'NewPassword1234!!' +''' MUST_CHANGE, DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END

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
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER ''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'


EXEC ( @SQLcmd)
EXEC ( @SQLcmd2)
EXEC ( @SQLcmd3)
EXEC ( @SQLcmd4)
EXEC ( @SQLcmd5)
EXEC ( @SQLcmd6)
EXEC ( @SQLcmd7)
EXEC ( @SQLcmd8)
EXEC ( @SQLcmd9)
EXEC ( @sqluser)











