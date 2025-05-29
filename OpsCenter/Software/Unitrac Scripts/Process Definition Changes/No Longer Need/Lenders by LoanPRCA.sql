USE UniTrac 

--DROP TABLE #tmpLCGCTId
SELECT P.TAB.value('.', 'nvarchar(max)') AS LCGCTId, pd.ID AS ProcId
INTO #tmpLCGCTId
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') AS P (TAB)
WHERE ID = '336'


SELECT
DISTINCT
	LDR.CODE_TX,
	LDR.NAME_TX,
	PD.ID ProcessDefID,
	pd.EXECUTION_FREQ_CD, 
	SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)') AS ServiceName,
	PD.STATUS_CD
FROM PROCESS_DEFINITION PD
JOIN #tmpLCGCTId tpc ON tpc.ProcId = PD.ID
JOIN LENDER LDR ON LDR.CODE_TX = tpc.LCGCTId 
WHERE LDR.STATUS_CD  IN ('ACTIVE') and LDR.PURGE_DT is null
ORDER BY [ServiceName]
	
