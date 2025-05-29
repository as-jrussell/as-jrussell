USE [UniTrac]
GO



--DROP TABLE #tmp
/*
select CONVERT(DATE,rh.update_dt) AS [Reports Create Date], COUNT(rh.id) [Reports] 
into #tmp
from report_history rh
where status_cd = 'ERR'  
AND CAST(rh.UPDATE_DT AS DATE) >= CAST(GETDATE()-6 AS DATE) and 
REPORT_ID IN (75,25,31,26,79,81,61,11,63,29,28)
GROUP BY CONVERT(DATE,rh.update_dt)


select * from #tmp
order by [Reports Create Date] ASC
*/


select rh.id into #tmp
from report_history rh
where CAST(rh.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE) and 
REPORT_ID IN (75,25,31,26,79,81,61,11,63,29,28)




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
join #tmp T on T.ID = rh.id



