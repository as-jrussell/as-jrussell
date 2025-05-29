DECLARE @sqluser varchar(MAX)
DECLARE @sqlcmdValidation varchar(MAX)
DECLARE @AppRole varchar(30) = ''
DECLARE @TargetDB varchar(100) = '' 
DECLARE @AccountRoot varchar(100) = ''
DECLARE @DryRun INT = 0

IF @TargetDB <> ''
BEGIN 
IF @AccountRoot <> ''
BEGIN 

select @sqluser =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ACCOUNT LOGIN ALREADY EXISTS''
END

USE ['+ @TargetDB +']
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: ACCOUNT USER ALREADY EXISTS ''

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
END



IF @DryRun = 0
	BEGIN 
		EXEC ( @sqluser)
		EXEC ( @sqlcmdValidation)
	END
ELSE
	BEGIN 
		PRINT ( @sqluser)
		PRINT ( @sqlcmdValidation )
	END











