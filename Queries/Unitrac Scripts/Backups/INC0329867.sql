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
select L.DIVISION_CODE_TX, dc.*
from LOAN L 
inner join NOTICE N on L.ID = n.LOAN_ID
join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
join process_log_item pli on pli.relate_id = n.id and pli.relate_type_cd = 'allied.unitrac.notice'
--JOIN dbo.OUTPUT_BATCH OB ON OB.PROCESS_LOG_ID = PLI.PROCESS_LOG_ID
where L.NUMBER_TX = '20015-55'
ORDER BY dc.UPDATE_DT ASC 

SELECT * FROM process_log_item
WHERE process_log_id = 50251069

SELECT * FROM work_item
WHERE id = 41559694

SELECT * FROM process_log
WHERE ID = 50251069

SELECT * FROM evaluation_event
WHERE ID = 103445589

SELECT * FROM required_coverage
WHERE ID = 150294047

SELECT * FROM event_sequence
WHERE ID = 163261

SELECT * FROM event_seq_container
WHERE ID = 48340

SELECT * FROM ref_code
WHERE code_cd = 'CE'

SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.ENTITY_ID IN ('10719') AND C.ENTITY_NAME_TX IN ('Allied.UniTrac.ProcessHelper.UniTracProcessDefinit')

SELECT * FROM PROCESS_DEFINITION
WHERE ID = 10719

SELECT * FROM  dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 10719 AND UPDATE_DT >= '2017-01-01'
--AND  UPDATE_DT <= '2017-08-01'
AND END_DT IS NOT NULL

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = --50251069

SELECT * FROM dbo.LENDER_ORGANIZATION
WHERE LENDER_ID = 722

--49218198
--49550886
49889927

---Find Batch by Process Log ID
SELECT OUTPUT_BATCH.EXTERNAL_ID,*
from OUTPUT_BATCH
--INNER JOIN OUTPUT_BATCH_LOG ON OUTPUT_BATCH.ID = OUTPUT_BATCH_LOG.OUTPUT_BATCH_ID
WHERE OUTPUT_BATCH.PROCESS_LOG_ID IN (50251069) --AND LOG_TXN_TYPE_CD = 'SENT' 



SELECT     
concat(SERVER_SHARE_TX,'\',RELATIVE_PATH_TX,'\')  as  [Document]
FROM dbo.DOCUMENT_CONTAINER DC 
JOIN dbo.DOCUMENT_MANAGEMENT DM ON DM.ID = DC.DOCUMENT_MANAGEMENT_ID
WHERE DC.ID IN (93213278,
93213285)

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


SELECT * FROM dbo.PROCESS_LOG
WHERE ID = 46905951


SELECT * FROM dbo.PROCESS_DEFINITION
WHERE iD = 14107


SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.ENTITY_ID IN ('14107') AND C.ENTITY_NAME_TX IN ('Allied.UniTrac.ProcessHelper.UniTracProcessDefinit')



SELECT * FROM dbo.OUTPUT_CONFIGURATION OC
JOIN dbo.LENDER L ON L.ID = OC.RELATE_ID AND OC.RELATE_CLASS_TX = 'Allied.UniTrac.Lender'
WHERE L.CODE_TX = '5030'

SELECT PROCESS_LOG_ID INTO #tmp FROM dbo.OUTPUT_BATCH
WHERE OUTPUT_CONFIGURATION_ID = 2009

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 53287396

SELECT * FROM dbo.PROCESS_LOG
WHERE ID = 53287396


SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID IN (10719, 10720)


SELECT * FROM dbo.LENDER_COLLATERAL_GROUP_COVERAGE_TYPE
where ID IN (2365, 2364)


SELECT * FROM dbo.LENDER_COLLATERAL_CODE_GROUP
WHERE ID IN (1173,
1172)

SELECT * FROM dbo.LENDER_PRODUCT
WHERE ID IN (2331,
2332)



SELECT PROCESS_DEFINITION_ID INTO #tmp2 FROM dbo.PROCESS_LOG
WHERE ID IN (SELECT * FROM #tmp)

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID IN (SELECT * FROM #tmp2)