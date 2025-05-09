USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT 
* FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2468') AND L.NUMBER_TX = '1765710-04'


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'RecordType'


SELECT * FROM dbo.PROPERTY_CHANGE
WHERE ENTITY_ID = '106352471' AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan'


/*
UPDATE dbo.LOAN
SET RECORD_TYPE_CD = 'A', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0229878'
--SELECT * FROM dbo.LOAN
WHERE ID IN (106352471)

iNSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0229878' , 'N' , 
 GETDATE() ,  1 , 
 'Moved Loan to Archive from Deleted', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE L.ID IN (106352471)

 */ 

