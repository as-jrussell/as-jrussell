use unitrac


select * from process_definition
where id in (39)


select * from process_log
where process_definition_id = 39
 AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
 order by update_dt desc

 select * from trading_partner_log
 where trading_partner_id in (select id from trading_partner where type_cd IN ('IDR_TP', 'EDI_TP', 'OCR_TP', 'LFP_TP'))
  AND   CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)
 order by CREATE_DT desc

 --drop table #tmpM
 select distinct MESSAGE_ID into #tmpM 
 from trading_partner_log
 where trading_partner_id in (select id from trading_partner where type_cd IN ('IDR_TP', 'EDI_TP', 'OCR_TP', 'LFP_TP'))
  AND   CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)


 SELECT * FROM dbo.MESSAGE
WHERE (ID IN  (select MESSAGE_ID from #tmpM) OR RELATE_ID_TX IN  (select MESSAGE_ID from #tmpM))
order by update_dt desc

select * from document
where message_id in (select MESSAGE_ID from #tmpM)
order by update_dt desc

select top 50 * from [TRANSACTION]
where document_id in (select id from document
where message_id in (select MESSAGE_ID from #tmpM)) and PROCESSED_IN = 'Y'
order by update_dt DESC



SELECT tp.TYPE_CD, tp.EXTERNAL_ID_TX, * from [TRANSACTION] t
JOIN dbo.DOCUMENT d ON d.id = t.DOCUMENT_ID
JOIN dbo.MESSAGE m ON m.ID = d.MESSAGE_ID
JOIN dbo.TRADING_PARTNER tp ON tp.id = m.RECEIVED_FROM_TRADING_PARTNER_ID
where t.document_id in (select id from document
where message_id in (select MESSAGE_ID from #tmpM)) and m.PROCESSED_IN = 'Y'
order by t.update_dt DESC