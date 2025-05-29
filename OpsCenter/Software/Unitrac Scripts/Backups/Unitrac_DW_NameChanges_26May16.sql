
USE UNITRAC_DW
GO

BEGIN TRY
BEGIN TRANSACTION

UPDATE LENDER_DIM
set NAME_TX = 'FreeStar Financial Credit Union',
update_dt = getdate()
WHERE ID = 1280

UPDATE LENDER_DIM
set NAME_TX = 'GE Credit Union',
update_dt = getdate()
WHERE ID = 562

UPDATE LENDER_DIM
set NAME_TX = 'OneAZ Credit Union',
update_dt = getdate()
WHERE ID = 1836

UPDATE LENDER_DIM
set NAME_TX = 'California International Bank N.A.',
update_dt = getdate()
WHERE ID = 2107



COMMIT TRANSACTION
END TRY
BEGIN CATCH
   ROLLBACK TRANSACTION
   RAISERROR ('ROLLBACK occured for UNITRAC_DW.dbo.LENDER_DIM.NAME_TX Update. NO RECORDS Updated', 16, 1) WITH LOG
   SELECT
ERROR_NUMBER() AS ErrorNumber
,ERROR_SEVERITY() AS ErrorSeverity
,ERROR_STATE() AS ErrorState
,ERROR_PROCEDURE() AS ErrorProcedure
,ERROR_LINE() AS ErrorLine
,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

