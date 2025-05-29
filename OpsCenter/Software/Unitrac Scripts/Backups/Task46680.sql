use unitrac


select distinct MESSAGE_ID into #tmpMessage
--select * 
from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
where tp.EXTERNAL_ID_TX = '2771' and tpl.create_dt >= '2018-08-16'

select * from MESSAGE
where id in (select * from #tmpMessage)


select * from work_item
where relate_id in  (select * from #tmpMessage)
and WORKFLOW_DEFINITION_ID = '1'


drop table #tmpMessage 