Use UniTrac  GO  
SET QUOTED_IDENTIFIER ON  GO     
--1) Add all Loan IDs to be reviewed to temp table 
SELECT RELATE_ID INTO #tmpLOANREVIEW 
FROM WORK_ITEM  WHERE WORKFLOW_DEFINITION_ID = 8 AND STATUS_CD = 'Initial' 
AND PURGE_DT IS NULL AND LENDER_ID = 2556   AND CONTENT_XML.value('(/Content/VerifyData/Detail/@FieldDisplayName)[1]' , 'varchar(40)') = 'Property ACV'     


--2) Import all above Active Loans & Collateral WITHOUT Good Insurance (Loans to Keep) into temp table

SELECT LN.ID INTO #tmpLOANKEEP  FROM LOAN LN 
INNER JOIN COLLATERAL CL ON LN.ID = CL.LOAN_ID AND CL.PURGE_DT IS NULL  
INNER JOIN PROPERTY P ON CL.PROPERTY_ID = P.ID AND P.PURGE_DT IS NULL  
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID AND RC.PURGE_DT IS NULL  
WHERE LN.ID IN (SELECT RELATE_ID FROM #tmpLOANREVIEW) AND LN.PURGE_DT IS NULL AND CL.STATUS_CD = 'A' AND RC.STATUS_CD = 'A' 
AND NOT (RC.SUMMARY_SUB_STATUS_CD = 'C' AND RC.SUMMARY_STATUS_CD = 'F')  AND NOT (RC.SUMMARY_SUB_STATUS_CD = 'C' AND RC.SUMMARY_STATUS_CD = 'P') 
AND NOT (RC.SUMMARY_SUB_STATUS_CD = 'C' AND RC.SUMMARY_STATUS_CD = 'X')  AND NOT (RC.SUMMARY_SUB_STATUS_CD = 'D' AND RC.SUMMARY_STATUS_CD = 'F') 
AND NOT (RC.SUMMARY_SUB_STATUS_CD = 'D' AND RC.SUMMARY_STATUS_CD = 'P')      


--3) Select Work Items to be REMOVED into temp table 
SELECT ID, RELATE_ID INTO #tmpWORKITEMREMOVE  FROM WORK_ITEM  
WHERE WORKFLOW_DEFINITION_ID = 8 AND STATUS_CD = 'Initial' AND PURGE_DT IS NULL AND LENDER_ID = 2556  
AND CONTENT_XML.value('(/Content/VerifyData/Detail/@FieldDisplayName)[1]' , 'varchar(40)') = 'Property ACV' 
AND RELATE_ID IN (SELECT RELATE_ID FROM #tmpLOANREVIEW)  AND RELATE_ID NOT IN (SELECT ID FROM #tmpLOANKEEP)       


--********************  ----Update Scripts  --*********************    
--1) Work Item Withdrawals  
UPDATE WORK_ITEM SET STATUS_CD = 'Withdrawn',UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0549174',LOCK_ID = LOCK_ID % 255 + 1  
-- SELECT CONTENT_XML.value('(/Content/VerifyData/Detail/@FieldDisplayName)[1]' , 'varchar(40)') AS FieldDisplayName,CONTENT_XML.value('(/Content/VerifyData/Detail/@VerificationStatus)[1]' , 'varchar(40)') AS VerificationStatus,*  FROM WORK_ITEM  
WHERE ID IN (SELECT DISTINCT ID FROM #tmpWORKITEMREMOVE)   


--2) Work Item History Updates 
INSERT INTO WORK_ITEM_ACTION (WORK_ITEM_ID, ACTION_CD, FROM_STATUS_CD, TO_STATUS_CD, CURRENT_QUEUE_ID,CURRENT_OWNER_ID, ACTION_NOTE_TX, ACTIVE_IN, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID, ACTION_USER_ID)  
SELECT DISTINCT ID,'Withdrawn',STATUS_CD, 'Withdrawn',CURRENT_QUEUE_ID,CURRENT_OWNER_ID,'Withdrawn via Script - INC0549174','Y',GETDATE(),GETDATE(), 'INC0549174',1,1  
FROM WORK_ITEM   WHERE ID IN (SELECT DISTINCT ID FROM #tmpWORKITEMREMOVE)     

--3) Purge Special Handling XML from Above Loans 
UPDATE LN SET SPECIAL_HANDLING_XML = NULL,UPDATE_DT = GETDATE() , UPDATE_USER_TX  = 'INC0549174',LOCK_ID = LN.LOCK_ID % 255 + 1  
--- SELECT *  
FROM LOAN LN   
WHERE ID IN (SELECT RELATE_ID FROM #tmpWORKITEMREMOVE)    

GO    SET QUOTED_IDENTIFIER OFF  GO  


USE UniTrac

SELECT l.NUMBER_TX, LE.CODE_TX, LE.NAME_TX, wi.* 
FROM dbo.LOAN L
JOIN dbo.WORK_ITEM WI ON WI.RELATE_ID = L.ID AND WI.WORKFLOW_DEFINITION_ID = 8
JOIN dbo.LENDER LE ON LE.ID = L.LENDER_ID
WHERE NUMBER_TX = '29661944-20161122'