------- Cancelled Lender Determine Cancel Pending, Outbound Call, VerifyData Open WI
----REPLACE XXXXXXX WITH THE THE WI ID
----REPLACE #### WITH THE THE Lender ID
----REPLACE INC0224584 WITH THE TICKET ID
---Checking UTLs WIs
USE UniTrac

SELECT * --INTO UniTracHDStorage..INC0224584
FROM UniTrac..WORK_ITEM
WHERE CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '1050'
AND WORKFLOW_DEFINITION_ID IN (2,3,6,8)
--AND STATUS_CD = 'Initial'
AND WORK_ITEM.STATUS_CD NOT LIKE 'Complete' AND WORK_ITEM.STATUS_CD NOT LIKE 'Withdrawn'
ORDER BY WORKFLOW_DEFINITION_ID ASC

SELECT * FROM UniTracHDStorage..INC0224584


-------- Clear Cancel Pending (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INC0224584'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0224584 )
        AND WORKFLOW_DEFINITION_ID = 3
        AND ACTIVE_IN = 'Y'

-------- Clear OBC (- rows)
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        UPDATE_USER_TX = 'INC0224584'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0224584 )
        AND WORKFLOW_DEFINITION_ID = 6
        AND ACTIVE_IN = 'Y'


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
	



	SELECT P.CODE_TX, P.NAME_TX, P.ProcessDefID [Process ID], PD.NAME_TX [Process Name], P.ServiceName [Process ServiceName],
	R.ProcessDefID [ReProcess ID], PDR.NAME_TX [Reprocess Name], R.ServiceName [ReProcess ServiceName]
	FROM #process P
	RIGHT JOIN #reprocess R oN R.CODE_TX = P.CODE_TX
	INNER JOIN dbo.PROCESS_DEFINITION PD ON P.ProcessDefID = PD.ID
	INNER JOIN dbo.PROCESS_DEFINITION PDR ON R.ProcessDefID = PDR.ID
	
	
	SELECT * FROM #reprocess R
	WHERE R.CODE_TX = '1050'
