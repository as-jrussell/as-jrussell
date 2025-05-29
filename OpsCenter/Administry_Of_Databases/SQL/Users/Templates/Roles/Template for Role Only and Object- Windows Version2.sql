DECLARE @sqluser VARCHAR(MAX)
DECLARE @sqlcmd VARCHAR(MAX)
DECLARE @sqlcmdSP VARCHAR(MAX)
DECLARE @sqlcmdrole VARCHAR(MAX)
DECLARE @sqlcmdValidation VARCHAR(MAX)
DECLARE @AppRole VARCHAR(100) = 'UIPA_APP_ACCESS' ---Name of Role Application Acroynm_APP_ACCESS 
DECLARE @TargetDB VARCHAR(100) = 'Unitrac' ---Database Name 
DECLARE @AccountRoot VARCHAR(100) =  'ELDREDGE_A\UIpath Test Robots' --User Account 
DECLARE @ObjectName VARCHAR(100) = 'SaveLenderPayeeCodeFile' --Object either Stored Proc/Table/etc.
DECLARE @TypeSP VARCHAR(10) = 'EX' ---lowest and most common access for stored proc is: EX and Tables is: SL
DECLARE @ObjectName2 VARCHAR(100) = 'SaveAddress' --Object either Stored Proc/Table/etc.
DECLARE @TypeSP2 VARCHAR(10) = 'EX' ---lowest and most common access for stored proc is: EX and Tables is: SL
DECLARE @ObjectName3 VARCHAR(100) = 'LENDER' --Object either Stored Proc/Table/etc.
DECLARE @TypeSP3 VARCHAR(10) = 'SL' ---lowest and most common access for stored proc is: EX and Tables is: SL
DECLARE @PermissionSP VARCHAR(100)
DECLARE @PermissionSP2 VARCHAR(100)
DECLARE @PermissionSP3 VARCHAR(100)
DECLARE @DryRun INT = 0

SELECT @PermissionSP = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @TypeSP

SELECT @PermissionSP2 = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @TypeSP2

SELECT @PermissionSP3 = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @TypeSP3

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

ALTER USER [' + @AccountRoot
                              + ']  WITH DEFAULT_SCHEMA=[dbo]


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
            SELECT @sqlcmdrole = ' 
USE [' + @TargetDB
                               + ']
IF EXISTS(select 1 from sys.objects where name =  ''' + @ObjectName + ''')
BEGIN
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                               + @ObjectName + '''AND TYPE = ''' + @TypeSP
                               + ''' AND USER_NAME(grantee_principal_id) ='''
                               + @AppRole + ''')
BEGIN
		GRANT ' + @PermissionSP
                               + ' ON [dbo]. [' + @ObjectName + '] TO  ['
                               + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                               + @PermissionSP + ' was issued to ' + @AppRole
                               + ' on ' + @TargetDB + ' for ' + @ObjectName + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
END

'
        END

      IF @ObjectName <> ''
         AND @PermissionSP <> ''
        BEGIN
            SELECT @sqlcmdSP = '
USE [' + @TargetDB
                               + ']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                               + @ObjectName + '''AND TYPE = ''' + @TypeSP
                               + ''' AND USER_NAME(grantee_principal_id) ='''
                               + @AppRole + ''')
BEGIN
		GRANT ' + @PermissionSP
                               + ' ON [dbo]. [' + @ObjectName + '] TO  ['
                               + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                               + @PermissionSP + ' was issued to ' + @AppRole
                               + ' on ' + @TargetDB + ' for ' + @ObjectName + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END





IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                               + @ObjectName2 + '''AND TYPE = ''' + @TypeSP2
                               + ''' AND USER_NAME(grantee_principal_id) ='''
                               + @AppRole + ''')
BEGIN
		GRANT ' + @PermissionSP2
                               + ' ON [dbo]. [' + @ObjectName2 + '] TO  ['
                               + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                               + @PermissionSP2 + ' was issued to ' + @AppRole
                               + ' on ' + @TargetDB + ' for ' + @ObjectName2 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END


IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                               + @ObjectName3 + '''AND TYPE = ''' + @TypeSP3
                               + ''' AND USER_NAME(grantee_principal_id) ='''
                               + @AppRole + ''')
BEGIN
		GRANT ' + @PermissionSP3
                               + ' ON [dbo]. [' + @ObjectName3 + '] TO  ['
                               + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                               + @PermissionSP3 + ' was issued to ' + @AppRole
                               + ' on ' + @TargetDB + ' for ' + @ObjectName3 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'
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
select ''Table that user has access to:'', OBJECT_NAME(major_id) [Object],  permission_name [Permission Type],  DB_NAME()[Database Name], USER_NAME(grantee_principal_id)[Role Name]
 FROM sys.database_permissions
where USER_NAME(grantee_principal_id) like ''%'+ @AppRole  +'%''

IF (select COUNT(*)
From sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  = '''+ @AppRole  +''') >= 1
BEGIN 
select  CONCAT(''This role: '',mp.name ,'' has database role as '',rp.name ,''on to this database: '',DB_NAME())
From sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  = '''+ @AppRole  +'''
END'
  END

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
	  EXEC ( @sqluser)
	  EXEC (@sqlcmdSP)
	  EXEC (@sqlcmdrole)
	  EXEC ( @sqlcmdValidation)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
	  PRINT ( @sqluser )
	  PRINT ( @sqlcmdSP )
	  PRINT ( @sqlcmdrole )
	  PRINT ( @sqlcmdValidation )
 END 
