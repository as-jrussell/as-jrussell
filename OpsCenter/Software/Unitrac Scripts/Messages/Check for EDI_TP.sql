use unitrac


select * from process_definition
where id in (39)


select tp.TYPE_CD, * from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
join MESSAGE m on m.RELATE_ID_TX = tpl.MESSAGE_ID
where tp.TYPE_CD = 'LFP_TP' and m.UPDATE_USER_TX not in ('LDHPCRA','LDHADHOC','LDHS','LDHW','LDHH') 
and m.MESSAGE_DIRECTION_CD = 'O'  AND   CAST(tpl.CREATE_DT AS DATE) = CAST(GETDATE()-7 AS DATE)

select MIN(UPDATE_DT) from process_log
where process_definition_id = 39
 AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE()-30 AS DATE)
 order by update_dt desc

 select * from trading_partner_log
 where trading_partner_id in (select id from trading_partner where type_cd = 'EDI_TP')
  AND   CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)
 order by CREATE_DT desc

 --drop table #tmpM
 select distinct MESSAGE_ID into #tmpM 
 from trading_partner_log
 where --trading_partner_id in (select id from trading_partner where type_cd = 'LFP_TP' 'EDI_TP') and
   CAST(CREATE_DT AS DATE) >= CAST(GETDATE() AS DATE)


 SELECT * FROM dbo.MESSAGE
WHERE (ID IN  (24885939) OR RELATE_ID_TX IN  (24885939))
order by update_dt desc

select * from document
where message_id in (24774859)
order by update_dt desc

select * from [TRANSACTION]
where DOCUMENT_ID = 35718207

select COUNT(*), D.MESSAGE_ID, TP.NAME_TX, TP.EXTERNAL_ID_TX , m.CREATE_DT
from [TRANSACTION] T
join DOCUMENT D on D.id = T.document_id
join MESSAGE m on m.id = d.MESSAGE_ID
join TRADING_PARTNER tp on tp.id = m.RECIPIENT_TRADING_PARTNER_ID
where document_id in (select id from document
where message_id in (select MESSAGE_ID from #tmpM))
GROUP BY D.MESSAGE_ID,  TP.EXTERNAL_ID_TX, TP.NAME_TX,   TP.ID ,m.CREATE_DT
order by  m.CREATE_DT DESC
--92148
--77698

select * from PROCESS_DEFINITION
where PROCESS_TYPE_CD = 'LOANPRCPA'



SELECT value_tx,DELIVERY_CODE_TX, tp.TYPE_CD, di.*
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE VALUE_TX like '%filelocker%'
order by  tp.TYPE_CD ASC

VALUE_TX = '\\filelocker\FTP\FTP Archives\SoftFile_IDR\ArchiveInput'
