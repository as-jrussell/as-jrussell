DECLARE @sqlcmd varchar(MAX)
DECLARE @AppRole varchar(100) = 'infa_APP_ACCESS'
DECLARE @TargetDB varchar(100) = 'Unitrac' 
DECLARE @Target varchar(100) 
DECLARE @Type varchar(10) 
DECLARE @Permission varchar(100) 

SELECT @Permission = permission_name  FROM sys.database_permissions WHERE type IN ('IN', 'UP')
SELECT @Target = name FROM sys.tables WHERE name in 
				('LOAN_EXTRACT_TRANSACTION_DETAIL', 'TRANSACTION', 
				'INSURANCE_EXTRACT_TRANSACTION_DETAIL', 'OWNER_EXTRACT_TRANSACTION_DETAIL',
				'COLLATERAL_EXTRACT_TRANSACTION_DETAIL')

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
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''+ @Target + '''AND TYPE = '''+ @TYPE  +''' AND USER_NAME(grantee_principal_id) ='''+ @AppRole +''')
BEGIN
		GRANT '+ @Permission + ' ON [dbo].' + @Target +' TO  ['+ @AppRole +'] 
		PRINT ''SUCCESS: GRANT SELECT  was issued to ' + @AppRole + ' on ' + @TargetDB  +'''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
'

--PRINT ( @SQLcmd)
EXEC( @SQLcmd)










