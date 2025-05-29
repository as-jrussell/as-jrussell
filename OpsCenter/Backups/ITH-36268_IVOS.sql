---SQLSSTGAWRD02.aws.local

DECLARE @sqluser varchar(MAX)
DECLARE @AppRole varchar(30) = 'db_datareader'
DECLARE @TargetDB varchar(100) = 'IVOS' 
DECLARE @AccountRoot varchar(100) = 'EccdbAppIntegrationStg'
DECLARE @Password varchar(100) = ''
DECLARE @DryRun INT = 1



select @sqluser =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] WITH PASSWORD= '''+  @Password + ''', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END

USE ['+ @TargetDB +']
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
		
		ALTER ROLE ['+ @AppRole +'] ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER
		
		The password will need to be changed upon the first login the password is in CyberArk! 

		''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'

IF @DryRun = 0 
BEGIN 
	EXEC ( @sqluser)
END

	ELSE
BEGIN 

	PRINT ( @sqluser)
END








