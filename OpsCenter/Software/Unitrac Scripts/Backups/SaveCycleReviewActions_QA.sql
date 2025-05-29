USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[SaveCycleReviewActions]    Script Date: 3/8/2016 3:00:25 PM ******/
DROP PROCEDURE [dbo].[SaveCycleReviewActions]
GO

/****** Object:  StoredProcedure [dbo].[SaveCycleReviewActions]    Script Date: 3/8/2016 3:00:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SaveCycleReviewActions](
      @PROCESS_LOG_ID bigint,
      @WORK_ITEM_ID bigint,
      @EVENTS_XML xml = null,  	     
      @UPDATE_USER_TX nvarchar(15)
)
AS
BEGIN
   SET NOCOUNT ON

    BEGIN TRY
		
		DECLARE @rowCount int
		DECLARE @applyAllXML xml
		DECLARE @printStatus varchar(20)
		DECLARE @rejectReason varchar(20)
	
		CREATE TABLE #TMP 
		( 
			RelateId BIGINT,
			ProcessLogItemId BIGINT,
			TypeCode VARCHAR(5),
			UserAction VARCHAR(50),
			UserActionXML XML,
			ReviewStatus VARCHAR(50)
		)		
						
		INSERT INTO #TMP(RelateID, ProcessLogItemId, TypeCode, UserAction, UserActionXML, ReviewStatus)
		SELECT p.n.value('(RelateId/text())[1]','bigint') AS RelateId,		
			p.n.value('(ProcessLogItemId/text())[1]','bigint') AS ProcessLogItemId,
			p.n.value('(TypeCode/text())[1]','varchar(5)') AS TypeCode,
			p.n.value('(UserAction/text())[1]','varchar(50)') AS UserAction,
			'<USER_ACTION>' + p.n.value('(UserAction/text())[1]','varchar(50)') + '</USER_ACTION>',
			p.n.value('(UserAction/text())[1]','varchar(50)') AS ReviewStatus
			FROM  @EVENTS_XML.nodes('CycleReviewEventList/CycleReviewEvent') AS p(n)
		
		--Update AgentNotification/Notice/Cert for Approve Status
		UPDATE DOCUMENT_CONTAINER
		SET PRINT_STATUS_CD = 'PEND',
			REJECT_REASON_TX = NULL,
			PRINT_STATUS_ASSIGNED_USER_TX = @UPDATE_USER_TX,
			PRINT_STATUS_ASSIGNED_DT = getdate(),
			UPDATE_USER_TX = @UPDATE_USER_TX,
			UPDATE_DT = getdate(),
			LOCK_ID = DC.LOCK_ID + 1
		FROM DOCUMENT_CONTAINER DC
			JOIN #TMP EVT ON EVT.RelateId = DC.RELATE_ID
					AND	EVT.TypeCode IN ('AGNO','NTC', 'ISCT')			
		WHERE 
		((EVT.TypeCode IN ('NTC','AGNO') and DC.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice')
		OR
		(EVT.TypeCode = 'ISCT' and DC.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.ForcePlacedCertificate'))
		AND EVT.UserAction = 'Approve'
		AND (DC.PRINT_STATUS_CD = 'UNRES' OR DC.PRINT_STATUS_CD IS NULL)
		AND DC.RECIPIENT_TYPE_CD <> 'LNDR'
		AND DC.PURGE_DT IS NULL

      --Update Notice Interaction for Email/Fax	to set the NoticeIsApproved flag to true for all agent notification event is approved	
		UPDATE INTERACTION_HISTORY 
		SET SPECIAL_HANDLING_XML.modify('replace value of (/SH/NoticeIsApproved/text())[1] with "true"'),
			UPDATE_USER_TX = @UPDATE_USER_TX,
			UPDATE_DT = getdate(),
			LOCK_ID = IH.LOCK_ID + 1
		FROM INTERACTION_HISTORY IH
         JOIN NOTICE NTC ON NTC.ID = IH.RELATE_ID AND  RELATE_CLASS_TX = 'Allied.UniTrac.Notice'
			JOIN #TMP EVT ON EVT.RelateId = NTC.ID AND EVT.TypeCode = 'AGNO' 
         JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = EVT.ProcessLogItemId AND PLI.INFO_XML.value('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(5)') IN ('EMAIL','FAX')
      WHERE 
         EVT.UserAction = 'Approve'      
		   
		--Update Notice/Cert for Not Approve Status
		UPDATE DOCUMENT_CONTAINER
		SET PRINT_STATUS_CD = 'EXCLUDE',
			REJECT_REASON_TX = EVT.UserAction,
			PRINT_STATUS_ASSIGNED_USER_TX = @UPDATE_USER_TX,
			PRINT_STATUS_ASSIGNED_DT = getdate(),
			UPDATE_USER_TX = @UPDATE_USER_TX,
			UPDATE_DT = getdate(),
			LOCK_ID = DC.LOCK_ID + 1
		FROM DOCUMENT_CONTAINER DC
			JOIN #TMP EVT ON EVT.RelateId = DC.RELATE_ID
					AND	EVT.TypeCode IN ('NTC', 'ISCT')			
		WHERE 
		((EVT.TypeCode = 'NTC' and DC.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice')
		OR
		(EVT.TypeCode = 'ISCT' and DC.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.ForcePlacedCertificate'))
		AND EVT.UserAction <> 'Approve'
		AND (DC.PRINT_STATUS_CD = 'UNRES' OR DC.PRINT_STATUS_CD IS NULL)
		AND DC.RECIPIENT_TYPE_CD <> 'LNDR'
		AND DC.PURGE_DT IS NULL
		
		--Update Cert for Lender Copy
		UPDATE DOCUMENT_CONTAINER
		SET PRINT_STATUS_CD = 'PEND',
			REJECT_REASON_TX = NULL,
			PRINT_STATUS_ASSIGNED_USER_TX = @UPDATE_USER_TX,
			PRINT_STATUS_ASSIGNED_DT = getdate(),
			UPDATE_USER_TX = @UPDATE_USER_TX,
			UPDATE_DT = getdate(),
			LOCK_ID = DC.LOCK_ID + 1
		FROM DOCUMENT_CONTAINER DC
			JOIN #TMP EVT ON EVT.RelateId = DC.RELATE_ID
					AND	EVT.TypeCode = 'ISCT'			
		WHERE DC.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.ForcePlacedCertificate'
		AND DC.RECIPIENT_TYPE_CD = 'LNDR'
		AND (DC.PRINT_STATUS_CD = 'UNRES' OR DC.PRINT_STATUS_CD IS NULL)
		AND DC.PURGE_DT IS NULL		
		
		--Update Cert for Release For Billing
		UPDATE FORCE_PLACED_CERTIFICATE
		SET BILLING_STATUS_CD = 'PEND',
			UPDATE_USER_TX = @UPDATE_USER_TX,
			UPDATE_DT = getdate(),
			LOCK_ID = FPC.LOCK_ID + 1
		FROM FORCE_PLACED_CERTIFICATE FPC
			JOIN #TMP EVT ON EVT.RelateId = FPC.ID
					AND	EVT.TypeCode = 'RLBI'			
		WHERE EVT.UserAction <> 'Approve'		

      --Update OBC		
		UPDATE INTERACTION_HISTORY 
		SET SPECIAL_HANDLING_XML.modify('replace value of (/SH/ReviewStatus/text())[1] with sql:column("EVT.ReviewStatus")'),
			UPDATE_USER_TX = @UPDATE_USER_TX,
			UPDATE_DT = getdate(),
			LOCK_ID = IH.LOCK_ID + 1
		FROM INTERACTION_HISTORY IH
			JOIN WORK_ITEM WI ON WI.RELATE_ID = IH.ID AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.OutboundCallInteraction'
			JOIN #TMP EVT ON EVT.RelateId = WI.ID AND EVT.TypeCode = 'OBCL'			

		
		--Update ProcessLogItem with UserAction
		UPDATE PROCESS_LOG_ITEM
		SET INFO_XML.modify('insert sql:column("EVT.UserActionXML") as last into (/INFO_LOG)[1]')
		, UPDATE_USER_TX = @UPDATE_USER_TX
		, UPDATE_DT = getdate()
		, LOCK_ID = PLI.LOCK_ID + 1
		FROM PROCESS_LOG_ITEM PLI
			JOIN #TMP EVT ON EVT.ProcessLogItemId = PLI.ID	
		WHERE PLI.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(100)') IS NULL								
		
		SET @rowCount = @@rowcount
		
		DROP TABLE #TMP
				
        SELECT 'SUCCESS' AS RESULT, @rowCount
        
    END TRY
    BEGIN CATCH
        SELECT 
        'ERROR' AS RESULT, 		
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() as ErrorState,
		ERROR_PROCEDURE() as ErrorProcedure,
		ERROR_LINE() as ErrorLine,
		ERROR_MESSAGE() as ErrorMessage;
    END CATCH        
    
END

GO

