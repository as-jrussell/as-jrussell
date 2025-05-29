select pl.ID, PRINT_STATUS_CD,PRINTED_DT, OB.OUTPUT_CONFIGURATION_ID, DC.*
from PROCESS_LOG pl
inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
inner join NOTICE N on N.id = pli.relate_id 
inner join LOAN L on L.ID = n.LOAN_ID
INNER JOIN dbo.OUTPUT_BATCH OB ON OB.PROCESS_LOG_ID = PL.ID 
left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
where L.NUMBER_TX = '2215637701'

SELECT OUTPUT_BATCH.EXTERNAL_ID,*
from OUTPUT_BATCH
INNER JOIN OUTPUT_BATCH_LOG ON OUTPUT_BATCH.ID = OUTPUT_BATCH_LOG.OUTPUT_BATCH_ID
WHERE OUTPUT_BATCH.PROCESS_LOG_ID IN (37449526) --AND LOG_TXN_TYPE_CD = 'SENT' 


SELECT * FROM dbo.OUTPUT_CONFIGURATION
WHERE ID = '4886'

SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID = '37449526'


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = '37449526'

UPDATE N
SET PDF_GENERATE_CD = 'PEND', LOCK_ID = LOCK_ID+1
--SELECT *
 FROM dbo.NOTICE N
WHERE N.ID IN(19234347)

SELECT * FROM dbo.TEMPLATE
WHERE ID = '135'

SELECT * FROM dbo.LENDER
WHERE CODE_TX = '2805'
--2048

SELECT IH.* FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = C.PROPERTY_ID
WHERE L.NUMBER_TX = '2215637701' AND L.LENDER_ID = '2048'
AND IH.CREATE_DT >= '2016-09-16 ' AND IH.CREATE_DT <= '2016-09-17 '

--83429567
--89890410

SELECT * FROM dbo.CPI_QUOTE C
LEFT JOIN dbo.CPI_ACTIVITY A ON A.CPI_QUOTE_ID = C.ID
WHERE C.ID = '37161203'


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'R'

SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID = '256110572'

SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID = '56226234'


SELECT * FROM dbo.OWNER_POLICY OP
WHERE OP.POLICY_NUMBER_TX = '4996057500'

USE UniTrac


SELECT TOP 10 pl.ID, PRINT_STATUS_CD,PRINTED_DT, OB.OUTPUT_CONFIGURATION_ID, DC.*
from PROCESS_LOG pl
inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
inner join NOTICE N on N.id = pli.relate_id 
inner join LOAN L on L.ID = n.LOAN_ID
INNER JOIN dbo.OUTPUT_BATCH OB ON OB.PROCESS_LOG_ID = PL.ID 
left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
WHERE ob.OUTPUT_CONFIGURATION_ID = '4886'AND PRINT_STATUS_CD  IN ('PRINTED')
ORDER BY dc.CREATE_DT DESC 


select pl.ID, PRINT_STATUS_CD,PRINTED_DT, OB.OUTPUT_CONFIGURATION_ID, DC.*
from PROCESS_LOG pl
inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
inner join NOTICE N on N.id = pli.relate_id 
inner join LOAN L on L.ID = n.LOAN_ID
INNER JOIN dbo.OUTPUT_BATCH OB ON OB.PROCESS_LOG_ID = PL.ID 
left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
where L.NUMBER_TX = '2215637701'

SELECT *
INTO UniTracHDStorage..INC0251617
 FROM dbo.DOCUMENT_CONTAINER
 WHERE ID = '67537270'


 UPDATE dbo.DOCUMENT_CONTAINER
 SET OUTPUT_CONFIGURATION_XML = '<OutputConfigurationSettings TypeCd="NTC" SubTypeCd="" OutputTypeCd="EMAIL">
  <EmailSubject>Insurance Information Requested</EmailSubject>
  <EmailFromAddress>donotreply@myinsuranceinfo.com</EmailFromAddress>
</OutputConfigurationSettings>'
--SELECT *  FROM dbo.DOCUMENT_CONTAINER
 WHERE ID = '67537270'