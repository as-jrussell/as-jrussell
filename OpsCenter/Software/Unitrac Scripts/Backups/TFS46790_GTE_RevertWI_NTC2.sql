/*
	TFS 46790 - NTC 2 
	GTE 1615 Cycle Back Off - Incident INC0372771


	This is for GTE 1615, this lender removed tier tracking and went to predictive notice timing.
	We need to have all 1st notices generated from the 8/24/2018 cycle cleared and any 2nd notices 
	that generated placed back to 1st notice status with the open quote so when the lender does cycle 
	again these 2nd notices will generate again. Please make sure when these 2nd notices are backed off
	that the loan is back in 1st notice status with an open quote. We have issues recently where this 
	was not done and created more issues. If it is easier to just run a script to clear the notice cycle 
	on the 1st notices that is fine but for the 2nd's I am not sure that can be done since we want these 
	back in 1st notice cycle. Please let me know if any questions.  



*/


IF OBJECT_ID(N'tempdb..#tmpNTC2',N'U') IS NOT NULL
DROP TABLE #tmpNTC2


Declare @Task varchar(10) = 'TASK46790'

select rc.ID as RC_ID, ee.id as EE_ID, ee.RELATE_ID as NOTICE_ID, es.id as ES_ID, rc.CPI_QUOTE_ID, es.ORDER_NO as Event_Order_No
into #tmpNTC2
from PROCESS_LOG_ITEM pli
join EVALUATION_EVENT ee on ee.ID = pli.EVALUATION_EVENT_ID
join EVENT_SEQUENCE es on es.id = ee.EVENT_SEQUENCE_ID and es.EVENT_TYPE_CD = 'NTC' and es.NOTICE_SEQ_NO  = 2
join REQUIRED_COVERAGE rc on rc.id = ee.REQUIRED_COVERAGE_ID
where pli.PROCESS_LOG_ID = 63407173
and es.NOTICE_SEQ_NO = rc.NOTICE_SEQ_NO



	update rc 
	set NOTICE_DT = lastEventDT.LastEventDate, NOTICE_SEQ_NO = prevEvent.NOTICE_SEQ_NO, NOTICE_TYPE_CD = prevEvent.NOTICE_TYPE_CD, 
	LAST_EVENT_DT = lastEventDT.LastEventDate, LAST_EVENT_SEQ_ID = prevEvent.ID, LAST_SEQ_CONTAINER_ID = prevEvent.EVENT_SEQ_CONTAINER_ID ,
	GOOD_THRU_DT = NULL , UPDATE_DT = GETDATE(), LOCK_ID = (rc.LOCK_ID % 255) + 1 , UPDATE_USER_TX = @Task

	from #tmpNTC2 t
	join REQUIRED_COVERAGE rc on rc.id = t.RC_ID
	join EVENT_SEQUENCE es on es.ID = t.ES_ID
	join EVALUATION_EVENT ee on ee.ID = t.EE_ID
	cross APPLY
	(
		select *
		from EVENT_SEQUENCE prev
		where prev.EVENT_SEQ_CONTAINER_ID = es.EVENT_SEQ_CONTAINER_ID and prev.ORDER_NO = es.ORDER_NO - 1
	
	) prevEvent
	outer APPLY
	(
		select lee.EVENT_DT as LastEventDate
		from EVALUATION_EVENT lee 
		where lee.GROUP_ID = ee.GROUP_ID and lee.EVENT_SEQUENCE_ID = prevEvent.ID and lee.REQUIRED_COVERAGE_ID = rc.ID

	) lastEventDT
	where t.event_order_no > 1
		

BEGIN /* NTC 2 Updates that are common to all scenarios */

	update n
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (n.LOCK_ID % 255 ) + 1
	from #tmpNTC2 t
	join notice n on n.id = t.NOTICE_ID and n.PURGE_DT is null


	update nr
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (nr.LOCK_ID % 255 ) + 1
	from #tmpNTC2 t
	join NOTICE_REQUIRED_COVERAGE_RELATE nr on nr.NOTICE_ID = t.NOTICE_ID and nr.PURGE_DT is null


	update ih
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ih.LOCK_ID % 255 ) + 1
	from #tmpNTC2 t
	join INTERACTION_HISTORY ih on ih.RELATE_ID = t.NOTICE_ID and ih.RELATE_CLASS_TX = 'Allied.UniTrac.Notice' and TYPE_CD = 'NOTICE'


	update dc
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (dc.LOCK_ID % 255 ) + 1
	from #tmpNTC2 t
	join DOCUMENT_CONTAINER dc on dc.RELATE_ID = t.NOTICE_ID and RELATE_CLASS_NAME_TX = 'ALLIED.UNITRAC.NOTICE'


	update ee 
	set STATUS_CD = 'PEND', RELATE_ID = null, RELATE_TYPE_CD = null,
	UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ee.LOCK_ID % 255 ) + 1
	from #tmpNTC2 t
	join EVALUATION_EVENT ee on ee.id = t.EE_ID

	
END /* NTC 2 Clear */