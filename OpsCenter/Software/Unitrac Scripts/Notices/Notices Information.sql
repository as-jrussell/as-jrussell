USE UniTrac


--Find out notice and document container by Loan Number

SELECT pl.ID, PRINT_STATUS_CD,PRINTED_DT, OB.OUTPUT_CONFIGURATION_ID, DC.*
from PROCESS_LOG pl
inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
inner join NOTICE N on N.id = pli.relate_id 
inner join LOAN L on L.ID = n.LOAN_ID
INNER JOIN dbo.OUTPUT_BATCH OB ON OB.PROCESS_LOG_ID = PL.ID 
left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
where L.NUMBER_TX = 'XXXXXX'
ORDER BY dc.UPDATE_DT ASC 


--SELECT pl.ID, PRINT_STATUS_CD,PRINTED_DT, OB.OUTPUT_CONFIGURATION_ID, DC.*
select pli.*
from LOAN L 
inner join NOTICE N on L.ID = n.LOAN_ID
join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
join process_log_item pli on pli.relate_id = n.id and pli.relate_type_cd = 'allied.unitrac.notice'
JOIN dbo.OUTPUT_BATCH OB ON OB.PROCESS_LOG_ID = PL.ID 
where L.NUMBER_TX = '20015-55'
ORDER BY dc.UPDATE_DT ASC 


---Find Batch by Process Log ID
SELECT OUTPUT_BATCH.EXTERNAL_ID,*
from OUTPUT_BATCH
INNER JOIN OUTPUT_BATCH_LOG ON OUTPUT_BATCH.ID = OUTPUT_BATCH_LOG.OUTPUT_BATCH_ID
WHERE OUTPUT_BATCH.PROCESS_LOG_ID IN (XXXXXXX) --AND LOG_TXN_TYPE_CD = 'SENT' 


--Notice Types
SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'NoticeType' 
AND ACTIVE_IN = 'Y' AND PURGE_DT IS NULL


---Updating Notice back to pending status
--UPDATE N
--SET PDF_GENERATE_CD = 'PEND', LOCK_ID = LOCK_ID+1
----SELECT *
-- FROM dbo.NOTICE N
--WHERE N.ID IN(XXXXXX)