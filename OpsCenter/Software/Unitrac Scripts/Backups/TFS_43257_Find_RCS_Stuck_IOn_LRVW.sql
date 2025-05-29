/*
TFS 43385 - Find RCs where they are stuck on the LRVW eval event. 
*/

declare @task as nvarchar(10) = '43385'
 
 select distinct (esc.ID)
 into #tmpLRVWs
 
  from EVENT_SEQUENCE es 
  join EVENT_SEQ_CONTAINER esc on esc.id = es.EVENT_SEQ_CONTAINER_ID
  join LENDER_PRODUCT lp on lp.id= esc.LENDER_PRODUCT_ID
  
  
  where es.EVENT_TYPE_CD = 'LRVW' and es.PURGE_DT is null and esc.PURGE_DT is null and lp.PURGE_DT is null 
 
  group by esc.id

  select max(ee.id) as EE_ID, ee.REQUIRED_COVERAGE_ID, es.ORDER_NO, es.id as EventSeqID, es.EVENT_SEQ_CONTAINER_ID, max( ee.GROUP_ID) as GROUP_ID, MAX(ee.EVENT_DT) as EVENT_DT
  into #tmpLastCompLRVW
  from #tmpLRVWs t
  join EVENT_SEQUENCE es on es.EVENT_SEQ_CONTAINER_ID = t.ID
  join EVALUATION_EVENT ee on ee.EVENT_SEQUENCE_ID = es.ID
  where ee.TYPE_CD = 'LRVW' and ee.STATUS_CD = 'COMP'
  --and ee.REQUIRED_COVERAGE_ID = 95116518
  group by ee.REQUIRED_COVERAGE_ID, es.ORDER_NO, es.ID, es.EVENT_SEQ_CONTAINER_ID


  select distinct(ee.REQUIRED_COVERAGE_ID)
  into #tmpAffectedRCs
  from EVALUATION_EVENT ee
  join #tmpLastCompLRVW t on t.REQUIRED_COVERAGE_ID = ee.REQUIRED_COVERAGE_ID and ee.GROUP_ID = t.GROUP_ID
  	join REQUIRED_COVERAGE rc on rc.id = ee.REQUIRED_COVERAGE_ID
  cross apply
  (
	select esp.id as NextSeqEventID, eep.id as NextEvalEventID
	from EVENT_SEQUENCE esp 
	join EVALUATION_EVENT eep on eep.EVENT_SEQUENCE_ID = esp.ID and eep.GROUP_ID = t.GROUP_ID
	where esp.EVENT_SEQ_CONTAINER_ID = t.EVENT_SEQ_CONTAINER_ID and esp.ORDER_NO = t.ORDER_NO + 1
	and eep.REQUIRED_COVERAGE_ID = ee.REQUIRED_COVERAGE_ID
	and eep.STATUS_CD = 'PEND'

  ) nextEvent 
    cross apply
  (
	select esp.id as PrevSeqEventID, eep.id as PrevEvalEventID
	from EVENT_SEQUENCE esp 
	join EVALUATION_EVENT eep on eep.EVENT_SEQUENCE_ID = esp.ID and eep.GROUP_ID = t.GROUP_ID
	where esp.EVENT_SEQ_CONTAINER_ID = t.EVENT_SEQ_CONTAINER_ID and esp.ORDER_NO = t.ORDER_NO - 1
	and eep.REQUIRED_COVERAGE_ID = ee.REQUIRED_COVERAGE_ID
	and eep.STATUS_CD = 'COMP'
  ) LastEvent 
  where
   rc.LAST_EVENT_SEQ_ID = LastEvent.PrevSeqEventID

  
select ldr.NAME_TX, l.NUMBER_TX, rc.id as ReqCovID, rc.TYPE_CD
from REQUIRED_COVERAGE rc
join #tmpAffectedRCs t on t.REQUIRED_COVERAGE_ID = rc.ID
join COLLATERAL c on c.PROPERTY_ID = rc.PROPERTY_ID
join LOAN l on l.id = c.LOAN_ID
join lender ldr on ldr.id = l.LENDER_ID



--update rc
--set LAST_EVENT_SEQ_ID = lrvw.EventSeqID, LAST_SEQ_CONTAINER_ID = lrvw.EVENT_SEQ_CONTAINER_ID, LAST_EVENT_DT = LRVW.EVENT_DT, 
--rc.UPDATE_DT = GETDATE(), rc.LOCK_ID = (rc.LOCK_ID % 255) + 1, rc.UPDATE_USER_TX = @task

--from REQUIRED_COVERAGE rc
--join #tmpAffectedRCs trc on trc.REQUIRED_COVERAGE_ID = rc.ID
--join #tmpLastCompLRVW lrvw on lrvw.REQUIRED_COVERAGE_ID = rc.ID




  IF OBJECT_ID(N'tempdb..#tmpLRVWs',N'U') IS NOT NULL
  DROP TABLE #tmpLRVWs
   IF OBJECT_ID(N'tempdb..#tmpLastCompLRVW',N'U') IS NOT NULL
  DROP TABLE #tmpLastCompLRVW

   IF OBJECT_ID(N'tempdb..#tmpAffectedRCs',N'U') IS NOT NULL
  DROP TABLE #tmpAffectedRCs


