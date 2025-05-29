USE UniTrac

--Query to Force Complete all the Verify Data WIs

UPDATE wi
     SET STATUS_CD = 'Complete', update_dt = GETDATE(), update_user_tx = 'CompleteVD'
   --  SELECT COUNT(*) 
	 FROM WORK_ITEM wi 
     WHERE wi.WORKFLOW_DEFINITION_ID = 8
     AND wi.STATUS_CD NOT IN ('complete', 'withdrawn', 'error')
     AND wi.PURGE_DT is NULL
    --72005 

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
		RETRY_COUNT_NO = '2', STATUS_CD = 'Error'
--SELECT * FROM dbo.REPORT_HISTORY
WHERE STATUS_CD = 'PEND'



---We need to clear the KeyImage work item data that came over from Production. Apply the script below:
UPDATE  UniTrac..WORK_ITEM
SET     PURGE_DT = GETDATE()
--SELECT * FROM UniTrac..WORK_ITEM
WHERE   WORKFLOW_DEFINITION_ID = ( SELECT   ID
                                   FROM     WORKFLOW_DEFINITION
                                   WHERE    NAME_TX = 'KeyImage'  )

     AND STATUS_CD NOT IN ('complete', 'withdrawn', 'error')

