use unitrac

--drop table #tmp
select id, relate_id into #tmp 
--select *
from work_item
where id in (52137812)


--drop table #tmpRH
SELECT RELATE_ID INTO #tmpRH FROM dbo.PROCESS_LOG_ITEM
WHERE process_log_id IN (select RELATE_ID from #tmp)
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'



SELECT rt.name_tx, rh.*
 FROM dbo.REPORT_HISTORY rh
join #tmpRH R on R.RELATE_ID = RH.ID
join lender L on L.ID = RH.LENDER_ID
join report rt on rt.id = rh.report_id
where  report_id = 69


select * from work_item_action
where work_item_id in (select ID from #tmp)
and ACTION_CD = 'Generate Escrow File'


select * from PROCESS_LOG
where process_definition_id in ()


select * from work_item_action
where work_item_id in (select ID from #tmp)
and ACTION_CD = 'Add Note Only'



select * from PROCESS_LOG
where process_definition_id in (889955)


select * from work_item_action
where work_item_id in (select ID from #tmp)
order by update_dt asc

select * from work_item
where relate_id IN (889955, 17251419)


select * 
from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
where tpl.create_dt >= '2019-02-05 17:00' and trading_partner_id = 2436
and log_message like '%52137812%'
order by tpl.create_dt asc

select * from message
where id in (17251419) or relate_id_tx in (17251419)


