DECLARE @sqluser varchar(MAX)
DECLARE @sqlcmd varchar(MAX)
DECLARE @sqlTable varchar(MAX)
DECLARE @AppRole varchar(100) = 'Osprey_APP_ACCESS'
DECLARE @TargetDB varchar(100) = 'OCR' 
DECLARE @TargetTable1 varchar(100) = 'OutputImages' 
DECLARE @AccountRoot varchar(100) = 'ELDREDGE_A\magarwal'
DECLARE @Type varchar(10) = 'SL'
DECLARE @Permission varchar(100) 
DECLARE @DryRun INT = 0 

SELECT @Permission = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type 



SELECT @sqlcmd = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
BEGIN
		CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;

'



select @sqluser =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
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
		
		ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'


SELECT @sqlTable = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AccountRoot +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo].[' + @TargetTable1 +'] TO ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


IF @DryRun = 0
	BEGIN 
		EXEC ( @SQLcmd)
		EXEC ( @sqluser)
		EXEC ( @sqlTable)
	END
ELSE
	BEGIN 
		PRINT ( @SQLcmd)
		PRINT ( @sqluser)
	    PRINT ( @sqlTable)
	END









	--Per Database
--EXECUTE AS user = ''
use master
--Per Instance
EXECUTE AS Login = 'ELDREDGE_A\magarwal'

SELECT CURRENT_USER  



SELECT SYSTEM_USER


  --REVERT;

  use OCR
  select top 5 * from ocr.dbo.OutputImages

  select top 5 * from ADDRESS


  use DBA