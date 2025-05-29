USE UniTrac

--Query to Force Complete all the Verify Data WIs

UPDATE wi
     SET STATUS_CD = 'Complete', update_dt = GETDATE(), update_user_tx = 'CompleteVD'
   --  SELECT COUNT(*) 
	 FROM WORK_ITEM wi 
     WHERE wi.WORKFLOW_DEFINITION_ID = 8
     AND wi.STATUS_CD NOT IN ('complete', 'withdrawn', 'error')
     AND wi.PURGE_DT is NULL
    --46134 

--Update Event Option Balance_Staging Refresh
	  update bo
     set DEFAULT_VALUE_TX = '999', UPDATE_DT = getdate(), update_user_tx = 'TestingDB'
      --  SELECT COUNT(*) 
	 from lender ldr 
     join LENDER_PRODUCT lp on lp.LENDER_ID = ldr.id and lp.PURGE_DT is null
     join BUSINESS_OPTION_GROUP bog on bog.RELATE_ID = lp.id and bog.RELATE_CLASS_NM = 'Allied.UniTrac.LenderProduct'
     join BUSINESS_OPTION bo on bo.BUSINESS_OPTION_GROUP_ID = bog.id and bo.NAME_TX = 'EventOptionBalance'
	 --8238


	 UPDATE wi
     SET STATUS_CD = 'Complete', update_dt = GETDATE(), update_user_tx = 'CompleteVD'
   --  SELECT COUNT(*) 
	 FROM WORK_ITEM wi 
     WHERE wi.WORKFLOW_DEFINITION_ID = 1
     AND wi.STATUS_CD NOT IN ('complete', 'withdrawn', 'error')
     AND wi.PURGE_DT is NULL