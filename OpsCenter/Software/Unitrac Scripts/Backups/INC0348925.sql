/*
 Update Positive Cancel Term No
*/

declare @task nvarchar (10)= 'INC0348925'
declare @ftxID as bigint = 23796304
declare @newTerm as bigint = 12
declare @reason as nvarchar(10) = 'Upd mth 12'

IF (@ftxID <> 0 and @newTerm <> 0)
BEGIN 

update FINANCIAL_TXN set TERM_NO = @newTerm, UPDATE_DT = getdate(), UPDATE_USER_TX = @task , LOCK_ID = (LOCK_ID % 255 ) + 1, reason_tx = @reason
--select * into UnitracHDStorage..INC0348925
 from FINANCIAL_TXN
where id = @ftxID and TXN_TYPE_CD = 'C' and AMOUNT_NO > 0

END 

