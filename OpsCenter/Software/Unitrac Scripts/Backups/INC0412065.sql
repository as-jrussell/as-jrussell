USE [UniTrac]
GO 


select * from unitrachdstorage..INC0412065
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT l.number_tx, L.PURGE_DT, L.RECORD_TYPE_CD, P.PURGE_DT, P.RECORD_TYPE_CD, C.PURGE_DT, RC.PURGE_DT, RC.RECORD_TYPE_CD, RC.SUMMARY_STATUS_cd, RC.SUMMARY_SUB_STATUS_CD, P.*
--into unitrachdstorage..INC0412065
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2282') AND L.NUMBER_TX IN ('1098001048')
and rc.type_cd = 'hazard'

update rc
set type_cd='COMM-LIABILITY', record_type_cd = 'G',update_dt = GETDATE(), update_user_tx ='INC0412065', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, summary_status_cd = 'C', cpi_status_cd = 'C'
from required_coverage rc
where id in (247023097)


update rc
set type_cd=jc.type_cd, record_type_cd = jc.record_type_cd,update_dt = GETDATE(), update_user_tx ='INC0412065',
summary_status_cd = jc.summary_status_cd,cpi_status_cd = jc.cpi_status_cd
--, LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, summary_status_cd = 'C', cpi_status_cd = 'C'
--select *
from required_coverage rc
join unitrachdstorage..INC0412065 jc on rc.id = jc.id 

update rc
set type_cd='COMM-LIABILITY', record_type_cd = 'D',update_dt = GETDATE(), update_user_tx ='INC0412065', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, summary_status_cd = 'C', cpi_status_cd = 'C'
from required_coverage rc
where id in (244351058)



select * from ref_code
where code_cd = 'B'


B	C

select * from ref_code 
where domain_cd = 'RequiredCoverageInsStatus'


select * from interaction_history
where property_id = 241256306