DECLARE @sqlcmd varchar(MAX)
DECLARE @AccountRoot varchar(100) = 'ELDREDGE_A\svc_idnw_utrc_prd01'
DECLARE @DatabaseName varchar(100) = 'Unitrac' 
DECLARE @AppRole varchar(100) = 'SAIL_APP_ACCESS'
DECLARE @AccountRootAdd varchar(100) = 'IDUTUser'
DECLARE @Password varchar(100) = ''
DECLARE @DryRun INT = 1

   SELECT @sqlcmd = 'USE ['+ @DatabaseName +']


IF EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  DROP MEMBER ['+  @AccountRoot + '] ;

		PRINT ''SUCCESS: USER DROPPED FROM ROLE''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER WAS NOT REMOVED FROM ROLE OR DOES NOT EXIST!'' 
END

USE ['+ @DatabaseName +']
IF EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		DROP USER ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER DROPPED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER NOT DROPPED OR DOES NOT EXIST''
		
END

 USE [master]

IF EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		DROP LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: LOGIN DROPPED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: LOGIN NOT DROPPED OR DOES NOT EXIST!''
END

USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRootAdd +''')
BEGIN
		CREATE LOGIN ['+  @AccountRootAdd + '] WITH PASSWORD= '''+  @Password + ''', DEFAULT_DATABASE=[MASTER], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END

USE ['+ @DatabaseName +']
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRootAdd +''')
BEGIN
		CREATE USER ['+  @AccountRootAdd + '] FOR LOGIN ['+  @AccountRootAdd + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
		DROP USER ['+  @AccountRootAdd + '] 
		CREATE USER ['+  @AccountRootAdd + '] FOR LOGIN ['+  @AccountRootAdd + '] 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRootAdd +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRootAdd + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER
		''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'


IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )

  END 



