USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT * FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('1831') AND DIVISION_CODE_TX = '10'

SELECT  * --INTO UniTracHDStorage..INC0218002 
FROM dbo.LOAN
WHERE LENDER_ID = '372' AND DIVISION_CODE_TX = '10'

SELECT * FROM  UniTracHDStorage..INC0218002

SELECT *  FROM dbo.LENDER_PAYEE_CODE_FILE L
--INNER JOIN dbo.LENDER_PAYEE_CODE_MATCH LL ON LL.LENDER_PAYEE_CODE_FILE_ID = L.ID
WHERE PAYEE_CODE_TX = '5540'

SELECT * FROM dbo.LENDER_PAYEE_CODE_MATCH
ORDER BY LENDER_PAYEE_CODE_FILE_ID ASC



--UPDATE dbo.LOAN 
--SET DIVISION_CODE_TX = '99'
----SELECT * FROM dbo.LOAN
--WHERE LENDER_ID = '372' AND DIVISION_CODE_TX = '10'