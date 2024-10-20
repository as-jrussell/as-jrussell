USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[Support_Backoff_OutboundCall]    Script Date: 12/19/2017 7:27:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [Support_Backoff_OutboundCall] @workItemId=1660
DECLARE
	@workItemId   bigint,
	@eeId bigint


SET @workitemID = ''
BEGIN
	 --Set the options to support indexed views.
  SET NUMERIC_ROUNDABORT OFF;
  SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
      QUOTED_IDENTIFIER, ANSI_NULLS ON;
  SET XACT_ABORT ON


	Declare @ihId as  bigint = null
	declare @rcID as BIGINT = null
	declare @groupId as BIGINT = NULL
	DECLARE @eventSequenceId as BIGINT = NULL
	declare @eventOrderNum as BIGINT = null
	Declare @EventID as bigint

	Declare @lastEventDt as datetime2
	Declare @lastEventSeqId as bigint
	Declare @lastSeqContainerId as bigint

	
	SELECT @ihId = RELATE_ID
	FROM WORK_ITEM
	WHERE ID = @workItemId


	
	
	UPDATE WORK_ITEM
	SET PURGE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' ,
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
	WHERE ID = @workItemId
	
	UPDATE INTERACTION_HISTORY
	SET PURGE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' ,
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
	WHERE ID = @ihId
	   
	UPDATE EVALUATION_EVENT SET STATUS_CD = 'PEND' , 
	UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' ,
	LOCK_ID = (LOCK_ID % 255) + 1
	WHERE ID = @eeId
	AND TYPE_CD = 'VFY'

	


	
	SELECT  
		@rcId = ee.REQUIRED_COVERAGE_ID,
		@groupId = GROUP_ID ,
		@eventSequenceId = ISNULL(ee.EVENT_SEQUENCE_ID ,0 ),
		@eventOrderNum = es.ORDER_NO,
		@EventID = ee.ID
	From EVALUATION_EVENT ee	
	inner join EVENT_SEQUENCE es on es.ID = ee.EVENT_SEQUENCE_ID
	where ee.id = @eeID

	if (@eventOrderNum = 1 AND (@EventID = @groupId))
	BEGIN
	-- OBC being backed off is the first event. Set Last Event Info on RC record to null

	UPDATE REQUIRED_COVERAGE set LAST_EVENT_DT = NULL , LAST_EVENT_SEQ_ID = NULL , LAST_SEQ_CONTAINER_ID = NULL ,
		  GOOD_THRU_DT = NULL , UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 , UPDATE_USER_TX = 'CYCBACKOFF'
		  where ID = @rcId 
	END

	ELSE
	BEGIN
      
	  SELECT top 1 @lastEventDt = ee.EVENT_DT, @lastEventSeqId = ee.EVENT_SEQUENCE_ID, @lastSeqContainerId = es.EVENT_SEQ_CONTAINER_ID
	  from EVALUATION_EVENT ee
	  join EVENT_SEQUENCE es on es.ID = ee.EVENT_SEQUENCE_ID
	  Where ee.GROUP_ID = @groupId and ee.REQUIRED_COVERAGE_ID = @rcID and ee.STATUS_CD = 'COMP'
	  order by ee.EVENT_DT desc, es.NOTICE_SEQ_NO


	  UPDATE REQUIRED_COVERAGE set LAST_EVENT_DT = @lastEventDt , LAST_EVENT_SEQ_ID = @lastEventSeqId , LAST_SEQ_CONTAINER_ID = @lastSeqContainerId ,
	  GOOD_THRU_DT = NULL , UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 , UPDATE_USER_TX = 'CYCBACKOFF'
	  where ID = @rcId 
	   
	END  
	

	
   
	
END
