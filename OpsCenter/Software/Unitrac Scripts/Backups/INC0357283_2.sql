use unitrac


declare @rowcount int = 1000
while @rowcount >= 1000
BEGIN
 BEGIN TRY

 UPDATE TOP (1000) C
SET Collateral_CODE_ID = 525 , LENDER_COLLATERAL_CODE_TX = 'Vehicle', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0357283'
--SELECT  Collateral_CODE_ID, LENDER_COLLATERAL_CODE_TX, *
FROM Collateral C
where ID IN (select ID from jcs..INC0357283_Collateral) and C.Collateral_CODE_ID <> '525'
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


