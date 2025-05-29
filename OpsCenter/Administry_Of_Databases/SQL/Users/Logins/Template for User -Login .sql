DECLARE @sqluser varchar(MAX)
DECLARE @cmd1 VARCHAR(500)
DECLARE @cmd2 VARCHAR(500)

DECLARE @AppRole varchar(30) = 'db_datawriter'--db_datareader, db_datawriter, db_owner (Only for SAs) 
DECLARE @TargetDB varchar(100) = '' 
DECLARE @AccountRoot varchar(100) = ''
DECLARE @Password varchar(100) = '' --- If there is a password then it is SQL account and if it not it is an AD account
DECLARE @DryRun INT = 1


IF @Password <> ''
BEGIN 
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
	
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +'] ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'
END
IF @Password IS NULL Or  @Password = ''
BEGIN 

select @sqluser =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[MASTER]
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
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER''
	
END



IF NOT EXISTS (select mp.name, rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''+ @AccountRoot +''' AND RP.NAME ='''+@AppRole+''')

BEGIN
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'

SET @cmd1='USE [?]  SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
          + @AccountRoot + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access]
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  = ''' + @AccountRoot
          + ''''
SET @cmd2='USE [?] 	SELECT DB_NAME() [DatabaseName], CONCAT(''The Account: '' ,USER_NAME(grantee_principal_id), '' has access to the table: '', 
OBJECT_NAME(major_id), '' with '' , permission_name, '' rights on '', DB_NAME(), '' database'' ) [Access]
FROM sys.database_permissions
where USER_NAME(grantee_principal_id) = '''
          + @AccountRoot + ''''

IF Object_id(N'tempdb..#1') IS NOT NULL
  DROP TABLE #1

CREATE TABLE #1
  (
     [databasename] VARCHAR(250),
     [Access]       VARCHAR(max)
  )

INSERT INTO #1
EXEC Sp_msforeachdb
  @cmd1

INSERT INTO #1
EXEC Sp_msforeachdb
  @cmd2

END

IF @DryRun = 0 
BEGIN 
	EXEC ( @sqluser)
	SELECT *
FROM   #1
order by databasename, Access asc
END

	ELSE
BEGIN 

	PRINT ( @sqluser)
	SELECT *
FROM   #1
order by databasename, Access asc
END








