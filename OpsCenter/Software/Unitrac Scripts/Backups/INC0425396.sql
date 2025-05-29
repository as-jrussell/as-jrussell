--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT LL.CODE_TX, L.NUMBER_TX
into #tmpLoans
from LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
join lender ll on ll.id = l.lender_id
WHERE RC.ID IN (select required_coverage_id from EVALUATION_EVENT
where id in (select EVALUATION_EVENT_ID from process_log_item
where process_log_id = 72875428) and type_cd = 'AOBC')

SELECT * FROM dbo.LENDER
WHERE CODE_TX IN () 



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



select * from work_item wi
where id in (54214836) 


select * from process_log_item
where process_log_id = 72875428



select * from EVALUATION_EVENT
where id in (select EVALUATION_EVENT_ID from process_log_item
where process_log_id = 72875428) and type_cd = 'AOBC'


select L.Number_tx, * from INTERACTION_HISTORY ih 
join property p on p.id = ih.property_id 
join COLLATERAL c on c.PROPERTY_ID = p.id
join LOAN l on l.id = c.loan_id
join #tmpLoans Lo on LO.NUMBER_TX = L.NUMBER_TX 

select * from #tmpLoans
--0000530903-0010