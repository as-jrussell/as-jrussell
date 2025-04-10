USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT IH.* FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('8500') AND L.NUMBER_TX = '201506335'

201506335

SELECT * FROM dbo.OWNER_POLICY
WHERE ID = 162230257


SELECT * FROM dbo.[TRANSACTION]
WHERE ID = 180654782

187534347


SELECT * FROM dbo.DOCUMENT
WHERE ID = 16679304

SELECT * FROM dbo.MESSAGE
WHERE id = 6744821

SELECT * FROM dbo.MESSAGE
WHERE RELATE_ID_TX = 6744821

SELECT * FROM dbo.TRADING_PARTNER_LOG
WHERE MESSAGE_ID = 6744821


SELECT L.NUMBER_TX, UTL.* FROM dbo.UTL_MATCH_RESULT UTL
JOIN dbo.LOAN L ON L.ID = UTL.LOAN_ID AND L.LENDER_ID = '92'
WHERE UTL.CREATE_DT >= '2017-02-07'
AND MATCH_RESULT_CD = 'EXACTRVW'
ORDER BY UTL.CREATE_DT ASC 
