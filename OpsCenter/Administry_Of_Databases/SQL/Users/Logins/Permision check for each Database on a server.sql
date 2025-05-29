DECLARE @sqlcmdValidation VARCHAR(1000)
DECLARE @sqlcmdValidation2 VARCHAR(400)
DECLARE @sqlcmdValidation3 VARCHAR(1000)
DECLARE @DatabaseName SYSNAME
DECLARE @DBName VARCHAR(100) 
DECLARE @AppRole VARCHAR(100) = 'ELDREDGE_A\svc_ider_prd01'
DECLARE @Dryrun BIT = 0

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
     IsProcessed  BIT
  )

-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases
            (DatabaseName,
             IsProcessed)
SELECT name,
       0 -- SELECT *
FROM   [DBA].[backup].[Schedule] S
       JOIN sys.databases D
         ON S.DatabaseName = D.name
WHERE  DatabaseType = 'USER'
        OR DatabaseName = 'HDTstorage'
ORDER  BY database_id

WHILE EXISTS(SELECT *
             FROM   #TempDatabases
             WHERE  IsProcessed = 0)
  BEGIN
      -- Fetch 1 DatabaseName where IsProcessed = 0
      SELECT TOP 1 @DatabaseName = DatabaseName
      FROM   #TempDatabases
      WHERE  IsProcessed = 0

      --UTdbInfraClientTest has access to the database  as Infa_APP_ACCESS on UniTrac database on UTQA-SQL-14
      SET @sqlcmdValidation='USE [' + @DatabaseName
                            + '] SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
                            + @AppRole + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access]
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where Rp.name  = ''' + @AppRole
                            + '''
UNION
SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
                            + @AppRole + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access]
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  = ''' + @AppRole
                            + ''''
      SET @sqlcmdValidation2='USE [' + @DatabaseName
                             + '] 	SELECT DB_NAME() [DatabaseName], CONCAT(''The Account: '' ,USER_NAME(grantee_principal_id), '' has access to the table: '', 
OBJECT_NAME(major_id), '' with '' , permission_name, '' rights on '', DB_NAME(), '' database'' ) [Access]
FROM sys.database_permissions
where USER_NAME(grantee_principal_id) = '''
                             + @AppRole + '''
		  
		  
		  
		  '
      SET @sqlcmdValidation3='USE [' + @DatabaseName
                             + ']
SELECT DB_NAME() [DatabaseName],  name
from sys.server_principals
where name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%' + @AppRole
                             + '%'')
	UNION
SELECT DB_NAME() [DatabaseName],  name
from sys.server_principals
where name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  like ''%' + @AppRole + '%''	)
'

      IF @Dryrun = 0
        BEGIN
            INSERT INTO #1
            EXEC (@sqlcmdValidation)

            INSERT INTO #1
            EXEC ( @sqlcmdValidation2)

            INSERT INTO #1
            EXEC ( @sqlcmdValidation3)
        END
      ELSE
        BEGIN
            PRINT ( @sqlcmdValidation )

            PRINT ( @sqlcmdValidation2 )

            PRINT ( @sqlcmdValidation3 )
        END

      -- Update table
      UPDATE #TempDatabases
      SET    IsProcessed = 1
      WHERE  DatabaseName = @databaseName
  END

IF @Dryrun = 0 AND @DBName is null or @DBName=''
BEGIN
  SELECT *
  FROM   #1
  ORDER  BY databasename,
            Access ASC 
END
ELSE 
BEGIN
   SELECT *
  FROM   #1
     WHERE  DatabaseName = @DBName
  ORDER  BY databasename,
            Access ASC 
END