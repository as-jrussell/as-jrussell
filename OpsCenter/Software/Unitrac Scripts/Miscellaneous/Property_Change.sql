USE UniTrac
---Property Change Table Query



SELECT * 
FROM dbo.PROPERTY_CHANGE PC
LEFT JOIN dbo.PROPERTY_CHANGE_UPDATE PCU ON PC.ID = PCU.CHANGE_ID
WHERE PC.USER_TX = '' AND pc.CREATE_DT >= ''


---It will always be on of the items below
/*
ENTITY_NAME_TX
Allied.UniTrac.Collateral
Allied.UniTrac.DocumentInteraction
Allied.UniTrac.Escrow
Allied.UniTrac.Loan
Allied.UniTrac.Owner
Allied.UniTrac.OwnerPolicy
Allied.UniTrac.OwnerPolicyInteraction
Allied.UniTrac.PolicyCoverage
Allied.UniTrac.ProcessHelper.UniTracProcessDefinit
Allied.UniTrac.Property
Allied.UniTrac.RequiredCoverage
Osprey.ProcessMgr.ProcessDefinition
Quote
Refund

*/


SELECT top 1 PCU.* 
FROM dbo.PROPERTY_CHANGE PC
LEFT JOIN dbo.PROPERTY_CHANGE_UPDATE PCU ON PC.ID = PCU.CHANGE_ID
WHERE pc.ENTITY_NAME_TX = 'Allied.UniTrac.cOLLATERAL' AND FORMAT_TO_VALUE_TX = 'nEW'
order by pc.id desc 




SELECT TOP 1 * 
FROM dbo.PROPERTY_CHANGE_UPDATE PCU
WHERE pcu.FORMAT_FROM_VALUE_TX = 'nEW'
ORDER BY change_ID DESC 

SELECT * 
FROM UNITRAC.DBO.LOAN
WHERE NUMBER_TX = '69493-008'


SELECT * 
FROM dbo.PROPERTY_CHANGE PC
LEFT JOIN dbo.PROPERTY_CHANGE_UPDATE PCU ON PC.ID = PCU.CHANGE_ID
WHERE pc.ENTITY_NAME_TX = 'Allied.UniTrac.RequiredCoverage' AND 
pc.ENTITY_ID IN (
SELECT PROPERTY_ID
FROM COLLATERAL
WHERE LOAN_ID = 203494269)
ORDER BY PCU.CREATE_DT DESC 

SELECT * FROM WORK_ITEM_ACTION
WHERE work_item_ID IN (95118347)

SELECT top 100 SERVER_TX, * 
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 336 
and END_DT is not null
and SERVER_TX <> 'UNITRAC-WH004'
ORDER BY ID DESC 


SELECT
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[3]', 'varchar (50)') ProcessID,
* FROM WORK_ITEM wi
WHERE wi.CREATE_DT >= '2022-01-01' and
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') is not NULL


SELECT * FROM WORK_ITEM_ACTION
WHERE work_item_ID IN (95118347)


SELECT *
FROM PROCESS_LOG
WHERE ID IN (109302358,109302605)

SELECT  PLI.INFO_XML.value('(/INFO_LOG/RELATE_INFO)[1]', 'varchar (85)') [lOAN NUMBER]
into #tmp
--SELECT  PLI.INFO_XML.value('(/INFO_LOG/RELATE_INFO)[1]', 'varchar (85)'), *
FROM PROCESS_LOG_ITEM  pli
WHERE PROCESS_LOG_ID IN (109302358,109302605)


SELECT  [lOAN NUMBER], COUNT(*)
FROM #tmp
group by [lOAN NUMBER]
HAVING COUNT(*) > '1'







SELECT TOP 1 * 
FROM COLLATERAL