
USE UNITRAC_DW
GO

BEGIN TRY
BEGIN TRANSACTION

UPDATE LENDER_DIM
set NAME_TX = 'SAG-AFTRA Federal Credit Union',
update_dt = getdate()
WHERE ID = 914


UPDATE LENDER_DIM
set NAME_TX = 'Premier Members CU',
update_dt = getdate()
WHERE ID = 586


UPDATE LENDER_DIM
set NAME_TX = 'TruPartner CU (Passmore lender)',
update_dt = getdate()
WHERE ID = 125


UPDATE LENDER_DIM
set NAME_TX = 'Northern Colorado CU',
update_dt = getdate()
WHERE ID = 446


UPDATE LENDER_DIM
set NAME_TX = 'Cornerstone Community Credit Union',
update_dt = getdate()
WHERE ID = 692


UPDATE LENDER_DIM
set NAME_TX = 'Greater KC Public Safety Credit Union',
update_dt = getdate()
WHERE ID = 1115


UPDATE LENDER_DIM
set NAME_TX = 'Trius Federal Credit Union',
update_dt = getdate()
WHERE ID = 2156


UPDATE LENDER_DIM
set NAME_TX = 'Arch Community CU',
update_dt = getdate()
WHERE ID = 373


UPDATE LENDER_DIM
set NAME_TX = 'TLCU Financial',
update_dt = getdate()
WHERE ID = 1669


UPDATE LENDER_DIM
set NAME_TX = 'Coca-Cola Federal Credit Union',
update_dt = getdate()
WHERE ID = 731


UPDATE LENDER_DIM
set NAME_TX = 'Union Square Credit Union',
update_dt = getdate()
WHERE ID = 739


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

