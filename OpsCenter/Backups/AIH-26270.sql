DECLARE @sqluser VARCHAR(MAX)
DECLARE @sqlcmd VARCHAR(MAX)
DECLARE @sqlcmdObject VARCHAR(MAX)
DECLARE @sqlcmdObject2 VARCHAR(MAX)
DECLARE @sqlcmdrole VARCHAR(MAX)
DECLARE @sqlcmdValidation VARCHAR(MAX)
DECLARE @AppRole VARCHAR(100) = 'UIPA_APP_ACCESS' ---Name of Role Application Acroynm_APP_ACCESS 
DECLARE @TargetDB VARCHAR(100) = 'Unitrac' ---Database Name 
DECLARE @AccountRoot VARCHAR(100) = 'ELDREDGE_A\UIpath Test Robots' --User Account 
DECLARE @ObjectName VARCHAR(100) = 'RMO_Waive_PastDue_VerifyData_RPAProcess' --Object either Stored Proc/Table/etc.
DECLARE @TypeObject VARCHAR(10) = 'EX' ---lowest and most common access for stored proc is: EX and Tables is: SL
DECLARE @PermissionObject VARCHAR(100)
DECLARE @ObjectName2 VARCHAR(100) = '' --Object either Stored Proc/Table/etc.
DECLARE @TypeObject2 VARCHAR(10) = '' ---lowest and most common access for stored proc is: EX and Tables is: SL
DECLARE @PermissionObject2 VARCHAR(100)
DECLARE @DryRun INT = 0

SELECT @PermissionObject = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @TypeObject

SELECT @PermissionObject2 = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @TypeObject2


IF @TargetDB <> ''
  BEGIN
      IF @AppRole <> ''
        BEGIN
            SELECT @sqlcmd = 'USE [' + @TargetDB
                             + ']

DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''
                             + @AppRole + ''')
BEGIN
		CREATE ROLE [' + @AppRole + ']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;
'
        END

      IF @AccountRoot <> ''
        BEGIN
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
		PRINT ''WARNING: ACCOUNT LOGIN ALREADY EXISTS''
END

USE [' + @TargetDB
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
		PRINT ''WARNING: ACCOUNT USER ALREADY EXISTS ''

END

'
        END

      IF @AccountRoot <> ''
         AND @AppRole <> ''
        BEGIN
            --Create Role
            SELECT @sqlcmdrole = ' USE [' + @TargetDB + ']
IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''
                                 + @AccountRoot + ''' AND rp.name =''' + @AppRole
                                 + ''')

BEGIN
		
		ALTER ROLE [' + @AppRole + ']  ADD MEMBER ['
                                 + @AccountRoot + '] ;
		PRINT ''SUCCESS: ' + @AppRole
                                 + ' GIVEN TO ' + @AccountRoot
                                 + ' ''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ' + @AppRole
                                 + ' PERMISSION TO ' + @AccountRoot + ' ALREADY EXISTS''
END'
        END

      IF @ObjectName <> ''
         AND @PermissionObject <> ''
        BEGIN
            SELECT @sqlcmdObject = '
USE [' + @TargetDB
                               + ']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                               + @ObjectName + '''AND TYPE = ''' + @TypeObject
                               + ''' AND USER_NAME(grantee_principal_id) ='''
                               + @AppRole + ''')
BEGIN
		GRANT ' + @PermissionObject
                               + ' ON [dbo]. [' + @ObjectName + '] TO  ['
                               + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                               + @PermissionObject + ' was issued to ' + @AppRole
                               + ' on ' + @TargetDB + ' for ' + @ObjectName + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END'
        END


      IF @ObjectName2 <> ''
         AND @PermissionObject2 <> ''
        BEGIN
            SELECT @sqlcmdObject2 = '
USE [' + @TargetDB
                               + ']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                               + @ObjectName2 + '''AND TYPE = ''' + @TypeObject2
                               + ''' AND USER_NAME(grantee_principal_id) ='''
                               + @AppRole + ''')
BEGIN
		GRANT ' + @PermissionObject2
                               + ' ON [dbo]. [' + @ObjectName2 + '] TO  ['
                               + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                               + @PermissionObject2 + ' was issued to ' + @AppRole
                               + ' on ' + @TargetDB + ' for ' + @ObjectName2 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
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
	  EXEC ( @sqluser)
	  EXEC (@sqlcmdObject)
	  EXEC (@sqlcmdObject2)
	  EXEC (@sqlcmdrole)
	  EXEC ( @sqlcmdValidation)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
	  PRINT ( @sqluser )
	  PRINT ( @sqlcmdObject )
	  PRINT ( @sqlcmdObject2 )
	  PRINT ( @sqlcmdrole )
	  PRINT ( @sqlcmdValidation )
  END 
