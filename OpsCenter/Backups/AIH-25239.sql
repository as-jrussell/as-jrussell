
  
EXEC sp_MSforeachdb 'USE [?] IF EXISTS (select * FROM sys.database_principals where name = ''ELDREDGE_A\IT Development'')
	BEGIN 
	DROP USER [ELDREDGE_A\IT Development]
	END'




IF EXISTS (select * FROM sys.server_principals where name = 'ELDREDGE_A\IT Development')
	BEGIN 
	DROP LOGIN [ELDREDGE_A\IT Development]
	END


/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE @cmd1 VARCHAR(500)
DECLARE @cmd2 VARCHAR(500)
DECLARE  @AccountName nvarchar(100) = 'ELDREDGE_A\SQL_DataStore_Development_Team'
DECLARE  @AccountName2 nvarchar(100) = --'ELDREDGE_A\SQL_centerpoint_development_team'
'ELDREDGE_A\IT Development'


SELECT *
  FROM [DBA].[info].[GroupMembership]
  where GroupName =  @AccountName
  AND AccountName = MappedLoginName
    ORDER BY HARVESTDATE DESC 
  
SELECT *
  FROM [DBA].[info].[GroupMembership]
  where GroupName =  @AccountName2
  ORDER BY HARVESTDATE DESC 
  
SET @cmd1='USE [?]  SELECT  DB_NAME()[DatabaseName], CONCAT(''The Account: '
          + @AccountName + ' has access to the database '', 
 '' as '' ,  rp.name, '' on '', DB_NAME(), '' database'', '' on the '', @@SERVERNAME ) [Access]
	from sys.database_role_members dm
	join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
	join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
	where mp.name  = ''' + @AccountName
          + ''''
SET @cmd2='USE [?] 	SELECT DB_NAME() [DatabaseName], CONCAT(''The Account: '' ,USER_NAME(grantee_principal_id), '' has access to the table: '', 
OBJECT_NAME(major_id), '' with '' , permission_name, '' rights on '', DB_NAME(), '' database'' ) [Access]
FROM sys.database_permissions
where USER_NAME(grantee_principal_id) = '''
          + @AccountName + ''''

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
order by databasename, Access asc

