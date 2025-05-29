USE UniTrac


------Place Lender Code
--DROP TABLE #tmpPD
 SELECT id into #tmpPD
 --select  *
 FROM dbo.PROCESS_DEFINITION
where active_in = 'Y' and onhold_in = 'N'  
and status_cd <> 'Expired'
and NAME_TX like '%%'


-------Grabs ID to move to Work Item
--DROP TABLE #tmpPL
select id into #tmpPL
--select * 
from process_log 
where PROCESS_DEFINITION_id in (select * from #tmpPD)
and CAST(update_dt AS DATE) >= CAST(GETDATE() AS DATE)
and end_dt is not null

--Cycle Work Items
select * from work_item
where relate_id in (select * from #tmpPL) and workflow_definition_id = 9



--DROP TABLE #tmpWI
select id into #tmpWI from work_item
where relate_id in (select * from #tmpPL) and workflow_definition_id = 9


--DROP TABLE #tmpWIA
select action_note_tx into #tmpWIA from work_item_action
where work_item_id in (select * from #tmpWI) and action_note_tx <> '' 

--DROP TABLE #tmpPL2
select ID into #tmpPL2
--select * 
from process_log 
where PROCESS_DEFINITION_id in (select * from #tmpWIA)
and CAST(update_dt AS DATE) >= CAST(GETDATE() AS DATE)
and end_dt is not null


----Billing Work Items
select * from work_item
where relate_id in (select distinct relate_id from process_log_item
where process_log_id in (select * from #tmpPL2) and relate_type_cd = 'Allied.UniTrac.BillingGroup')
and workflow_definition_id = 10