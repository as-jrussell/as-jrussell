------- Cancelled Lender Determine Cancel Pending, Outbound Call, VerifyData Open WI
----REPLACE XXXXXXX WITH THE THE WI ID
----REPLACE 023000 WITH THE THE Lender ID
----REPLACE INC0243260 WITH THE TICKET ID
---Checking UTLs WIs
USE UniTrac

SELECT  * 
--INTO UniTracHDStorage..INC0243260
FROM    WORK_ITEM
WHERE   RELATE_TYPE_CD = 'Allied.UniTrac.UTLMatchResult'
        AND RELATE_ID IN (
        SELECT  UTL_MATCH_RESULT.ID
        FROM    LOAN
                INNER JOIN COLLATERAL ON LOAN.ID = COLLATERAL.LOAN_ID-- AND COLLATERAL.PURGE_DT IS NULL
                INNER JOIN PROPERTY ON COLLATERAL.PROPERTY_ID = PROPERTY.ID
                INNER JOIN dbo.UTL_MATCH_RESULT ON PROPERTY.ID = UTL_MATCH_RESULT.PROPERTY_ID
                INNER JOIN LENDER ON LOAN.LENDER_ID = LENDER.ID
        WHERE   LENDER.CODE_TX = '023000'
                AND WORK_ITEM.STATUS_CD NOT LIKE 'Complete'
                AND WORK_ITEM.STATUS_CD NOT LIKE 'Withdrawn' 
			   )

---Checking Verify Data, Cancel Pending , and Outbound WIs
SELECT * 
--INTO UniTracHDStorage..INC0243260
FROM WORK_ITEM
WHERE WORKFLOW_DEFINITION_ID IN (3,6,8)  AND RELATE_TYPE_CD = 'Allied.UniTrac.RequiredCoverage' AND RELATE_ID IN (SELECT REQUIRED_COVERAGE.ID
FROM LOAN
INNER JOIN COLLATERAL ON LOAN.ID = COLLATERAL.LOAN_ID-- AND COLLATERAL.PURGE_DT IS NULL
INNER JOIN PROPERTY ON COLLATERAL.PROPERTY_ID = PROPERTY.ID
INNER JOIN REQUIRED_COVERAGE ON PROPERTY.ID = REQUIRED_COVERAGE.PROPERTY_ID
INNER JOIN LENDER ON LOAN.LENDER_ID = LENDER.ID
WHERE LENDER.CODE_TX = '023000'
AND WORK_ITEM.STATUS_CD NOT LIKE 'Complete' AND WORK_ITEM.STATUS_CD NOT LIKE 'Withdrawn' )
ORDER BY WORK_ITEM.STATUS_CD ASC 


SELECT * 
INTO UniTracHDStorage..INC0243260
FROM UniTrac..WORK_ITEM
WHERE CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '023000'
AND WORKFLOW_DEFINITION_ID IN (2,3,6,8)
--AND STATUS_CD = 'Initial'
AND WORK_ITEM.STATUS_CD NOT LIKE 'Complete' AND WORK_ITEM.STATUS_CD NOT LIKE 'Withdrawn'
ORDER BY WORKFLOW_DEFINITION_ID ASC

