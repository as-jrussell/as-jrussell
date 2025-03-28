USE [UniTrac]
GO 


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'CS'


--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT O.ID INTO #tmp
--O.* INTO UniTracHDStorage..INC0275981_Other
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('3067') --AND L.NUMBER_TX IN ('')
AND OL.OWNER_TYPE_CD ='CS' 
AND O.FIRST_NAME_TX = 'NA'





UPDATE dbo.OWNER
SET FIRST_NAME_TX = NULL, LOCK_ID = LOCK_ID+1, UPDATE_DT= GETDATE(), UPDATE_USER_TX = 'INC0275981'
--SELECT * FROM dbo.OWNER
WHERE ID IN (SELECT * FROM #tmp)