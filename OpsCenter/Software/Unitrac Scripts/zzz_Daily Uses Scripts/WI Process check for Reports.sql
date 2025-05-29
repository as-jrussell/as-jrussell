USE UniTrac


--Finding WI via Number
SELECT  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
 CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID IN ()





--Process Log ID


SELECT RELATE_ID INTO #tmpRH FROM dbo.PROCESS_LOG_ITEM
WHERE process_log_id IN ()
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'

--drop table #tmpRH
SELECT L.Name_tx, L.CODE_TX, COUNT(*), MIN(rh.CREATE_DT) FROM dbo.REPORT_HISTORY rh
join lender L on L.ID = RH.LENDER_ID
join #tmpRH R on R.RELATE_ID = RH.ID
and rh.status_cd = 'PEND'
GROUP BY L.Name_tx, L.CODE_TX



SELECT retry_count_no, rh.*
 FROM dbo.REPORT_HISTORY rh
join #tmpRH R on R.RELATE_ID = RH.ID
join lender L on L.ID = RH.LENDER_ID
and document_container_id is null

