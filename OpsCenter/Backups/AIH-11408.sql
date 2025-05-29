DECLARE @sqluser VARCHAR(MAX)
DECLARE @sqlcmd VARCHAR(MAX)
DECLARE @sqlcmd2 VARCHAR(MAX)
DECLARE @sqlcmd3 VARCHAR(MAX)
DECLARE @sqlcmd4 VARCHAR(MAX)
DECLARE @sqlcmd5 VARCHAR(MAX)
DECLARE @sqlcmd6 VARCHAR(MAX)
DECLARE @sqlcmd7 VARCHAR(MAX)
DECLARE @sqlcmd8 VARCHAR(MAX)
DECLARE @sqlcmd9 VARCHAR(MAX)
DECLARE @sqlcmd10 VARCHAR(MAX)
DECLARE @sqlcmd11 VARCHAR(MAX)
DECLARE @sqlcmd12 VARCHAR(MAX)
DECLARE @sqlcmd13 VARCHAR(MAX)
DECLARE @sqlcmd14 VARCHAR(MAX)
DECLARE @sqlcmd15 VARCHAR(MAX)
DECLARE @sqlcmd16 VARCHAR(MAX)
DECLARE @sqlcmd17 VARCHAR(MAX)
DECLARE @sqlcmd18 VARCHAR(MAX)
DECLARE @sqlcmd19 VARCHAR(MAX)
DECLARE @sqlcmd20 VARCHAR(MAX)
DECLARE @sqlcmd21 VARCHAR(MAX)
DECLARE @sqlcmd22 VARCHAR(MAX)
DECLARE @sqlcmd23 VARCHAR(MAX)
DECLARE @sqlcmd24 VARCHAR(MAX)
DECLARE @sqlcmd25 VARCHAR(MAX)
DECLARE @sqlcmd26 VARCHAR(MAX)
DECLARE @AppRole VARCHAR(100) = 'PIMS_APP_ACCESS'
DECLARE @TargetDB VARCHAR(100) = 'Unitrac'
DECLARE @AccountRoot VARCHAR(100) = 'PIMSdbLinked_UTSTG_INTAPPPROD01'
DECLARE @TargetTable1 VARCHAR(100) = 'ADDRESS'
DECLARE @TargetTable2 VARCHAR(100) = 'BORROWER_INSURANCE_AGENCY'
DECLARE @TargetTable3 VARCHAR(100) = 'BORROWER_INSURANCE_COMPANY'
DECLARE @TargetTable4 VARCHAR(100) = 'COLLATERAL'
DECLARE @TargetTable5 VARCHAR(100) = 'COLLATERAL_CODE'
DECLARE @TargetTable6 VARCHAR(100) = 'ESCROW'
DECLARE @TargetTable7 VARCHAR(100) = 'ESCROW_REQUIRED_COVERAGE_RELATE'
DECLARE @TargetTable8 VARCHAR(100) = 'IMPAIRMENT'
DECLARE @TargetTable9 VARCHAR(100) = 'LENDER'
DECLARE @TargetTable10 VARCHAR(100) = 'LOAN'
DECLARE @TargetTable11 VARCHAR(100) = 'NOTICE'
DECLARE @TargetTable12 VARCHAR(100) = 'OWNER'
DECLARE @TargetTable13 VARCHAR(100) = 'OWNER_ADDRESS'
DECLARE @TargetTable14 VARCHAR(100) = 'OWNER_LOAN_RELATE'
DECLARE @TargetTable15 VARCHAR(100) = 'OWNER_POLICY'
DECLARE @TargetTable16 VARCHAR(100) = 'POLICY_COVERAGE'
DECLARE @TargetTable17 VARCHAR(100) = 'PROCESS_DEFINITION'
DECLARE @TargetTable18 VARCHAR(100) = 'PROCESS_LOG'
DECLARE @TargetTable19 VARCHAR(100) = 'PROCESS_LOG_ITEM'
DECLARE @TargetTable20 VARCHAR(100) = 'PROPERTY'
DECLARE @TargetTable21 VARCHAR(100) = 'REF_CODE'
DECLARE @TargetTable22 VARCHAR(100) = 'RELATED_DATA'
DECLARE @TargetTable23 VARCHAR(100) = 'RELATED_DATA_DEF'
DECLARE @TargetTable24 VARCHAR(100) = 'REQUIRED_COVERAGE'
DECLARE @TargetTable25 VARCHAR(100) = 'REQUIRED_ESCROW'
DECLARE @TargetTable26 VARCHAR(100) = 'WORK_ITEM'
DECLARE @Type VARCHAR(10) = 'SL'
DECLARE @Permission VARCHAR(100)
DECLARE @DryRun INT = 0

SELECT @Permission = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @Type

