USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT O.ID, O.LAST_NAME_TX, O.FIRST_NAME_TX, O.MIDDLE_INITIAL_TX, L.NUMBER_TX FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('3656') AND O.LAST_NAME_TX IN ('LLC', 'INC', 'Trust', 'church', 'corp')
AND (O.FIRST_NAME_TX IS NOT NULL OR O.MIDDLE_INITIAL_TX IS NOT NULL)