-------- Clear UTLs (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INC0243260',
		 LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                  ELSE LOCK_ID + 1 END
WHERE   ID IN  (  SELECT ID FROM UniTracHDStorage..INC0243260)
        AND WORKFLOW_DEFINITION_ID = 2
		AND STATUS_CD = 'Initial'
        AND ACTIVE_IN = 'Y'

-------- Clear Cancel Pending (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INC0243260'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0243260)
        AND WORKFLOW_DEFINITION_ID = 3
        AND ACTIVE_IN = 'Y'

-------- Clear OBC (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INC0243260'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0243260)
        AND WORKFLOW_DEFINITION_ID = 6
        AND ACTIVE_IN = 'Y'

-------- Clear VerifyData (- rows)
SELECT DISTINCT
        WI.ID AS WI_ID ,
        LOAN.ID AS LOAN_ID
INTO    #TMPWI
FROM    LOAN
        JOIN LENDER ON LENDER.ID = LOAN.LENDER_ID
        JOIN WORK_ITEM WI ON WI.RELATE_ID = LOAN.ID
WHERE   LENDER.CODE_TX = '023000'
        AND WI.WORKFLOW_DEFINITION_ID = 8
        AND WI.STATUS_CD NOT IN ( 'COMPLETE', 'Withdrawn' )
        AND WI.PURGE_DT IS NULL
        AND LOAN.PURGE_DT IS NULL
        AND LOAN.RECORD_TYPE_CD IN ('G','A')

SELECT * FROM #TMPWI

SELECT * INTO UniTracHDStorage..LOAN_INC0243260
FROM dbo.LOAN WHERE ID IN (SELECT LOAN_ID FROM #TMPWI)

UPDATE  LN
SET     SPECIAL_HANDLING_XML = NULL ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0243260' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    LOAN LN
        JOIN #TMPWI ON #TMPWI.LOAN_ID = LN.ID


UPDATE  WI
SET     STATUS_CD = 'Withdrawn' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0243260' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    WORK_ITEM WI
        JOIN #TMPWI ON #TMPWI.WI_ID = WI.ID


SELECT ID,STATUS_CD, WORKFLOW_DEFINITION_ID FROM dbo.WORK_ITEM
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0243260)
AND STATUS_CD = 'Initial'

SELECT SPECIAL_HANDLING_XML, UPDATE_DT, UPDATE_USER_TX, LOCK_ID
FROM dbo.LOAN WHERE ID IN (SELECT LOAN_ID FROM #TMPWI)



SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, * --INTO UniTracHDStorage..WI_INCXXXXXXX
INTO    #TMPWI_D
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( 23781646,23782325,25036293,30864836,31872512  )



UPDATE WI SET STATUS_CD = 'Withdrawn' , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0243260' , 
LOCK_ID = WI.LOCK_ID % 255 + 1
---- SELECT COUNT(*)
FROM WORK_ITEM WI JOIN #TMPWI_D TMP ON 
TMP.ID = WI.ID
AND WI.PURGE_DT IS NULL
---- 

INSERT INTO WORK_ITEM_ACTION (WORK_ITEM_ID, ACTION_CD, FROM_STATUS_CD, TO_STATUS_CD, CURRENT_QUEUE_ID, 
CURRENT_OWNER_ID, ACTION_NOTE_TX, ACTIVE_IN, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID, ACTION_USER_ID)
SELECT DISTINCT ID , 'Withdraw' , STATUS_CD , 'Withdrawn' , CURRENT_QUEUE_ID , 
CURRENT_OWNER_ID , 'INC0243260' , 'Y' , GETDATE() , GETDATE() , 'INC0243260' , 1 , 1
FROM #TMPWI_D
ORDER BY STATUS_CD
---- 


UPDATE LN SET SPECIAL_HANDLING_XML = NULL , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX  = 'INC0243260' , 
LOCK_ID = LN.LOCK_ID % 255 + 1
--- SELECT LN.NUMBER_TX
FROM LOAN LN JOIN #TMPWI_D ON #TMPWI_D.RELATE_ID = LN.ID
--- 





USE UniTrac 

--DROP TABLE #tmpLCGCTId
SELECT P.TAB.value('.', 'nvarchar(max)') AS LCGCTId, pd.ID AS ProcId
INTO #tmpLCGCTId
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') AS P (TAB)
WHERE PROCESS_TYPE_CD = 'UTLMTCHIB'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'

--drop table #process
SELECT
DISTINCT
	LDR.CODE_TX,
	LDR.NAME_TX,
	PD.ID ProcessDefID,
	pd.EXECUTION_FREQ_CD, 
	pd.FREQ_MULTIPLIER_NO,
	SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)') AS ServiceName,
	PD.STATUS_CD
	INTO #process
FROM PROCESS_DEFINITION PD
JOIN #tmpLCGCTId tpc ON tpc.ProcId = PD.ID
JOIN LENDER LDR ON LDR.CODE_TX = tpc.LCGCTId
WHERE PROCESS_TYPE_CD = 'UTLMTCHIB'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'
ORDER BY [ServiceName]
	
--DROP TABLE #tmpLCGCTIc
SELECT P.TAB.value('.', 'nvarchar(max)') AS LCGCTId, pd.ID AS ProcId
INTO #tmpLCGCTIc
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') AS P (TAB)
WHERE PROCESS_TYPE_CD = 'UTLIBREPRC'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'

--DROP TABLE #reprocess
SELECT
DISTINCT
	LDR.CODE_TX,
	LDR.NAME_TX,
	PD.ID ProcessDefID,
	pd.EXECUTION_FREQ_CD, 
	pd.FREQ_MULTIPLIER_NO,
	SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)') AS ServiceName,
	PD.STATUS_CD
	INTO #reprocess
FROM PROCESS_DEFINITION PD
JOIN #tmpLCGCTIc tpc ON tpc.ProcId = PD.ID
JOIN LENDER LDR ON LDR.CODE_TX = tpc.LCGCTId
WHERE PROCESS_TYPE_CD = 'UTLIBREPRC'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'
ORDER BY [ServiceName]
	




	SELECT R.CODE_TX, R.NAME_TX, R.ProcessDefID [ReProcess ID], PDR.NAME_TX [Reprocess Name], R.ServiceName [ReProcess ServiceName]
	FROM #reprocess R
	LEFT JOIN dbo.PROCESS_DEFINITION PDR ON R.ProcessDefID = PDR.ID
	WHERE r.CODE_TX = '023000'

		SELECT P.CODE_TX, P.NAME_TX, P.ProcessDefID [Process ID], PD.NAME_TX [Process Name], P.ServiceName [Process ServiceName]
	FROM #process P
		LEFT JOIN dbo.PROCESS_DEFINITION PD ON P.ProcessDefID = PD.ID
			WHERE P.CODE_TX = '023000'

/*
DROP TABLE #tmpLCGCTId
DROP TABLE #process
DROP TABLE #tmpLCGCTIc
DROP TABLE #reprocess

*/