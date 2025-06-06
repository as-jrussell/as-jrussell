------- Cancelled Lender Determine Cancel Pending, Outbound Call, VerifyData Open WI
----REPLACE XXXXXXX WITH THE THE WI ID
----REPLACE 6584 WITH THE THE Lender ID
----REPLACE INCXXXXXXX WITH THE TICKET ID
---Checking UTLs WIs
USE UniTrac

--SELECT * FROM dbo.LENDER WHERE CODE_TX IN ('6584')

SELECT 
WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, 
WI.CONTENT_XML.value('(/Content/Collateral/Type)[1]', 'varchar (50)') Collateral,
WI.CONTENT_XML.value('(/Content/Property/Description)[1]', 'varchar (50)') Property, WI.* 
INTO UniTracHDStorage..INC0282772
FROM UniTrac..WORK_ITEM WI
JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
WHERE L.CODE_TX IN ('6584')
AND WI.WORKFLOW_DEFINITION_ID IN (2,3,6,8)
AND WI.STATUS_CD NOT IN ('Complete', 'Withdrawn')
ORDER BY WI.WORKFLOW_DEFINITION_ID ASC



-------- Clear UTLs (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INCXXXXXXX',
		 LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                  ELSE LOCK_ID + 1 END
WHERE   ID IN  (  SELECT ID FROM UniTracHDStorage..INCXXXXXXX)
        AND WORKFLOW_DEFINITION_ID = 2
		AND STATUS_CD = 'Initial'
        AND ACTIVE_IN = 'Y'

-------- Clear Cancel Pending (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INC0282772'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0282772)
        AND WORKFLOW_DEFINITION_ID = 3
        AND ACTIVE_IN = 'Y'

-------- Clear OBC (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INCXXXXXXX'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXXX)
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
WHERE   LENDER.CODE_TX = '6584'
        AND WI.WORKFLOW_DEFINITION_ID = 8
        AND WI.STATUS_CD NOT IN ( 'COMPLETE', 'Withdrawn' )
        AND WI.PURGE_DT IS NULL
        AND LOAN.PURGE_DT IS NULL
        AND LOAN.RECORD_TYPE_CD IN ('G','A')

SELECT * FROM #TMPWI

SELECT * INTO UniTracHDStorage..LOAN_INCXXXXXXX
FROM dbo.LOAN WHERE ID IN (SELECT LOAN_ID FROM #TMPWI)

UPDATE  LN
SET     SPECIAL_HANDLING_XML = NULL ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INCXXXXXXX' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    LOAN LN
        JOIN #TMPWI ON #TMPWI.LOAN_ID = LN.ID


UPDATE  WI
SET     STATUS_CD = 'Withdrawn' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INCXXXXXXX' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                       ELSE LOCK_ID + 1
                  END
--SELECT COUNT(*)
FROM    WORK_ITEM WI
        JOIN #TMPWI ON #TMPWI.WI_ID = WI.ID


SELECT ID,STATUS_CD FROM dbo.WORK_ITEM
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INCXXXXXXX)

SELECT SPECIAL_HANDLING_XML, UPDATE_DT, UPDATE_USER_TX, LOCK_ID
FROM dbo.LOAN WHERE ID IN (SELECT LOAN_ID FROM #TMPWI)


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
	WHERE r.CODE_TX = '6584'

		SELECT P.CODE_TX, P.NAME_TX, P.ProcessDefID [Process ID], PD.NAME_TX [Process Name], P.ServiceName [Process ServiceName]
	FROM #process P
		LEFT JOIN dbo.PROCESS_DEFINITION PD ON P.ProcessDefID = PD.ID
			WHERE P.CODE_TX = '6584'

/*
DROP TABLE #tmpLCGCTId
DROP TABLE #process
DROP TABLE #tmpLCGCTIc
DROP TABLE #reprocess

*/
