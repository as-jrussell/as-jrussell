 /*
	tfs 49456  - Update Nicholas Cancel FTX

*/

declare @task as varchar(15) = 'INC0433968'
declare @billinggroupID bigint = 2105944

IF OBJECT_ID(N'tempdb..#tmpFTX',N'U') IS NOT NULL
	DROP TABLE #tmpFTX

select fpc.NUMBER_TX,ftx.FPC_ID, ftx.ID as CurrentCancelFTXID, ftx.AMOUNT_NO as CurrentFTXCancelAmount, ftx.TERM_NO as CurrentFTXCancelTerm, 
lasttermrec.ID as LastRecID, lasttermrec.AMOUNT_NO as lastRecAmt, lasttermrec.TERM_NO as LastRecTerm
,LastPayment.ID as LastPaymentFTXID, LastPayment.AMOUNT_NO as LastPaymentAmount, LastPayment.LastPaymentTerm
,ftx.AMOUNT_NO + lasttermrec.AMOUNT_NO as NewCancelAmount, LastPayment.LastPaymentTerm as NewCancelTerm
,lasttermrec.AMOUNT_NO * -1 as UpdatedCancelAmount
into #tmpFTX
from FINANCIAL_TXN ftx
join FORCE_PLACED_CERTIFICATE fpc on fpc.id = ftx.FPC_ID
cross APPLY
(
	select *
	from FINANCIAL_TXN ftx2 
	where ftx2.FPC_ID = ftx.FPC_ID
	and ftx2.TERM_NO = ftx.TERM_NO 
	and ftx2.TXN_TYPE_CD = 'R'

) lasttermrec
cross APPLY
(
  select ftx3.*, d.TERM_NO as LastPaymentTerm
  from FINANCIAL_TXN ftx3
  join FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION d on d.FTX_ID = ftx3.ID
  where ftx3.FPC_ID = ftx.FPC_ID
  and d.TERM_NO = ftx.TERM_NO-1
  and ftx3.TXN_TYPE_CD='P'
) LastPayment
where 
ftx.TXN_TYPE_CD ='C'
and
fpc.NUMBER_TX in (
'MT60000839','MT60001079','MT60001256','MT60001504','MT60001508','MT60001541','MT60001544','MT60001726','MT60001790','MT60001897','MT60002077','MT60002257','MT60002407','MT60002409','MT60002414','MT60002480','MT60002512','MT60002534','MT60003286','MT60003368','MT60003536','MT60003540','MT60003769','MT60003926','MT60003978','MT60004075','MT60004132','MT60004393','MT60004496','MT60004500','MT60004532','MT60004563','MT60004678','MT60004679','MT60004706','MT60004745','MT60005125','MT60005154','NIC0045234','NIC0045781','NIC0045834','NIC0045918','NIC0046271','NIC0046941'
)

select * from #tmpftx

BEGIN -- Insert Cancel FTX for prior term

	insert into FINANCIAL_TXN (FPC_ID,LFT_ID,AP_ID,TXN_TYPE_CD,AMOUNT_NO,TXN_DT,REASON_TX,CREATE_DT,UPDATE_DT, UPDATE_USER_TX,LOCK_ID,TERM_NO)
	select distinct
	 FPC_ID,
	 0,
	 0,
	 'C',
	 NewCancelAmount,
	 '2019-04-01 18:22:46.5730000',
	 concat('Month ',NewCancelTerm),
	 getdate(),
	 getdate(),
	 @task,
	 1,
	 NewCancelTerm
	from #tmpFTX

END /* new cancel FTX Insert */

BEGIN /* Insert into FTX Detail for new cancel FTX */
	
	insert into FINANCIAL_TXN_DETAIL (FINANCIAL_TXN_ID,TYPE_CD,AMOUNT_NO,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID)
	select DISTINCT
	ftx.ID,
	'PRM',
	t.NewCancelAmount,
	getdate(),
	getdate(),
	@task,
	1
	from FINANCIAL_TXN ftx
	join #tmpftx t on t.fpc_id = ftx.FPC_ID
	where ftx.TXN_TYPE_CD='C' and ftx.TERM_NO = t.NewCancelTerm

END /* Insert into FTX Detail for new cancel FTX */

BEGIN /* Insert new Cancel fTX into FTA table */

	insert into FINANCIAL_TXN_APPLY (FINANCIAL_TXN_ID,BILLING_GROUP_ID,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,NEW_TXN_IN,HOLD_IN)

	select DISTINCT
	ftx.ID,
	@billinggroupID,
	getdate(),
	getdate(),
	@task,
	1,
	'Y',
	'N'
	from FINANCIAL_TXN ftx
	join #tmpftx t on t.fpc_id = ftx.FPC_ID
	where ftx.TXN_TYPE_CD='C' and ftx.TERM_NO = t.NewCancelTerm

END /* Insert new Cancel fTX into FTA table */

BEGIN /* Update Current Cancel FTX Amount */

	update ftx
	set AMOUNT_NO = t.UpdatedCancelAmount
	,UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ftx.LOCK_ID % 255 ) + 1
	--select ftx.* into UnitracHDStorage.dbo.FINANCIAL_TXN_INC0433968
	from FINANCIAL_TXN ftx
	join #tmpFTX t on t.currentCancelFTXID = ftx.ID
	where ftx.PURGE_DT is null

END /* Update Current Cancel FTX Amount */

BEGIN /* Update Current Cancel FTX Detail Amount */

	update ftxd
	set AMOUNT_NO = t.UpdatedCancelAmount
	,UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ftxd.LOCK_ID % 255 ) + 1
	--select ftxd.* into UnitracHDStorage.dbo.FINANCIAL_TXN_DETAIL_INC0433968
	from FINANCIAL_TXN_DETAIL ftxd
	join #tmpFTX t on t.currentCancelFTXID = ftxd.FINANCIAL_TXN_ID
	where ftxd.PURGE_DT is NULL

END /* Update Current Cancel FTX Detail Amount */