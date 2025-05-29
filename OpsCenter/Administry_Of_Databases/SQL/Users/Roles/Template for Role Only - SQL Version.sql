DECLARE @sqluser VARCHAR(2000)
DECLARE @sqluser2 VARCHAR(2000)
DECLARE @sqlcmd VARCHAR(2000)
DECLARE @ObjectPermission VARCHAR(2000)
DECLARE @sqlcmdValidation VARCHAR(2000)
DECLARE @Permission VARCHAR(20)
DECLARE @AppRole VARCHAR(30) = ''
DECLARE @TargetDB VARCHAR(100) = ''
DECLARE @AccountRoot VARCHAR(100) = ''
DECLARE @Object VARCHAR(50) = ''
DECLARE @Password VARCHAR(100) = ''
DECLARE @Type VARCHAR(2) = ''
DECLARE @DryRun INT = 0

SELECT @Permission = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @Type

IF @TargetDB <> ''
  BEGIN
      IF @AppRole <> ''
        BEGIN
            SELECT @sqlcmd = 'USE [' + @TargetDB
                             + ']; DECLARE @sqlCMD varchar(1000) = '''';
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
        END

      IF @AppRole <> ''
         AND @Object <> ''
         AND @Type <> ''
        BEGIN
            SELECT @ObjectPermission = '
USE [' + @TargetDB
                                       + ']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                                       + @Object + '''AND TYPE = ''' + @TYPE
                                       + ''' AND USER_NAME(grantee_principal_id) ='''
                                       + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                                       + ' ON [dbo]. [' + @Object + '] TO  [' + @AppRole
                                       + '] 
	PRINT ''SUCCESS: GRANT ' + @Permission
                                       + ' was issued to ' + @AppRole + ' on ' + @TargetDB
                                       + 'on object name: ' + @Object + ' ''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END'
        END

      IF @AccountRoot <> ''
         AND @Password <> ''
        BEGIN
            SELECT @sqluser = ' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''
                              + @AccountRoot + ''')
BEGIN
		CREATE LOGIN ['
                              + @AccountRoot + '] WITH PASSWORD= '''
                              + @Password + ''', DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END
'
        END

      IF @AccountRoot <> ''
        BEGIN
            SELECT @sqluser2 = 'USE  [' + @TargetDB
                               + ']
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''
                               + @AccountRoot + ''')
BEGIN
		CREATE USER [' + @AccountRoot
                               + '] FOR LOGIN [' + @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
END

USE  ['
                               + @TargetDB + ']
IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''
                               + @AccountRoot + ''')

BEGIN
		
		ALTER ROLE [' + @AppRole
                               + ']  ADD MEMBER [' + @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER
		
		The password will need to be changed upon the first login the password is in CyberArk! 

		''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'
        END

      SELECT @sqlcmdValidation = 'USE [' + @TargetDB
                                 + ']

select ''Server Login:'', DB_NAME()[Database Name], * from sys.server_principals
where name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%' + @AppRole
                                 + '%'')

select ''DB User:'',  DB_NAME()[Database Name], * from sys.database_principals 
where name  like ''%' + @AppRole
                                 + '%'' 

--Application Roles with Logins
select  ''User / Role:'', DB_NAME(), rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%' + @AppRole
                                 + '%''
	OR mp.name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%' + @AppRole
                                 + '%'')

--Tables that the Roles 
select ''Table that user has access to:'', OBJECT_NAME(major_id) [Object],  permission_name [Permission Type],  DB_NAME()[Database Name], USER_NAME(grantee_principal_id)[Role Name],
* FROM sys.database_permissions
where USER_NAME(grantee_principal_id) like ''%'
                                 + @AppRole + '%'''
  END

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
	  EXEC (@ObjectPermission)
	  EXEC ( @sqluser)
	  EXEC ( @sqluser2)
	  EXEC (@sqlcmdValidation)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
	  PRINT ( @ObjectPermission )
	  PRINT ( @sqluser )
	  PRINT ( @sqluser2 )
	  PRINT ( @sqlcmdValidation )
  END 
