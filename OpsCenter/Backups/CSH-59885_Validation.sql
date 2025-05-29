DECLARE @cmd1 VARCHAR(500)
DECLARE @cmd2 VARCHAR(500)
DECLARE @account VARCHAR(100) = 'ELDREDGE_A\Positrac-Daemon-PROD'
--UTdbInfraClientTest has access to the database  as Infa_APP_ACCESS on UniTrac database on UTQA-SQL-14
SET @cmd1='USE [?]  SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
          + @account + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access]
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  = ''' + @account
          + ''''
SET @cmd2='USE [?] 	SELECT DB_NAME() [DatabaseName], CONCAT(''The Account: '' ,USER_NAME(grantee_principal_id), '' has access to the table: '', 
OBJECT_NAME(major_id), '' with '' , permission_name, '' rights on '', DB_NAME(), '' database'' ) [Access]
FROM sys.database_permissions
where USER_NAME(grantee_principal_id) = '''
          + @account + ''''

IF Object_id(N'tempdb..#1') IS NOT NULL
  DROP TABLE #1

CREATE TABLE #1
  (
     [databasename] VARCHAR(250),
     [Access]       VARCHAR(max)
  )

INSERT INTO #1
EXEC Sp_msforeachdb
  @cmd1

INSERT INTO #1
EXEC Sp_msforeachdb
  @cmd2

SELECT *
FROM   #1