SELECT @sqlcmd = 'USE ' + @TargetDB
                 + '; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''
                 + @AppRole + ''')
BEGIN
		CREATE ROLE [' + @AppRole + ']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;


USE '
                 + @TargetDB
                 + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                 + @TargetTable1 + '''AND TYPE = ''' + @TYPE
                 + ''' AND USER_NAME(grantee_principal_id) ='''
                 + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                 + ' ON [dbo]. [' + @TargetTable1 + '] TO  ['
                 + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                 + @Permission + ' was issued to ' + @AppRole
                 + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd2 = '
USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @TargetTable2 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @TargetTable2 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd3 = '


USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @TargetTable3 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @TargetTable3 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd4 = '

USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @TargetTable4 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @TargetTable4 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd5 = '

USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @TargetTable5 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @TargetTable5 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd6 = 'USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @TargetTable6 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @TargetTable6 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd7 = '
USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @TargetTable7 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @TargetTable7 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd8 = '
USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @TargetTable8 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @TargetTable8 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd9 = '
USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                  + @TargetTable9 + '''AND TYPE = ''' + @TYPE
                  + ''' AND USER_NAME(grantee_principal_id) ='''
                  + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                  + ' ON [dbo]. [' + @TargetTable8 + '] TO  ['
                  + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                  + @Permission + ' was issued to ' + @AppRole
                  + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd10 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable10 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable10 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd11 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable11 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable11 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd12 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable12 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable12 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd13 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable13 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable13 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd14 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable14 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable14 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd15 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable15 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable15 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd16 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable16 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable16 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd17 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable17 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable17 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd18 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable18 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable18 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd19 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable19 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable19 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd20 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable20 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable20 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd21 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable21 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable21 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd22 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable22 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable22 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd23 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable23 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable23 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd24 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable24 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable24 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd25 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable25 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable25 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmd26 = '
USE ' + @TargetDB
                   + '
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                   + @TargetTable26 + '''AND TYPE = ''' + @TYPE
                   + ''' AND USER_NAME(grantee_principal_id) ='''
                   + @AppRole + ''')
BEGIN
		GRANT ' + @Permission
                   + ' ON [dbo]. [' + @TargetTable26 + '] TO  ['
                   + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                   + @Permission + ' was issued to ' + @AppRole
                   + ' on ' + @TargetDB + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqluser = ' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''
                  + @AccountRoot + ''')
BEGIN
		CREATE LOGIN ['
                  + @AccountRoot + '] WITH PASSWORD= '''
                  + 'NewPassword1234!!' + ''' MUST_CHANGE, DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END

USE ' + @TargetDB
                  + '
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''
                  + @AccountRoot + ''')
BEGIN
		CREATE USER [' + @AccountRoot
                  + '] FOR LOGIN [' + @AccountRoot
                  + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
		DROP USER [' + @AccountRoot
                  + '] 
		CREATE USER [' + @AccountRoot
                  + '] FOR LOGIN [' + @AccountRoot
                  + '] 
END


IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = ''' + @AccountRoot
                  + ''')

BEGIN
		
		ALTER ROLE [' + @AppRole + ']  ADD MEMBER ['
                  + @AccountRoot + '] ;
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

      EXEC (@SQLCMD2)

      EXEC (@SQLCMD3)

      EXEC (@SQLCMD4)

      EXEC (@SQLCMD5)

      EXEC (@SQLCMD6)

      EXEC (@SQLCMD7)

      EXEC (@SQLCMD8)

      EXEC (@SQLCMD9)

      EXEC (@SQLCMD10)

      EXEC (@SQLCMD11)

      EXEC (@SQLCMD12)

      EXEC (@SQLCMD13)

      EXEC (@SQLCMD14)

      EXEC (@SQLCMD15)

      EXEC (@SQLCMD16)

      EXEC (@SQLCMD17)

      EXEC (@SQLCMD18)

      EXEC (@SQLCMD19)

      EXEC (@SQLCMD20)

      EXEC (@SQLCMD21)

      EXEC (@SQLCMD22)

      EXEC (@SQLCMD23)

      EXEC (@SQLCMD24)

      EXEC (@SQLCMD25)

      EXEC (@SQLCMD26)

      EXEC ( @sqluser)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )

      PRINT ( @SQLCMD2 )

      PRINT ( @SQLCMD3 )

      PRINT ( @SQLCMD4 )

      PRINT ( @SQLCMD5 )

      PRINT ( @SQLCMD6 )

      PRINT ( @SQLCMD7 )

      PRINT ( @SQLCMD8 )

      PRINT ( @SQLCMD9 )

      PRINT ( @SQLCMD10 )

      PRINT ( @SQLCMD11 )

      PRINT ( @SQLCMD12 )

      PRINT ( @SQLCMD13 )

      PRINT ( @SQLCMD14 )

      PRINT ( @SQLCMD15 )

      PRINT ( @SQLCMD16 )

      PRINT ( @SQLCMD17 )

      PRINT ( @SQLCMD18 )

      PRINT ( @SQLCMD19 )

      PRINT ( @SQLCMD20 )

      PRINT ( @SQLCMD21 )

      PRINT ( @SQLCMD22 )

      PRINT ( @SQLCMD23 )

      PRINT ( @SQLCMD24 )

      PRINT ( @SQLCMD25 )

      PRINT ( @SQLCMD26 )

      PRINT ( @sqluser )
  END 
