USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[Support_Backoff_PurgeFPC]    Script Date: 12/19/2017 7:27:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DECLARE

	@fpcId as bigint

	select @fpcId = RELATE_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = ''
AND RELATE_TYPE_CD = 'Allied.UniTrac.ForcePlacedCertificate'

BEGIN	
	SET NOCOUNT ON

    Declare @RCId as bigint
	
    -- withdraw cancel pending WI, if created with the FPC's issued
	 SELECT @RCId = REQUIRED_COVERAGE_ID FROM FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE
	 WHERE FPC_ID = @fpcId AND PURGE_DT IS NULL

    IF OBJECT_ID(N'tempdb..#tmpCxlWI',N'U') IS NOT NULL
			   DROP TABLE #tmpCxlWI   

    CREATE TABLE #tmpCxlWI
    (
      WORK_ITEM_ID BIGINT ,
      RC_ID BIGINT ,
      FPC_ID BIGINT
    )

    INSERT INTO #tmpCxlWI
    (
      WORK_ITEM_ID , RC_ID , FPC_ID
    )
    SELECT ID , @RCId , @fpcId
    FROM WORK_ITEM
    WHERE WORKFLOW_DEFINITION_ID = 3
	 AND RELATE_TYPE_CD = 'Allied.Unitrac.RequiredCoverage'
	 AND RELATE_ID = @RCId AND PURGE_DT IS NULL
	 AND STATUS_CD = 'Initial'
	 AND CONTENT_XML.value('(Content/CancelCPIWorkflow/Certificates/Certificate/RelateId/node())[1]', 'bigint') = @fpcId
	 AND CONTENT_XML.value('(Content/CancelCPIWorkflow/Certificates/Certificate/RelateClass/node())[1]', 'varchar(50)') = 'ForcePlacedCertificate' 
	
    -- SET CPI STATUS TO BINDER - STATUS CALC WILL RECALC
    UPDATE RC SET 
    CPI_STATUS_CD = CASE WHEN CPI_STATUS_CD = 'X' THEN 'B' ELSE CPI_STATUS_CD END ,
    SUMMARY_STATUS_CD = CASE WHEN SUMMARY_STATUS_CD = 'X' THEN 'B' ELSE SUMMARY_STATUS_CD END ,
    UPDATE_USER_TX = 'CYCBACKOFF' , UPDATE_DT = GETDATE() ,
    LOCK_ID = (LOCK_ID % 255) + 1
    FROM REQUIRED_COVERAGE RC JOIN #tmpCxlWI TMP ON
    TMP.RC_ID = RC.ID
	 
    UPDATE WORK_ITEM SET STATUS_CD = 'Withdrawn',
	 PURGE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' , 
	 LOCK_ID = (LOCK_ID % 255) + 1 , UPDATE_DT = GETDATE()
	 FROM WORK_ITEM WI JOIN #tmpCxlWI TMP ON TMP.WORK_ITEM_ID = WI.ID

    UPDATE INTERACTION_HISTORY SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'CYCBACKOFF'
     where RELATE_ID = @fpcId and RELATE_CLASS_TX = 'Allied.UniTrac.ForcePlacedCertificate'
     and TYPE_CD = 'CPI'
     
    UPDATE FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'CYCBACKOFF'
	 where FPC_ID = @fpcId AND PURGE_DT IS NULL
	     
	UPDATE FORCE_PLACED_CERTIFICATE SET PURGE_DT = GETDATE() , ACTIVE_IN = 'N',
	CANCELLATION_DT = EFFECTIVE_DT, UPDATE_USER_TX = 'CYCBACKOFF' where ID = @fpcId
	
	EXEC SaveActiveForcePlacedCert @fpcId
	
END

