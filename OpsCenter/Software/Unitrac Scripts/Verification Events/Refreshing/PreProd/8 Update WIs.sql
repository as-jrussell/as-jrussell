USE UniTrac

--Query to Force Complete all the Verify Data WIs


-------------------------
---REMOVED Verify Data WI purging for training environment usage
-------------------------


--Update Event Option Balance_Staging Refresh
	  update bo
     set DEFAULT_VALUE_TX = '999', UPDATE_DT = getdate(), update_user_tx = 'TestingDB'
      --  SELECT DEFAULT_VALUE_TX,* --COUNT(*) 
	 from lender ldr 
     join LENDER_PRODUCT lp on lp.LENDER_ID = ldr.id and lp.PURGE_DT is null
     join BUSINESS_OPTION_GROUP bog on bog.RELATE_ID = lp.id and bog.RELATE_CLASS_NM = 'Allied.UniTrac.LenderProduct'
     join BUSINESS_OPTION bo on bo.BUSINESS_OPTION_GROUP_ID = bog.id and bo.NAME_TX = 'EventOptionBalance'
	 --7515


---Remove Work Items Messages

UPDATE dbo.WORK_ITEM
SET STATUS_CD = 'Withdrawn', 
UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'Unitrac', 
LOCK_ID = LOCK_ID+1
--SELECT * FROM dbo.WORK_ITEM
WHERE STATUS_CD = 'Approve'
AND WORKFLOW_DEFINITION_ID = '1'




--Remove Reports out of queue
USE UniTrac
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET    PURGE_DT = GETDATE(),
		UPDATE_USER_TX = 'Unitrac',
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE(), 
		LOCK_ID = LOCK_ID+1,
		RETRY_COUNT_NO = '2'
--SELECT PURGE_DT, RETRY_COUNT_NO, * FROM dbo.REPORT_HISTORY
WHERE STATUS_CD = 'PEND'

-------------------------
---REMOVED KeyImageWI purging for training environment usage
-------------------------


	 UPDATE M
SET PURGE_DT = GETDATE(), 
PROCESSED_IN = 'Y'
--SELECT COUNT(*) 
FROM dbo.MESSAGE M
WHERE PROCESSED_IN  = 'N'
AND PURGE_DT IS NULL

