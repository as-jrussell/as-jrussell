DECLARE @sqluser varchar(MAX)
DECLARE @sqluseradd varchar(MAX)
DECLARE @sqllogin varchar(MAX)
DECLARE @sqlvalidation varchar(MAX)
DECLARE @sqlvalidationDB varchar(MAX)
DECLARE @SQL_StoredProc varchar(max)
DECLARE @DefaultDB varchar(100)
DECLARE @AppRole varchar(100) = ''
DECLARE @ServerRole varchar(100) 
DECLARE @DatabaseName varchar(100) = '' 
DECLARE @AccountRoot varchar(100) = ''
DECLARE @WhatIf BIT = 1
DECLARE @SQLStoredProc VARCHAR(1) =1 ---Only needed if the AD account starts with SQL_ 

select top 1 @DefaultDB =
 CASE WHEN ServerLocation = 'AWS-RDS'  THEN   'master'
ELSE   'tempdb' END
 from dba.info.instance

select @sqluser =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=['+@DefaultDB+']
		PRINT ''SUCCESS: LOGIN ['+  @AccountRoot + '] CREATED''
END
	ELSE 
BEGIN
			PRINT ''WARNING: USER LOGIN: ['+ @AccountRoot +'] ALREADY EXISTS''
END'

IF @ServerRole <> ''
BEGIN 
select @sqluseradd ='
IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type
				from sys.server_role_members dm
				join  sys.server_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.server_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''' AND  rp.name ='''+ @ServerRole +''')

BEGIN
		
		ALTER SERVER ROLE ['+ @ServerRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION ['+ @ServerRole +']  GIVEN TO LOGIN: ['+ @AccountRoot +']''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS on LOGIN: ['+ @AccountRoot +']''
END				
				
				
				'

END


IF @DatabaseName <> '' AND @SQLStoredProc <> 0
BEGIN 
select @sqllogin ='
USE ['+ @DatabaseName +']
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
			PRINT ''SUCCESS: USER ['+  @AccountRoot + '] CREATED!!''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ['+ @AccountRoot +'] ALREADY EXISTS!!''
END



IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION ['+ @AppRole +']  GIVEN TO USER: '+ @AccountRoot +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS on user: ['+ @AccountRoot +']''
END'




select  @sqlvalidationDB ='

USE ['+ @DatabaseName +']
select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''''





END 


IF @SQLStoredProc = 0
BEGIN 
IF @WhatIf = 0
BEGIN 
select @SQL_StoredProc ='
EXEC [DBA].[deploy].[SetDatabaseMembership] @DryRun = '+@SQLStoredProc+'
EXEC [DBA].[deploy].[SetDatabasePermission] @DryRun = '+@SQLStoredProc+''
END
ELSE 
BEGIN 
select @SQL_StoredProc ='
EXEC [DBA].[deploy].[SetDatabaseMembership] @DryRun = 1
EXEC [DBA].[deploy].[SetDatabasePermission] @DryRun = 1'
END
END 



select @sqlvalidation ='
USE [master]

select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type
				from sys.server_role_members dm
				join  sys.server_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.server_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot+''''


IF @WhatIf = 0
	BEGIN 
	
		EXEC ( @sqluser)
		EXEC ( @sqluseradd)
		EXEC ( @sqllogin)
		EXEC (@SQL_StoredProc) 
		EXEC ( @sqlvalidation)
		EXEC ( @sqlvalidationDB)
	END
ELSE
	BEGIN 
		PRINT ( @sqluser)
		PRINT ( @sqluseradd)
		PRINT ( @sqllogin)
		EXEC (@SQL_StoredProc) 
		PRINT ( @sqlvalidation)
		PRINT ( @sqlvalidationDB)
	END



