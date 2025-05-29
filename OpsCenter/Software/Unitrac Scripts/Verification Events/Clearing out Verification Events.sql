USE UniTrac


SELECT PLI.RELATE_ID AS VERIFICATION_EVENT_WI ,
       LOAN_ID [LOAN_ID]
	   into #tmpN
FROM   PROCESS_LOG_ITEM PLI
       JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIP ON WIP.PROCESS_LOG_ITEM_ID = PLI.ID
                                                     AND WIP.PURGE_DT IS NULL
       JOIN WORK_ITEM WI ON WI.ID = WIP.WORK_ITEM_ID
                            AND WI.WORKFLOW_DEFINITION_ID = 9
	   JOIN NOTICE N on N.ID = PLI.RELATE_ID and PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Notice' and N.TYPE_CD = 'PN'
WHERE  PLI.PURGE_DT IS NULL
       AND WI.ID = 48846919;     /* CYLE WORK ITEM */


	   select * from #tmp


--Loan Notice Cycle Reset
SELECT 
rc.*
--INTO #tmpRC
FROM   LOAN L
       INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
       INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
       INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
       INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE  L.ID IN (select loan_id from #tmp)
     
UPDATE rc 
SET rc.NOTICE_DT =NULL, rc.NOTICE_SEQ_NO = '0'
--SELECT NOTICE_DT, NOTICE_SEQ_NO,* 
FROM dbo.REQUIRED_COVERAGE rc
WHERE ID IN (SELECT id FROM #tmpRC)


SELECT pli.evaluation_event_id into #tmpN
FROM   PROCESS_LOG_ITEM PLI
       JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIP ON WIP.PROCESS_LOG_ITEM_ID = PLI.ID
                                                     AND WIP.PURGE_DT IS NULL
       JOIN WORK_ITEM WI ON WI.ID = WIP.WORK_ITEM_ID
                            AND WI.WORKFLOW_DEFINITION_ID = 9
	   JOIN NOTICE N on N.ID = PLI.RELATE_ID and PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Notice' and N.TYPE_CD = 'PN'
WHERE  PLI.PURGE_DT IS NULL
       AND WI.ID = 48846919;     /* CYLE WORK ITEM */


	  -- drop table #tmpN
select * from evaluation_event
where id in (select * from #tmpN)



update EE
set status_cd = 'CLR', purge_dt =GETDATE()
--select *
from evaluation_event EE
where EE.id in (select * from #tmpN)


