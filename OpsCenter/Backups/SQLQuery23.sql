 
 USE [master]


 DECLARE @AppRole VARCHAR(100) =  'ELDREDGE_A\OctopusDeploy'



IF NOT EXISTS (SELECT * FROM sys.server_principals where name = 'ELDREDGE_A\OctopusDeploy')
BEGIN
		CREATE LOGIN [ELDREDGE_A\OctopusDeploy] FROM WINDOWS WITH DEFAULT_DATABASE=[TEMPDB]
		PRINT 'SUCCESS: LOGIN CREATED'
END
	ELSE 
BEGIN
		PRINT 'WARNING: USER ALREADY EXISTS !!!!'
END

USE [UTL]

IF NOT EXISTS (SELECT * FROM sys.database_principals where name = 'ELDREDGE_A\OctopusDeploy')
BEGIN
		CREATE USER [ELDREDGE_A\OctopusDeploy] FOR LOGIN [ELDREDGE_A\OctopusDeploy] 
		PRINT 'SUCCESS: USER CREATED';
END
	ELSE 
BEGIN
		PRINT 'WARNING: PERMISSION ALREADY EXISTS !!!!'
	
END



IF NOT EXISTS (select mp.name, rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
				from sys.database_role_members dm
				join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
				join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
				where mp.name = 'ELDREDGE_A\OctopusDeploy')

BEGIN
		
		ALTER ROLE [db_ddladmin] ADD MEMBER  [ELDREDGE_A\OctopusDeploy]
		ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\OctopusDeploy]
       ALTER ROLE [db_datawriter] ADD MEMBER [ELDREDGE_A\OctopusDeploy]
		GRANT EXECUTE TO [ELDREDGE_A\OctopusDeploy]
		GRANT VIEW DEFINITION TO [ELDREDGE_A\OctopusDeploy]
		PRINT 'SUCCESS: PERMISSION GIVEN TO USER'
END
	ELSE 
BEGIN
		PRINT 'WARNING: PERMISSION ALREADY EXISTS !!!!' 
END


DECLARE @sqlcmdValidation VARCHAR(1000)
DECLARE @sqlcmdValidation2 VARCHAR(400)
DECLARE @sqlcmdValidation3 VARCHAR(400)
DECLARE @DatabaseName SYSNAME




IF Object_id(N'tempdb..#1') IS NOT NULL
  DROP TABLE #1

CREATE TABLE #1
  (
     [databasename] VARCHAR(250),
     [Access]       VARCHAR(max)
  )


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
WHERE  database_id >= 4
AND name NOT IN ('DBA', 'Perfstats')
ORDER  BY database_id

WHILE EXISTS( SELECT * FROM #TempDatabases WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 





--UTdbInfraClientTest has access to the database  as Infa_APP_ACCESS on UniTrac database on UTQA-SQL-14
SET @sqlcmdValidation='USE [' + @DatabaseName
                             + '] SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
          + @AppRole + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access]
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where Rp.name  = ''' + @AppRole  + '''
UNION
SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
          + @AppRole + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access]
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  = ''' + @AppRole  + ''''
	  
SET @sqlcmdValidation2='USE [' + @DatabaseName
                             + '] 	SELECT DB_NAME() [DatabaseName], CONCAT(''The Account: '' ,USER_NAME(grantee_principal_id), '' has access to the table: '', 
OBJECT_NAME(major_id), '' with '' , permission_name, '' rights on '', DB_NAME(), '' database'' ) [Access]
FROM sys.database_permissions
where USER_NAME(grantee_principal_id) = '''
          + @AppRole + ''''


SET @sqlcmdValidation3='USE [' + @DatabaseName
                             + ']SELECT DB_NAME() [DatabaseName],  name
from sys.server_principals
where name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  like ''%'+ @AppRole  +'%'')
'


INSERT INTO #1
   EXEC (@sqlcmdValidation)

INSERT INTO #1
  EXEC ( @sqlcmdValidation2)

  INSERT INTO #1
  EXEC ( @sqlcmdValidation3) 


    -- Update table
    UPDATE  #TempDatabases 
    SET IsProcessed = 1
    WHERE DatabaseName = @databaseName


  END

  
    



	SELECT *
FROM   #1
order by databasename, Access asc
