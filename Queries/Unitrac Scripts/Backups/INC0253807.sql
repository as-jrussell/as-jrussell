USE UniTrac

SELECT *
FROM LENDER
WHERE CODE_TX = '3140'


SELECT *
FROM LENDER_PAYEE_CODE_FILE
WHERE LENDER_ID = 1882 AND PAYEE_CODE_TX = '5604'



SELECT *
FROM LENDER_PAYEE_CODE_MATCH
INNER JOIN ADDRESS ON LENDER_PAYEE_CODE_MATCH.REMITTANCE_ADDR_ID = ADDRESS.ID
WHERE LENDER_PAYEE_CODE_FILE_ID = 20377 AND LENDER_PAYEE_CODE_MATCH.PURGE_DT IS NULL

SELECT *
FROM LENDER_PAYEE_CODE_MATCH
WHERE LENDER_PAYEE_CODE_FILE_ID = 20377

UPDATE LENDER_PAYEE_CODE_MATCH
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0253807', LOCK_ID = LOCK_ID + 1
WHERE LENDER_PAYEE_CODE_FILE_ID = 20377 AND ID IN (19437)

SELECT *
FROM BORROWER_INSURANCE_COMPANY
--WHERE NAME = 'HARTFORD'
WHERE ID IN (16278,13920)