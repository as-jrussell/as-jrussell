DECLARE @SQLlogin VARCHAR(max)
DECLARE @SQLuser VARCHAR(max)
DECLARE @SQLPasswordReset VARCHAR(max) 
DECLARE @sqlcmdValidation VARCHAR(1000)
DECLARE @sqlcmdValidation2 VARCHAR(400)
DECLARE @sqlcmdValidation3 VARCHAR(1000)
DECLARE @sqlcmdValidation4 VARCHAR(1000)
DECLARE @username NVARCHAR(200) = 'UTRCdbNancy.Yu' ---Username
DECLARE @Password NVARCHAR(200) = 'Password1234!!!' --Password
DECLARE @DatabaseName SYSNAME
DECLARE @DryRun BIT = 0 --1 preview / 0 executes it  
DECLARE @PasswordReset BIT = 0 --1 preview / 0 executes it  

IF @PasswordReset = 0
BEGIN 

select @SQLPasswordReset = '
USE [master]
ALTER LOGIN ['+@username+'] WITH DEFAULT_DATABASE=[Unitrac], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON'

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLPasswordReset)
  END
ELSE
  BEGIN
      PRINT ( @SQLPasswordReset )
  END

end 

ELSE 

BEGIN
SELECT @sqllogin = '	USE [master]

  IF NOT EXISTS (SELECT 1 FROM sys.server_principals where name = '''
                   + @username + ''')
BEGIN 

CREATE LOGIN [' + @username
                   + '] WITH PASSWORD= ''' + @Password
                   + ''' MUST_CHANGE, DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GRANT ALTER TRACE TO [' + @username
                   + ']
GRANT VIEW SERVER STATE TO [' + @username + ']
END
'

IF @DryRun = 0
  BEGIN
      EXEC ( @sqllogin)
  END
ELSE
  BEGIN
      PRINT ( @sqllogin )
  END

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
SELECT DatabaseName,
       0 -- SELECT *
FROM   [DBA].[backup].[Schedule] S
       JOIN sys.databases D
         ON S.DatabaseName = D.name
WHERE  databasetype = 'USER'
       AND DatabaseName <> 'PerfStats'

-- Loop through the remaining databases
WHILE EXISTS(SELECT *
             FROM   #TempDatabases
             WHERE  IsProcessed = 0)
  BEGIN
      -- Fetch 1 DatabaseName where IsProcessed = 0
      SELECT TOP 1 @DatabaseName = DatabaseName
      FROM   #TempDatabases
      WHERE  IsProcessed = 0

      -- Prepare SQL Statement
      SELECT @SQLuser = '

USE [' + @DatabaseName
                        + ']
  IF NOT EXISTS (SELECT 1 FROM sys.database_principals where name = '''
                        + @username + ''')
BEGIN 
CREATE USER [' + @username
                        + '] FOR LOGIN [' + @username
                        + ']
ALTER ROLE [db_datareader] ADD MEMBER ['
                        + @username
                        + ']
ALTER ROLE [db_datawriter] ADD MEMBER ['
                        + @username
                        + ']
ALTER ROLE [db_executor] ADD MEMBER ['
                        + @username + ']
GRANT SHOWPLAN TO [' + @username + ']
END 

'

      -- You know what we do here if it's 1 then it'll give us code and 0 executes it
      IF @DryRun = 0
        BEGIN
            PRINT ( @DatabaseName )

            EXEC ( @sqluser)
        --	EXEC ( @sqllogin)
        END
      ELSE
        BEGIN
            PRINT ( @sqluser )
        --	PRINT ( @sqllogin)
        END



      -- Update table
      UPDATE #TempDatabases
      SET    IsProcessed = 1
      WHERE  DatabaseName = @databaseName
  END 
END



IF @DryRun = 0
BEGIN
 IF Object_id(N'tempdb..#1') IS NOT NULL
  DROP TABLE #1

CREATE TABLE #1
  (
     [databasename] VARCHAR(250),
     [Access]       VARCHAR(max),
	 [DatabaseBaseType] VARCHAR(250)
  )


IF Object_id(N'tempdb..#TempDatabases2') IS NOT NULL
  DROP TABLE #TempDatabases2

CREATE TABLE #TempDatabases2
  (
     DatabaseName SYSNAME,
     IsProcessed BIT
  )
-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases2 (DatabaseName, IsProcessed)
SELECT name, 0 -- SELECT *
FROM   sys.databases
WHERE  database_id >= 4
AND name NOT IN ('DBA', 'Perfstats')
ORDER  BY database_id

WHILE EXISTS( SELECT * FROM #TempDatabases2 WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases2 WHERE IsProcessed = 0 


	

--UTdbInfraClientTest has access to the database  as Infa_APP_ACCESS on UniTrac database on UTQA-SQL-14
SET @sqlcmdValidation='USE [' + @DatabaseName
                             + '] SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
          + @username + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access], ''USER'' 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where Rp.name  = ''' + @username  + '''
UNION
SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
          + @username + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access], ''USER'' 
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  = ''' + @username  + ''''
	  
SET @sqlcmdValidation2='USE [' + @DatabaseName
                             + '] 	SELECT DB_NAME() [DatabaseName], CONCAT(''The Account: '' ,USER_NAME(grantee_principal_id), '' has access to the table: '', 
OBJECT_NAME(major_id), '' with '' , permission_name, '' rights on '', DB_NAME(), '' database'' ) [Access], ''USER'' 
FROM sys.database_permissions
where USER_NAME(grantee_principal_id) = '''
          + @username + '''
		  
		  
		  
		  '


SET @sqlcmdValidation3='USE [' + @DatabaseName
                             + ']
SELECT DB_NAME() [DatabaseName],  name, ''USER'' 
from sys.server_principals
where name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where rp.name  like ''%'+ @username  +'%'')
	UNION
SELECT DB_NAME() [DatabaseName],  name, ''USER'' 
from sys.server_principals
where name  in (select  mp.name
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  like ''%'+ @username  +'%''	)
'



SET @sqlcmdValidation4='USE [master]
SELECT  
 DB_NAME() [DatabaseName],
what.permission_name, ''SYSTEM'' 
FROM
sys.server_permissions what
INNER JOIN sys.server_principals who
ON who.principal_id = what.grantee_principal_id
WHERE who.name ='''+ @username  +'''	
'


INSERT INTO #1
   EXEC (@sqlcmdValidation)

INSERT INTO #1
  EXEC ( @sqlcmdValidation2)

  INSERT INTO #1
  EXEC ( @sqlcmdValidation3) 

INSERT INTO #1
  EXEC ( @sqlcmdValidation4) 


    -- Update table
    UPDATE  #TempDatabases2 
    SET IsProcessed = 1
    WHERE DatabaseName = @databaseName


  END

  
    



	SELECT DISTINCT *
FROM   #1
order by DatabaseBaseType ASC, databasename,Access desc
END 
