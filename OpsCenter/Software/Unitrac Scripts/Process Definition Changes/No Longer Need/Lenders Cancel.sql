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
	



	SELECT P.CODE_TX, P.NAME_TX, P.ProcessDefID [Process ID], PD.NAME_TX [Process Name], P.ServiceName [Process ServiceName],
	R.ProcessDefID [ReProcess ID], PDR.NAME_TX [Reprocess Name], R.ServiceName [ReProcess ServiceName], PDR.ID, PDR.SETTINGS_XML_IM
	FROM #process P
	RIGHT JOIN #reprocess R oN R.CODE_TX = P.CODE_TX
	INNER JOIN dbo.PROCESS_DEFINITION PD ON P.ProcessDefID = PD.ID
	INNER JOIN dbo.PROCESS_DEFINITION PDR ON R.ProcessDefID = PDR.ID
	WHERE P.CODE_TX = '2244'


	SELECT ID FROM dbo.PROCESS_DEFINITION
	WHERE ID IN (50)


    SELECT  *
    FROM    dbo.PROCESS_LOG_ITEM PLI
            INNER JOIN dbo.LENDER L ON L.ID = PLI.RELATE_ID
                                       AND RELATE_TYPE_CD = 'Allied.UniTrac.Lender'
    WHERE   PLI.PROCESS_LOG_ID IN (
            SELECT  ID
            FROM    dbo.PROCESS_LOG
            WHERE   PROCESS_DEFINITION_ID IN ( SELECT   ID
                                               FROM     dbo.PROCESS_DEFINITION
                                               WHERE    ID IN ( 50 ) )
                    AND UPDATE_DT >= '2016-03-16 ' )
            AND L.CODE_TX = '2244'


			SELECT * FROM UniTracHDStorage..UnitracServices
			WHERE Name = 'UnitracBusinessServiceCycle4'


			SELECT * FROM dbo.PROCESS_DEFINITION
			WHERE NAME_TX LIKE '%2244%' AND ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N'



			SELECT TOP 3 * FROM dbo.PROCESS_LOG
			WHERE PROCESS_DEFINITION_ID = '10630'
			ORDER BY UPDATE_DT DESC