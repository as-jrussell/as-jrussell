USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.LENDER_ID, L.NUMBER_TX, COUNTRY_TX, OA.* FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2286') AND L.NUMBER_TX IN (SELECT [NoteNumber] FROM UniTracHDStorage..Canada)

 UPDATE OA
SET OA.CITY_TX = C.City, OA.STATE_PROV_TX = C.Providence, OA.POSTAL_CODE_TX = [ZIP ], 
OA.COUNTRY_TX = 'CA', OA.LOCK_ID =  OA.LOCK_ID+1,
OA.UPDATE_DT = GETDATE(), OA.UPDATE_USER_TX = 'INC0283304'
--SELECT OA.*
FROM dbo.OWNER_ADDRESS OA 
JOIN dbo.OWNER O ON O.ADDRESS_ID = OA.ID
JOIN dbo.OWNER_LOAN_RELATE OLR ON OLR.OWNER_ID = O.ID
JOIN dbo.LOAN L ON L.ID = OLR.LOAN_ID AND L.LENDER_ID = '2324'
JOIN UniTracHDStorage..Canada C ON C.[NoteNumber] = L.NUMBER_TX





SELECT * FROM UniTracHDStorage..Canada


---Finding Branch
SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '' AND Lo.TYPE_CD = 'DIV'



---Finding Collateral Code
SELECT  CC.ID ,
        CC.CODE_TX ,
        CC.DESCRIPTION_TX 
         FROM dbo.COLLATERAL_CODE CC
INNER JOIN dbo.LCCG_COLLATERAL_CODE_RELATE CCR ON CCR.COLLATERAL_CODE_ID = CC.ID
INNER JOIN dbo.LENDER_COLLATERAL_CODE_GROUP LCCG ON LCCG.ID = CCR.LCCG_ID
INNER JOIN dbo.LENDER L ON L.ID = LCCG.LENDER_ID
WHERE L.CODE_TX = 'XXXX'

