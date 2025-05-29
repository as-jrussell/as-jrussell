/* DECLARE ALL variables at the top */
DECLARE @sqluser VARCHAR(2000)
DECLARE @sqluser2 VARCHAR(2000)
DECLARE @sqlcmd VARCHAR(2000)
DECLARE @ObjectPermission VARCHAR(2000)
DECLARE @sqlcmdValidation VARCHAR(2000)
DECLARE @sqlcmdValidation2 VARCHAR(2000)
DECLARE @sqlcmdValidation3 VARCHAR(2000)
DECLARE @AppRole VARCHAR(30) = 'db_datareader'
DECLARE @AccountRoot VARCHAR(100) =  'ELDREDGE_A\SVC_POSA_PRD01'
DECLARE @Password VARCHAR(100) = ''
DECLARE @DryRun INT = 1

DECLARE @DatabaseName SYSNAME
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
WHERE  name IN ('IQQ_Live', 'IQQ_Training', 'IQQ_Common')
ORDER  BY database_id
-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempDatabases WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 



  
IF @DatabaseName <> ''
  BEGIN
      IF @AppRole <> ''
        BEGIN
            SELECT @sqlcmd = 'USE [' + @DatabaseName
                             + ']; DECLARE @sqlCMD varchar(1000) = '''';
IF NOT EXISTS (select * from sys.database_principals where name = '''
                             + @AppRole + ''')
BEGIN
		CREATE ROLE [' + @AppRole + ']  AUTHORIZATION [dbo];
		PRINT ''SUCCESS: ROLE was created''
END
	ELSE 
BEGIN
		PRINT ''WARNING: ROLE ALREADY EXISTS''
END;'
        END

      IF @AppRole <> ''

      IF @AccountRoot <> ''
         AND @Password <> ''
        BEGIN
            SELECT @sqluser = ' USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''
                              + @AccountRoot + ''')
BEGIN
		CREATE LOGIN ['
                              + @AccountRoot + '] WITH PASSWORD= '''
                              + @Password + ''', DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END
'
        END

      IF @AccountRoot <> ''
        BEGIN
            SELECT @sqluser2 = 'USE  [' + @DatabaseName
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
		PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
END

USE  ['
                               + @DatabaseName + ']
IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = '''
                               + @AccountRoot + ''')

BEGIN
		
		ALTER ROLE [' + @AppRole
                               + ']  ADD MEMBER [' + @AccountRoot + '] ;
		GRANT EXECUTE TO ['+@AccountRoot+']
		PRINT ''SUCCESS: PERMISSION GIVEN TO USER
		
		The password will need to be changed upon the first login the password is in CyberArk! 

		''
END
	ELSE 
BEGIN
		PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
END'
        END




		SET @sqlcmdValidation2='USE [' + @DatabaseName
                               + ']
  SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
          + @AccountRoot + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access]
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  = ''' + @AccountRoot
          + ''''


SET @sqlcmdValidation3='USE [' + @DatabaseName
                               + ']	SELECT DB_NAME() [DatabaseName], CONCAT(''The Account: '' ,USER_NAME(grantee_principal_id), '' has access to the table: '', 
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
  @sqlcmdValidation3

  INSERT INTO #1
EXEC Sp_msforeachdb
  @sqlcmdValidation2



	  SELECT DISTINCT *
FROM   #1
order by databasename, Access asc


	

  END


    -- You know what we do here if it's 1 then it'll give us code and 0 executes it

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
	  EXEC (@ObjectPermission)
	  EXEC ( @sqluser)
	  EXEC ( @sqluser2)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
	  PRINT ( @ObjectPermission )
	  PRINT ( @sqluser )
	  PRINT ( @sqluser2 )
  END 

    -- Update table
    UPDATE  #TempDatabases 
    SET IsProcessed = 1
    WHERE DatabaseName = @databaseName


  END

