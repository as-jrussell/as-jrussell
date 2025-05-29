use unitrac


select * from process_definition
where  UPDATE_USER_TX = 'DWSrvrIN'

SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss], * from process_log
where process_definition_id IN (11847,
732881)
 AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
 order by update_dt desc


 select * from process_log
where process_definition_id IN (39)
 AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
 order by update_dt desc

 select * from trading_partner_log
 where   CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)
 order by CREATE_DT desc

 --drop table #tmpM
 select distinct MESSAGE_ID into #tmpM 
 from trading_partner_log
 where trading_partner_id in (select id from trading_partner where type_cd = 'OCR_TP')
  AND   CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)


 SELECT * FROM dbo.MESSAGE
WHERE (ID IN  (select MESSAGE_ID from #tmpM) OR RELATE_ID_TX IN  (select MESSAGE_ID from #tmpM))
order by update_dt desc

select * from document
where message_id in (select MESSAGE_ID from #tmpM)
order by update_dt desc

select * from [TRANSACTION]
where document_id in (select id from document
where message_id in (select MESSAGE_ID from #tmpM))
order by update_dt desc




select * from 