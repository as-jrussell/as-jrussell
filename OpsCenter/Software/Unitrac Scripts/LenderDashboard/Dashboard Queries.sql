--UNITRAC-WH02	Dashboard
--UNITRAC-WH18	LenderDashboard
--UNITRAC-WH18	OperationalDashboard
USE OspreyDashboard
--1) Internal Dashboard
SELECT *
FROM PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'DASHCACHE'

select *
from PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 144381 AND START_DT >= '2016-01-15'
ORDER BY START_DT DESC

--Osprey.DashboardService.exe.config (Config Info for Internal Dashboard)
--exec DashboardCacheRefresh (SP with Internal DB queries



--2) Osprey Dashboard (Lender Dashboard)

select *
from OspreyDashboard.dbo.CONNECTION_DESCRIPTOR

select DS.UPDATE_DT,*
from OspreyDashboard.dbo.DATASOURCE DS
ORDER BY DS.UPDATE_DT DESC

select *
from OspreyDashboard.dbo.PROCESS_DEFINITION

Select *
from OspreyDashboard.dbo.PROCESS_LOG
WHERE START_DT >= '2017-03-01'
ORDER BY START_DT ASC 

Select *
from OspreyDashboard.dbo.PROCESS_LOG_ITEM
ORDER BY CREATE_DT DESC



--3) Operational Dashboard
select *
from OperationalDashboard.dbo.CONNECTION_DESCRIPTOR

select DS.UPDATE_DT,*
from OperationalDashboard.dbo.DATASOURCE DS
ORDER BY DS.UPDATE_DT DESC



--Job Updates:
--Operational Dashboard
UPDATE DATASOURCE
SET LAST_CACHE_UPDATE_DT = '2016-01-06 20:00:00.0000000', LOCK_ID = LOCK_ID + 1
--Osprey Dashboard
UPDATE DATASOURCE
SET LAST_CACHE_UPDATE_DT = '2016-01-06 22:30:00.0000000', LOCK_ID = LOCK_ID + 1
where ID not in (8,9,150)
--Unfinished Queries (Osprey Dashboard)
UPDATE DATASOURCE
SET LAST_CACHE_UPDATE_DT = '2016-01-06 20:30:00.0000000', LOCK_ID = LOCK_ID + 1
where ID in (8,9,150,110,7)

--Internal Dashboard Updates
UPDATE PROCESS_DEFINITION
SET LOCK_ID = LOCK_ID + 1,OVERRIDE_DT = '2016-01-07 00:00:00.000',
SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with "1/7/2016 8:00:00 PM"')
WHERE ID = 144381


SELECT * FROM OspreyDashboard..PROCESS_DEFINITION

SELECT * FROM OspreyDashboard..PROCESS_LOG

SELECT * FROM OperationalDashboard..PROCESS_LOG