USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[Support_BackoffFPC]    Script Date: 12/19/2017 7:28:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DECLARE
   @fpcId as bigint,
	@rcId as bigint 


	select @rcId = RELATE_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = ''
AND RELATE_TYPE_CD = 'Allied.Unitrac.RequiredCoverage'

	select @fpcId = RELATE_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = ''
AND RELATE_TYPE_CD = 'Allied.UniTrac.ForcePlacedCertificate'


BEGIN	
	SET NOCOUNT ON	
	
	Declare @cpiQuoteId as bigint
	Declare @NoticeType as nvarchar(10)
	Declare @NoticeSequence as int
	Declare @prevNoticeDt as datetime2 
	Declare @prevNtcCreateDt as datetime2
	Declare @prevNoticeId as bigint
	Declare @lastEventDt as datetime2
	Declare @lastEventSeqId as bigint
	Declare @lastSeqContainerId as bigint
	Declare @groupId as bigint
	Declare @exposureDt as datetime2
   Declare @eeId as bigint

   Declare @LoanStatus as varchar(3)
	Declare @CollateralStatus as varchar(3)
	Declare @RCStatus as varchar(3)
	Declare @RCSubStatus as varchar(3)
	Declare @RCSummaryStatus as varchar(3)
	Declare @RCSummarySubStatus as varchar(3)
	Declare @CNT as int
	
	SELECT 
		@groupId = GROUP_ID ,
		@eeId = ee.ID
	from  FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE fpcr 
	join EVALUATION_EVENT ee  on ee.RELATE_ID = fpcr.FPC_ID 
	and ee.RELATE_TYPE_CD = 'Allied.UniTrac.ForcePlacedCertificate'	
	and ee.REQUIRED_COVERAGE_ID = fpcr.REQUIRED_COVERAGE_ID 
	and ee.TYPE_CD = 'ISCT'	
	JOIN dbo.PROCESS_LOG_ITEM PLI ON PLI.EVALUATION_EVENT_ID = EE.ID 
	WHERE PLI.PROCESS_LOG_ID IN (@ProcessLogID)
			
	UPDATE EVALUATION_EVENT set STATUS_CD = 'NOTU', PURGE_DT = GETDATE(), UPDATE_USER_TX = 'CYCBACKOFF'
	where REQUIRED_COVERAGE_ID = @rcId and STATUS_CD = 'PEND'

   IF OBJECT_ID(N'tempdb..#tmpNTC',N'U') IS NOT NULL
			   DROP TABLE #tmpNTC    
	
	SELECT * 
	 INTO #tmpNTC
	 FROM dbo.GetEvaluationLastStatus(@eeId ,'LoanStatus,CollateralStatus,RCStatus,RCSubStatus,RCSummaryStatus,RCSummarySubStatus')
			
	 SELECT @LoanStatus = LOAN.STATUS_CD , @CollateralStatus = COLL.STATUS_CD , @RCStatus = RC.STATUS_CD , 
	 @RCSubStatus = RC.SUB_STATUS_CD , @RCSummaryStatus  = RC.SUMMARY_STATUS_CD , @RCSummarySubStatus = RC.SUMMARY_SUB_STATUS_CD 
	 FROM LOAN JOIN COLLATERAL COLL ON COLL.LOAN_ID = LOAN.ID
	 JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = COLL.PROPERTY_ID
	 WHERE RC.ID = @rcId
 
	 SELECT @CNT = COUNT(*) FROM #tmpNTC WHERE 
	 (
	   (STATUSCD = 'LoanStatus' AND ISNULL(STATUSVALUE,'') <> ISNULL(@LoanStatus,'')) OR
	   (STATUSCD = 'CollateralStatus' AND ISNULL(STATUSVALUE,'') <> ISNULL(@CollateralStatus,'')) OR
	   (STATUSCD = 'RCStatus' AND ISNULL(STATUSVALUE,'') <> ISNULL(@RCStatus,'')) OR
	   (STATUSCD = 'RCSubStatus' AND ISNULL(STATUSVALUE,'') <> ISNULL(@RCSubStatus,'')) OR
	   (STATUSCD = 'RCSummaryStatus' AND ISNULL(STATUSVALUE,'') <> ISNULL(@RCSummaryStatus,'')
	    AND STATUSVALUE <> 'F'	   
	   ) OR
	   (STATUSCD = 'RCSummarySubStatus' AND ISNULL(STATUSVALUE,'') <> ISNULL(@RCSummarySubStatus,''))
	  )	

	--- set to previous notice only if the status is same as previous status
	If @CNT = 0	
       BEGIN
	   SELECT top 1 @prevNoticeId = ee.RELATE_ID , 
	      @lastEventDt = ee.EVENT_DT , 
	      @lastEventSeqId = ee.EVENT_SEQUENCE_ID ,
          @lastSeqContainerId = es.EVENT_SEQ_CONTAINER_ID , 
          @NoticeSequence = es.NOTICE_SEQ_NO , 
          @NoticeType = es.NOTICE_TYPE_CD 
          from EVALUATION_EVENT ee (NOLOCK) join EVENT_SEQUENCE es ON es.ID = ee.EVENT_SEQUENCE_ID 
          where GROUP_ID = @groupId and ee.TYPE_CD = 'NTC' and ee.RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
          and ee.REQUIRED_COVERAGE_ID = @rcId and ee.STATUS_CD = 'COMP'
          ORDER BY ee.EVENT_DT desc , es.NOTICE_SEQ_NO desc
       
       --- if not found in the same group, due to prev cycle backoff/from VUT
       if @@ROWCOUNT = 0
          SELECT top 1 @prevNoticeId = ee.RELATE_ID , 
	      @lastEventDt = ee.EVENT_DT , 
	      @lastEventSeqId = ee.EVENT_SEQUENCE_ID ,
          @lastSeqContainerId = es.EVENT_SEQ_CONTAINER_ID , 
          @NoticeSequence = es.NOTICE_SEQ_NO , 
          @NoticeType = es.NOTICE_TYPE_CD 
          from EVALUATION_EVENT ee join EVENT_SEQUENCE es ON es.ID = ee.EVENT_SEQUENCE_ID 
          where ee.TYPE_CD = 'NTC' 
          and ee.REQUIRED_COVERAGE_ID = @rcId and ee.STATUS_CD = 'COMP'
          ORDER BY ee.EVENT_DT desc , es.NOTICE_SEQ_NO desc
       
       set @cpiQuoteId = NULL
       
	      if ISNULL(@prevNoticeId,0) > 0
		     BEGIN
			      SELECT 		   
			      @cpiQuoteId = n.CPI_QUOTE_ID , 
			      @prevNoticeDt = n.EXPECTED_ISSUE_DT  
			      from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON
			      nr.NOTICE_ID = n.ID where nr.REQUIRED_COVERAGE_ID = @rcId and
			      nr.PURGE_DT IS NULL and n.PURGE_DT IS NULL and n.SEQUENCE_NO = @NoticeSequence 
			      and n.TYPE_CD = @NoticeType and  n.ID = @prevNoticeId
		     END
	      else
		     BEGIN
			      Declare @tmpNotice as TABLE
			      (
			        EXPECTED_ISSUE_DT datetime2,
			        CNT int
			      )
			   
			      INSERT INTO @tmpNotice
			      select MAX(n.EXPECTED_ISSUE_DT) as EXPECTED_ISSUE_DT , COUNT(*) as CNT
			      from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
			      where nr.REQUIRED_COVERAGE_ID = @rcId 
			      and nr.PURGE_DT IS NULL and n.PURGE_DT IS NULL 
			      and n.SEQUENCE_NO = @NoticeSequence 
			      and n.TYPE_CD = @NoticeType		
		  
		          if EXISTS( Select 1 from @tmpNotice where CNT > 1)
			         BEGIN
			            SELECT @prevNoticeId = (SELECT MAX(n.ID) as ID 
					      from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
					      join @tmpNotice t ON t.EXPECTED_ISSUE_DT  = n.EXPECTED_ISSUE_DT
					      where nr.REQUIRED_COVERAGE_ID = @rcId 
					      and nr.PURGE_DT IS NULL 
					      and n.PURGE_DT IS NULL 
					      and n.SEQUENCE_NO = @NoticeSequence 
					      and n.TYPE_CD = @NoticeType ) 
				      END  
			       ELSE
			         BEGIN
			           SELECT @prevNoticeId = n.ID
						   from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
					      join @tmpNotice t ON t.EXPECTED_ISSUE_DT  = n.EXPECTED_ISSUE_DT
					      where nr.REQUIRED_COVERAGE_ID = @rcId 
					      and nr.PURGE_DT IS NULL 
					      and n.PURGE_DT IS NULL 
					      and n.SEQUENCE_NO = @NoticeSequence 
					      and n.TYPE_CD = @NoticeType	
			         END		  		   
		   
		      if ISNULL(@prevNoticeId,0) = 0 
		        BEGIN
		          Declare @tmpNotice_Others as TABLE
			      (
			        EXPECTED_ISSUE_DT datetime2,
			        CNT int
			      )
			   
			      INSERT INTO @tmpNotice_Others
			      select MAX(n.EXPECTED_ISSUE_DT) as EXPECTED_ISSUE_DT , COUNT(*) as CNT
			      from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
			      where nr.REQUIRED_COVERAGE_ID = @rcId 
			      and nr.PURGE_DT IS NULL and n.PURGE_DT IS NULL 
			      and n.TYPE_CD not in ('BI','PI','CCU','CCF','PCF','CA','AN')
		  
		          if EXISTS( Select 1 from @tmpNotice_Others where CNT > 1)
			         BEGIN
			            SELECT @prevNoticeId = (SELECT MAX(n.ID) as ID 
					      from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
					      join @tmpNotice_Others t ON t.EXPECTED_ISSUE_DT  = n.EXPECTED_ISSUE_DT
					      where nr.REQUIRED_COVERAGE_ID = @rcId 
					      and nr.PURGE_DT IS NULL 
					      and n.PURGE_DT IS NULL )		
					   
					    SELECT @NoticeSequence = SEQUENCE_NO , @NoticeType = TYPE_CD from NOTICE
					    where ID = @prevNoticeId			   
				      END  
			       ELSE
			         BEGIN
			           SELECT @prevNoticeId = n.ID , @NoticeSequence = n.SEQUENCE_NO , @NoticeType = n.TYPE_CD
						   from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
					      join @tmpNotice_Others t ON t.EXPECTED_ISSUE_DT  = n.EXPECTED_ISSUE_DT
					      where nr.REQUIRED_COVERAGE_ID = @rcId 
					      and nr.PURGE_DT IS NULL 
					      and n.PURGE_DT IS NULL
			         END
		         END		 		    
		   
			      SELECT @cpiQuoteId = n.CPI_QUOTE_ID , @prevNoticeDt = n.EXPECTED_ISSUE_DT  
			      from NOTICE n (NOLOCK) JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr (NOLOCK) ON nr.NOTICE_ID = n.ID 
			      where nr.REQUIRED_COVERAGE_ID = @rcId 
			      and nr.PURGE_DT IS NULL and n.PURGE_DT IS NULL 
			      and n.SEQUENCE_NO = @NoticeSequence 
			      and n.TYPE_CD = @NoticeType 
			      and n.ID = @prevNoticeId
			   
			      if ISNULL(@cpiQuoteId,0) > 0
			        BEGIN
			          Select @exposureDt = START_DT from CPI_ACTIVITY where CPI_QUOTE_ID = @cpiQuoteId
			        END
			   
		     END  
	   
	      UPDATE REQUIRED_COVERAGE set NOTICE_DT = @prevNoticeDt, NOTICE_SEQ_NO = @NoticeSequence , NOTICE_TYPE_CD = @NoticeType,
	      EXPOSURE_DT = CASE When @exposureDt is not NULL Then @exposureDt else EXPOSURE_DT END , 	   
	      CPI_QUOTE_ID = @cpiQuoteId , LAST_EVENT_DT = NULL , LAST_EVENT_SEQ_ID = NULL , 
	      LAST_SEQ_CONTAINER_ID = NULL , GOOD_THRU_DT = NULL
	      where ID = @rcId

	 END
    
END

