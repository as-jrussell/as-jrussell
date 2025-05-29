use unitrac


 insert INTO REF_code 
 (CODE_CD, DOMAIN_CD, MEANING_TX, DESCRIPTION_TX, ACTIVE_IN, CREATE_DT, UPDATE_DT, PURGE_DT, UPDATE_USER_TX, LOCK_ID, AGENCY_ID, ID, ORDER_NO)
SELECT 'DUPLICATE', DOMAIN_CD, 'Possible Duplicate Payment - Coverage Paid Within 60 Days', 'Possible Duplicate Payment - Coverage Paid Within 60 Days', ACTIVE_IN, GETDATE(), GETDATE(), PURGE_DT, '', LOCK_ID, AGENCY_ID, ORDER_NO
FROM REF_CODE WHERE DOMAIN_CD = 'EscrowExceptionReason'
AND  ID IN (6779)



 insert INTO REF_code 
 (CODE_CD, DOMAIN_CD, MEANING_TX, DESCRIPTION_TX, ACTIVE_IN, CREATE_DT, UPDATE_DT, PURGE_DT, UPDATE_USER_TX, LOCK_ID, AGENCY_ID,  ORDER_NO)
SELECT 'NEWLOAN', DOMAIN_CD, 'Due Date Less Than 6 Months from Loan Effective Date', 'Due Date Less Than 6 Months from Loan Effective Date', ACTIVE_IN, GETDATE(), GETDATE(), PURGE_DT, '', LOCK_ID, AGENCY_ID, ORDER_NO
FROM REF_CODE WHERE DOMAIN_CD = 'EscrowExceptionReason'
AND  ID IN (6779)


insert into ESCROW_EXCEPTION_DEFINITION
(reason_cd, function_name_tx, standard_in, create_dt, update_dt, UPDATE_USER_TX, PURGE_DT, LOCK_ID) 
select  'NEWLOAN','fn_EscrowEx_NEWLOANoan', standard_in, GETDATE(),GETDATE(), '', PURGE_DT, LOCK_ID
from ESCROW_EXCEPTION_DEFINITION
where id = 50


insert into ESCROW_EXCEPTION_DEFINITION
(reason_cd, function_name_tx, standard_in, create_dt, update_dt, UPDATE_USER_TX, PURGE_DT, LOCK_ID) 
select  'DUPLICATE','fn_EscrowEx_Duplicates', standard_in, GETDATE(),GETDATE(), '', PURGE_DT, LOCK_ID
from ESCROW_EXCEPTION_DEFINITION
where id = 50


select  *
from ESCROW_EXCEPTION_DEFINITION
where reason_cd in ('DUPLICATE', 'NEWLOAN')

select  *
from ref_code rc
and  DOMAIN_CD = 'EscrowExceptionReason'


SELECT l.name_tx, l.code_tx, e.* FROM ESCROW_EXCEPTION_DEFINITION_LENDER_RELATE e
join lender l on l.id = e.lender_id
where l.CODE_TX in ('3039', '3140')

select * from lender 
where name_tx like '%capital%'

SELECT * FROM REF_CODE WHERE DOMAIN_CD = 'EscrowExceptionReason'



select CODE_TX, ID, NAME_TX from LENDER
where code_tx in ('1244',
'1940',
'2107',
'2270',
'2282',
'3039',
'3057',
'3102',
'3140',
'3769',
'4407',
'6004')


insert ESCROW_EXCEPTION_DEFINITION_LENDER_RELATE (ESCROW_EXCEPTION_DEFINITION_ID, LENDER_ID, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID)
values ('52',2402, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',651, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',227, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',255, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',2269, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',2273, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',1102, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',2338, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',1882, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',2333, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',2477, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('52',980, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',2402, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',651, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',227, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',255, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',2269, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',2273, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',1102, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',2338, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',1882, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',2333, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',2477, GETDATE(), GETDATE(), 'Task47024', NULL, 1),
 ('51',980, GETDATE(), GETDATE(), 'Task47024', NULL, 1)


