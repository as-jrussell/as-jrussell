/*
 Update Positive Cancel Term No
*/

declare @task nvarchar (10)= 'INC0388289'
declare @ftxID as bigint = 23006305
declare @newTerm as bigint = 5
declare @reason_tx nvarchar (10)= 'Month 5-LH'

IF (@ftxID <> 0 and @newTerm <> 0)
BEGIN 

update FINANCIAL_TXN set TERM_NO = @newTerm, UPDATE_DT = getdate(), UPDATE_USER_TX = @task , LOCK_ID = (LOCK_ID % 255 ) + 1, reason_tx = @reason_tx
--select * into UnitracHDStorage..INC0348925
 from FINANCIAL_TXN
where id = @ftxID and TXN_TYPE_CD = 'C' and AMOUNT_NO > 0

END 

