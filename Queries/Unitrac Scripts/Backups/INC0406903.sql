USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT RC.*
--into unitrachdstorage..INC0406903
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('016400') AND RC.STATUS_CD = 'B'
and L.Division_CODE_TX = '3'


select * from ref_code
where domain_cd = 'RequiredCoverageStatus'


---Finding Branch
SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '016400' AND Lo.TYPE_CD = 'DIV'

update rc 
set  RC.STATUS_CD = 'A'
--select *
from REQUIRED_COVERAGE RC 
join unitrachdstorage..INC0406903 RD on RD.ID =RC.ID
where RC.STATUS_CD = 'B'




	