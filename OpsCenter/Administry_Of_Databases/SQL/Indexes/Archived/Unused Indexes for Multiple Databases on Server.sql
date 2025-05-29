

declare @cmd1 varchar(max)



set @cmd1='USE [?]

DECLARE @now DATETIME
SET @now = GETDATE()

SELECT  @@ServerName [ServerName],
DB_NAME() [Database Name],
o.name AS ObjectName
, i.name AS IndexName
, dm_ius.user_seeks AS UserSeek
, dm_ius.user_scans AS UserScans
, dm_ius.user_lookups AS UserLookups
, dm_ius.user_updates AS UserUpdates
, p.TableRows
, ''DROP INDEX '' + QUOTENAME(i.name)
+ '' ON '' + QUOTENAME(s.name) + ''.'' + QUOTENAME(OBJECT_NAME(dm_ius.object_id)) as ''drop statement''
, @now AS [current date]
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id AND dm_ius.object_id = i.object_id
INNER JOIN sys.objects o on dm_ius.object_id = o.object_id
INNER JOIN sys.schemas s on o.schema_id = s.schema_id
INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.object_id
FROM sys.partitions p GROUP BY p.index_id, p.object_id) p
ON p.index_id = dm_ius.index_id AND dm_ius.object_id = p.object_id
WHERE OBJECTPROPERTY(dm_ius.object_id,''IsUserTable'') = 1
AND dm_ius.database_id = DB_ID()
AND i.type_desc = ''nonclustered''
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
AND dm_ius.user_seeks = 0
AND dm_ius.user_scans = 0
AND dm_ius.user_lookups = 0
AND o.name NOT LIKE ''MS%''
AND DB_NAME() NOT IN (''msdb'', ''master'', ''tempdb'', ''model'', ''HDTStorage'', ''DBA'', ''Perfstats'')
--AND o.name  = ''WORK_ITEM_TASK''
ORDER BY p.TableRows DESC'


IF OBJECT_ID(N'tempdb..#UselessIndexes') IS NOT NULL
DROP TABLE #UselessIndexes

CREATE TABLE #UselessIndexes ([ServerName] varchar(100), [Database Name] varchar(100),[ObjectName] varchar(100), [IndexName] varchar(100) , [UserSeek] varchar(100) , [UserScans] varchar(100), [UserLookups] varchar(100), [UserUpdates] varchar(100) , [TableRows] varchar(100), [drop statement] varchar(max), [current date] DATETIME)

INSERT INTO #UselessIndexes
 exec sp_MSforeachdb @cmd1

-- print @cmd1



SELECT * FROM #UselessIndexes