DECLARE @cmd1 VARCHAR(500)

--UTdbInfraClientTest has access to the database  as Infa_APP_ACCESS on UniTrac database on UTQA-SQL-14
SET @cmd1='USE [?]  SELECT DB_NAME(),
    class_desc 
  , CASE WHEN class = 0 THEN DB_NAME()
         WHEN class = 1 THEN OBJECT_NAME(major_id)
         WHEN class = 3 THEN SCHEMA_NAME(major_id) END [Securable]
  , USER_NAME(grantee_principal_id) [User]
  , permission_name
  , state_desc
FROM sys.database_permissions'

IF Object_id(N'tempdb..#1') IS NOT NULL
  DROP TABLE #1

CREATE TABLE #1
  (
     [databasename] VARCHAR(250),
     [class_desc]       VARCHAR(max),
      [Securable]     VARCHAR(max),
     [User]      VARCHAR(max),
     [permission_name]       VARCHAR(max),
     [state_desc]       VARCHAR(max)
  )

INSERT INTO #1
EXEC Sp_msforeachdb
  @cmd1


SELECT *
FROM   #1
where [permission_name] = 'VIEW DEFINITION'
and databasename <> 'master'

/*


EXEC sp_MSforeachdb 'use [?] '

select * from sys.databases a
LEFT JOIN #1 b on a.name = b.databasename
where b.databasename is null and a.database_id >= 5
and a.name not in ('DBA', 'Perfstats')


exec xp_logininfo  'ELDREDGE_A\mlockard'



select CONCAT('USE [',name, '] ALTER ROLE [db_datawriter] DROP MEMBER [SQL_RFPL_Development_Team]') 
from sys.databases a
LEFT JOIN #1 b on a.name = b.databasename
where  a.database_id >= 5
and a.name not in ('DBA', 'Perfstats', 'HDTStorage')
*/
