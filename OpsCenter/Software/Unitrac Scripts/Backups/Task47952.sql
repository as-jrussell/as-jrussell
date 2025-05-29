USE [UniTrac]
GO 




select 
l.number_tx, 
olr.owner_type_cd,
 o.first_name_tx, 
 o.last_name_tx,
 o.id as Owner_id, olr.id as Owner_loan_relate_id
 into #tmp
 from owner_loan_relate olr

join owner o on o.id = olr.owner_id
join loan l on l.id = olr.loan_id
join lender le on le.id = l.lender_id
where le.code_tx = '1873'
and olr.OWNER_TYPE_CD = 'cs'
and o.first_name_tx = '0'
and olr.purge_dt is null
and o.purge_dt is null
and l.record_type_cd in ('g','a')
and l.status_cd != 'u'
order by l.id desc

select * from #tmp

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT OA.* 
into UnitracHDStorage..Task47952OA
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE O.ID IN (select id from UnitracHDStorage..Task47952)

select * from UnitracHDStorage..Task47952



update O set purge_dt = GETDATE(), update_dt = GETDATE(), lock_id = lock_id+1, update_user_tx = 'Task47952'
--select *
from OWNER O
where id in (select id from UnitracHDStorage..Task47952)


update O set purge_dt = GETDATE(), update_dt = GETDATE(), lock_id = lock_id+1, update_user_tx = 'Task47952'
--select *
from OWNER_LOAN_RELATE O
where id in (select id from UnitracHDStorage..Task47952OL)


update O set purge_dt = GETDATE(), update_dt = GETDATE(), lock_id = lock_id+1, update_user_tx = 'Task47952'
--select *
from OWNER_ADDRESS O
where id in (select id from UnitracHDStorage..Task47952OA)