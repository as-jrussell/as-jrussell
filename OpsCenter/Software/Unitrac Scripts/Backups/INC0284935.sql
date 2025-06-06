USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT TOP 10 O.LAST_NAME_TX, O.FIRST_NAME_TX, P.ID, * FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2016') --AND L.NUMBER_TX IN ('87429L41')
AND O.LAST_NAME_TX = 'Ojomo'

SELECT * FROM dbo.INTERACTION_HISTORY
WHERE PROPERTY_ID = '28538558'


SELECT * FROM UNITRACARCHIVE..INTERACTION_HISTORY
WHERE PROPERTY_ID = '28538558'

---Finding Branch
SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '' AND Lo.TYPE_CD = 'DIV'

SELECT TOP 10 * FROM dbo.DOCUMENT_CONTAINER
WHERE RELATIVE_PATH_TX



---Finding Collateral Code
SELECT  CC.ID ,
        CC.CODE_TX ,
        CC.DESCRIPTION_TX 
         FROM dbo.COLLATERAL_CODE CC
INNER JOIN dbo.LCCG_COLLATERAL_CODE_RELATE CCR ON CCR.COLLATERAL_CODE_ID = CC.ID
INNER JOIN dbo.LENDER_COLLATERAL_CODE_GROUP LCCG ON LCCG.ID = CCR.LCCG_ID
INNER JOIN dbo.LENDER L ON L.ID = LCCG.LENDER_ID
WHERE L.CODE_TX = 'XXXX'



SELECT * FROM UNITRACARCHIVE..l