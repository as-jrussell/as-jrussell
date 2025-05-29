 /*
	tfs 49456  - Update Nicholas Cancel FTX

*/

declare @task as varchar(15) = 'TFS49628'

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
fpc.NUMBER_TX in --('MT60002421','MT60002849','MT60002865','MT60002892','MT60003019','MT60003052','MT60003088','MT60003100','MT60003108','MT60003156','MT60003220','MT60003239','MT60003248','MT60003282','MT60003311','MT60003537','MT60003749','MT60003820','MT60003825','MT60003886','MT60003887','MT60003933','MT60003945','MT60003969','MT60004051','MT60004091','MT60004116','MT60004155','MT60004186','MT60004236','MT60004237','MT60004249','MT60004274','MT60004277','MT60004327','MT60004365','MT60004384','MT60004386','MT60004433','MT60004458','MT60004495','MT60004524','MT60004537','MT60004549','MT60004768','MT60004940','NIC0043412')
('MT60008063')



--select 'please save back to tfs' as COMMENT_TX, * INTO UnitracHDStorage.dbo.TFS49628_TERM_UPDATES
--from #tmpftx 


select TERM_NO,t.LastPaymentTerm,ftx.*  
into unitrachdstorage..INC0455698_month
	from FINANCIAL_TXN ftx
	join #tmpFTX t on t.PostedRefundFTXID = ftx.ID
	where ftx.PURGE_DT is null



BEGIN /* Update Current Posted Refund Term */

	update ftx
	set TERM_NO = t.LastPaymentTerm
	,UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ftx.LOCK_ID % 255 ) + 1
--select TERM_NO,t.LastPaymentTerm,*  
	from FINANCIAL_TXN ftx
	join #tmpFTX t on t.PostedRefundFTXID = ftx.ID
	where ftx.PURGE_DT is null




END /* Update Current Posted Refund Term */


--Restore
	update ftx
	set TERM_NO = t.LastPaymentTerm
	,UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ftx.LOCK_ID % 255 ) + 1
--select TERM_NO,t.LastPaymentTerm,*  
	from FINANCIAL_TXN ftx
	join INC0455698_month t on t.PostedRefundFTXID = ftx.ID
	where ftx.PURGE_DT is null