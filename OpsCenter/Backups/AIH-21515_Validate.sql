DECLARE @DatabaseName nvarchar(100) = 'UNITRAC' 
DECLARE @Acct nvarchar(100) = 'MSGP_APP_ACCESS'
DECLARE @sqlcmd nvarchar(MAX)
DECLARE @DryRun INT = 0

--SELECT @DBNAME = name from sys.databases WHERE database_id in (SELECT max(database_id) from sys.databases)

   SELECT @sqlcmd = 'USE ['+ @DatabaseName +']

select ''Server Login:'', DB_NAME()[Database Name], * from sys.server_principals
where name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%'+ @Acct  +'%'')

select ''DB User:'',  DB_NAME()[Database Name], * from sys.database_principals 
where name  like ''%'+ @Acct  +'%'' 

--Application Roles with Logins
select  ''User / Role:'', DB_NAME(), rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%'+ @Acct  +'%''
	OR mp.name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%'+ @Acct  +'%'')

--Tables that the Roles 
select ''Table that user has access to:'', OBJECT_NAME(major_id) [Object],  permission_name [Permission Type],  DB_NAME()[Database Name], USER_NAME(grantee_principal_id)[Role Name],
* FROM sys.database_permissions
where USER_NAME(grantee_principal_id) like ''%'+ @Acct  +'%''' 




IF @DatabaseName  ='?'
BEGIN 
IF @DryRun = 0
  BEGIN
  
		exec sp_MSforeachdb @sqlcmd 
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd + '
	  
	  exec sp_MSforeachdb @sqlcmd' )
  END
  END 
  ELSE 
  BEGIN 
IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
		
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd + '
	  
	  exec @sqlcmd')
  END

  END

