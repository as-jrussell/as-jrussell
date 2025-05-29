 use unitrac

 ----Identify Transactions

select MI.ID INTO #tmpMessageEDI
FROM MESSAGE MI (NOLOCK)
JOIN DELIVERY_INFO DI (NOLOCK) ON DI.ID = MI.DELIVERY_INFO_ID
JOIN TRADING_PARTNER TP (NOLOCK) ON TP.ID = DI.TRADING_PARTNER_ID  
where TP.TYPE_CD IN ('OCR_TP', 'IDR_TP', 'BSS_TP', 'EDI_TP') AND  CAST(MI.CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)


SELECT ID into #tmpDocumentEDI
FROM DOCUMENT
WHERE MESSAGE_ID IN (select ID from #tmpMessageEDI)       


SELECT id into #tmp3087EDI
FROM [TRANSACTION]
WHERE DOCUMENT_ID IN (select ID from #tmpDocumentEDI) 
AND  CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)





--drop table #tmp3087EDI_IGN
select id, document_id into #tmp3087EDI_IGN
FROM [TRANSACTION]
where ID in (select ID from #tmp3087EDI) and STATUS_CD = 'ERR'


--drop table #tmp3087EDI_IGN_Message 
select message_id into #tmp3087EDI_IGN_Message 
from document
where id in (select document_id from #tmp3087EDI_IGN)

--vALIDATION

SELECT DATA.value('(/Transaction/InsuranceDocument/Insured/LastName)[1]' , 'varchar(20)') as LastName,
DATA.value('(/Transaction/InsuranceDocument/Insured/FirstName)[1]' , 'varchar(20)') as FirstName,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/Year)[1]' , 'varchar(20)') as Year,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/Make)[1]' , 'varchar(20)') as Make,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/Model)[1]' , 'varchar(20)') as Model,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/Style)[1]' , 'varchar(20)') as Style,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/VIN)[1]' , 'varchar(20)') as VIN,
DATA.value('(/Transaction/InsuranceDocument/InsuranceCompany/CompanyName)[1]' , 'varchar(40)') as InsCo,
DATA.value('(/Transaction/InsuranceDocument/Policy/@Number)[1]' , 'varchar(40)') as PolNo

FROM [TRANSACTION]
where ID in (select ID from #tmp3087EDI) and STATUS_CD = 'ERR'

--BACKUP

select * 
into unitrachdstorage..CHG0XXXXXX_Transaction
from [Transaction] T
where id in (select id from #tmp3087EDI_IGN) 

SELECT * 
into unitrachdstorage..CHG0XXXXXX_Message
FROM MESSAGE M
WHERE  relate_id_tx IN (SELECT message_id FROM #tmp3087EDI_IGN_Message)
       AND MESSAGE_DIRECTION_CD = 'O'


----IMPLEMENTATION 

--Reset Processed Flag on Transactions
update T set   DATA.modify('replace value of (/Transaction/@Processed)[1] with "N"')
--select * 
from [Transaction] T
where id in (select id from #tmp3087EDI_IGN) 

--Reset Ignore Flag on Transactions and reset entire trasnactions to re-process
update T    
SET     STATUS_CD = 'INIT',PROCESSED_IN = 'N' ,LOCK_ID = LOCK_ID + 1,
DATA.modify('replace value of (/Transaction/@Ignore)[1] with "N"')
--select * 
from [Transaction] T
where id in (select id from #tmp3087EDI_IGN) 


--Reset Outbound message to be reprocessed
UPDATE  M
SET     RECEIVED_STATUS_CD = 'INIT',SENT_STATUS_CD = 'PEND',LOCK_ID = LOCK_ID + 1, PROCESSED_IN = 'N'
--SELECT * 
FROM MESSAGE M
WHERE  relate_id_tx IN (SELECT message_id FROM #tmp3087EDI_IGN_Message)
       AND MESSAGE_DIRECTION_CD = 'O'

---BackOut

UPDATE  M
SET     RECEIVED_STATUS_CD = E.RECEIVED_STATUS_CD,SENT_STATUS_CD = E.SENT_STATUS_CD,M.LOCK_ID =M. LOCK_ID + 1, PROCESSED_IN =E.PROCESSED_IN
--SELECT * 
FROM MESSAGE M
join unitrachdstorage..CHG010963_Message E on E.ID = M.ID


update T    
SET     STATUS_CD =E.STATUS_CD,PROCESSED_IN = E.PROCESSED_IN ,T.LOCK_ID = T.LOCK_ID + 1,
DATA = E.DATA
--select	E.* 
from [Transaction] T
join unitrachdstorage..CHG010963_Transaction E on E.ID = T.ID
