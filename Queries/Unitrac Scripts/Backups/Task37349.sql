USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DIVISION_CODE_TX, LL.CODE_TX, COLLATERAL_CODE_ID, COLLATERAL_NUMBER_NO, LL.NAME_TX, * FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.NUMBER_TX = '4056002-07'

SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '2830' AND Lo.TYPE_CD = 'DIV'

SELECT  *
FROM    dbo.COLLATERAL_CODE
WHERE   DESCRIPTION_TX LIKE '%%'
        AND AGENCY_ID = '1'

/*
UPDATE dbo.LOAN
SET DIVISION_CODE_TX = '4', UPDATE_DT = GETDATE(),
LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'Task37349'
WHERE ID = '124853216'


 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'Task37349' , 'N' , 
 GETDATE() ,  1 , 
 'Moved Loan to Mortgage Branch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM dbo.LOAN L
WHERE L.ID = '124853216'
*/