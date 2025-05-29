--Remove all elements from the plan cache for the entire instance
DBCC FREEPROCCACHE;

--Flush the plan cache for the entire instance and suppress the regular completion message
DBCC FREEPROCCACHE WITH NO_INFOMSGS;

--Flush the ad hoc and prepared plan cache for the entire instance
DBCC FREESYSTEMCACHE ('SQL Plans');

--Flush the ad hoc and prepared plan cache for one resource pool
DBCC FREESYSTEMCACHE ('SQL Plans', 'LimitedIOPool');

-- Flush the entire plan cache for one resource pool
DBCC FREEPROCCACHE ('LimitedIOPool');

--Remove all elements from the plan cache for one database (does not work in SQL Azure)
-- Get DBID from one database name first
DECLARE @intDBID INT;
SET @intDBID = (SELECT [dbid] 
                FROM master.dbo.sysdatabases 
                WHERE name = N'AdventureWorks2014');

DBCC FLUSHPROCINDB (@intDBID);


--Clear plan cache for the current database
USE DBNAME;
GO
-- New in SQL Server 2016 and SQL Azure
ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE;


-- Remove one query plan from the cache

-- Find the plan handle for that query 
-- OPTION (RECOMPILE) keeps this query from going into the plan cache
SELECT cp.plan_handle, cp.objtype, cp.usecounts, 
DB_NAME(st.dbid) AS [DatabaseName]
FROM sys.dm_exec_cached_plans AS cp CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st 
WHERE OBJECT_NAME (st.objectid)
LIKE N'%uspGetEmployeeManagers%' OPTION (RECOMPILE); 

-- Remove the specific query plan from the cache using the plan handle from the above query 
DBCC FREEPROCCACHE (0x050011007A2CC30E204991F30200000001000000000000000000000000000000000000000000000000000000);
 
