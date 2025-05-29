--Loan Search Details
SELECT TOP 10 *
FROM SEARCH_FULLTEXT

select TOP 10 *
from LOAN
WHERE LENDER_ID = 968 AND RECORD_TYPE_CD = 'G' AND CREATE_DT >= '2015-04-01'

SELECT *
FROM LENDER
WHERE ID = 968


--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
select *
from LOAN
INNER JOIN COLLATERAL ON LOAN.ID = COLLATERAL.LOAN_ID
INNER JOIN PROPERTY ON COLLATERAL.PROPERTY_ID = PROPERTY.ID
INNER JOIN REQUIRED_COVERAGE ON PROPERTY.ID = REQUIRED_COVERAGE.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE ON LOAN.ID = OWNER_LOAN_RELATE.LOAN_ID
INNER JOIN OWNER ON OWNER_LOAN_RELATE.OWNER_ID = OWNER.ID
INNER JOIN OWNER_ADDRESS ON OWNER.ADDRESS_ID = OWNER_ADDRESS.ID
WHERE LOAN.NUMBER_TX = '29870535-80-3' AND LENDER_ID = 968

--LOAN HISTORY SEARCH INFORMATION
SELECT TOP 10 *
FROM INTERACTION_HISTORY
WHERE PROPERTY_ID = 85507662

--DOCUMENT STORAGE LOCATIONS BY TYPE/AGENCY
SELECT *
FROM DOCUMENT_MANAGEMENT

--Notice Information by Loan
SELECT DC.*
FROM LOAN L 
inner join NOTICE N on L.ID = n.LOAN_ID
left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
WHERE L.NUMBER_TX = '29870535-80-3' 

--FPC Information by Loan
SELECT *
FROM LOAN L 
inner join FORCE_PLACED_CERTIFICATE FPC on L.ID = FPC.LOAN_ID
left outer join document_container dc on dc.relate_id = FPC.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate' AND DC.PURGE_DT IS NULL
WHERE L.NUMBER_TX = '039-007806' AND L.LENDER_ID = 2216

--Cycle Process Definitions by Lender
SELECT *
FROM PROCESS_DEFINITION
WHERE NAME_TX LIKE '%1036%' AND PROCESS_TYPE_CD = 'CYCLEPRC' AND ACTIVE_IN = 'Y'

--Log of Process Runs
SELECT *
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 10416
ORDER BY START_DT DESC

--Certificates created by Process
SELECT dc.*
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
						inner join FORCE_PLACED_CERTIFICATE fpc on fpc.id = pli.relate_id 
			left outer join document_container dc on dc.relate_id = fpc.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
WHERE PROCESS_DEFINITION_ID = 10416 AND PL.ID = 23400728


--Cycle Porcesses by Lender
SELECT LENDER.CODE_TX, LENDER.NAME_TX, PROCESS_DEFINITION.*
FROM PROCESS_DEFINITION
INNER JOIN LENDER ON SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]' , 'varchar(20)') = LENDER.ID
WHERE PROCESS_TYPE_CD = 'CYCLEPRC' AND ACTIVE_IN = 'Y' AND LENDER.CODE_TX = '1771'

SELECT *
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 16048 AND STATUS_CD = 'Complete'
ORDER BY START_DT DESC

select *
from process_log_item
where PROCESS_LOG_ID = 23638223 order by RELATE_TYPE_CD

--File by Cert ID
SELECT DM.SERVER_SHARE_TX+'\'+RELATIVE_PATH_TX+'\'+CAST(DC.ID as varchar(20))+'.pdf',*
FROM document_container  DC
INNER JOIN DOCUMENT_MANAGEMENT DM ON DC.DOCUMENT_MANAGEMENT_ID = DM.ID
WHERE dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
AND DC.RELATE_ID = 5098829

--File by Notice ID
SELECT DM.SERVER_SHARE_TX+'\'+RELATIVE_PATH_TX+'\'+CAST(DC.ID as varchar(20))+'.pdf',*
FROM document_container DC
INNER JOIN DOCUMENT_MANAGEMENT DM ON DC.DOCUMENT_MANAGEMENT_ID = DM.ID
WHERE dc.relate_class_name_tx = 'allied.unitrac.NOTICE'
AND DC.RELATE_ID = 13414896

--Certs by Cycle Process
SELECT DM.SERVER_SHARE_TX+'\'+RELATIVE_PATH_TX+'\'+CAST(DC.ID as varchar(20))+'.pdf',*
from PROCESS_LOG pl
inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
inner join FORCE_PLACED_CERTIFICATE fpc on fpc.id = pli.relate_id 
left outer join document_container dc on dc.relate_id = fpc.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
INNER JOIN DOCUMENT_MANAGEMENT DM ON DC.DOCUMENT_MANAGEMENT_ID = DM.ID
INNER JOIN PROCESS_DEFINITION PD ON pl.PROCESS_DEFINITION_ID = PD.ID
INNER JOIN LENDER L ON SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]' , 'varchar(20)') = L.ID
WHERE PROCESS_TYPE_CD = 'CYCLEPRC' AND PD.ACTIVE_IN = 'Y' AND L.CODE_TX = '1771' AND PL.START_DT >= '2015-06-05'

--Notices by Cycle Process
SELECT DM.SERVER_SHARE_TX+'\'+RELATIVE_PATH_TX+'\'+CAST(DC.ID as varchar(20))+'.pdf',*
from PROCESS_LOG pl
inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
inner join NOTICE N on N.id = pli.relate_id 
left outer join document_container dc on dc.relate_id = N.id and dc.relate_class_name_tx = 'allied.unitrac.notice'
INNER JOIN DOCUMENT_MANAGEMENT DM ON DC.DOCUMENT_MANAGEMENT_ID = DM.ID
INNER JOIN PROCESS_DEFINITION PD ON pl.PROCESS_DEFINITION_ID = PD.ID
INNER JOIN LENDER L ON SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]' , 'varchar(20)') = L.ID
WHERE PROCESS_TYPE_CD = 'CYCLEPRC' AND PD.ACTIVE_IN = 'Y' AND L.CODE_TX = '1771' AND PL.START_DT >= '2015-06-05'


SELECT TOP 100 *
FROM OUTPUT_BATCH
WHERE PROCESS_LOG_ID = 23638223

--Notices created by Process
SELECT dc.*
								from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
	WHERE PROCESS_DEFINITION_ID = 10416 AND PL.ID = 23400728

--Output Batches by Process	
SELECT *
FROM OUTPUT_BATCH	
WHERE PROCESS_LOG_ID = 23400728

--Printers/Output Paths
SELECT *
FROM OUTPUT_DEVICE

--Work Item Search by Process			
SELECT * 
FROM WORK_ITEM 
WHERE RELATE_ID = 23400728


