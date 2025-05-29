USE UniTrac


SELECT * FROM dbo.PROCESS_LOG pl 
JOIN dbo.PROCESS_DEFINITION pd ON pd.ID = pl.PROCESS_DEFINITION_ID
WHERE pd.PROCESS_TYPE_CD = 'CYCLEPRC' AND  CAST(pl.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
AND PL.END_DT IS NOT NULL


SELECT le.code_Tx as LenderCode, le.name_tx as LenderName, wi.id as WorkItemId, count(pli.id) as ErrorCount,wi.create_dt as WorkItemCreateDate 
FROM PROCESS_LOG_ITEM PLI
INNER JOIN WORK_ITEM WI ON WI.RELATE_ID = PLI.PROCESS_LOG_ID AND WI.WORKFLOW_DEFINITION_ID = 9
inner join lender le on le.id = wi.lender_id
WHERE PLI.STATUS_CD = 'ERR'
AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.RequiredCoverage'
AND  CAST(pli.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
and pli.info_xml.value('(/INFO_LOG/MESSAGE_LOG)[1]','nvarchar(max)') like '%rpa%'
group by le.code_Tx, le.name_tx, wi.id,wi.create_dt
ORDer by count(pli.id) desc
