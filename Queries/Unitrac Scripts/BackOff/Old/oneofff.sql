USE [UniTrac]
GO

DECLARE @ProcessLogID NVARCHAR(255)

	select @ProcessLogID = RELATE_ID FROM dbo.WORK_ITEM
	WHERE ID IN (42455431, 42487970, 42484409, 42512517)

	UPDATE EE set EE.STATUS_CD = 'CLR', 
	EE.PURGE_DT = GETDATE(), EE.UPDATE_USER_TX = 'CYCBACKOFF',
	EE.UPDATE_DT = GETDATE() , EE.LOCK_ID = (EE.LOCK_ID % 255) + 1
	--SELECT EE.* 
	FROM dbo.EVALUATION_EVENT EE 
	JOIN dbo.PROCESS_LOG_ITEM PLI ON PLI.RELATE_ID = EE.REQUIRED_COVERAGE_ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.RequiredCoverage'
	WHERE PLI.PROCESS_LOG_ID IN (@ProcessLogID) AND EE.STATUS_CD = 'PEND'
    AND EVENT_SEQUENCE_ID IS NOT NULL

   UPDATE EE SET LAST_EVENT_DT = NULL , 
    LAST_EVENT_SEQ_ID = NULL , LAST_SEQ_CONTAINER_ID = NULL ,
    EE.UPDATE_USER_TX = 'CYCBACKOFF', EE.UPDATE_DT = GETDATE() , 
    EE.LOCK_ID = (EE.LOCK_ID % 255) + 1
	--SELECT EE.* 
	FROM dbo.REQUIRED_COVERAGE EE 
	JOIN dbo.PROCESS_LOG_ITEM PLI ON PLI.RELATE_ID = EE.ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.RequiredCoverage'
	WHERE PLI.PROCESS_LOG_ID IN (@ProcessLogID)