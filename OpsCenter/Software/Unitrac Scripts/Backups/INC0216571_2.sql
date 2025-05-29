---- DROP TABLE #TMPPLI
select pli.RELATE_ID, pli.RELATE_TYPE_CD, 
	ee.TYPE_CD , ee.ID as EE_ID ,
	CONVERT(VARCHAR(10), pl.START_DT , 101 ) AS PROCESS_DT , ee.REQUIRED_COVERAGE_ID	
	INTO #TMPPLI
	from process_log_item pli
	  inner join process_log pl on pl.id = pli.process_log_id 
	  inner join evaluation_event ee on ee.id = pli.evaluation_event_id
	  inner join work_item wi on wi.relate_id = pl.id and wi.relate_type_cd = 'Osprey.ProcessMgr.ProcessLog'
	where wi.id in (28620386)
	  and ((pli.relate_type_cd = 'allied.unitrac.Forceplacedcertificate' and ee.TYPE_CD = 'ISCT') or
		   (pli.relate_type_cd = 'Allied.UniTrac.Notice') or
		   (pli.relate_type_cd = 'Allied.UniTrac.Workflow.OutboundCallWorkItem') or 
		   (pli.relate_type_cd = 'allied.unitrac.Forceplacedcertificate' and ee.TYPE_CD = 'PRNT') or
		   (pli.relate_type_cd = 'Allied.UniTrac.NoticeInteraction') or
		   (pli.relate_type_cd = 'Allied.UniTrac.RequiredCoverage' and ee.TYPE_CD = 'DFLT')  
		   )
		   and pli.STATUS_CD = 'COMP'
		   and ee.STATUS_CD = 'COMP'
----203

select * --INTO UnitracHDStorage.dbo.TMPPLI_INC0216571

from #TMPPLI

----- DROP TABLE #TMPRC
SELECT PLI.* , NTC.SEQUENCE_NO , NTC.TYPE_CD AS NTC_TYPE_CD ,  RC.NOTICE_SEQ_NO , RC.NOTICE_DT , RC.NOTICE_TYPE_CD
--INTO #TMPRC
FROM #TMPPLI PLI
JOIN NOTICE NTC ON NTC.ID = PLI.RELATE_ID
JOIN REQUIRED_COVERAGE RC ON RC.ID = PLI.REQUIRED_COVERAGE_ID
WHERE PLI.relate_type_cd = 'Allied.UniTrac.Notice'
----200
AND RC.NOTICE_SEQ_NO > 0
----17
AND RC.NOTICE_SEQ_NO = NTC.SEQUENCE_NO
----0
AND RC.NOTICE_TYPE_CD = NTC.TYPE_CD
----0
AND DATEDIFF( DAY , RC.NOTICE_DT , NTC.EXPECTED_ISSUE_DT ) = 0
-----0
--AND DATEDIFF( DAY , RC.NOTICE_DT , NTC.EXPECTED_ISSUE_DT ) <> 0
---- 7 - SEND THESE 7 TO BUSINESS


select *  INTO UnitracHDStorage.dbo.TMPRC_INC0216571
from #TMPRC

INSERT INTO #TMPRC
SELECT PLI.* , NTC.SEQUENCE_NO , NTC.TYPE_CD AS NTC_TYPE_CD ,  RC.NOTICE_SEQ_NO , RC.NOTICE_DT , RC.NOTICE_TYPE_CD
FROM #TMPPLI PLI
JOIN NOTICE NTC ON NTC.ID = PLI.RELATE_ID
JOIN REQUIRED_COVERAGE RC ON RC.ID = PLI.REQUIRED_COVERAGE_ID
WHERE PLI.relate_type_cd = 'Allied.UniTrac.Notice'
AND NTC.TYPE_CD IN ( 'CCU' , 'CCF' , 'BI' )
----- 0


begin transaction

	BEGIN TRY

	  declare @relateId bigint
	  declare @relateClass nvarchar(100)
	  Declare @typeCd varchar(20)
	  Declare @eeId bigint
	  Declare @cycleProcessDate datetime
	  Declare @rcId bigint

	  declare itemCursor cursor for
		select RELATE_ID, RELATE_TYPE_CD , TYPE_CD , EE_ID, PROCESS_DT , REQUIRED_COVERAGE_ID from #TMPRC;

	  open itemCursor

	  fetch next from itemCursor into @relateId, @relateClass, @typeCd, @eeId, @cycleProcessDate, @rcId

	  WHILE @@FETCH_STATUS = 0
	  BEGIN

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