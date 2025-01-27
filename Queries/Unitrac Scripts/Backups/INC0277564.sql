USE UniTrac	



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT * FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE OA.LINE_1_TX = '265 WARWICK DR' AND O.LAST_NAME_TX = 'Burks'
AND LL.CODE_TX = '1919'


SELECT IH.* FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
WHERE  L.NUMBER_TX = '55143270-01'
AND L.LENDER_ID = '67'
ORDER BY IH.UPDATE_DT DESC 

SELECT * FROM dbo.FORCE_PLACED_CERTIFICATE
WHERE ID = '6026039'


SELECT  TYPE_CD, * FROM dbo.CPI_QUOTE C
JOIN dbo.CPI_ACTIVITY A ON A.CPI_QUOTE_ID = C.ID
WHERE C.ID = '37344396'

SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'CPIActivityType'


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'CPIEventType'


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'CPIActivityIssueReason'





SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'CPIBasisType'