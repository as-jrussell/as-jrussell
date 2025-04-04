IF OBJECT_ID(N'tempdb..#TMPLP',N'U') IS NOT NULL
       DROP TABLE #TMPLP

---- ORDERUP - REPLACE MM/DD/YY WITH DATE
--- DROP TABLE #TMPLP
SELECT DISTINCT LENDER.AGENCY_ID ,  LENDER.CODE_TX , LENDER.NAME_TX , LENDER.CANCEL_DT , 
RC.LENDER_PRODUCT_ID , RC.ID AS RC_ID , 
LP.NAME_TX AS LP_NAME_TX , LP.DESCRIPTION_TX AS LP_DESCRIPTION_TX , 
RC.TYPE_CD , LP.BASIC_TYPE_CD , LP.BASIC_SUB_TYPE_CD , 
LOAN.LENDER_ID , LOAN.ID AS LOAN_ID , LOAN.NUMBER_TX , 
WI.ID AS WI_ID , WI.CREATE_DT , WI.STATUS_CD ,
WI.CURRENT_QUEUE_ID , WI.CURRENT_OWNER_ID 
INTO #TMPLP
--- SELECT COUNT(*)
FROM LOAN JOIN LENDER ON LENDER.ID = LOAN.LENDER_ID
JOIN WORK_ITEM WI ON WI.RELATE_ID = LOAN.ID
AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
AND WI.STATUS_CD NOT IN ('Complete', 'Withdrawn')
JOIN COLLATERAL COLL ON COLL.LOAN_ID = LOAN.ID
AND COLL.PURGE_DT IS NULL
JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = COLL.PROPERTY_ID
AND RC.PURGE_DT IS NULL
JOIN LENDER_PRODUCT LP ON LP.ID = RC.LENDER_PRODUCT_ID
AND LP.PURGE_DT IS NULL
WHERE WI.WORKFLOW_DEFINITION_ID = 8
AND WI.PURGE_DT IS NULL
AND LENDER.PURGE_DT IS NULL
--AND LENDER.TEST_IN = 'N'
AND LENDER.CANCEL_DT IS NULL
AND WI.CREATE_DT < 'mm/dd/yy'
AND LP.BASIC_TYPE_CD = 'ORDERUP'
ORDER BY LENDER.CODE_TX , WI.CREATE_DT

---- TRK ONLY/WITHOUT NTC - REPLACE MM/DD/YY WITH DATE
INSERT INTO #TMPLP
SELECT DISTINCT LENDER.AGENCY_ID ,  LENDER.CODE_TX , LENDER.NAME_TX , LENDER.CANCEL_DT , 
RC.LENDER_PRODUCT_ID , RC.ID AS RC_ID , 
LP.NAME_TX AS LP_NAME_TX , LP.DESCRIPTION_TX AS LP_DESCRIPTION_TX , 
RC.TYPE_CD , LP.BASIC_TYPE_CD , LP.BASIC_SUB_TYPE_CD , 
LOAN.LENDER_ID , LOAN.ID AS LOAN_ID , LOAN.NUMBER_TX , 
WI.ID AS WI_ID , WI.CREATE_DT , WI.STATUS_CD ,
WI.CURRENT_QUEUE_ID , WI.CURRENT_OWNER_ID 
--- SELECT COUNT(*)
FROM LOAN JOIN LENDER ON LENDER.ID = LOAN.LENDER_ID
JOIN WORK_ITEM WI ON WI.RELATE_ID = LOAN.ID
AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
AND WI.STATUS_CD NOT IN ('Complete', 'Withdrawn')
JOIN COLLATERAL COLL ON COLL.LOAN_ID = LOAN.ID
AND COLL.PURGE_DT IS NULL
JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = COLL.PROPERTY_ID
AND RC.PURGE_DT IS NULL
JOIN LENDER_PRODUCT LP ON LP.ID = RC.LENDER_PRODUCT_ID
AND LP.PURGE_DT IS NULL
WHERE WI.WORKFLOW_DEFINITION_ID = 8
AND WI.PURGE_DT IS NULL
AND LENDER.PURGE_DT IS NULL
--AND LENDER.TEST_IN = 'N'
AND LENDER.CANCEL_DT IS NULL
AND WI.CREATE_DT < 'MM/DD/YY'
AND LP.BASIC_TYPE_CD = 'TRKONLY'
AND LP.BASIC_SUB_TYPE_CD = 'WONTC'
ORDER BY LENDER.CODE_TX , WI.CREATE_DT


---- GET OTHER RC'S FOR THE GIVEN LOAN
SELECT DISTINCT RC.ID AS RC_ID , RC.PROPERTY_ID
INTO #TMPRC
FROM #TMPLP VD
JOIN COLLATERAL COLL ON COLL.LOAN_ID = VD.LOAN_ID
AND COLL.PURGE_DT IS NULL
JOIN PROPERTY PR ON PR.ID = COLL.PROPERTY_ID
AND PR.PURGE_DT IS NULL
JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = COLL.PROPERTY_ID
AND RC.PURGE_DT IS NULL
AND RC.RECORD_TYPE_CD = 'G'
AND PR.RECORD_TYPE_CD = 'G'
AND RC.ID NOT IN
(
SELECT DISTINCT RC_ID FROM #TMPLP
)


---- WITHDRAW WI
UPDATE WI SET STATUS_CD = 'Withdrawn' , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'BUGXXXX' , 
LOCK_ID = WI.LOCK_ID % 255 + 1
---- SELECT COUNT(*)
FROM WORK_ITEM WI JOIN #TMPLP TMP ON 
TMP.WI_ID = WI.ID
AND WI.PURGE_DT IS NULL


INSERT INTO WORK_ITEM_ACTION (WORK_ITEM_ID, ACTION_CD, FROM_STATUS_CD, TO_STATUS_CD, CURRENT_QUEUE_ID, 
CURRENT_OWNER_ID, ACTION_NOTE_TX, ACTIVE_IN, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID, ACTION_USER_ID)
SELECT WI_ID , 'Withdraw' , STATUS_CD , 'Withdrawn' , CURRENT_QUEUE_ID , 
CURRENT_OWNER_ID , 'BUGXXXX' , 'Y' , GETDATE() , GETDATE() , 'BUGXXXX' , 1 , 1
FROM #TMPLP
ORDER BY STATUS_CD



UPDATE LN SET SPECIAL_HANDLING_XML = NULL , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX  = 'BUGXXXX' , 
LOCK_ID = LN.LOCK_ID % 255 + 1
--- SELECT COUNT(*)
FROM LOAN LN JOIN #TMPLP ON #TMPLP.LOAN_ID = LN.ID


---- CLEAR GOOD THRU IN CASE THE OTHER RC'S ARE VD PRODUCTS
UPDATE RC SET GOOD_THRU_DT = NULL , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'BUGXXXXX' ,
LOCK_ID = RC.LOCK_ID % 255 + 1
--- SELECT COUNT(*)
FROM REQUIRED_COVERAGE RC JOIN #TMPRC ON 
#TMPRC.RC_ID = RC.ID

