DECLARE @sqlrole varchar(MAX)
DECLARE @sqluser varchar(MAX)
DECLARE 	@sqlcmdPermission1	varchar(MAX)
DECLARE 	@sqlcmdPermission2	varchar(MAX)
DECLARE 	@sqlcmdPermission3	varchar(MAX)
DECLARE 	@sqlcmdPermission4	varchar(MAX)
DECLARE 	@sqlcmdPermission5	varchar(MAX)
DECLARE 	@sqlcmdPermission6	varchar(MAX)
DECLARE 	@sqlcmdPermission7	varchar(MAX)
DECLARE 	@sqlcmdPermission8	varchar(MAX)
DECLARE 	@sqlcmdPermission9	varchar(MAX)
DECLARE 	@sqlcmdPermission10	varchar(MAX)
DECLARE 	@sqlcmdPermission11	varchar(MAX)
DECLARE 	@sqlcmdPermission12	varchar(MAX)
DECLARE 	@sqlcmdPermission13	varchar(MAX)
DECLARE 	@sqlcmdPermission14	varchar(MAX)
DECLARE 	@sqlcmdPermission15	varchar(MAX)
DECLARE 	@sqlcmdPermission16	varchar(MAX)
DECLARE 	@sqlcmdPermission17	varchar(MAX)
DECLARE 	@sqlcmdPermission18	varchar(MAX)
DECLARE 	@sqlcmdPermission19	varchar(MAX)
DECLARE 	@sqlcmdPermission20	varchar(MAX)
DECLARE 	@sqlcmdPermission21	varchar(MAX)
DECLARE 	@sqlcmdPermission22	varchar(MAX)
DECLARE 	@sqlcmdPermission23	varchar(MAX)
DECLARE 	@sqlcmdPermission24	varchar(MAX)
DECLARE 	@sqlcmdPermission25	varchar(MAX)
DECLARE 	@sqlcmdPermission26	varchar(MAX)
DECLARE 	@sqlcmdPermission27	varchar(MAX)
DECLARE 	@sqlcmdPermission28	varchar(MAX)
DECLARE 	@sqlcmdPermission29	varchar(MAX)
DECLARE 	@sqlcmdPermission30	varchar(MAX)
DECLARE 	@sqlcmdPermission31	varchar(MAX)
DECLARE 	@sqlcmdPermission32	varchar(MAX)
DECLARE 	@sqlcmdPermission33	varchar(MAX)
DECLARE 	@sqlcmdPermission34	varchar(MAX)
DECLARE 	@sqlcmdPermission35	varchar(MAX)
DECLARE 	@sqlcmdPermission36	varchar(MAX)
DECLARE 	@sqlcmdPermission37	varchar(MAX)
DECLARE 	@sqlcmdPermission38	varchar(MAX)
DECLARE 	@sqlcmdPermission39	varchar(MAX)
DECLARE 	@sqlcmdPermission40	varchar(MAX)
DECLARE 	@sqlcmdPermission41	varchar(MAX)
DECLARE 	@sqlcmdPermission42	varchar(MAX)
DECLARE 	@sqlcmdPermission43	varchar(MAX)
DECLARE 	@sqlcmdPermission44	varchar(MAX)
DECLARE 	@sqlcmdPermission45	varchar(MAX)
DECLARE 	@sqlcmdPermission46	varchar(MAX)
DECLARE @AppRole varchar(100) = 'SWINDS_APP_ACCESS'
DECLARE @TargetDB varchar(100) = 'Unitrac' 
DECLARE @TargetTable1 	 varchar(100) = 'PROCESS_DEFINITION'
DECLARE @TargetTable2	 varchar(100) = 'PROCESS_LOG'
DECLARE @TargetTable3	 varchar(100) = 'UTL_MATCH_RESULT'
DECLARE @TargetTable4	 varchar(100) = 'LOAN'
DECLARE @TargetTable5	 varchar(100) = 'LENDER'
DECLARE @TargetTable6	 varchar(100) = 'UTLSERVER.UTL.LOAN'
DECLARE @TargetTable7	 varchar(100) = 'TRADING_PARTNER_LOG'
DECLARE @TargetTable8	 varchar(100) = 'TRADING_PARTNER'
DECLARE @TargetTable9	 varchar(100) = 'MESSAGE'
DECLARE @TargetTable10	 varchar(100) = 'COLLATERAL'
DECLARE @TargetTable11	 varchar(100) = 'PROPERTY'
DECLARE @TargetTable12	 varchar(100) = 'REQUIRED_COVERAGE'
DECLARE @TargetTable13	 varchar(100) = 'PROPERTY_OWNER_POLICY_RELATE'
DECLARE @TargetTable14	 varchar(100) = 'OWNER_POLICY'
DECLARE @TargetTable15	 varchar(100) = 'POLICY_COVERAGE'
DECLARE @TargetTable16	 varchar(100) = 'WORK_ITEM'
DECLARE @TargetTable17	 varchar(100) = 'WORK_ITEM_ACTION'
DECLARE @TargetTable18	 varchar(100) = 'REPORT_HISTORY'
DECLARE @TargetTable19	 varchar(100) = 'OUTPUT_BATCH'
DECLARE @TargetTable20	 varchar(100) = 'USER_WORK_QUEUE_RELATE'
DECLARE @TargetTable21	 varchar(100) = 'DOCUMENT_CONTAINER'
DECLARE @TargetTable22	 varchar(100) = 'Transaction'
DECLARE @TargetTable23	 varchar(100) = 'DOCUMENT'
DECLARE @AccountRoot varchar(100) = 'solarwinds_sql'
DECLARE @Type varchar(10) = 'SL'
DECLARE @Permission varchar(100) 
DECLARE @Type2 varchar(10) = 'UP'
DECLARE @Permission2 varchar(100) 

