USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT C.* INTO UniTracHDStorage..INC0232130
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2007') AND L.NUMBER_TX = '7508799-10'
AND C.ID = '128561347'

UPDATE dbo.COLLATERAL
SET STATUS_CD = 'X', UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'INC0232130'
--SELECT * FROM dbo.COLLATERAL
WHERE ID = '128561347'


--3) Insert History into PROPERTY_CHANGE table
 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Collateral' , C.ID , 'INC0232130' , 'N' , 
 GETDATE() ,  1 , 
 'Moved Collateral to Warehouse Status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Collateral' , C.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE C.ID IN (128561347)
--1085


SELECT * FROM dbo.PROPERTY_CHANGE
WHERE ENTITY_ID = '128561347'