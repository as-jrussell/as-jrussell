/* DECLARE ALL variables at the top */
DECLARE @sqluser VARCHAR(MAX)
DECLARE @sqlcmd VARCHAR(MAX)
DECLARE @sqlcmdSP VARCHAR(MAX)
DECLARE @sqlcmdrole VARCHAR(MAX)
DECLARE @sqlcmdValidation VARCHAR(MAX)
DECLARE @AccountRoot VARCHAR(100)
DECLARE @PermissionSP VARCHAR(100)
DECLARE @DatabaseName SYSNAME
DECLARE @AppRole VARCHAR(100) = 'ORCL_APP_ACCESS' ---Name of Role Application Acroynm_APP_ACCESS 
DECLARE @ObjectName VARCHAR(100) = 'GetAllLenderRemittance' --Object either Stored Proc/Table/etc.
DECLARE @TypeSP VARCHAR(10) = 'EX' ---lowest and most common access for stored proc is: EX and Tables is: SL
DECLARE @Password NVARCHAR(200) = '' --Password
DECLARE @DryRun INT =0

SELECT @AccountRoot = CASE WHEN (SELECT TOP 1 ServerEnvironment FROM DBA.info.Instance ORDER BY HarvestDate DESC )  = 'DEV' THEN 'svc_ORCL_DEV01'
WHEN (SELECT TOP 1 ServerEnvironment FROM DBA.info.Instance ORDER BY HarvestDate DESC )  = 'TST' THEN 'svc_ORCL_TST01'
WHEN (SELECT TOP 1 ServerEnvironment FROM DBA.info.Instance ORDER BY HarvestDate DESC )  = 'STG' THEN 'svc_ORCL_STG01'
WHEN (SELECT TOP 1 ServerEnvironment FROM DBA.info.Instance ORDER BY HarvestDate DESC )  = 'PRD' THEN 'SVC_ORCL_PRD01'
END 

-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases
CREATE TABLE #TempDatabases
  (
     DatabaseName SYSNAME,
     IsProcessed BIT
  )
-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases (DatabaseName, IsProcessed)
SELECT name, 0 -- SELECT *
FROM   sys.databases
WHERE  name in ('IQQ_LIVE','IQQ_TRAINING')
ORDER  BY database_id
-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempDatabases WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 

SELECT @PermissionSP = permission_name
FROM   Fn_builtin_permissions(DEFAULT)
WHERE  type = @TypeSP

    -- Prepare SQL Statement
IF @DatabaseName <> ''
  BEGIN
      IF @AppRole <> ''
        BEGIN
            SELECT @sqlcmd = 'USE [' + @DatabaseName
                             + ']


DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = ''' + @AppRole + ''')
BEGIN
		CREATE ROLE [' + @AppRole + ']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END
'
        END

      IF @AccountRoot <> ''
        BEGIN
            SELECT @sqluser = ' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''
                              + @AccountRoot + ''')
BEGIN
IF '''+ @AccountRoot + ''' LIKE ''%ELDREDGE_A%''
BEGIN
		CREATE LOGIN ['
                              + @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
		PRINT ''SUCCESS: LOGIN CREATED - AD version''
END
ELSE 
BEGIN
CREATE LOGIN [' + @AccountRoot
                   + '] WITH PASSWORD= ''' + @Password
                   + ''', DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
		PRINT ''SUCCESS: LOGIN CREATED - SQL version''
END
END
	ELSE 
BEGIN
		PRINT ''WARNING: ACCOUNT LOGIN ALREADY EXISTS''
END

USE [' + @DatabaseName
                              + ']
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''
                              + @AccountRoot + ''')
BEGIN
		CREATE USER [' + @AccountRoot
                              + '] FOR LOGIN [' + @AccountRoot + '] 
		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: ACCOUNT USER ALREADY EXISTS ''

END

'
        END

      IF @AccountRoot <> ''
         AND @AppRole <> ''
        BEGIN
            --Create Role
            SELECT @sqlcmdrole = ' USE [' + @DatabaseName + ']

IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''
                                 + @AccountRoot + ''' AND rp.name =''' + @AppRole
                                 + ''')

BEGIN
		
		ALTER ROLE [' + @AppRole + ']  ADD MEMBER ['
                                 + @AccountRoot + '] ;
		PRINT ''SUCCESS: ' + @AppRole
                                 + ' GIVEN TO ' + @AccountRoot
                                 + ' ''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ' + @AppRole
                                 + ' PERMISSION TO ' + @AccountRoot + ' ALREADY EXISTS''
END
 '
        END

      IF @ObjectName <> ''
         AND @PermissionSP <> ''
        BEGIN
            SELECT @sqlcmdSP = '
USE [' + @DatabaseName
                               + ']
IF EXISTS (SELECT 1 FROM sys.objects where name ='''
                               + @ObjectName + ''')
BEGIN
IF NOT EXISTS (SELECT 1 FROM sys.database_permissions where OBJECT_NAME(major_id) ='''
                               + @ObjectName + '''AND TYPE = ''' + @TypeSP
                               + ''' AND USER_NAME(grantee_principal_id) ='''
                               + @AppRole + ''')
BEGIN
		GRANT ' + @PermissionSP
                               + ' ON [dbo]. [' + @ObjectName + '] TO  ['
                               + @AppRole + '] 
	PRINT ''SUCCESS: GRANT '
                               + @PermissionSP + ' was issued to ' + @AppRole
                               + ' on ' + @DatabaseName + ' for ' + @ObjectName + '''
END
	ELSE 
BEGIN
		PRINT ''WARNING: GRANTS ALREADY EXISTS''
END
END
'
        END

      SELECT @sqlcmdValidation = 'USE [' + @DatabaseName
                                 + ']

select ''Server Login:'', DB_NAME()[Database Name], * from sys.server_principals
where name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%' + @AppRole
                                 + '%'')

select ''DB User:'',  DB_NAME()[Database Name], * from sys.database_principals 
where name  like ''%' + @AppRole
                                 + '%'' 

--Application Roles with Logins
select  ''User / Role:'', DB_NAME(), rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%' + @AppRole
                                 + '%''
	OR mp.name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%' + @AppRole
                                 + '%'')

--Tables that the Roles 
select ''Table that user has access to:'', OBJECT_NAME(major_id) [Object],  permission_name [Permission Type],  DB_NAME()[Database Name], USER_NAME(grantee_principal_id)[Role Name],
* FROM sys.database_permissions
where USER_NAME(grantee_principal_id) like ''%'
                                 + @AppRole + '%''
'
  END

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
	  EXEC ( @sqluser)
	  EXEC (@sqlcmdSP)
	  EXEC (@sqlcmdrole)
	  EXEC ( @sqlcmdValidation)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
	  PRINT ( @sqluser )
	  PRINT ( @sqlcmdSP )
	  PRINT ( @sqlcmdrole )
	  PRINT ( @sqlcmdValidation )
  END 


    -- Update table
    UPDATE  #TempDatabases 
    SET IsProcessed = 1
    WHERE DatabaseName = @databaseName
  END