SELECT @Permission = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type 
SELECT @Permission2 = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type2

SELECT @sqlrole = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
BEGIN
		CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;'


SELECT @sqlcmdPermission1 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission2 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable2 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable2 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable2 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission3 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable3 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable3 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable3 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'



SELECT @sqlcmdPermission4 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable4 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable4 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable4 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission5 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable5 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable5 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable5 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission6 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable6 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable6 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable6 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission7 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable7 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable7 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable7 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission8 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable8 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable8 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable8 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission9 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable9 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable9 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable9 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission10 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable10 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable10 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable10 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission11 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable11 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable11 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable11 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission12 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable12 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable12 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable12 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission13 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable13 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable13 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable13 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'



SELECT @sqlcmdPermission14 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable14 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable14 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable14 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission15 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable15 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable15 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable15 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission16 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable16 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable16 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable16 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission17 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable17 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable17 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable17 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission18 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable18 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable18 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable18 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission19 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable19 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable19 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable19 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission20 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable20 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable20 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable20 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission21 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable21 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable21 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable21 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission22 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable22 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable22 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable22 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'



SELECT @sqlcmdPermission23 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable23 + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo]. [' + @TargetTable23 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable23 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission24 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable1 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable1 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable1 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission25 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable2 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable2 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable2 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission26 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable3 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable3 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable3 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'



SELECT @sqlcmdPermission27 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable4 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable4 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable4 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission28 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable5 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable5 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable5 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission29 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable6 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable6 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable6 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission30 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable7 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable7 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable7 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission31 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable8 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable8 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable8 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission32 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable9 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable9 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable9 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission33 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable10 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable10 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable10 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission34 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable11 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable11 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable11 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission35 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable12 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable12 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable12 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission36 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable13 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable13 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable13 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'



SELECT @sqlcmdPermission37 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable14 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable14 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable14 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission38 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable15 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable15 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable15 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission39 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable16 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable16 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable16 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission40 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable17 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable17 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable17 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission41 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable18 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable18 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable18 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission42 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable19 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable19 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable19 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

SELECT @sqlcmdPermission43 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable20 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable20 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable20 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission44 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable21 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable21 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable21 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'


SELECT @sqlcmdPermission45 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable22 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable22 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable22 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'



SELECT @sqlcmdPermission46 = '
USE '+ @TargetDB +'
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @TargetTable23 + '''AND TYPE = '''+ @TYPE2  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission2 + ' ON [dbo]. [' + @TargetTable23 +'] TO  ['+ @AppRole +'] 
	PRINT ''SUCCESS: GRANT ' + @Permission2 +' was issued to ' + @AppRole + ' on ' + @TargetDB  +' for ' + @TargetTable23 + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'





select @sqluser ='

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
END
'


EXEC (@sqlrole)
EXEC (@sqlcmdPermission1)
EXEC (@sqlcmdPermission2)
EXEC (@sqlcmdPermission3)
EXEC (@sqlcmdPermission4)
EXEC (@sqlcmdPermission5)
EXEC (@sqlcmdPermission7)
EXEC (@sqlcmdPermission8)
EXEC (@sqlcmdPermission9)
EXEC (@sqlcmdPermission10)
EXEC (@sqlcmdPermission11)
EXEC (@sqlcmdPermission12)
EXEC (@sqlcmdPermission13)
EXEC (@sqlcmdPermission14)
EXEC (@sqlcmdPermission15)
EXEC (@sqlcmdPermission16)
EXEC (@sqlcmdPermission17)
EXEC (@sqlcmdPermission18)
EXEC (@sqlcmdPermission19)
EXEC (@sqlcmdPermission20)
EXEC (@sqlcmdPermission21)
EXEC (@sqlcmdPermission22)
EXEC (@sqlcmdPermission23)
EXEC (@sqlcmdPermission24)
EXEC (@sqlcmdPermission25)
EXEC (@sqlcmdPermission26)
EXEC (@sqlcmdPermission27)
EXEC (@sqlcmdPermission28)
EXEC (@sqlcmdPermission30)
EXEC (@sqlcmdPermission31)
EXEC (@sqlcmdPermission32)
EXEC (@sqlcmdPermission33)
EXEC (@sqlcmdPermission34)
EXEC (@sqlcmdPermission35)
EXEC (@sqlcmdPermission36)
EXEC (@sqlcmdPermission37)
EXEC (@sqlcmdPermission38)
EXEC (@sqlcmdPermission39)
EXEC (@sqlcmdPermission40)
EXEC (@sqlcmdPermission41)
EXEC (@sqlcmdPermission42)
EXEC (@sqlcmdPermission43)
EXEC (@sqlcmdPermission44)
EXEC (@sqlcmdPermission45)
EXEC (@sqlcmdPermission46)
EXEC (@sqluser)










