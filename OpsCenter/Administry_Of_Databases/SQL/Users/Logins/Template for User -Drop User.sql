DECLARE @sqluser varchar(MAX) 
DECLARE @AppRole1 varchar(30) = 'DB_DATAREADER'
DECLARE @AppRole2 varchar(30) = 'DB_DATAWRITER'
DECLARE @TargetDB varchar(100) = '' 
DECLARE @AccountRoot varchar(100) = ''


DECLARE @DryRun INT = 0


select @sqluser ='

USE ['+ @TargetDB +']



IF EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		ALTER ROLE ['+ @AppRole1 +']  DROP MEMBER ['+  @AccountRoot + '] ;
		ALTER ROLE ['+ @AppRole2 +']  DROP MEMBER ['+  @AccountRoot + '] ;
		DROP USER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: USER DROPPED''	
END
ELSE
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY DROPPED'' 
END'

IF @DryRun = 0 
BEGIN 
	EXEC ( @sqluser)
END

	ELSE
BEGIN 
	PRINT ( @sqluser)
END








