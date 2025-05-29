 USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX, PC.*  
--into unitrachdstorage..INC0388242
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
WHERE LL.CODE_TX IN ('4217') AND L.NUMBER_TX IN (select loannumber from unitrachdstorage..INC0388242_Founder)


select * from unitrachdstorage..INC0388242_Founder

select * from unitrachdstorage..INC0388242

update pc
set pc.DEDUCTIBLE_NO = f.[new deductible], pc.UPDATE_DT = GETDATE(), pc.update_user_tx = 'INC0388242', pc.LOCK_ID = CASE WHEN pc.LOCK_ID >= 255 THEN 1 ELSE pc.LOCK_ID + 1 END
--select *
from POLICY_COVERAGE pc
join unitrachdstorage..INC0388242 pc2 on pc.id = pc2.id
join  unitrachdstorage..INC0388242_Founder F on F.LoanNumber = pc2.NUMBER_TX
