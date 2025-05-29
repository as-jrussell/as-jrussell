SELECT P.TAB.value('.', 'nvarchar(max)') AS LCGCTId, pd.ID AS ProcId
INTO #tmpLCGCTId
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LCGCTList/LCGCTId') AS P (TAB)
WHERE PROCESS_TYPE_CD = 'CYCLEPRC'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'



SELECT T.ProcId, COUNT(*) AS RcCount into #tmpProcCounts FROM  REQUIRED_COVERAGE RC 
JOIN #tmpLCGCTId T ON RC.LCGCT_ID = T.LCGCTId
JOIN COLLATERAL col ON col.PROPERTY_ID = RC.PROPERTY_ID
JOIN LOAN ln ON ln.ID = col.LOAN_ID
   AND RC.STATUS_CD != 'S'
	AND RC.PURGE_DT IS NULL
	AND col.PURGE_DT IS NULL
	AND ln.PURGE_DT IS NULL    
	GROUP by T.ProcId
	
	
SELECT
DISTINCT
	LDR.CODE_TX,
	LDR.NAME_TX,
	PD.ID ProcessDefID,
	pd.EXECUTION_FREQ_CD, 
	pd.FREQ_MULTIPLIER_NO,
	SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)') AS ServiceName,
	DATENAME(dw,CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]', 'nvarchar(max)') AS datetime2)) AS NextRunDay,
	CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]', 'nvarchar(max)') AS datetime2) AS NextRunDate,
	tpc.RcCount
FROM PROCESS_DEFINITION PD
JOIN LENDER LDR ON LDR.ID = SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]', 'nvarchar(max)')
JOIN LOAN l ON l.LENDER_ID = LDR.ID
JOIN #tmpProcCounts tpc ON tpc.ProcId = PD.ID
WHERE PROCESS_TYPE_CD = 'CYCLEPRC'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'
ORDER BY [ServiceName]
	


--DROP table #TempCounts
--DROP TABLE #tmpLCGCTId
--DROP table #tmpProcCounts
