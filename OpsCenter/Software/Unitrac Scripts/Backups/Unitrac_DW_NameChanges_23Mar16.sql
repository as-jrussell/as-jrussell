

USE UNITRAC_DW
GO

BEGIN TRY
BEGIN TRANSACTION

UPDATE LENDER_DIM
set NAME_TX = 'TruPartner Credit Union',
update_dt = getdate()
WHERE ID = 125

UPDATE LENDER_DIM
set NAME_TX = 'Denali Federal Credit Union',
update_dt = getdate()
WHERE ID = 351


UPDATE LENDER_DIM
set NAME_TX = 'Hudson River Financial FCU',
update_dt = getdate()
WHERE ID = 1938

UPDATE LENDER_DIM
set NAME_TX = 'Coast 2 Coast Financial CU',
update_dt = getdate()
WHERE ID = 844

UPDATE LENDER_DIM
set NAME_TX = 'Firefly Credit Union',
update_dt = getdate()
WHERE ID = 629

UPDATE LENDER_DIM
set NAME_TX = 'Priority Credit Union',
update_dt = getdate()
WHERE ID = 871


UPDATE LENDER_DIM
set NAME_TX = 'Polish-American Federal Credit Union',
update_dt = getdate()
WHERE ID = 1869


UPDATE LENDER_DIM
set NAME_TX = 'Kentucky Telco Credit Union',
update_dt = getdate()
WHERE ID = 899


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

