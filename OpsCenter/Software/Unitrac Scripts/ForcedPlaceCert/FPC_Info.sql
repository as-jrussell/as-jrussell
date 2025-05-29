declare @loannumber as varchar(max) = '' --1291126-1
declare @fpcnumber as varchar(max) = 'FLM5001031'--MQK0102493  PHJ0007554  PHN0050625  OI33008607

select * from FINANCIAL_TXN_DETAIL where FINANCIAL_TXN_ID =24051895

select * from FINANCIAL_REPORT_TXN where FPC_ID = 7542192

declare @loanid as bigint = null
declare @fpcid as bigint = null
declare @lenderid as bigint
declare @cpiquoteid as bigint
declare @masterpolicyassignmentid as bigint

SELECT DATEDIFF(day,'8/1/2017','09/06/2017') as datedifferance

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

select format(ft.TXN_DT,'MM/dd/yyyy HH:mm') as date, rc.MEANING_TX as action, ft.AMOUNT_NO as amount, term_no, '',ft.CREATE_DT, ft.UPDATE_USER_TX, * 
from financial_txn ft 
join REF_CODE rc on rc.CODE_CD = ft.TXN_TYPE_CD and rc.DOMAIN_CD = 'TransactionType'

where ft.fpc_id = @fpcid and ft.purge_dt is null-- and term_no = 3

select top 1 * 
from financial_txn ftx inner join financial_txn_apply fta on ftx.id = fta.financial_txn_id where fpc_id = @fpcid and ftx.purge_dt is null --and BILLING_GROUP_ID = 1606154 
order by ftx.TXN_DT desc

select * from force_placed_certificate where ID = @fpcid

select format(cpia.PROCESS_DT,'MM/dd/yyyy HH:mm') as date, rc.MEANING_TX as action, cpia.TOTAL_PREMIUM_NO as amount, 
format(cpia.START_DT, 'MM/dd/yyyy') as start_date, format(cpia.END_DT, 'MM/dd/yyyy') as end_date, cpia.CREATE_DT,cpia.UPDATE_USER_TX, * 
from CPI_ACTIVITY cpia
join REF_CODE rc on rc.CODE_CD = cpia.TYPE_CD and rc.DOMAIN_CD='CPIActivityType'
where cpia.CPI_QUOTE_ID = @cpiquoteid and cpia.PURGE_DT is null 
order by cpia.create_dt

select * from loan where id = @loanid
select rc.* 
from FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r
join REQUIRED_COVERAGE rc on rc.id = r.REQUIRED_COVERAGE_ID
where r.FPC_ID = @fpcid

--update FORCE_PLACED_CERTIFICATE set STATUS_CD = 'B', CANCELLATION_DT = null where id = 6572471
--update CPI_ACTIVITY set PURGE_DT = getdate() where id in (36326659,
--36370826)
--update FINANCIAL_TXN set PURGE_DT = getdate() where id in (19760905,
--19779398,
--19815257,
--19832247)