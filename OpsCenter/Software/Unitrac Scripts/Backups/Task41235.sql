USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT * FROM LOAN L
WHERE BRANCH_CODE_TX LIKE 'CONDO%' AND RECORD_TYPE_CD = 'I'


---Finding Branch
SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE LO.CODE_TX LIKE '%con%'



---Finding Collateral Code
SELECT DISTINCT CC.ID INTO #tmpCC
         FROM dbo.COLLATERAL_CODE CC
INNER JOIN dbo.LCCG_COLLATERAL_CODE_RELATE CCR ON CCR.COLLATERAL_CODE_ID = CC.ID
INNER JOIN dbo.LENDER_COLLATERAL_CODE_GROUP LCCG ON LCCG.ID = CCR.LCCG_ID
INNER JOIN dbo.LENDER L ON L.ID = LCCG.LENDER_ID
WHERE CC.DESCRIPTION_TX LIKE 'condo%' AND CC.AGENCY_ID = '1'



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT * FROM LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
WHERE C.COLLATERAL_CODE_ID IN (SELECT * FROM #tmpCC) AND  RECORD_TYPE_CD = 'I'



SELECT DISTINCT BRANCH_CODE_TX FROM dbo.LOAN
WHERE RECORD_TYPE_CD = 'I'



SELECT DISTINCT RECORD_TYPE_CD FROM LOAN L
WHERE BRANCH_CODE_TX LIKE 'CONDO%' 