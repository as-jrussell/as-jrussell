USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX, LOAN_BALANCE_NO, BALANCE_AMOUNT_NO, P.*
--INTO UniTracHDStorage..INC0241671
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2864') AND L.NUMBER_TX IN ('4000043522301', '4000043522302', '4000043522304')

UPDATE P
SET P.ACV_NO = L.BALANCE_AMOUNT_NO, P.UPDATE_DT = GETDATE(),P.UPDATE_USER_TX = 'INC0241671',P.LOCK_ID=P.LOCK_ID+1
--SELECT *
FROM dbo.PROPERTY P
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
WHERE L.LENDER_ID = '281' AND L.NUMBER_TX IN ('4000043522301', '4000043522302', '4000043522304')



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Property' , P.ID , ' INC0241671' , 'N' , 
 GETDATE() ,  1 , 
 'Converted ACV amount to Match Loan Balanace',
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Property' , P.ID , 'PEND' , 'N'
FROM PROPERTY P
WHERE P.ID IN (SELECT ID FROM UniTracHDStorage..INC0241671)