USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT C.PROPERTY_ID, * FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.NUMBER_TX IN ('652116-01')

UPDATE IH
SET DOCUMENT_ID = NULL
--SELECT * 
FROM dbo.INTERACTION_HISTORY IH
WHERE id IN (199371704)

SELECT * FROM UniTracHDStorage..INC0219268



SELECT  *
FROM    dbo.COLLATERAL_CODE
WHERE   DESCRIPTION_TX LIKE '%%'
        AND AGENCY_ID = '1'
        AND ID IN (  )



SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '2120' AND Lo.TYPE_CD = 'DIV'