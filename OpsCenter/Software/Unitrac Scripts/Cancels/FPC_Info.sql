use unitrac 


declare @loannumber as varchar(max) = '' --1291126-1
declare @fpcnumber as varchar(max) = 'MT60004654'--MQK0102493  PHJ0007554  PHN0050625  OI33008607


declare @loanid as bigint = null
declare @fpcid as bigint = null
declare @lenderid as bigint
declare @cpiquoteid as bigint
declare @masterpolicyassignmentid as bigint


if (ISNULL(@loannumber,'') != '') 
begin
  select @loanid = id, @lenderid = LENDER_ID from loan where number_tx = @loannumber  and PURGE_DT is null
  select @fpcid = id, @cpiquoteid = CPI_QUOTE_ID, @masterpolicyassignmentid = MASTER_POLICY_ASSIGNMENT_ID from force_placed_certificate where LOAN_ID = @loanid
end 
else if (ISNULL(@fpcnumber,'') != '')
begin
  select @loanid = LOAN_ID, @fpcid = id, @cpiquoteid = CPI_QUOTE_ID, @masterpolicyassignmentid = MASTER_POLICY_ASSIGNMENT_ID from force_placed_certificate where  NUMBER_TX = @fpcnumber
  select @lenderid = LENDER_ID from loan where ID = @loanid and PURGE_DT is null
end

select format(ft.TXN_DT,'MM/dd/yyyy HH:mm') as date, rc.MEANING_TX as action, ft.AMOUNT_NO as amount, term_no, '',ft.CREATE_DT, ft.UPDATE_USER_TX, BILLING_GROUP_ID, * 
from financial_txn ft 
join REF_CODE rc on rc.CODE_CD = ft.TXN_TYPE_CD and rc.DOMAIN_CD = 'TransactionType'
join FINANCIAL_TXN_APPLY fta on fta.FINANCIAL_TXN_ID = ft.id 
where ft.fpc_id = @fpcid and ft.purge_dt is null

