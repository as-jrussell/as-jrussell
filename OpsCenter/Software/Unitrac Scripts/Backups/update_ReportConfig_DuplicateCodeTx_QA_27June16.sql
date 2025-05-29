
USE UNITRAC
GO

BEGIN TRY
BEGIN TRANSACTION

		  update report_config 
		  set purge_dt = getdate(), display_in='N'
		  where id=200000943

COMMIT TRANSACTION
END TRY
BEGIN CATCH
   ROLLBACK TRANSACTION
   RAISERROR ('ROLLBACK occured for duplicate Report_Config update. No update on duplicate CODE_TX = NTCREG_CPICXL', 16, 1) WITH LOG
   SELECT
ERROR_NUMBER() AS ErrorNumber
,ERROR_SEVERITY() AS ErrorSeverity
,ERROR_STATE() AS ErrorState
,ERROR_PROCEDURE() AS ErrorProcedure
,ERROR_LINE() AS ErrorLine
,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

