 /*
	tfs 49456  - Update Nicholas Cancel FTX

*/

declare @task as varchar(15) = 'TFS49456'

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
fpc.NUMBER_TX in (
'NIC0043989',
'MT60001910',
'MT60002502',
'MT60002582',
'NIC0045440',
'NIC0044801',
'MT60002342',
'MT60002469',
'MT60001654',
'NIC0043829',
'MT60002778',
'MT60001138',
'MT60001377',
'MT60001211',
'NIC0045521',
'MT60002459',
'MT60002434',
'MT60000882',
'MT60001175',
'NIC0047179',
'MT60002722',
'MT60002124',
'NIC0045493',
'NIC0046891',
'MT60000607',
'MT60002328',
'NIC0045185',
'NIC0042127',
'MT60001763',
'MT60001046',
'MT60002122',
'MT60001030',
'NIC0046906',
'MT60002766',
'NIC0046360',
'MT60001747',
'MT60001404',
'NIC0046940',
'MT60001900',
'NIC0047106',
'NIC0046084',
'MT60001239',
'MT60001012',
'MT60001379',
'NIC0046868',
'NIC0046359',
'MT60002318',
'NIC0046473',
'NIC0047145',
'NIC0045027',
'NIC0043697',
'NIC0043145',
'NIC0042692',
'NIC0043712',
'NIC0047024',
'NIC0044350',
'MT60000854',
'NIC0047015',
'MT60000500',
'MT60001344',
'MT60001997',
'MT60000567',
'NIC0043833',
'MT60000869',
'MT60000532',
'NIC0043201',
'MT60002438',
'MT60002559',
'NIC0047095',
'NIC0047004',
'MT60001931',
'MT60002701',
'MT60002635',
'MT60002240',
'NIC0046262'
)

select 'please save back to tfs', * from #tmpftx 



BEGIN /* Update Current Posted Refund Term */

	update ftx
	set TERM_NO = t.LastPaymentTerm
	,UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ftx.LOCK_ID % 255 ) + 1

	from FINANCIAL_TXN ftx
	join #tmpFTX t on t.PostedRefundFTXID = ftx.ID
	where ftx.PURGE_DT is null

END /* Update Current Posted Refund Term */

