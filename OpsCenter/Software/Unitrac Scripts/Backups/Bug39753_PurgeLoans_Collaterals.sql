/*
Task 39753
*/



Select * into #tmprjg from 
(
Select c.ID as Collateral_ID, l.ID as Loan_ID, c.PROPERTY_ID, l.NUMBER_TX as Loan_Number_TX, c.CREATE_DT as CollateralCreateDate,
l.CREATE_DT as LoanCreateDate, C.PURGE_DT as CollateralPurgeDate, l.PURGE_DT as LoanPurgeDate,c.UPDATE_DT as CollateralUpdateDate,
l.UPDATE_DT as LoanUpdateDate, c.UPDATE_USER_TX as CollateralUpdateUser, l.UPDATE_USER_TX as LoanUpdateUser
from COLLATERAL c
inner join Loan l on l.ID = c.LOAN_ID

Where c.PROPERTY_ID = 153886752 
and l.NUMBER_TX <> '60000003537-00117'
--and c.PURGE_DT is null
and l.LENDER_ID = 2294 
) as BadMatches

--Select l.ID, l.NUMBER_TX, l.PURGE_DT, GETDATE() as NewPurgeDate, 'Bug39753' as UpdateUser, GETDATE() as UpdateDate,  (l.LOCK_ID % 255) + 1 as NewLockID

update l
set l.PURGE_DT = GETDATE(), l.UPDATE_DT = GETDATE(), l.UPDATE_USER_TX = 'Bug39753',
l.LOCK_ID = (l.LOCK_ID % 255) + 1 
From  loan l
inner join #tmprjg t on t.Loan_ID = l.ID


--Select c.id, c.PROPERTY_ID, c.PURGE_DT, GETDATE() as NewPurgeDate, 'Bug39753' as UpdateUser, GETDATE() as Updatedate, (c.LOCK_ID % 255) + 1 as NewLockID

Update c
Set c.PURGE_DT = GETDATE(), c.UPDATE_DT = GETDATE(), c.UPDATE_USER_TX = 'Bug39753',
c.LOCK_ID = (c.LOCK_ID % 255) + 1
From COLLATERAL c
Inner Join #tmprjg t on t.Collateral_ID = c.ID


IF OBJECT_ID('tempdb..#tmprjg') IS NOT NULL
    DROP TABLE #tmprjg



