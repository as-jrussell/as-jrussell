use unitrac


--Add work items
select relate_id 
into #tmpWI
from work_item
where workflow_definition_id = 1 and 
id in ()

---Check to see if any are in error
select *
from work_item
where workflow_definition_id = 1 and 
relate_id in (select * from #tmp)

--Verify that received status isn't in error and processed on the inbound status
select * from message
where id in (select * from #tmpWI)

--Verify that received status isn't in error and processed on the outbound status
select * from message
where relate_id_tx in (select * from #tmpWI)

---Check for errors
select * from trading_partner_log
where message_id in (select * from #tmpWI) 
and log_type_cd = 'Error'