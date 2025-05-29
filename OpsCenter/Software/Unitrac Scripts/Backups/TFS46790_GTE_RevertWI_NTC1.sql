/*
	TFS 46790
	GTE 1615 Cycle Back Off - Incident INC0372771


	This is for GTE 1615, this lender removed tier tracking and went to predictive notice timing.
	We need to have all 1st notices generated from the 8/24/2018 cycle cleared and any 2nd notices 
	that generated placed back to 1st notice status with the open quote so when the lender does cycle 
	again these 2nd notices will generate again. Please make sure when these 2nd notices are backed off
	that the loan is back in 1st notice status with an open quote. We have issues recently where this 
	was not done and created more issues. If it is easier to just run a script to clear the notice cycle 
	on the 1st notices that is fine but for the 2nd's I am not sure that can be done since we want these 
	back in 1st notice cycle. Please let me know if any questions.  


	With cycle being 9/1, new loans with a loan effective date older than 90 days would be 6/3/2018 .
	 Anything 6/3/2018 and older would need to go from New to Audit. 

*/


IF OBJECT_ID(N'tempdb..#tmpAuditRCs',N'U') IS NOT NULL
	DROP TABLE #tmpAuditRCs
IF OBJECT_ID(N'tempdb..#tmpNTC1',N'U') IS NOT NULL
	DROP TABLE #tmpNTC1
  

    CREATE TABLE #tmpAuditRCs
    (
      LOAN_ID BIGINT ,
      RC_ID BIGINT ,
	  PROP_ID BIGINT,
	  LOAN_NO varchar(100),
      INS_SUMMARY_STATUS VARCHAR(1),
	  INS_SUMMARY_SUB_STATUS VARCHAR(1),
	  EXPOSURE_DT DATETIME
    )

Declare @Task varchar(10) = 'TASK46790'
Declare @AuditStatus varchar(2) = 'A'


select rc.ID as RC_ID, ee.id as EE_ID, ee.RELATE_ID as NOTICE_ID, es.id as ES_ID, rc.CPI_QUOTE_ID, es.ORDER_NO as Event_Order_No
into #tmpNTC1
from PROCESS_LOG_ITEM pli
join EVALUATION_EVENT ee on ee.ID = pli.EVALUATION_EVENT_ID
join EVENT_SEQUENCE es on es.id = ee.EVENT_SEQUENCE_ID and es.EVENT_TYPE_CD = 'NTC' and es.NOTICE_SEQ_NO  = 1
join REQUIRED_COVERAGE rc on rc.id = ee.REQUIRED_COVERAGE_ID

where pli.PROCESS_LOG_ID = 63407173
and es.NOTICE_SEQ_NO = rc.NOTICE_SEQ_NO


BEGIN /*  Order 1 Updates  IF NTC 1 was event 1, clear out RC Notice information and set event back to pending.  */

	update rc
	set NOTICE_DT = NULL , NOTICE_SEQ_NO = NULL , NOTICE_TYPE_CD = NULL,
		CPI_QUOTE_ID = NULL , LAST_EVENT_DT = NULL , LAST_EVENT_SEQ_ID = NULL , LAST_SEQ_CONTAINER_ID = NULL ,
		GOOD_THRU_DT = NULL , UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 , UPDATE_USER_TX = @Task
	from #tmpNTC1 t
	join REQUIRED_COVERAGE rc on rc.id = t.RC_ID and rc.PURGE_DT is NULL
	where t.Event_Order_No = 1

END /* Order 1 */


BEGIN /* Order 2 Updates. If NTC 2 was not event 1, set RC back to previous event. Still Clear all NTC 1 Information */

	update rc 
	set NOTICE_DT = NULL , NOTICE_SEQ_NO = NULL , NOTICE_TYPE_CD = NULL, CPI_QUOTE_ID = NULL , 
	LAST_EVENT_DT = lastEventDT.LastEventDate , LAST_EVENT_SEQ_ID = prevEvent.ID , LAST_SEQ_CONTAINER_ID = prevEvent.EVENT_SEQ_CONTAINER_ID ,
	GOOD_THRU_DT = NULL , UPDATE_DT = GETDATE() , LOCK_ID = (rc.LOCK_ID % 255) + 1 , UPDATE_USER_TX = @Task
	from #tmpNTC1 t
	join REQUIRED_COVERAGE rc on rc.id = t.RC_ID
	join EVENT_SEQUENCE es on es.ID = t.ES_ID
	join EVALUATION_EVENT ee on ee.ID = t.EE_ID
	cross APPLY
	(
		select *
		from EVENT_SEQUENCE prev
		where prev.EVENT_SEQ_CONTAINER_ID = es.EVENT_SEQ_CONTAINER_ID and prev.ORDER_NO = es.ORDER_NO - 1
	
	) prevEvent
	cross APPLY
	(
		select lee.EVENT_DT as LastEventDate
		from EVALUATION_EVENT lee 
		where lee.GROUP_ID = ee.GROUP_ID and lee.EVENT_SEQUENCE_ID = prevEvent.ID and lee.REQUIRED_COVERAGE_ID = rc.ID

	) lastEventDT
	where t.event_order_no > 1
		

END /* Order 2 Updates */

