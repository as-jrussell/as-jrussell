USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT L.NUMBER_TX
--INTO UniTracHDStorage..INC0253037_OP
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
--INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
--INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
--INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
WHERE LL.CODE_TX IN ('4296') AND L.NUMBER_TX IN ('110840-L3','29040-L2.1','29910-L1.1','122210-L2','36550-L2.2')



SELECT PC.* 
INTO UniTracHDStorage..INC0253037_PC
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
WHERE LL.CODE_TX IN ('4296') AND L.NUMBER_TX IN ('110840-L3','29040-L2.1','29910-L1.1','122210-L2','36550-L2.2')


SELECT RC.*
INTO UniTracHDStorage..INC0253037_RC2
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
--INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
--INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
--INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
WHERE LL.CODE_TX IN ('4296') AND L.NUMBER_TX IN ('110840-L3','29040-L2.1','29910-L1.1','122210-L2','36550-L2.2')


SELECT DISTINCT PROPERTY_id FROM UniTracHDStorage..INC0253037_RC


SELECT * FROM UniTracHDStorage..INC0253037_PC


SELECT * FROM UniTracHDStorage..INC0253037_OP




UPDATE OWNER_POLICY
 SET CANCELLATION_DT = NULL , 
CANCEL_REASON_CD = '' , 
STATUS_CD = 'E' , 
SUB_STATUS_CD = 'R', 
EXPIRATION_DT = GETDATE()-180 , 
UPDATE_DT = GETDATE() , 
UPDATE_USER_TX = 'INC0253037', 
LOCK_ID = LOCK_ID % 255 + 1
---- SELECT * FROM OWNER_POLICY
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0253037_op)

UPDATE pc
SET END_DT = OP.EXPIRATION_DT , 
CANCELLED_IN = 'N' ,
UPDATE_DT = GETDATE() , 
UPDATE_USER_TX = 'INC0253037', 
LOCK_ID = PC.LOCK_ID % 255 + 1
---- SELECT PC.* 
FROM POLICY_COVERAGE pc 
JOIN dbo.OWNER_POLICY op ON op.ID = pc.OWNER_POLICY_ID
WHERE pc.ID IN (SELECT ID FROM UniTracHDStorage..INC0253037_PC)


UPDATE REQUIRED_COVERAGE 
 SET GOOD_THRU_DT = NULL , 
INSURANCE_STATUS_CD = 'E' , 
INSURANCE_SUB_STATUS_CD = 'R' , 
SUMMARY_STATUS_CD = 'E' , 
SUMMARY_SUB_STATUS_CD = 'R' , 
NOTICE_DT = NULL , 
NOTICE_SEQ_NO = NULL , 
NOTICE_TYPE_CD = NULL , 
LAST_EVENT_DT = NULL , 
LAST_EVENT_SEQ_ID = NULL , 
LAST_SEQ_CONTAINER_ID = NULL ,
UPDATE_DT = GETDATE() , 
UPDATE_USER_TX =  'INC0253037' , 
LOCK_ID = LOCK_ID % 255 + 1
---- SELECT * FROM REQUIRED_COVERAGE 
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0253037_RC2)





