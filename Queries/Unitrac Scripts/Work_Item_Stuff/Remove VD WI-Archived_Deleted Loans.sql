IF OBJECT_ID(N'tempdb..#TMPWI',N'U') IS NOT NULL
       DROP TABLE #TMPWI 

--- DROP TABLE #TMPWI
SELECT WI.ID AS WI_ID , WI.RELATE_ID , WI.STATUS_CD , WI.CREATE_DT ,
WI.CURRENT_QUEUE_ID , WI.CURRENT_OWNER_ID 
INTO #TMPWI 
 FROM WORK_ITEM WI
JOIN LOAN ON LOAN.ID = WI.RELATE_ID
WHERE LOAN.RECORD_TYPE_CD IN ( 'A' ,  'D' )
AND LOAN.PURGE_DT IS NULL
AND WI.WORKFLOW_DEFINITION_ID = 8
AND WI.PURGE_DT IS NULL
AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
AND WI.STATUS_CD NOT IN ('Complete', 'Withdrawn')


---- check the loans are not cross-coll & primary loan is the other loan
IF OBJECT_ID(N'tempdb..#TMPWI_01',N'U') IS NOT NULL
       DROP TABLE #TMPWI_01 

SELECT DISTINCT LENDER.AGENCY_ID ,  
LENDER.CODE_TX , LENDER.NAME_TX , LENDER.CANCEL_DT , LENDER.TEST_IN , 
WI.* , LOAN.NUMBER_TX , LOAN.RECORD_TYPE_CD
INTO #TMPWI_01
 FROM #TMPWI WI
JOIN LOAN ON LOAN.ID = WI.RELATE_ID
JOIN LENDER ON LENDER.ID = LOAN.LENDER_ID
JOIN COLLATERAL COLL ON COLL.LOAN_ID = LOAN.ID
AND COLL.PURGE_DT IS NULL
--AND COLL.PRIMARY_LOAN_IN = 'Y'
OUTER APPLY 
(
SELECT C1.ID , C1.LOAN_ID FROM COLLATERAL C1
WHERE C1.PROPERTY_ID = COLL.PROPERTY_ID
AND C1.PURGE_DT IS NULL
AND C1.LOAN_ID <> COLL.LOAN_ID
AND C1.PRIMARY_LOAN_IN = 'Y'
) AS COLL1
WHERE LOAN.RECORD_TYPE_CD IN ( 'A' ,  'D' )
AND COLL1.ID IS NULL
AND LOAN.PURGE_DT IS NULL
ORDER BY LENDER.AGENCY_ID , LENDER.CODE_TX , LOAN.RECORD_TYPE_CD


UPDATE WI SET STATUS_CD = 'Withdrawn' , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'BUGXXXXX' , 
LOCK_ID = WI.LOCK_ID % 255 + 1
---- SELECT COUNT(*)
FROM WORK_ITEM WI JOIN #TMPWI_01 TMP ON 
TMP.WI_ID = WI.ID
AND WI.PURGE_DT IS NULL
---- 2387

INSERT INTO WORK_ITEM_ACTION (WORK_ITEM_ID, ACTION_CD, FROM_STATUS_CD, TO_STATUS_CD, CURRENT_QUEUE_ID, 
CURRENT_OWNER_ID, ACTION_NOTE_TX, ACTIVE_IN, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID, ACTION_USER_ID)
SELECT DISTINCT WI_ID , 'Withdraw' , STATUS_CD , 'Withdrawn' , CURRENT_QUEUE_ID , 
CURRENT_OWNER_ID , 'BUGXXXXX' , 'Y' , GETDATE() , GETDATE() , 'BUGXXXXX' , 1 , 1
FROM #TMPWI_01
ORDER BY STATUS_CD



UPDATE LN SET SPECIAL_HANDLING_XML = NULL , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX  = 'BUGXXXXX' , 
LOCK_ID = LN.LOCK_ID % 255 + 1
--- SELECT LN.*
FROM LOAN LN JOIN #TMPWI_01 ON #TMPWI_01.RELATE_ID = LN.ID



