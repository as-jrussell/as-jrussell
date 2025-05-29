-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID


SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( 28923107, 28939933   )

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN ( 28923107   )


SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID IN (258490)

SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (258490)

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (30117362)

SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (30117362)

----If need to check for a report fro process log
SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (30102821)



--Work Item query to get process log IDs
SELECT *
FROM WORK_ITEM
WHERE ID IN ( 28923107, 28939933    )
--WIA query to obtain Process Definition ID (In the ACTION_NOTE_TX)
SELECT *
FROM WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN ( 28923107, 28939933    ) and ACTION_CD = 'Release For Billing'
--New Billing Processes
SELECT *
FROM PROCESS_DEFINITION
WHERE ID in (258490)
--New Process Log IDs
SELECT *
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID in (258490)
--PLI Table
SELECT *
FROM PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (30117362)
--Billing Group WIs
SELECT *
FROM WORK_ITEM
WHERE RELATE_ID IN (1440002) AND RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup'


UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Withdrawn'
WHERE   ID IN ( 28939933 )
        AND WORKFLOW_DEFINITION_ID = 10
        AND ACTIVE_IN = 'Y'


		USE UniTrac 
GO	

DECLARE @workitemid as bigint 
set @workitemid = 28923107

	if OBJECT_ID('tempdb..#tmpProcess') IS NOT NULL
	   drop table #tmpProcess

    Create Table #tmpProcess
    (
      RELATE_ID bigint ,
      RELATE_TYPE_CD varchar(100), 
      TYPE_CD varchar(30), 
      EE_ID bigint,
      PROCESS_DT datetime,
      REQUIRED_COVERAGE_ID bigint
    )
    
    Insert into #tmpProcess
    (
      RELATE_ID , RELATE_TYPE_CD , TYPE_CD , EE_ID , PROCESS_DT , REQUIRED_COVERAGE_ID
    )
	select pli.RELATE_ID, pli.RELATE_TYPE_CD, 
	ee.TYPE_CD , ee.ID as EE_ID ,
	CONVERT(VARCHAR(10), pl.START_DT , 101 ) , ee.REQUIRED_COVERAGE_ID	
	from process_log_item pli
	  inner join process_log pl on pl.id = pli.process_log_id 
	  inner join evaluation_event ee on ee.id = pli.evaluation_event_id
	  inner join work_item wi on wi.relate_id = pl.id and wi.relate_type_cd = 'Osprey.ProcessMgr.ProcessLog'
	where wi.id = @workitemid
	  and ((pli.relate_type_cd = 'allied.unitrac.Forceplacedcertificate' and ee.TYPE_CD = 'ISCT') or
		   (pli.relate_type_cd = 'Allied.UniTrac.Notice') or
		   (pli.relate_type_cd = 'Allied.UniTrac.Workflow.OutboundCallWorkItem') or 
		   (pli.relate_type_cd = 'allied.unitrac.Forceplacedcertificate' and ee.TYPE_CD = 'PRNT') or
		   (pli.relate_type_cd = 'Allied.UniTrac.NoticeInteraction') or
		   (pli.relate_type_cd = 'Allied.UniTrac.RequiredCoverage' and ee.TYPE_CD = 'DFLT')  
		   )
		   and pli.STATUS_CD = 'COMP'
		   and ee.STATUS_CD = 'COMP'
		  
	begin transaction

	BEGIN TRY

	  declare @relateId bigint
	  declare @relateClass nvarchar(100)
	  Declare @typeCd varchar(20)
	  Declare @eeId bigint
	  Declare @cycleProcessDate datetime
	  Declare @rcId bigint

	  declare itemCursor cursor for
		select RELATE_ID, RELATE_TYPE_CD , TYPE_CD , EE_ID, PROCESS_DT , REQUIRED_COVERAGE_ID from #tmpProcess;

	  open itemCursor

	  fetch next from itemCursor into @relateId, @relateClass, @typeCd, @eeId, @cycleProcessDate, @rcId

	  WHILE @@FETCH_STATUS = 0
	  BEGIN

		if @relateClass = 'Allied.UniTrac.Workflow.OutboundCallWorkItem'
			begin			  
			  exec Support_Backoff_OutboundCall @workItemId=@relateId, @eeId = @eeId
			end

		if @relateClass = 'Allied.UniTrac.Notice'
			begin			  
			  exec Support_BackoffNotice @noticeId=@relateId
			end
     	    
		if @relateClass = 'Allied.UniTrac.ForcePlacedCertificate' and
		   @typeCd = 'PRNT'
			begin			  
			  exec Support_Backoff_Certificates @evaluationEventId=@eeId, @processDate = @cycleProcessDate	      
			end
		
		if @relateClass = 'Allied.UniTrac.NoticeInteraction'
			begin		  
			  exec Support_Backoff_AutoOBCall @ihId = @relateId  , @requiredCoverageId = @rcId
			end
		
		if @relateClass = 'Allied.UniTrac.RequiredCoverage' and 
		   @typeCd = 'DFLT'
			begin		
			   UPDATE REQUIRED_COVERAGE SET SUB_STATUS_CD = '' , GOOD_THRU_DT = NULL ,
			   UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' , 
			   LOCK_ID = (LOCK_ID % 255) + 1
			   WHERE ID = @rcId	AND SUB_STATUS_CD = 'X'	  
			end

		fetch next from itemCursor into @relateId, @relateClass, @typeCd, @eeId, @cycleProcessDate, @rcId
	  END

	  close itemCursor;
	  deallocate itemCursor; 
	  commit transaction	  
	 
	  
	  Update WORK_ITEM set PURGE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' , 
	   LOCK_ID = (LOCK_ID % 255) + 1 , UPDATE_DT = GETDATE() ,
	   STATUS_CD = 'Withdrawn' where ID = @workitemid

      select 'SUCCESS' AS RESULT ,
      0 AS ErrorNumber,
			0 AS ErrorSeverity,
			'' as ErrorState,
			'' as ErrorProcedure,
			'' as ErrorLine,
			'COMP' as ErrorMessage

	END TRY
	BEGIN CATCH
	  close itemCursor;
	  deallocate itemCursor;
	  rollback transaction

	  select
			'ERROR' AS RESULT,		
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() as ErrorState,
			ERROR_PROCEDURE() as ErrorProcedure,
			ERROR_LINE() as ErrorLine,
			ERROR_MESSAGE() as ErrorMessage;
	END CATCH 
    
