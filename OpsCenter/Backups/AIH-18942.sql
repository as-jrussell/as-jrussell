/*
These are two user variables that need to be altered. 
The database name and the DryRun

*/

DECLARE @TargetDB VARCHAR(100) = '' 
--Unitrac environment is Unitrac db only; IVOS environment are IVOS; and IVOS_Tools db; IQQ environment are iqq_live and iqq_common dbs

DECLARE @DryRun INT = 1 
---1 to view script and 0 initate the script

/*
The remaining Declare items that are all static information
*/
DECLARE @sqluser VARCHAR(MAX)
DECLARE @sqlcmd VARCHAR(MAX)
DECLARE @AppRole VARCHAR(100) = 'SAIL_APP_ACCESS'
DECLARE @AppRole2 VARCHAR(100) = 'db_datareader'
DECLARE @AppRole3 VARCHAR(100) = 'db_datawriter'
DECLARE @AccountRoot VARCHAR(100)

SELECT @AccountRoot = CASE ServerEnvironment
                        WHEN 'PRD' THEN 'ELDREDGE_A\svc_SAIL_PRD01'
                        WHEN 'STG' THEN 'ELDREDGE_A\svc_SAIL_STG01'
                        WHEN 'TST' THEN 'ELDREDGE_A\svc_SAIL_TST01'
                        WHEN 'DEV' THEN 'ELDREDGE_A\svc_SAIL_DEV01'
                      END
FROM   DBA.INFO.INSTANCE

IF @AccountRoot IS NOT NULL
  BEGIN
      SELECT @sqlcmd = 'USE [' + @TargetDB
                       + ']; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''
                       + @AppRole + ''')
BEGIN
		CREATE ROLE [' + @AppRole
                       + ']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ' + @AppRole + ' ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;

'

      SELECT @sqluser = ' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''
                        + @AccountRoot + ''')
BEGIN
		CREATE LOGIN ['
                        + @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
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
		ALTER ROLE [' + @AppRole2
                        + ']  ADD MEMBER [' + @AccountRoot
                        + '] ;
		ALTER ROLE [' + @AppRole3
                        + ']  ADD MEMBER [' + @AccountRoot + '] ;
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'

      IF @DryRun = 0
        BEGIN
            EXEC ( @SQLcmd)

            EXEC ( @sqluser)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )

            PRINT ( @sqluser )
        END
  END 
