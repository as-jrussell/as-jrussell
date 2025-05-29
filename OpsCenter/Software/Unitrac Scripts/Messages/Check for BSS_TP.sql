use unitrac


select * from process_definition
where id in (39)


select * from process_log
where process_definition_id = 39
 AND  CREATE_DT >= DateAdd(DAY, -1, getdate())
 order by update_dt desc

 select * from trading_partner_log
 where trading_partner_id in (select id from trading_partner where type_cd = 'BSS_TP')
  AND   CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-365 AS DATE)
 order by CREATE_DT desc



--drop table #tmpM
SELECT  M.* 
--into #tmpM 
FROM MESSAGE M
INNER JOIN TRADING_PARTNER TP ON TP.ID = M.RECIPIENT_TRADING_PARTNER_ID
 where tp.id in (select id from trading_partner where type_cd = 'BSS_TP')
--  AND  m.CREATE_DT >= DateAdd(HOUR, -16, getdate())
and m.CREATE_DT >='2020-03-05 18:37:42.190' and m.CREATE_DT <= '2020-03-05 19:48:32.383'
order by CREATE_DT asc

  select * from #tmpM

  SELECT  M.* 
into #tmpM 
FROM MESSAGE M
INNER JOIN TRADING_PARTNER TP ON TP.ID = M.RECIPIENT_TRADING_PARTNER_ID
 where tp.id in (select id from trading_partner where type_cd = 'BSS_TP')
  AND  m.CREATE_DT >= DateAdd(MINUTE, -90, getdate()) and m.MESSAGE_DIRECTION_CD  = 'I'

  select * from MESSAGE
  where RELATE_ID_TX in (  select id from #tmpM)
  order by update_dt desc
  --2020-03-05 19:48:39.637

  SELECT  M.* 
FROM MESSAGE M
INNER JOIN TRADING_PARTNER TP ON TP.ID = M.RECIPIENT_TRADING_PARTNER_ID
join DOCUMENT d on d.MESSAGE_ID = m.ID
join [TRANSACTION] t on t.document_id = d.id
 where tp.id in (select id from trading_partner where type_cd = 'BSS_TP')
  AND  m.CREATE_DT >= DateAdd(MINUTE, -90, getdate())



select * from document
where message_id in (select id from #tmpM)
and UPDATE_DT <='2020-03-05 19:00:32.383' and UPDATE_DT >= '2020-03-05 19:48:32.383'
order by update_dt desc
--2020-03-05 19:48:32.383

select * from [TRANSACTION]
where document_id in (select id from document
where message_id in (select id from #tmpM))
order by update_dt desc


select top 1 * from unitrac..[TRANSACTION]
where UPDATE_USER_TX ='LDHWebService'
--AND PROCESSED_IN = 'Y'
order by id desc



select * from PROCESS_DEFINITION
where NAME_TX like '%generation%'

--2020-03-05 18:37:42.190

--2020-03-05 18:35:18.743

--73622419562784



select top 1 * from NOTICE
where reference_id_tx = 73622419562784


select * from loan
where id in (64013353


select * from COLLATERAL
where LOAN_ID = 64013353


select * from INTERACTION_HISTORY
where property_id = 36916348
0order by CREATE_DT asc



--drop table #tmpM
 select distinct MESSAGE_ID into #tmpM 
 from trading_partner_log TPL
 JOIN TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
 where  CAST(tpl.CREATE_DT AS DATE) >= CAST(GETDATE()-2 AS DATE)

 select max(t.update_dt) [Last Processed], count(*) [Counts], tp.TYPE_CD
from [TRANSACTION] T
join DOCUMENT d on d.id = t.DOCUMENT_ID
join MESSAGE m on m.id = d.MESSAGE_ID
join TRADING_PARTNER tp on tp.id = m.RECIPIENT_TRADING_PARTNER_ID
join #tmpM MM on MM.MESSAGE_ID = M.ID 
where t.PROCESSED_IN = 'Y'
group by tp.TYPE_CD