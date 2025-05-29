/*
 Update Positive Cancel Term No
*/

declare @task nvarchar (10)= 'INC0415576'
declare @ftxID as bigint = '24011345'
declare @newTerm as bigint = '4'
declare @reason as nvarchar(10) = 'prev Mon 2'

IF (@ftxID <> 0 and @newTerm <> 0)
BEGIN 

update FINANCIAL_TXN set TERM_NO = @newTerm, UPDATE_DT = getdate(), UPDATE_USER_TX = @task , LOCK_ID = (LOCK_ID % 255 ) + 1, reason_tx = @reason
--select * into UnitracHDStorage..INC0348925
 from FINANCIAL_TXN
where id = @ftxID and TXN_TYPE_CD = 'C' and AMOUNT_NO > 0

END 

