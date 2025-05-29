Declare @workItemID as bigint = 45794042


Declare @billingGroupID as bigint = 0
IF OBJECT_ID(N'tempdb..#tmpFPCs',N'U') IS NOT NULL
  DROP TABLE #tmpFPCs


Select @billingGroupID = relate_id from WORK_ITEM where id = @workItemID and RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup'

select fpc.NUMBER_TX, ftx.TXN_TYPE_CD, ftx.AMOUNT_NO, ftx.TERM_NO, fta.BILLING_GROUP_ID, ftx.ID AS FTX_ID, fpc.ID as FPC_ID
into #tmpFPCs
from FINANCIAL_TXN_APPLY fta
join FINANCIAL_TXN ftx on ftx.id = fta.FINANCIAL_TXN_ID
join FORCE_PLACED_CERTIFICATE fpc on fpc.id = ftx.FPC_ID
where fta.BILLING_GROUP_ID = @billingGroupID 
and ftx.TXN_TYPE_CD = 'C' and ftx.AMOUNT_NO > 0

declare @fpcid as bigint = null
declare @fpcNumber as varchar(20) = null

DECLARE itemCursor cursor for
select FPC_ID, NUMBER_TX from #tmpFPCs

open itemCursor
fetch next from itemCursor into @fpcid, @fpcNumber

while @@FETCH_STATUS = 0	

begin
	select @fpcNumber as fpcNumber, format(ft.TXN_DT,'MM/dd/yyyy HH:mm') as date, rc.MEANING_TX as action, ft.AMOUNT_NO as amount, term_no, '',ft.CREATE_DT, ft.UPDATE_USER_TX, ft.REASON_TX
	from financial_txn ft 
	join REF_CODE rc on rc.CODE_CD = ft.TXN_TYPE_CD and rc.DOMAIN_CD = 'TransactionType'

	where ft.fpc_id = @fpcid and ft.purge_dt is null

	fetch next from itemCursor into @fpcid,@fpcNumber
end
close itemCursor;
deallocate itemCursor;

