use unitrac

declare @fpcnumber as varchar(max) = 'NIC0026595'

declare @loanid as bigint = null
declare @fpcid as bigint = null

if (ISNULL(@fpcnumber,'') != '')
begin
  select @loanid = LOAN_ID, @fpcid = id from force_placed_certificate where  NUMBER_TX = @fpcnumber
end


----select @fpcnumber as fpcNumber, format(ft.TXN_DT,'MM/dd/yyyy HH:mm') as date, rc.MEANING_TX as action, ft.AMOUNT_NO as amount, term_no, '',ft.CREATE_DT, ft.UPDATE_USER_TX, ft.REASON_TX
--select ft.*
--from financial_txn ft 
--join REF_CODE rc on rc.CODE_CD = ft.TXN_TYPE_CD and rc.DOMAIN_CD = 'TransactionType'

--where ft.fpc_id = @fpcid and ft.purge_dt is null




select @fpcnumber as fpcNumber, ft.ID as FTX_ID, format(ft.TXN_DT,'MM/dd/yyyy HH:mm') as date, rc.MEANING_TX as action, ft.AMOUNT_NO as amount, term_no, '',ft.CREATE_DT, ft.UPDATE_USER_TX, ft.REASON_TX, txn_type_cd
from financial_txn ft 
join REF_CODE rc on rc.CODE_CD = ft.TXN_TYPE_CD and rc.DOMAIN_CD = 'TransactionType'
where ft.fpc_id = @fpcid and ft.purge_dt is null