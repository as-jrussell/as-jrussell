Declare @workitemid as bigint 
set @workitemid = 28620386

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
	  and (
		   (pli.relate_type_cd = 'Allied.UniTrac.Notice') or
		   (pli.relate_type_cd = 'Allied.UniTrac.Workflow.OutboundCallWorkItem')
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

		fetch next from itemCursor into @relateId, @relateClass, @typeCd, @eeId, @cycleProcessDate, @rcId
	  END

	  close itemCursor;
	  deallocate itemCursor; 
	  commit transaction	  


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
    