USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT P.ID, L.*
--INTO UniTracHDStorage..INC0245355
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
WHERE VIN_TX = '2C3CCAGGXEH201487'

SELECT * FROM dbo.INTERACTION_HISTORY
WHERE PROPERTY_ID = '59225121'


SELECT * FROM dbo.PROPERTY_CHANGE PC
LEFT JOIN dbo.PROPERTY_CHANGE_UPDATE PCU ON PC.ID = PCU.CHANGE_ID 
WHERE PC.ENTITY_ID = '86344089' AND pc.ENTITY_NAME_TX LIKE '%Loan'

UPDATE LOAN 
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0245355',LOCK_ID=LOCK_ID+1, RECORD_TYPE_CD = 'G'
--SELECT * FROM LOAN
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0245355)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , ' INC0245355' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan Active', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0245355)