USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT division_code_tx, l.*
--into unitrachdstorage..INC0409841_loan
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2660') AND RC.TYPE_CD = 'PHYS-DAMAGE'



declare @rowcount int = 10000
while @rowcount >= 10000
BEGIN
 BEGIN TRY

 UPDATE TOP (10000) L
SET L.division_code_tx = '4', update_user_tx = 'INC0409841', update_dt = GETDATE()
--SELECT division_code_tx,  *
FROM loan l
where  ISNULL(division_code_tx, '') != '4'
and id in (select id from unitrachdstorage..INC0409841_loan)
--88291

 select @rowcount = @@rowcount
 END TRY
 BEGIN CATCH
  select Error_number(),
      error_message(),
      error_severity(),
    error_state(),
    error_line()
   THROW
   BREAK
 END CATCH
END
				 





 UPDATE  L
SET L.division_code_tx = P.division_code_tx, update_user_tx = 'INC0409841', update_dt = GETDATE()
--SELECT   count(STATUS_CD)  
FROM loan l
join unitrachdstorage..INC0409841 P on L.ID = P.ID