--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT C.STATUS_CD, L.NUMBER_TX, l.STATUS_CD FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
WHERE L.LENDER_ID IN (432) AND --L.STATUS_CD NOT IN ('A', 'U') 
c.STATUS_CD IN ('Z') 
AND L.CREATE_DT > '2014-01-01'
AND L.CREATE_DT < '2015-01-01'



SELECT * FROM dbo.LENDER
WHERE --ID IN ('988')
 CODE_TX IN ('1823') 



SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'LoanStatus'
WHERE MEANING_TX LIKE 'Repo%'

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