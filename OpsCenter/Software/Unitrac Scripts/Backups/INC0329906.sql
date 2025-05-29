USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT * 
--into unitrachdstorage..INC0329906_OA
from OWNER_ADDRESS OA 
WHERE OA.ID IN (select  [Address ID] from unitrachdstorage..[JoeyDataINC0329906])


select * from unitrachdstorage..[JoeyDataINC0329906]


update oa
set oa.LINE_1_TX = J.[After Property Line 1], UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0329906',LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select oa.LINE_1_TX , J.[After Property Line 1], *
from OWNER_ADDRESS oa
join unitrachdstorage..[JoeyDataINC0329906] J on J.[Address ID] = oa.id
