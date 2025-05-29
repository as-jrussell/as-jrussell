use unitrac

declare @fpcnumber as varchar(max) = 'mt50029716'

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




select @fpcnumber as fpcNumber, ft.ID as FTX_ID, format(ft.TXN_DT,'MM/dd/yyyy HH:mm') as date, rc.MEANING_TX as action, ft.AMOUNT_NO as amount, term_no, '',ft.CREATE_DT, ft.UPDATE_USER_TX, ft.REASON_TX
from financial_txn ft 
join REF_CODE rc on rc.CODE_CD = ft.TXN_TYPE_CD and rc.DOMAIN_CD = 'TransactionType'
where ft.fpc_id = @fpcid and ft.purge_dt is null
order by term_no, format(ft.TXN_DT,'MM/dd/yyyy HH:mm')  asc 





/*

select DISTINCT LL.Name_tx [Lender], LL.Code_tx [Lender Code] from force_placed_certificate fpc
join loan L on L.ID = FPC.Loan_ID
join Lender LL on LL.ID = L.Lender_id
where fpc.number_tx = 'mt50029716'

*/


select rc.DESCRIPTION_TX, ft.*
from financial_txn ft 
join REF_CODE rc on rc.CODE_CD = ft.TXN_TYPE_CD and rc.DOMAIN_CD = 'TransactionType'
where ft.fpc_id =7299264  and ft.purge_dt is null
order by term_no, format(ft.TXN_DT,'MM/dd/yyyy HH:mm')  asc 





select * from force_placed_certificate
where number_tx = 'mt50029716'