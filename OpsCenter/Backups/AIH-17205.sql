DECLARE @sqluser_iqq_live varchar(MAX)
DECLARE @sqluser_iqq_common varchar(MAX)
DECLARE @AppRole varchar(100) = 'SAIL_APP_ACCESS'
DECLARE @AppRole2 varchar(100) = 'db_datareader'
DECLARE @AppRole3 varchar(100) = 'db_datawriter'
DECLARE @TargetDB varchar(100) = 'IQQ_LIVE' 
DECLARE @TargetDB2 varchar(100) = 'IQQ_COMMON' 
DECLARE @AccountRoot varchar(100) = 'ELDREDGE_A\svc_idnw_iqqq_prd01'
DECLARE @Type varchar(10) = 'EX'
DECLARE @Permission varchar(100) 
DECLARE @Type2 varchar(10) = 'SL'
DECLARE @Permission2 varchar(100) 
DECLARE @DryRun INT = 1



SELECT @Permission = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type 
SELECT @Permission2 = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type2 

select @sqluser_iqq_live =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
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
		
		
		ALTER ROLE ['+ @AppRole2 +']  ADD MEMBER ['+  @AccountRoot + '] ;
		ALTER ROLE ['+ @AppRole3 +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'





select @sqluser_iqq_common =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
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
		
		
		ALTER ROLE ['+ @AppRole2 +']  ADD MEMBER ['+  @AccountRoot + '] ;
		ALTER ROLE ['+ @AppRole3 +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'








IF @DryRun = 0
  BEGIN
  
      EXEC ( @sqluser_iqq_live)
      EXEC ( @sqluser_iqq_common)
  END
ELSE
  BEGIN
  
      PRINT ( @sqluser_iqq_live )
      PRINT ( @sqluser_iqq_common )
  END 
