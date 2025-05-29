USE [UniTrac]
GO


	Declare @rcId as bigint 
	Declare @cpiQuoteId as bigint
	Declare @NoticeType as nvarchar(10)
	Declare @NoticeSequence as int
	Declare @NoticeDt as datetime2
	Declare @prevNoticeDt as datetime2 
	Declare @prevNtcCreateDt as datetime2
	Declare @prevNoticeId as bigint
	Declare @lastEventDt as datetime2
	Declare @lastEventSeqId as bigint
	Declare @lastSeqContainerId as bigint
	Declare @groupId as bigint
	Declare @eeId as BIGINT
    DECLARE @noticeId AS BIGINT
	
	Declare @eventSequenceId as bigint
	Declare @priorNtcEventSeqNo as int
	Declare @priorNtcEventSeqId as bigint
	Declare @priorNtcSeqContainerId as bigint
	Declare @priorOtherEventSeqNo as int
	Declare @priorOtherEventSeqId as bigint
	Declare @priorOtherSeqContainerId as bigint

    Declare @LoanStatus as varchar(3)
	Declare @CollateralStatus as varchar(3)
	Declare @RCStatus as varchar(3)
	Declare @RCSubStatus as varchar(3)
	Declare @RCSummaryStatus as varchar(3)
	Declare @RCSummarySubStatus as varchar(3)
	Declare @CNT as int
	DECLARE @ProcessLogID NVARCHAR(255)


	SET @ProcessLogID = 56710921

	SELECT  
		@NoticeType= n.TYPE_CD , 
		@NoticeSequence = n.SEQUENCE_NO , 
		@NoticeDt = n.EXPECTED_ISSUE_DT ,
		@rcId = nr.REQUIRED_COVERAGE_ID ,
		@groupId = GROUP_ID ,
		@eeId = ee.ID ,
		@eventSequenceId = ISNULL(ee.EVENT_SEQUENCE_ID ,0 )
	from NOTICE n join NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 	
	join EVALUATION_EVENT ee on ee.RELATE_ID = n.ID and ee.RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
		and ee.REQUIRED_COVERAGE_ID = nr.REQUIRED_COVERAGE_ID and ee.TYPE_CD IN ('NTC','AGNO')		
	where n.ID IN (SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM WHERE PROCESS_LOG_ID IN (@ProcessLogID) AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice')

	    	
	UPDATE INTERACTION_HISTORY SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'CYCBACKOFF' ,
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
     where RELATE_ID IN (SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM WHERE PROCESS_LOG_ID IN (@ProcessLogID) AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice')
 and RELATE_CLASS_TX = 'Allied.UniTrac.Notice' and TYPE_CD = 'NOTICE'
     
    UPDATE NOTICE_REQUIRED_COVERAGE_RELATE SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'CYCBACKOFF' ,
    UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 where NOTICE_ID IN (SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM WHERE PROCESS_LOG_ID IN (@ProcessLogID) AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice')

     
	UPDATE NOTICE SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'CYCBACKOFF' , 
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 where ID IN (SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM WHERE PROCESS_LOG_ID IN (@ProcessLogID) AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice')

		
	UPDATE EVALUATION_EVENT set STATUS_CD = 'NOTU', PURGE_DT = GETDATE(), UPDATE_USER_TX = 'CYCBACKOFF',
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
	where REQUIRED_COVERAGE_ID = @rcId and STATUS_CD = 'PEND'
   AND EVENT_SEQUENCE_ID IS NOT NULL
	
	UPDATE DOCUMENT_CONTAINER SET PURGE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF',
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
	WHERE RELATE_ID IN (SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM WHERE PROCESS_LOG_ID IN (@ProcessLogID) AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice')
 AND RELATE_CLASS_NAME_TX = 'ALLIED.UNITRAC.NOTICE'
	
	IF @NoticeType IN ('CCU','CCF','BI')
		BEGIN
	      UPDATE EVALUATION_EVENT SET STATUS_CD = 'PEND' , UPDATE_USER_TX = 'CYCBACKOFF' , 
	      UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1	
	      WHERE ID = @eeId
		END	
    
    if (@NoticeSequence = 1)
		BEGIN
		  --- check if still in the same seq & ntc type
		  UPDATE REQUIRED_COVERAGE set NOTICE_DT = NULL , NOTICE_SEQ_NO = NULL , NOTICE_TYPE_CD = NULL,
		  CPI_QUOTE_ID = NULL , LAST_EVENT_DT = NULL , LAST_EVENT_SEQ_ID = NULL , LAST_SEQ_CONTAINER_ID = NULL ,
		  GOOD_THRU_DT = NULL , UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 , UPDATE_USER_TX = 'CYCBACKOFF'
		  where ID = @rcId and NOTICE_SEQ_NO = @NoticeSequence and NOTICE_TYPE_CD = @NoticeType       
		   ---and  NOTICE_DT = @NoticeDt   
		   
		  UPDATE IH SET PURGE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' , 
		  UPDATE_DT = GETDATE() , LOCK_ID = (IH.LOCK_ID % 255) + 1		
		  FROM INTERACTION_HISTORY IH  
		  JOIN NOTICE NTC ON NTC.CPI_QUOTE_ID = IH.RELATE_ID 		  
		  WHERE IH.RELATE_CLASS_TX = 'Allied.Unitrac.CPIQuote'
		  AND IH.TYPE_CD = 'CPI'		 
		  AND NTC.ID IN (SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM WHERE PROCESS_LOG_ID IN (@ProcessLogID) AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice')

		END
    else
		BEGIN
         IF OBJECT_ID(N'tempdb..#tmpNTC',N'U') IS NOT NULL
			   DROP TABLE #tmpNTC    
    
          SET @CNT = 0

          --- REPEAT DOES NOT 
          IF NOT EXISTS (SELECT ID FROM EVALUATION_EVENT WHERE ID = @eeId
	          AND ALTERNATE_XML.value('(/ALTERNATE_XML/HISTORY_LOG)[1]', 'varchar(4000)')  like 'Repeat event%')
                BEGIN
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
	                  ) OR -- summary status can be different - In-force to Expired 
			            (STATUSCD = 'RCSummarySubStatus' AND ISNULL(STATUSVALUE,'') <> ISNULL(@RCSummarySubStatus,''))
			           )	
               END

         --- set to previous notice only if the status matches
			If @CNT = 0	
          BEGIN
		      SELECT  @prevNoticeId = ee.RELATE_ID ,  
				      @lastEventDt = ee.EVENT_DT , 
				      @lastEventSeqId = ee.EVENT_SEQUENCE_ID ,
				      @lastSeqContainerId = es.EVENT_SEQ_CONTAINER_ID 
		      from EVALUATION_EVENT ee join EVENT_SEQUENCE es  ON
		      es.ID = ee.EVENT_SEQUENCE_ID where GROUP_ID = @groupId and es.NOTICE_SEQ_NO = (@NoticeSequence - 1)
		      and es.NOTICE_TYPE_CD = @NoticeType and es.EVENT_TYPE_CD = 'NTC' and ee.TYPE_CD = 'NTC' 
		      and ee.REQUIRED_COVERAGE_ID = @rcId and ee.STATUS_CD = 'COMP' 
         		   
		      --- if not found in the same group, due to prev cycle backoff
		      if @@ROWCOUNT = 0
		          SELECT TOP 1 @prevNoticeId = ee.RELATE_ID ,  
							   @lastEventDt = ee.EVENT_DT , 
							   @lastEventSeqId = ee.EVENT_SEQUENCE_ID ,
							   @lastSeqContainerId = es.EVENT_SEQ_CONTAINER_ID 
			      from EVALUATION_EVENT ee join EVENT_SEQUENCE es ON es.ID = ee.EVENT_SEQUENCE_ID 
			      where es.NOTICE_SEQ_NO = (@NoticeSequence - 1) and es.NOTICE_TYPE_CD = @NoticeType 
			      and es.EVENT_TYPE_CD = 'NTC' and ee.TYPE_CD = 'NTC' 
			      and ee.REQUIRED_COVERAGE_ID = @rcId and ee.STATUS_CD = 'COMP' ORDER BY ee.EVENT_DT desc
	    
		      set @cpiQuoteId = NULL
	       
		      if ISNULL(@prevNoticeId,0) > 0
			     BEGIN
			      SELECT @cpiQuoteId = n.CPI_QUOTE_ID , @prevNoticeDt = n.EXPECTED_ISSUE_DT  
			      from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
			      where nr.REQUIRED_COVERAGE_ID = @rcId 
			      and nr.PURGE_DT IS NULL 
			      and n.PURGE_DT IS NULL 
			      and n.SEQUENCE_NO = (@NoticeSequence - 1)
			      and n.TYPE_CD = @NoticeType  
			      and n.ID = @prevNoticeId
			     END
		      else
			     BEGIN			  
			      Declare @tmpNotice as TABLE
			      (
			        EXPECTED_ISSUE_DT datetime2,
			        CNT int
			      )
			      
			      ---- check if previous seq type is AOBCL etc. and not Ntc.
			      SET @priorNtcEventSeqNo = 0
			      SET @priorOtherEventSeqNo = 0
			      SELECT 
					  @priorNtcEventSeqNo = ISNULL(PREVNTCEVT.NOTICE_SEQ_NO , 0) , 
					  @priorNtcEventSeqId = PREVNTCEVT.ID , 
					  @priorNtcSeqContainerId = PREVNTCEVT.EVENT_SEQ_CONTAINER_ID ,
					  @priorOtherEventSeqNo = ISNULL(PREVOTHEVT.NOTICE_SEQ_NO , 0) , 
					  @priorOtherEventSeqId = PREVOTHEVT.ID , 
					  @priorOtherSeqContainerId = PREVOTHEVT.EVENT_SEQ_CONTAINER_ID 
					  FROM EVENT_SEQUENCE ES 					  
					  OUTER APPLY
					  (
					    SELECT TOP 1 
					     ES2.NOTICE_SEQ_NO , ES2.ID, ES2.EVENT_SEQ_CONTAINER_ID
					    FROM EVENT_SEQUENCE ES2 
					    WHERE ES2.EVENT_SEQ_CONTAINER_ID = es.EVENT_SEQ_CONTAINER_ID
					    AND ES2.PURGE_DT IS NULL
					    AND ISNULL(ES2.NOTICE_SEQ_NO ,0 ) > 0
					    AND ES2.NOTICE_SEQ_NO < @NoticeSequence
					    AND ES2.EVENT_TYPE_CD <> 'NTC' 
					    ORDER BY ES2.NOTICE_SEQ_NO desc
					  ) AS PREVOTHEVT
					  OUTER APPLY
					  (
					    SELECT TOP 1 
					     ES1.NOTICE_SEQ_NO , ES1.ID, ES1.EVENT_SEQ_CONTAINER_ID
					    FROM EVENT_SEQUENCE ES1 
					    WHERE ES1.EVENT_SEQ_CONTAINER_ID = es.EVENT_SEQ_CONTAINER_ID
					    AND ES1.PURGE_DT IS NULL
					    AND ISNULL(ES1.NOTICE_SEQ_NO ,0 ) > 0
					    AND ES1.NOTICE_TYPE_CD = @NoticeType
					    AND ES1.NOTICE_SEQ_NO < @NoticeSequence
					    AND ES1.EVENT_TYPE_CD = 'NTC' 
					    ORDER BY ES1.NOTICE_SEQ_NO desc
					  ) AS PREVNTCEVT
					  WHERE ES.ID = @eventSequenceId
					  AND ES.PURGE_DT IS NULL					   
					  
			      			      
			      if (@priorOtherEventSeqNo = 1 and @priorOtherEventSeqNo = @NoticeSequence - 1)
			      Begin			        
			           --- since it is not Ntc., clear notice fields
			         UPDATE REQUIRED_COVERAGE set NOTICE_DT = NULL, NOTICE_SEQ_NO = NULL ,
					   CPI_QUOTE_ID = NULL , LAST_EVENT_DT = NULL , LAST_EVENT_SEQ_ID = @priorOtherEventSeqId , 
					   LAST_SEQ_CONTAINER_ID = @priorOtherSeqContainerId , GOOD_THRU_DT = NULL ,
					   UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 , UPDATE_USER_TX = 'CYCBACKOFF'
					   where ID = @rcId and NOTICE_SEQ_NO = @NoticeSequence and NOTICE_TYPE_CD = @NoticeType 
			      End
			   
			      if (@priorNtcEventSeqNo = @NoticeSequence - 1 or 
			          (@priorOtherEventSeqNo > 1 and @priorOtherEventSeqNo = @NoticeSequence - 1
                    AND @priorNtcEventSeqNo < @priorOtherEventSeqNo))
			      BEGIN
					  INSERT INTO @tmpNotice
					  select MAX(n.EXPECTED_ISSUE_DT) as EXPECTED_ISSUE_DT , COUNT(*) as CNT
					  from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
					  where nr.REQUIRED_COVERAGE_ID = @rcId 
					  and nr.PURGE_DT IS NULL 
					  and n.PURGE_DT IS NULL 
					  and n.SEQUENCE_NO = @priorNtcEventSeqNo
					  and n.TYPE_CD = @NoticeType
				   
					  if EXISTS( Select 1 from @tmpNotice where CNT > 1)
						 BEGIN
							SELECT @prevNoticeId = (SELECT MAX(n.ID) as ID 
							  from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
							  join @tmpNotice t ON t.EXPECTED_ISSUE_DT  = n.EXPECTED_ISSUE_DT
							  where nr.REQUIRED_COVERAGE_ID = @rcId 
							  and nr.PURGE_DT IS NULL 
							  and n.PURGE_DT IS NULL 
							  and n.SEQUENCE_NO = @priorNtcEventSeqNo
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
							  and n.SEQUENCE_NO = @priorNtcEventSeqNo
							  and n.TYPE_CD = @NoticeType	
						 END
				 			   
					  SELECT @cpiQuoteId = n.CPI_QUOTE_ID , @prevNoticeDt = n.EXPECTED_ISSUE_DT  
					  from NOTICE n JOIN NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 
					  where nr.REQUIRED_COVERAGE_ID = @rcId 
					  and nr.PURGE_DT IS NULL 
					  and n.PURGE_DT IS NULL 
					  and n.SEQUENCE_NO = @priorNtcEventSeqNo
					  and n.TYPE_CD = @NoticeType 
					  and n.ID = @prevNoticeId
					 
			       END 
			    END       
	          
	          if (@priorOtherEventSeqNo > 0 and @priorOtherEventSeqNo = @NoticeSequence - 1 and @priorNtcEventSeqNo > 0)  
	            BEGIN
	              UPDATE REQUIRED_COVERAGE set NOTICE_DT = @prevNoticeDt, NOTICE_SEQ_NO = @priorNtcEventSeqNo ,
				  CPI_QUOTE_ID = @cpiQuoteId , LAST_EVENT_DT = NULL , LAST_EVENT_SEQ_ID = @priorOtherEventSeqId , 
				  LAST_SEQ_CONTAINER_ID = @priorOtherSeqContainerId , GOOD_THRU_DT = NULL ,
				  UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 , UPDATE_USER_TX = 'CYCBACKOFF'
				  where ID = @rcId and NOTICE_SEQ_NO = @NoticeSequence and NOTICE_TYPE_CD = @NoticeType 
				END  
		      ELSE IF (ISNULL(@prevNoticeId,0) > 0)
		        BEGIN
				  UPDATE REQUIRED_COVERAGE set NOTICE_DT = @prevNoticeDt, NOTICE_SEQ_NO = (@NoticeSequence - 1) ,
				  CPI_QUOTE_ID = @cpiQuoteId , LAST_EVENT_DT = NULL , LAST_EVENT_SEQ_ID = NULL , 
				  LAST_SEQ_CONTAINER_ID = NULL , GOOD_THRU_DT = NULL ,
				  UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 , UPDATE_USER_TX = 'CYCBACKOFF'
				  where ID = @rcId and NOTICE_SEQ_NO = @NoticeSequence and NOTICE_TYPE_CD = @NoticeType       
				  ---and  NOTICE_DT = @NoticeDt
				END
				
		      IF ISNULL(@cpiQuoteId, 0) = 0
		        BEGIN
	              UPDATE IH SET PURGE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' , 
		          UPDATE_DT = GETDATE() , LOCK_ID = (IH.LOCK_ID % 255) + 1		
		          FROM INTERACTION_HISTORY IH  
		          JOIN NOTICE NTC ON NTC.CPI_QUOTE_ID = IH.RELATE_ID 		  
		          WHERE IH.RELATE_CLASS_TX = 'Allied.Unitrac.CPIQuote'
		          AND IH.TYPE_CD = 'CPI'		 
		          AND NTC.ID IN (SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM WHERE PROCESS_LOG_ID IN (@ProcessLogID) AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice')

	            END 
	            
          END
		END    


--------Use workitem to get the ProcessLogID/Relate ID--------


/*SELECT * FROM
WORK_ITEM 
WHERE ID = 44207406*/