BEGIN /* NTC 1 Updates that are common to all scenarios */

	update n
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (n.LOCK_ID % 255 ) + 1
	from #tmpNTC1 t
	join notice n on n.id = t.NOTICE_ID and n.PURGE_DT is null


	update nr
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (nr.LOCK_ID % 255 ) + 1
	from #tmpNTC1 t
	join NOTICE_REQUIRED_COVERAGE_RELATE nr on nr.NOTICE_ID = t.NOTICE_ID and nr.PURGE_DT is null


	update ih
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ih.LOCK_ID % 255 ) + 1
	from #tmpNTC1 t
	join INTERACTION_HISTORY ih on ih.RELATE_ID = t.NOTICE_ID and ih.RELATE_CLASS_TX = 'Allied.UniTrac.Notice' and TYPE_CD = 'NOTICE'


	update dc
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (dc.LOCK_ID % 255 ) + 1
	from #tmpNTC1 t
	join DOCUMENT_CONTAINER dc on dc.RELATE_ID = t.NOTICE_ID and RELATE_CLASS_NAME_TX = 'ALLIED.UNITRAC.NOTICE'


	update cpi
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (cpi.LOCK_ID % 255 ) + 1
	from #tmpNTC1 t
	join CPI_QUOTE cpi on cpi.id = t.CPI_QUOTE_ID and cpi.PURGE_DT is null

	update cpia 
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (cpia.LOCK_ID % 255 ) + 1 
	from #tmpNTC1 t 
	join CPI_ACTIVITY cpia on cpia.CPI_QUOTE_ID = t.CPI_QUOTE_ID and cpia.PURGE_DT is null

	update ih
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ih.LOCK_ID % 255 ) + 1 
	from #tmpNTC1 t
	join INTERACTION_HISTORY ih on ih.RELATE_ID = t.CPI_QUOTE_ID and ih.RELATE_CLASS_TX = 'Allied.UniTrac.CPIQuote' and ih.TYPE_CD = 'CPI'

	update ee 
	set STATUS_CD = 'PEND', RELATE_ID = null, RELATE_TYPE_CD = null,
	UPDATE_DT = getdate(), UPDATE_USER_TX = @task, LOCK_ID = (ee.LOCK_ID % 255 ) + 1
	from #tmpNTC1 t
	join EVALUATION_EVENT ee on ee.id = t.EE_ID

	
END /* NTC 1 Clear */




	
BEGIN /* New to Audit Updates */

	INSERT INTO #tmpAuditRCs
	(
		LOAN_ID, RC_ID, PROP_ID, LOAN_NO, INS_SUMMARY_STATUS, INS_SUMMARY_SUB_STATUS, EXPOSURE_DT
	)
	select  l.id as  LOAN_ID , rc.id as RC_ID, rc.property_id as PROP_ID, l.number_tx as LOAN_NO, rc.INSURANCE_STATUS_CD as INS_SUMMARY_STATUS,
		  rc.INSURANCE_SUB_STATUS_CD as INS_SUMMARY_SUB_STATUS , rc.EXPOSURE_DT as EXPOSURE_DT 

	from #tmpNTC1 t
	join REQUIRED_COVERAGE rc on rc.id = t.RC_ID
	join COLLATERAL c on c.PROPERTY_ID = rc.PROPERTY_ID and c.PURGE_DT is null
	join loan l on l.id = c.LOAN_ID and l.PURGE_DT is NULL
	where rc.SUMMARY_STATUS_CD = 'N'
	and l.EFFECTIVE_DT <= '06/03/2018'


	 update rc
	 set rc.Summary_Status_CD = @AuditStatus, rc.INSURANCE_STATUS_CD = @AuditStatus, BEGAN_NEW_IN = 'N',
		rc.Good_THRU_DT = null, 
		rc.UPDATE_USER_TX=@Task, rc.UPDATE_DT = getdate(), rc.LOCK_ID = (LOCK_ID % 255) + 1
	 from REQUIRED_COVERAGE rc
	 join #tmpAuditRCs t on t.RC_ID = rc.ID
	 where rc.PURGE_DT is null 



	BEGIN /* --  Insert Pc & PCU records for RC */
  		
		  declare @rcID bigint = 0,
				  @propID bigint = 0,
				  @currentSummaryStatus nvarchar(2)= null,
				  @currentSummarySubStatus nvarchar(2) = null,
				  @currentExposure datetime = null,
				  @chunksize int = 1000
		  declare itemCursor cursor for
		  select RC_ID, PROP_ID,INS_SUMMARY_STATUS, INS_SUMMARY_SUB_STATUS, EXPOSURE_DT from #tmpAuditRCs;

		  open itemCursor

		  fetch next from itemCursor into @rcID, @propID, @currentSummaryStatus, @currentSummarySubStatus, @currentExposure

		  WHILE @@FETCH_STATUS = 0
		  BEGIN	  

			begin transaction

			declare @propChangeID bigint = 0
			-- Insert into Property Change Table
			Insert into PROPERTY_CHANGE (ENTITY_NAME_TX,ENTITY_ID,USER_TX,ATTACHMENT_IN,CREATE_DT,DETAILS_IN,FORMATTED_IN,LOCK_ID,PARENT_NAME_TX,PARENT_ID,TRANS_STATUS_CD,UTL_IN)
				values ('Allied.UniTrac.RequiredCoverage',@rcID,@Task,'N',getdate(),'Y','N',1,'Allied.UniTrac.Property',@propID,'PEND','N')
			set @propChangeID = SCOPE_IDENTITY()
			if (@propChangeID <> 0)
			begin
			-- Insert into Property Change Update Table

			--SUMMARY_STATUS_CD
			insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
				values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'SUMMARY_STATUS_CD',@currentSummaryStatus,@AuditStatus,2,getdate(),'Y','U')


			--INSURANCE_STATUS_CD
			insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
				values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'INSURANCE_STATUS_CD',@currentSummaryStatus,@AuditStatus,2,getdate(),'Y','U')


			END

			commit transaction

			fetch next from itemCursor into @rcID,@propID, @currentSummaryStatus,@currentSummarySubStatus, @currentExposure
		  END

		  close itemCursor;
		  deallocate itemCursor; 
	end /* --  Insert Pc & PCU records for RC */

END /* New to Audit Updates */

