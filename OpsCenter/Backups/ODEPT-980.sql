/****** Script for SelectTopNRows command from SSMS  ******/

DECLARE  @AccountName nvarchar(100) = 'ELDREDGE_A\SQL_DataStore_Development_Team'
DECLARE  @AccountName2 nvarchar(100) = 'ELDREDGE_A\SQL_centerpoint_development_team'

IF Object_id(N'tempdb..#ITGroup') IS NOT NULL
DROP TABLE #ITGroup

IF Object_id(N'tempdb..#DevGroup') IS NOT NULL
DROP TABLE #DevGroup

CREATE TABLE #ITGroup (AccountName nvarchar(200), GroupName nvarchar(100))
INSERT INTO #ITGroup
SELECT [AccountName], @AccountName
  FROM [DBA].[info].[GroupMembership]
  where GroupName =  @AccountName
  AND AccountName = MappedLoginName
  
CREATE TABLE #DevGroup (AccountName nvarchar(200), GroupName nvarchar(100))
INSERT INTO #DevGroup
SELECT [AccountName], @AccountName2
FROM [DBA].[info].[GroupMembership]
  where GroupName =  @AccountName2
  AND AccountName = MappedLoginName




;with 
dislike as ( select  T.AccountName [Good Account], T.GroupName [Good GroupName],  G.AccountName [NotGood Account], G.GroupName [NotGood GroupName]

	FROM #ITGroup t
RIGHT JOIN #DevGroup  g ON t.AccountName =G.AccountName) ,

cte as (select * from  DBA.info.AuditLogin L ) 

SELECT  [Good Account], [Good GroupName], [NotGood Account],[NotGood GroupName],
CASE WHEN MAX(TimeStampUTC) is null THEN 'Never been access' ELSE
		CAST(MAX(TimeStampUTC)AS nvarchar(255)) END [Last Login]  
from dislike D
left join cte C on  D.[NotGood Account] = C.NTUserName
WHERE [Good Account] IS  NULL   
group by  [Good Account], [Good GroupName], [NotGood Account],[NotGood GroupName]
HAVING MAX(TimeStampUTC) is  null

--CREATE TABLE #DevGroup (Count INT, AccountName nvarchar(200))
--INSERT INTO #DevGroup
--select COUNT(*), AccountName 
--FROM [DBA].[info].[GroupMembership]
--  where [AccountName] in (select [AccountName] from #ITGroup)
--  AND AccountName = MappedLoginName
--	group by  AccountName


--SELECT [GroupName]
--      ,[AccountName]
--      ,[Comment]
--      ,[DiscoverDate]
--      ,[HarvestDate]
--      ,[MappedLoginName],
--	  CASE WHEN MAX(TimeStampUTC) is null THEN 'Never been access' ELSE
--		CAST(MAX(TimeStampUTC)AS nvarchar(255)) END [Last Login]
--  FROM  [DBA].[info].[GroupMembership] G
-- LEFT JOIN DBA.info.AuditLogin L on G.AccountName = L.NTUserName
--  WHERE AccountName in (SELECT AccountName 
--FROM [DBA].[info].[GroupMembership] 
--  where [AccountName] in (select [AccountName] from #ITGroup)
--  AND AccountName = MappedLoginName
--	group by  AccountName
--	having COUNT(*) >= 2
--)  AND AccountName = MappedLoginName
--Group by AccountName, GroupName, [Comment]
--      ,[DiscoverDate]
--      ,[HarvestDate]
--      ,[MappedLoginName] 
--	  having MAX(TimeStampUTC) is not null





--SELECT [GroupName]
--      ,[AccountName]
--       FROM  [DBA].[info].[GroupMembership]
--  WHERE AccountName in ('ELDREDGE_A\aali',
--'ELDREDGE_A\adclark',
--'ELDREDGE_A\arutan',
--'ELDREDGE_A\brutan',
--'ELDREDGE_A\jerkman',
--'ELDREDGE_A\jhirt',
--'ELDREDGE_A\mlockard',
--'ELDREDGE_A\ngreer',
--'ELDREDGE_A\rali',
--'ELDREDGE_A\szabinsky',
--'ELDREDGE_A\thenderson',
--'ELDREDGE_A\aali',
--'ELDREDGE_A\adclark',
--'ELDREDGE_A\arutan',
--'ELDREDGE_A\brutan',
--'ELDREDGE_A\jerkman',
--'ELDREDGE_A\jhirt',
--'ELDREDGE_A\mdahlstrom',
--'ELDREDGE_A\ngreer',
--'ELDREDGE_A\szabinsky',
--'ELDREDGE_A\thenderson')
--    AND AccountName = MappedLoginName
--	--AND AccountName NOT IN  (SELECT AccountName FROM DBA.INFO.GroupMembership WHERE GroupName = 'ELDREDGE_A\SQL_centerpoint_development_team')
--	order BY AccountName DESC 



se