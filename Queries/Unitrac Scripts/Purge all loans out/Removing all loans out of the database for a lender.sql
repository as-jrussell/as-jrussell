USE [UniTrac]
GO 

----To see what loan status is
SELECT L.PURGE_DT, L.RECORD_TYPE_CD, P.PURGE_DT, P.RECORD_TYPE_CD, C.PURGE_DT, RC.PURGE_DT, RC.RECORD_TYPE_CD,
L.ID, P.ID, C.ID, RC.ID
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 








---Backs up loans 
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.* 
INTO UniTracHDStorage..INC0XXXXX_L
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT C.* 
INTO UniTracHDStorage..INC0XXXXX_C
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT P.* 
INTO UniTracHDStorage..INC0XXXXX_P
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT RC.*
INTO UniTracHDStorage..INC0XXXXX_RC
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 



SELECT O.*
INTO UniTracHDStorage..INC0XXXXX_O
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
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 

SELECT OL.*
INTO UniTracHDStorage..INC0XXXXX_OL
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
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 



SELECT OA.*
INTO UniTracHDStorage..INC0XXXXX_OA
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
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 


SELECT POP.*
INTO UniTracHDStorage..INC0XXXXX_POP
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
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 



SELECT OP.*
INTO UniTracHDStorage..INC0XXXXX_OP
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
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 



SELECT PC.*
INTO UniTracHDStorage..INC0XXXXX_PC 
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
WHERE L.NUMBER_TX  IN ('')  AND LL.CODE_TX IN ('') 




/*

--Mark them deleted
UPDATE dbo.REQUIRED_COVERAGE
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, RECORD_TYPE_CD = 'D', PURGE_DT = GETDATE()
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0XXXXX_RC)

UPDATE LOAN 
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, RECORD_TYPE_CD = 'D', PURGE_DT = GETDATE()
--SELECT * FROM LOAN
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXX_L)


UPDATE PROPERTY
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, RECORD_TYPE_CD = 'D', PURGE_DT = GETDATE()
--SELECT * FROM PROPERTY
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXX_P)


UPDATE dbo.COLLATERAL
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXX_C)


UPDATE OWNER_LOAN_RELATE 
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXX_OL)


UPDATE OWNER
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXX_O)


UPDATE OWNER_ADDRESS
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXX_OA)


UPDATE PROPERTY_OWNER_POLICY_RELATE 
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXX_POP)


UPDATE OWNER_POLICY
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXX_OP)


UPDATE POLICY_COVERAGE
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXX_PC)



*/






