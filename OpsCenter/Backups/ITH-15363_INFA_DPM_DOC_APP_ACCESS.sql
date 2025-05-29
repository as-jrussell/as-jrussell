DECLARE @sqlcmd varchar(MAX) 
DECLARE @AppRole varchar(100) = 'INFA_DPM_DOC_APP_ACCESS'
DECLARE @TargetDB varchar(100) = 'DPM_DOC' 
DECLARE @AccountRoot varchar(100) = 'INFA_DPM_DOC'



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
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetDB + '''AND TYPE = ''CO'' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT CONNECT TO  ['+ @AppRole +'] 
		PRINT ''SUCCESS: GRANT CONNECT  was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetDB + '''AND TYPE = ''CRTB'' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT CREATE TABLE TO  ['+ @AppRole +'] 
		PRINT ''SUCCESS: GRANT CREATE TABLE  was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END


USE [master]

IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] WITH PASSWORD= '''+  @AccountRoot + ''' MUST_CHANGE, DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
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
		PRINT ''WARNING: USER ALREADY EXISTS''
END

IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where rp.name = '''+ @AccountRoot +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS''
END
'

EXEC ( @SQLcmd)
--PRINT ( @SQLcmd)


