USE [UniTrac]
GO 

DROP TABLE UniTracHDStorage..INC0241253

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.* 
--INTO UniTracHDStorage.. INC0241253_RC
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
WHERE L.LENDER_ID = '255' AND BRANCH_CODE_TX = 'HELOC'

SELECT COUNT(*) FROM UniTracHDStorage.. INC0241253_RC
SELECT * FROM UniTracHDStorage.. INC0241253_L
SELECT COUNT(*) FROM UniTracHDStorage.. INC0241253_P




/*
UPDATE dbo.REQUIRED_COVERAGE
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = ' INC0241253', RECORD_TYPE_CD = 'D'
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0241253_RC)


UPDATE LOAN 
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0241253', RECORD_TYPE_CD = 'D'
--SELECT * FROM LOAN
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0241253_L)



UPDATE PROPERTY
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0241253', RECORD_TYPE_CD = 'D'
--SELECT * FROM PROPERTY
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0241253_P)


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , ' INC0241253' , 'N' , 
 GETDATE() ,  1 , 
 'Deleted Loan', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0241253_RC)

INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , ' INC0241253' , 'N' , 
 GETDATE() ,  1 , 
'Deleted Loan', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0241253_L)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Property' , P.ID , ' INC0241253' , 'N' , 
 GETDATE() ,  1 , 
 'Deleted Loan',
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Property' , P.ID , 'PEND' , 'N'
FROM PROPERTY P
WHERE P.ID IN (SELECT ID FROM UniTracHDStorage..INC0241253_P)
*/