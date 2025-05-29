USE PremAcc3

--Reportse
SELECT Report_Query_1, * FROM dbo.Report_List
WHERE Report_Name LIKE '%refund%'


SELECT DISTINCT report_group FROM dbo.Report_List
WHERE Report_Name LIKE '%refund%'

SELECT Report_Query_1, *FROM dbo.Report_List
where Report_Group = 'Management'
aND  Report_Query_1 LIKE '%iVOS%'


---When a report runs
select Run_After, Started [Start], Finished, E_Mail_Sent, Notify_Sent,*
from ScheduleParameters
WHERE Report_Name LIKE '%backfeed%'
ORDER BY Started DESC 


select Run_After, Started [Start], Finished, E_Mail_Sent, Notify_Sent,*
 from ReportParameters
WHERE Report_Name LIKE '%backfeed%'
order by ID desc



select Report_Description, rl.Report_Group, Run_After, Started [Start], Finished, E_Mail_Sent, Notify_Sent,*
 from ReportParameters rp
 LEFT JOIN dbo.Report_List rl on rp.report_list_id = rl.id
where rp.Report_List_ID =754
--and report_group like '%Unitrac%'
order by rl.ID desc



select CONVERT(TIME,finished- started)[hh:mm:ss], Report_Description, Run_After, Started [Start], Finished, E_Mail_Sent, Notify_Sent,*
 from ReportParameters rp
 join dbo.Report_List rl on rp.report_list_id = rl.id
where rp.report_name = 'CPI Certificate Audit'-- and started >='2019-01-01'
--and report_group like '%Unitrac%'
order by rl.ID desc





select 
CURRENT_TIMESTAMP 