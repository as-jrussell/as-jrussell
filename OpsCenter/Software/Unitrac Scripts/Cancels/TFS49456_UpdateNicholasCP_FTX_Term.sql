 /*
	tfs 49456  - Update Nicholas Cancel FTX

*/

declare @task as varchar(15) = 'INC0483233'
declare @NUMBER_TX as nvarchar(255) = 'MT60011106'

IF OBJECT_ID(N'tempdb..#tmpFTX',N'U') IS NOT NULL
	DROP TABLE #tmpFTX

select fpc.NUMBER_TX,ftx.FPC_ID, 
LastPayment.ID as LastPaymentFTXID, LastPayment.AMOUNT_NO as LastPaymentAmount, LastPayment.LastPaymentTerm,
postedRefund.id as PostedRefundFTXID, postedRefund.AMOUNT_NO as RefundAmount, postedRefund.TERM_NO as PostedRefundTerm
into #tmpFTX
from FINANCIAL_TXN ftx
join FORCE_PLACED_CERTIFICATE fpc on fpc.id = ftx.FPC_ID
cross APPLY
(
  select ftx3.*, d.TERM_NO as LastPaymentTerm
  from FINANCIAL_TXN ftx3
  join FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION d on d.FTX_ID = ftx3.ID
  where ftx3.FPC_ID = ftx.FPC_ID
  and d.TERM_NO = ftx.TERM_NO-1
  and ftx3.TXN_TYPE_CD='P'
) LastPayment
cross APPLY
(
	select *
	from FINANCIAL_TXN ftx4
	where ftx4.FPC_ID = ftx.FPC_ID
	and ftx4.TXN_TYPE_CD = 'CP'

) postedRefund
where 
ftx.TXN_TYPE_CD ='C'
and ftx.TERM_NO = postedRefund.TERM_NO
and
--fpc.NUMBER_TX in ('NIC0043412')
fpc.NUMBER_TX in (@number_TX)




--select 'please save back to tfs' as COMMENT_TX, * INTO UnitracHDStorage.dbo.TFS49628_TERM_UPDATES
--from #tmpftx 



BEGIN /* Update Current Posted Refund Term */

	--update ftx
	--set TERM_NO = t.LastPaymentTerm
	--,UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ftx.LOCK_ID % 255 ) + 1
select TERM_NO,t.LastPaymentTerm,*  
	from FINANCIAL_TXN ftx
	join #tmpFTX t on t.PostedRefundFTXID = ftx.ID
	where ftx.PURGE_DT is null

END /* Update Current Posted Refund Term */

select ftx.*  
into unitrachdstorage..INC0483233
	from FINANCIAL_TXN ftx
	join FORCE_PLACED_CERTIFICATE fpc on ftx.FPC_ID = fpc.id
	where ftx.PURGE_DT is null


	select ftx.*  
into unitrachdstorage..INC0483233
	from FINANCIAL_TXN ftx
	join FORCE_PLACED_CERTIFICATE fpc on ftx.FPC_ID = fpc.id
	where fpc.NUMBER_TX in ('MT60011928', 'MT60011106')
	and AMOUNT_NO in ('1.28', '0.20')

		update ftx
	set TERM_NO = t.TERM_NO
--select TERM_NO,t.LastPaymentTerm,*  
	from FINANCIAL_TXN ftx
	join unitrachdstorage..INC0483233 t on t.id = ftx.ID
