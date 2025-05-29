DECLARE @sqlcmdSP varchar(MAX)
DECLARE @sqlcmd2 varchar(MAX)
DECLARE @sqlcmd3 varchar(MAX)
DECLARE @sqlcmd4 varchar(MAX)
DECLARE @sqlcmdValidation varchar(MAX)
DECLARE @AppRole varchar(100) = 'SWINDS_APP_ACCESS'
DECLARE @TargetDB varchar(100) = 'PRL_ALLIEDSYS_PROD' 
DECLARE @StoredProc varchar(100) = '' 
DECLARE @sqlcmd varchar(MAX)
DECLARE @TargetTable1 varchar(100) = 'PROCESS_LOG' 
DECLARE @TargetTable2 varchar(100) = '' 
DECLARE @Type varchar(10) = 'SL'
DECLARE @Permission varchar(100) 
DECLARE @Type2 varchar(10) = ''
DECLARE @PermissionSP varchar(100) 
DECLARE @TypeSP varchar(10) = ''
DECLARE @Permission2 varchar(100) 
DECLARE @DryRun INT = 1

SELECT @Permission = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type 
SELECT @Permission2 = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type2 
SELECT @PermissionSP = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @TypeSP

IF @StoredProc  <> ''
BEGIN 
SELECT @sqlcmdSP = '
USE ['+ @TargetDB +']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @StoredProc + '''AND TYPE = '''+ @TypeSP  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @PermissionSP + ' ON [dbo]. [' + @StoredProc +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @PermissionSP +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @StoredProc + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'
END 


IF @TargetTable1  <> '' AND @Permission <> ''
BEGIN 
SELECT @sqlcmd = '
USE ['+ @TargetDB +']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

END

IF @TargetTable2  <> '' AND @Permission <> ''
BEGIN 
SELECT @sqlcmd2 = '


USE ['+ @TargetDB +']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable2 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable2 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable2 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'
END

IF @TargetTable1  <> '' AND @Permission2 <> ''
BEGIN 
SELECT @sqlcmd3 = '
USE ['+ @TargetDB +']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'
END

IF @TargetTable2  <> '' AND @Permission2 <> ''
BEGIN 
SELECT @sqlcmd4 = '


USE ['+ @TargetDB +']
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable2 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable2 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable2 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'
END


   SELECT @sqlcmdValidation = 'USE ['+ @TargetDB +']

select ''Server Login:'', DB_NAME()[Database Name], * from sys.server_principals
where name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%'+ @AppRole  +'%'')

select ''DB User:'',  DB_NAME()[Database Name], * from sys.database_principals 
where name  like ''%'+ @AppRole  +'%'' 

--Application Roles with Logins
select  ''User / Role:'', DB_NAME(), rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%'+ @AppRole  +'%''
	OR mp.name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%'+ @AppRole  +'%'')

--Tables that the Roles 
select ''Table that user has access to:'', OBJECT_NAME(major_id) [Object],  permission_name [Permission Type],  DB_NAME()[Database Name], USER_NAME(grantee_principal_id)[Role Name],
* FROM sys.database_permissions
where USER_NAME(grantee_principal_id) like ''%'+ @AppRole  +'%''' 




IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
	  EXEC ( @SQLcmd2)
	  EXEC ( @SQLcmd3)
	  EXEC ( @SQLcmd4)
      EXEC ( @sqlcmdSP)
	  EXEC ( @sqlcmdValidation)
	    
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
      PRINT ( @SQLcmd2 )
	  PRINT ( @SQLcmd3 )
      PRINT ( @SQLcmd4 )
      PRINT ( @sqlcmdSP )
      PRINT ( @sqlcmdValidation )
	  
  END 
