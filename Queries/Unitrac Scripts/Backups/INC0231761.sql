USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT P.*
INTO UniTracHDStorage..INC0231761_Prop
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
WHERE LL.CODE_TX IN ('2257') AND l.NUMBER_TX = '119807-0001'

SELECT * FROM UniTracHDStorage..INC0231761_RC

SELECT * FROM UniTracHDStorage..INC0231761_Prop

UPDATE dbo.LOAN
SET UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0231761', LOCK_ID = LOCK_ID+1,
RECORD_TYPE_CD = 'G'
--SELECT * FROM LOAN
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0231761)



UPDATE dbo.PROPERTY
SET UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0231761', LOCK_ID = LOCK_ID+1,
RECORD_TYPE_CD = 'G'
--SELECT * FROM PROPERTY
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0231761_Prop)


UPDATE RC SET RC.GOOD_THRU_DT = NULL ,RC.UPDATE_DT = GETDATE() , RC.UPDATE_USER_TX = 'INC023176' ,
RC.LOCK_ID = CASE WHEN RC.LOCK_ID >= 255 THEN 1 ELSE RC.LOCK_ID + 1 END, RC.RECORD_TYPE_CD = 'G'
--SELECT DISTINCT RC.ID
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0231761_RC)


 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0231761' , 'N' , 
 GETDATE() ,  1 , 
 'Ticket INC0231761 states the loan should not be deleted', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0231761)


 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , 'INC0231761' , 'N' , 
 GETDATE() ,  1 , 
 'Ticket INC0231761 states the loan should not be deleted', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0231761_RC)




 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Property' , P.ID , 'INC0231761' , 'N' , 
 GETDATE() ,  1 , 
 'Ticket INC0231761 states the loan should not be deleted', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Property' , p.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE P.ID IN (SELECT ID FROM UniTracHDStorage..INC0231761_Prop)







SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'RecordType'


