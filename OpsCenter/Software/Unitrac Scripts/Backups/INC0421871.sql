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
where reason_cd in ('DUPLICATE', 'NEWLOANOAN')


select  *
from ref_code
where code_cd in ('DUPLICATE', 'NEWLOANOAN')

SELECT * FROM ESCROW_EXCEPTION_DEFINITION_LENDER_RELATE

SELECT * FROM REF_CODE WHERE DOMAIN_CD = 'EscrowExceptionReason'


select * from users

