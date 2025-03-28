USE [UniTrac]
GO 


--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  L.NUMBER_TX, IH.EFFECTIVE_DT, IH.NOTE_TX, IH.TYPE_CD 
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('6087') AND L.NUMBER_TX = '754384130'
UNION 
SELECT  L.NUMBER_TX, IH.EFFECTIVE_DT, IH.NOTE_TX, IH.TYPE_CD 
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN UNITRACARCHIVE..INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('6087') AND L.NUMBER_TX = '754384130'
AND IH.NOTE_TX IS NOT NULL
ORDER BY IH.EFFECTIVE_DT ASC  



--SELECT L.NUMBER_TX, IH.*
--FROM LOAN L
--INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
--INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
--INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
--INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
--WHERE LL.CODE_TX IN ('6087') AND L.NUMBER_TX = '754384130'
