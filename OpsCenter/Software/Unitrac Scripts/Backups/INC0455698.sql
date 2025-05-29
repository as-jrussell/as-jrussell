 /*
	tfs 49456  - Update Nicholas Cancel FTX

*/

use unitrac
 
declare @task as varchar(15) = 'INC0455698'
declare @billinggroupID bigint = 2148236

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
'MT60008063')

select * from #tmpftx

BEGIN -- Insert Cancel FTX for prior term

	insert into FINANCIAL_TXN (FPC_ID,LFT_ID,AP_ID,TXN_TYPE_CD,AMOUNT_NO,TXN_DT,REASON_TX,CREATE_DT,UPDATE_DT, UPDATE_USER_TX,LOCK_ID,TERM_NO)
	select distinct
	 FPC_ID,
	 0,
	 0,
	 'C',
	 NewCancelAmount,
	 '2019-09-01 18:22:46.5730000',
	 concat('Month ',NewCancelTerm),
	 getdate(),
	 getdate(),
'INC0455698',
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
'INC0455698',
	1
	from FINANCIAL_TXN ftx
	join #tmpftx t on t.fpc_id = ftx.FPC_ID
	where ftx.TXN_TYPE_CD='C' and ftx.TERM_NO = t.NewCancelTerm

END /* Insert into FTX Detail for new cancel FTX */

BEGIN /* Insert new Cancel fTX into FTA table */

	insert into FINANCIAL_TXN_APPLY (FINANCIAL_TXN_ID,BILLING_GROUP_ID,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,NEW_TXN_IN,HOLD_IN)

	select DISTINCT
	ftx.ID,
	2148236,
	getdate(),
	getdate(),
	
'INC0455698',
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
	,UPDATE_DT = getdate(), UPDATE_USER_TX = 'INC0455698', LOCK_ID = (ftx.LOCK_ID % 255 ) + 1
	--select ftx.* into UnitracHDStorage.dbo.FINANCIAL_TXN_INC0455698
	from FINANCIAL_TXN ftx
	join #tmpFTX t on t.currentCancelFTXID = ftx.ID
	where ftx.PURGE_DT is null

END /* Update Current Cancel FTX Amount */

BEGIN /* Update Current Cancel FTX Detail Amount */

	update ftxd
	set AMOUNT_NO = t.UpdatedCancelAmount
	,UPDATE_DT = getdate(), UPDATE_USER_TX = 'INC0455698', LOCK_ID = (ftxd.LOCK_ID % 255 ) + 1
	--select ftxd.* into UnitracHDStorage.dbo.FINANCIAL_TXN_DETAIL_INC0455698
	from FINANCIAL_TXN_DETAIL ftxd
	join #tmpFTX t on t.currentCancelFTXID = ftxd.FINANCIAL_TXN_ID
	where ftxd.PURGE_DT is NULL

END /* Update Current Cancel FTX Detail Amount */


