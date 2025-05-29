

use unitrac


select * from PROCESS_DEFINITION
where NAME_TX like ''


select * from process_log
where PROCESS_DEFINITION_ID = ''
and update_dt >= ''


SELECT RELATE_ID INTO #tmpRH FROM dbo.PROCESS_LOG_ITEM
WHERE process_log_id IN ()
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'

--drop table #tmpRH
SELECT L.Name_tx [Lender Name], L.CODE_TX [Lender Code], RR.NAME_TX [Report Name],rh.record_count_no [Report record count], rh.status_cd [Print status], rh.update_dt [Report Processed]
 FROM dbo.REPORT_HISTORY rh
join lender L on L.ID = RH.LENDER_ID
join #tmpRH R on R.RELATE_ID = RH.ID
join REPORT RR on RR.ID = RH.report_id
