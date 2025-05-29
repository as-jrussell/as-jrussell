use unitrac

--Add work item provided by user 
select id, relate_id into #tmp 
--select *
from work_item
where id in ( 52911790, 52919723, 52923908  )


/*check to see if the escrow file has been generated 
 */

select * from work_item_action
where work_item_id in (select ID from #tmp)
and ACTION_CD = 'Generate Escrow File'

/*check to see if the escrow file has been completed */
select * from work_item_action
where work_item_id in (select ID from #tmp)
and ACTION_CD = 'Add Note Only'

/* If it has not been completed then take a look at the process definition
use the process definition id that is in the action note of the previous two queries to enter in the next process defintion id) */

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service], id into #tmpPD 
--select *
from process_definition
where id in (914882, 914936, 914955, 914974, 914985) 


--Check to see if processed 
select  *
from PROCESS_LOG pl
join #tmpPD pd on pd.id = pl.process_definition_id
order by pl.update_dt desc 

--If it hasn't check to see what is running no process should run longer than hour if it is please research
select  top 10  CONVERT(TIME,END_DT- START_DT)[hh:mm:ss],*
from PROCESS_LOG pl
join #tmpPD pd on pd.[Target Service] = pl.service_name_tx
order by pl.update_dt desc 

select * from process_definition pd
join #tmpPD tp on pd.id = tp.id

---As long as the process definition has completed check to see if there an output file in the log message add the work item provided

select message_id into #tmpMessage
--select * 
from TRADING_PARTNER_LOG tpl
where CAST(TPL.CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)
and trading_partner_id = 2436
--and log_message like '%%'
order by tpl.create_dt asc

select * from trading_partner
where external_id_tx = '2771'

select * from message
where id in (#######) or relate_id_tx in (#######) 




select * from work_item_action
where work_item_id in (select ID from #tmp)
order by update_dt asc


/*

drop table #tmp
drop table #tmpPD
drop table #tmpMessage

*/


   
