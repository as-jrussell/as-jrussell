DECLARE @sqluser varchar(MAX) 
DECLARE @AppRole varchar(30) = 'db_datareader'
DECLARE @TargetDB varchar(100) = 'IVOS_Tools' 
DECLARE @AccountRoot varchar(100) = 'ELDREDGE_A\SQL_IVOS_Development_Team'
DECLARE @DryRun INT = 0


select @sqluser ='

USE '+ @TargetDB +'



IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		CREATE USER ['+  @AccountRoot + ']  FOR LOGIN ['+  @AccountRoot + '] WITH DEFAULT_SCHEMA=[dbo];
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: CREATED USER''

	
END

ELSE IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''' AND rp.name = '''+ @AppRole +''')	

BEGIN
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''

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








