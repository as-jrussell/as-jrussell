use unitrac


select distinct MESSAGE_ID into #tmpMessage
--select * 
from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
where tp.EXTERNAL_ID_TX IN ('2771') and tpl.create_dt >= '2019-02-04 19:00'
--and LOG_MESSAGE like '%.dat%'
order by tpl.create_dt asc


select * from MESSAGE
where id in (select * from #tmpMessage)


select * from work_item
where relate_id in  (select * from #tmpMessage)
and WORKFLOW_DEFINITION_ID = '1'


drop table #tmpMessage 


Output File : (\\as.local\shared\CarmelShares\PenFed_Escrow\ESC-2771.52115513-20190204193535.txt) archived to Directory : \\vut-app\Mountain\2771Test\FileC\ArchiveInput  as File: (\\vut-app\Mountain\2771Test\FileC\ArchiveInput\2019_02_04_19_43_03_108-ESC-2771.52115513-20190204193535.txt) created for Document Id : 29383596

select * from work_item_action
where work_item_id = 52115513



Generate Escrow File - Process Definition (Id=889202) was created

update pd set status_cd = 'Initial'
--select status_cd,* 
from process_definition pd
where id in (889202)


select status_cd,* 
from process_definition pd
where id in (889202,889223)




update pl set purge_dt = GETDATE()
--select *
from PROCESS_LOG pl
where process_definition_id in (889202)



select * from process_log_item
where process_log_id in (69030272,
69117236)
