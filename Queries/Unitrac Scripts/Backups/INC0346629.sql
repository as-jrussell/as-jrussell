USE UniTrac


--Finding WI via Number
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID IN (45291163)



--Finding WI via CODE_TX
----REPLACE #### WITH THE THE Lender ID
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
INNER JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
WHERE L.CODE_TX = '' AND WI.STATUS_CD = ''  
AND --WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted', 'Initial') AND 
WI.UPDATE_DT >= ''
AND WI.WORKFLOW_DEFINITION_ID = 'X'



--Process Log ID


SELECT RELATE_ID INTO #tmpRH FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = '57874404'
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'

--drop table #tmpRH
SELECT * FROM dbo.REPORT_HISTORY
WHERE ID IN (SELECT * FROM #tmpRH)

