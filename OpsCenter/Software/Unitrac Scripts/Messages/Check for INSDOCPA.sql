use unitrac


select * from process_definition
where id in (39)


select * from process_log
where process_definition_id = 39
 AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
 order by update_dt desc

 select *
 from trading_partner_log
 where CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE) and process_cd = 'INSDOCPA'
 order by CREATE_DT desc

 --drop table #tmpM
 select distinct MESSAGE_ID into #tmpM 
 from trading_partner_log
 where CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE) and process_cd != 'lfp_tp'

 SELECT * FROM dbo.MESSAGE
WHERE (ID IN  (select MESSAGE_ID from #tmpM) OR RELATE_ID_TX IN  (select MESSAGE_ID from #tmpM))
order by update_dt desc

select * from document
where message_id in (select MESSAGE_ID from #tmpM)
order by update_dt desc

select * from [TRANSACTION]
where document_id in (select id from document
where message_id in (select MESSAGE_ID from #tmpM))
order by id desc

SELECT tp.TYPE_CD, tp.EXTERNAL_ID_TX, * from [TRANSACTION] t
JOIN dbo.DOCUMENT d ON d.id = t.DOCUMENT_ID
JOIN dbo.MESSAGE m ON m.ID = d.MESSAGE_ID
JOIN dbo.TRADING_PARTNER tp ON tp.id = m.RECEIVED_FROM_TRADING_PARTNER_ID
where t.id in (
 select distinct relate_id_tx
 from trading_partner_log
 where CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE) and process_cd = 'idr_tp')
 order by t.id desc


