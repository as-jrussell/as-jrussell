USE UniTrac


--XXXXXXX replace with the work item(s)
SELECT  
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WQ.NAME_TX [Queue], WI.*
into #tmpPL
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID IN (49682254,49688204,49692436,49683022)



--DROP TABLE in #tmpPL
SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE process_log_id in (select ProcessID from #tmpPL)


SELECT RELATE_ID INTO #tmpRH FROM dbo.PROCESS_LOG_ITEM
WHERE process_log_id in (select ProcessID from #tmpPL)
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'

--drop table #tmpRH
SELECT * FROM dbo.REPORT_HISTORY rh
join #tmpRH R on R.relate_ID = rh.id




---Use the report Id and update ## field and the XXXXXXXX with the report ID
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE(), DOCUMENT_CONTAINER_ID = NULL
--select * 
from report_history rh
join #tmpRH T on T.relate_ID = rh.id