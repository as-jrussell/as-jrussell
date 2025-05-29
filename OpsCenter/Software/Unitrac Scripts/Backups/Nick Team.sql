USE [UniTrac]
GO 


SELECT
COUNT(*) [Counts], STATUS_CD [Status]
FROM REPORT_HISTORY  rh
LEFT JOIN dbo.DOCUMENT_CONTAINER dc ON dc.id = rh.DOCUMENT_CONTAINER_ID
WHERE CAST(rh.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE)  AND rh.GENERATION_SOURCE_CD = 'u'
GROUP BY	STATUS_CD


SELECT MAX(rh.UPDATE_DT) [Last Report Done by UBSRPT]
FROM REPORT_HISTORY  rh
WHERE   STATUS_CD = 'COMP'
AND CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
		AND rh.UPDATE_USER_TX = 'UBSRPT'

SELECT MAX(CREATE_DT) [Last UTL Matched]
FROM UTL_MATCH_RESULT 
WHERE UTL_VERSION_NO = 2 AND CREATE_DT > dateadd(dd, -3, getdate()) 

select count(*)as [OldSyncCount - Should be zero],  min(CREATE_DT) [Oldest UTL] 
from UTL_CACHE_CHANGE_QUEUE
where DATEDIFF(minute, CREATE_DT, getutcdate()) > 120

select count(*) [Cert Count]
 from force_placed_certificate
 where   CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
 and pdf_generate_cd = 'PEND'

select count(*) [Notice Count]
from notice
where   CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
and pdf_generate_cd = 'PEND'
SELECT COUNT(*) [WI in Approve Total]
FROM dbo.WORK_ITEM WI
JOIN dbo.MESSAGE M ON M.RELATE_ID_TX = WI.RELATE_ID AND WI.WORKFLOW_DEFINITION_ID = '1'
WHERE WI.STATUS_CD = 'Approve'


SELECT COUNT(*) [WI in Approve needs to be processed and not touched]
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = 'Approve'
AND CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') IS NULL



SELECT COUNT(*) [WIs that excluding LFPs that are in Error]
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = 'Error'
AND   CAST(create_dt AS DATE) = CAST(GETDATE()-1AS DATE)
AND WORKFLOW_DEFINITION_ID <> '1'
AND PURGE_DT IS NULL AND CONTENT_XML.value('(/Content/EvaluationError)[1]', 'varchar (85)') NOT LIKE '%Unable to load%'
AND CONTENT_XML.value('(/Content/EvaluationError)[1]', 'varchar (85)') NOT LIKE '%Object reference not set to an instance of an object%'

