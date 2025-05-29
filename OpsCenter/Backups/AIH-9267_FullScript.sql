DECLARE @sqluser varchar(MAX)
DECLARE @sqluser2 varchar(MAX)
DECLARE @sqlcmd varchar(MAX)
DECLARE @sqlcmd2 varchar(MAX)
DECLARE @sqlcmd3 varchar(MAX)
DECLARE @sqlcmd4 varchar(MAX)
DECLARE @sqlcmd5 varchar(MAX)
DECLARE @sqlcmd6 varchar(MAX)
DECLARE @sqlcmd7 varchar(MAX)
DECLARE @sqlcmd8 varchar(MAX)
DECLARE @sqlcmd9 varchar(MAX)
DECLARE @sqlcmd10 varchar(MAX)
DECLARE @sqlcmd11 varchar(MAX)
DECLARE @sqlcmd12 varchar(MAX)
DECLARE @sqlcmd13 varchar(MAX)
DECLARE @sqlcmd14 varchar(MAX)
DECLARE @sqlcmd15 varchar(MAX)
DECLARE @sqlcmdVUT1 varchar(MAX)
DECLARE @sqlcmdVUT2 varchar(MAX)
DECLARE @sqlcmdVUT3 varchar(MAX)
DECLARE @sqlcmdVUT4 varchar(MAX)
DECLARE @sqlcmdVUT5 varchar(MAX)
DECLARE @sqlcmdVUT6 varchar(MAX)
DECLARE @sqlcmdVUT7 varchar(MAX)
DECLARE @sqlcmdVUT8 varchar(MAX)
DECLARE @sqlcmdVUT9 varchar(MAX)
DECLARE @sqlcmdVUT10 varchar(MAX)
DECLARE @AppRole varchar(100) = 'infa_APP_ACCESS'
DECLARE @TargetDB varchar(100) = 'Unitrac' 
DECLARE @TargetDB2 varchar(100) = 'VUT' 
DECLARE @TargetTableUnitrac1 varchar(100) = 'LOAN_EXTRACT_TRANSACTION_DETAIL' 
DECLARE @TargetTableUnitrac2 varchar(100) = 'TRANSACTION' 
DECLARE @TargetTableUnitrac3 varchar(100) = 'INSURANCE_EXTRACT_TRANSACTION_DETAIL' 
DECLARE @TargetTableUnitrac4 varchar(100) = 'OWNER_EXTRACT_TRANSACTION_DETAIL' 
DECLARE @TargetTableUnitrac5 varchar(100) = 'COLLATERAL_EXTRACT_TRANSACTION_DETAIL'
DECLARE @TargetTableUnitrac6 varchar(100) = 'RELATED_DATA' 
DECLARE @TargetTableUnitrac7 varchar(100) = 'RELATED_DATA_DEF' 
DECLARE @TargetTableUnitrac8 varchar(100) = 'LENDER'
DECLARE @TargetTableUnitrac9 varchar(100) = 'COLLATERAL_CODE'
DECLARE @TargetTableUnitrac10 varchar(100) = 'LENDER_ORGANIZATION'
DECLARE @TargetTableUnitrac11 varchar(100) = 'REF_CODE_ATTRIBUTE'
DECLARE @TargetTableUnitrac12 varchar(100) = 'REF_CODE'
DECLARE @TargetTableUnitrac13 varchar(100) = 'LOAN'
DECLARE @TargetTableUnitrac14 varchar(100) = 'COLLATERAL'
DECLARE @TargetTableUnitrac15 varchar(100) = 'REQUIRED_COVERAGE'
DECLARE @TargetTableVUT1 varchar(100) = 'tblLenderExtractConversion' 
DECLARE @TargetTableVUT2 varchar(100) = 'tblLenderExtract' 
DECLARE @TargetTableVUT3 varchar(100) = 'tblLenderExtractFieldMasterList' 
DECLARE @TargetTableVUT4 varchar(100) = 'tblLenderExtractCategoryFieldOrder' 
DECLARE @TargetTableVUT5 varchar(100) = 'tblLenderExtractCategory' 
DECLARE @TargetTableVUT6 varchar(100) = 'lkuExtractCategory' 
DECLARE @TargetTableVUT7 varchar(100) = 'tblLenderExtractCategoryMap' 
DECLARE @TargetTableVUT8 varchar(100) = 'tblLookup' 
DECLARE @TargetTableVUT9 varchar(100) = 'lkuPaymentFrequency'
DECLARE @TargetTableVUT10 varchar(100) = 'lkuVINLookup'
DECLARE @AccountRoot varchar(100) = 'UTdbInfraClientTest'
DECLARE @Type varchar(10) = 'IN'
DECLARE @Permission varchar(100) 



SELECT @Permission = permission_name  FROM Unitrac.sys.database_permissions WHERE type = @Type 

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


USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd2 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac2 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac2 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd3 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac3 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac3 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd4 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac4 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac4 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd5 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac5 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac5 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd6 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac6 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac6 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd7 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac7 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac7 +'] TO  ['+ @AppRole +'] 
		PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''

END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd8 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac8 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac8 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd9 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac9 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac9 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd10 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac10 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac10 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmd11 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac11 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac11 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmd12 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac12 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac12 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmd13 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac13 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac13 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd14 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac14 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac14 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmd15 = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableUnitrac15 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableUnitrac15 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT1 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
BEGIN
		CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;


USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT2 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT2 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT2 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT3 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT3 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT3 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT4 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT4 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT4 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT5 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT5 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT5 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT6 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT6 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT6 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT7 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT7 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT7 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT8 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT8 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT8 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT9 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT9 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT9 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdVUT10 = 'USE '+ @TargetDB2 +'; DECLARE @sqlCMD varchar(1000) = '''';

USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTableVUT10 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTableVUT10 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB2  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


select @sqluser =' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] WITH PASSWORD= '''+  @AccountRoot +''' MUST_CHANGE, DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
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
		PRINT ''WARNING: USER ALREADY EXISTS''
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

select @sqluser2 =' USE '+ @TargetDB2 +'
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
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

EXEC ( @SQLcmd)
EXEC ( @SQLcmd2)
EXEC ( @SQLcmd3)
EXEC ( @SQLcmd4)
EXEC ( @SQLcmd5)
EXEC ( @SQLcmd15)
EXEC ( @SQLcmdVUT1)
EXEC ( @SQLcmdVUT2)
EXEC ( @SQLcmdVUT3)
EXEC ( @SQLcmdVUT4)
EXEC ( @SQLcmdVUT5)
EXEC ( @SQLcmdVUT6)
EXEC ( @sqluser)
EXEC ( @sqluser2)

/* These get SELECT ACCESS ONLY */
--EXEC ( @SQLcmdVUT7)
--EXEC ( @SQLcmdVUT8)
--EXEC ( @SQLcmdVUT9)
--EXEC ( @SQLcmdVUT10)
--EXEC ( @SQLcmd6)
--EXEC ( @SQLcmd7)
--EXEC ( @SQLcmd8)
--EXEC ( @SQLcmd9)
--EXEC ( @SQLcmd10)
--EXEC ( @SQLcmd11)
--EXEC ( @SQLcmd12)
--EXEC ( @SQLcmd13)
--EXEC ( @SQLcmd14)











