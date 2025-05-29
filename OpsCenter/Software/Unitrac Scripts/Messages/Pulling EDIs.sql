USE Unitrac 

SELECT * FROM process_log
WHERE ID = '83357993' 

select * from REF_CODE	
where CODE_CD in ('INSCNFCT')

--drop table #tmpM
 select distinct MESSAGE_ID into #tmpM 
 from trading_partner_log TPL
 JOIN TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
 where  CAST(tpl.CREATE_DT AS DATE) >= CAST(GETDATE()-4 AS DATE) 

 select max(t.update_dt) [Last Processed], count(*) [Counts], tp.TYPE_CD
from [TRANSACTION] T
join DOCUMENT d on d.id = t.DOCUMENT_ID
join MESSAGE m on m.id = d.MESSAGE_ID
join TRADING_PARTNER tp on tp.id = m.RECIPIENT_TRADING_PARTNER_ID
join #tmpM MM on MM.MESSAGE_ID = M.ID 
where t.PROCESSED_IN = 'Y'
group by tp.TYPE_CD 

 select max(t.CREATE_DT) [Not processed], count(*)[Counts], tp.TYPE_CD
from [TRANSACTION] T
join DOCUMENT d on d.id = t.DOCUMENT_ID
join MESSAGE m on m.id = d.MESSAGE_ID
join TRADING_PARTNER tp on tp.id = m.RECIPIENT_TRADING_PARTNER_ID
join #tmpM MM on MM.MESSAGE_ID = M.ID 
where t.PROCESSED_IN = 'N'
group by tp.TYPE_CD 





 select distinct MESSAGE_ID into #tmpM 
 from trading_partner_log TPL
 JOIN TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
 where  CAST(tpl.CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)

select D.MESSAGE_ID, TP.NAME_TX ,TP.EXTERNAL_ID_TX, COUNT(*), CONVERT(date, D.CREATE_DT)
from [TRANSACTION] T
join DOCUMENT D on D.id = T.document_id
join MESSAGE m on m.id = d.MESSAGE_ID
join TRADING_PARTNER tp on tp.id = m.RECIPIENT_TRADING_PARTNER_ID
where document_id in (select id from document
where message_id in (select MESSAGE_ID from #tmpM))
GROUP BY D.MESSAGE_ID,  TP.EXTERNAL_ID_TX, TP.NAME_TX,TP.EXTERNAL_ID_TX,CONVERT(date, D.CREATE_DT)
order by COUNT(*) desc



select * from work_item
where id in (67229658)


select * from trading_partner_log
where message_id = 24648810


select * from message
where relate_id_tx = 24648810


select * from 


select max(update_dt) from [TRANSACTION]
where DOCUMENT_ID in (35766518,
35766519,
35766520,
35766521,
35766522,
35766523,
35766524,
35766525,
35766526,
35766527) and PROCESSED_IN = 'Y'
--39757


SELECT *
 FROM UniTrac..Document
 where id in (35766518,
35766519,
35766520,
35766521,
35766522,
35766523,
35766524,
35766525,
35766526,
35766527)


select * from message
where id in (24831168)

select * from DOCUMENT_MANAGEMENT
