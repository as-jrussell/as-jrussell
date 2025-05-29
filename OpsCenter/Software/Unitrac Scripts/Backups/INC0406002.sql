use unitrac

--Add work item provided by user 
select id, relate_id into #tmp 
--select *
from work_item
where id in (52896116  )


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
where id in (914278, 914873) 


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
where CAST(TPL.CREATE_DT AS DATE) = CAST(GETDATE()-7 AS DATE)
and log_message like '%52896116%'
order by tpl.create_dt asc



select * from message
where id in (17917464,17917479,17919226) or relate_id_tx in (17917464,17917479,17919226)




select * from work_item_action
where work_item_id in (select ID from #tmp)
order by update_dt asc


/*

drop table #tmp
drop table #tmpPD
drop table #tmpMessage

*/


   
----------Taking them off hold for USD
UPDATE dbo.MESSAGE
SET PROCESSED_IN = 'N' , RECEIVED_STATUS_CD = 'RCVD' , LOCK_ID = LOCK_ID+1
--SELECT * FROM dbo.MESSAGE
WHERE ID IN  (17919226,17917479)


select * from trading_partner_log
where message_id in (17919226,17917479)