USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT IH.* FROM LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2979') AND L.NUMBER_TX = '4240003058'

SELECT * FROM dbo.PRIOR_CARRIER_POLICY
WHERE REQUIRED_COVERAGE_ID IN (138630635,138630634, 138633371,138633372)

SELECT * FROM dbo.NOTICE
WHERE ID = '20443144'

SELECT * FROM dbo.DOCUMENT_CONTAINER
WHERE RELATE_ID = '20443144' AND RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice'

SELECT  *
FROM    dbo.COLLATERAL_CODE
WHERE   DESCRIPTION_TX LIKE '%%'
        AND AGENCY_ID = '1'
        AND ID IN (  )



SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '' AND Lo.TYPE_CD = 'DIV'

