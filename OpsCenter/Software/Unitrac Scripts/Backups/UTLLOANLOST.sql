USE UniTrac



SELECT * FROM dbo.WORK_ITEM
WHERE WORKFLOW_DEFINITION_ID = '2'
AND UPDATE_USER_TX = 'UBSMatchInC'




USE UniTrac 

--DROP TABLE #tmpLCGCTId
SELECT P.TAB.value('.', 'nvarchar(max)') AS LCGCTId, pd.ID AS ProcId
INTO #tmpLCGCTId
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') AS P (TAB)
WHERE PROCESS_TYPE_CD = 'UTLMTCHIB' AND ID = '1656'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'

SELECT * FROM #tmpLCGCTId


SELECT T.ProcId, CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    UniTrac..WORK_ITEM WI
JOIN #tmpLCGCTId T ON T.LCGCTId = WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') 
WHERE WI.WORKFLOW_DEFINITION_ID = '2' AND CAST(WI.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY WI.CREATE_DT DESC




SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender , 
CONTENT_XML.value('(/Content/Loan/Number)[1]', 'varchar (50)') Number,
 *
FROM    UniTrac..WORK_ITEM WI
JOIN #tmpLCGCTId T ON T.LCGCTId = WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') 
WHERE  CAST(WI.CREATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND WORKFLOW_DEFINITION_ID = '2'
ORDER BY CONTENT_XML.value('(/Content/Loan/Number)[1]', 'varchar (50)') DESC



SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE ID IN (SELECT * FROM #tmp) AND TO_STATUS_CD <> 'Complete'
ORDER BY ACTION_USER_ID DESC

SELECT * FROM dbo.WORK_ITEM
WHERE ID IN (30979117,
30964163)


SELECT * FROM dbo.UTL_MATCH_RESULT
WHERE ID IN (72277339,
72326963)




UTLLoanId:


SELECT * FROM dbo.UTL_MATCH_RESULT
WHERE CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
--AND UPDATE_USER_TX = 'UBSMatchINC'

AND UTL_LOAN_ID = '153886422'

 UTLLoanId:153886422



 USE UniTrac

SELECT DISTINCT
        SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [TargetService]
INTO    #tmp
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N'
        AND ACTIVE_IN = 'Y'

--DROP TABLE #tmp
SELECT DISTINCT
        SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [TargetService] ,
        PD.STATUS_CD [Process Def Status] ,
        PD.ID [Process Def ID] ,
        PL.ID [Process Log ID] ,
        PL.START_DT ,
        PL.END_DT ,
        PL.STATUS_CD ,
        PL.MSG_TX ,
        PL.CREATE_DT ,
        PL.UPDATE_DT ,
        PL.UPDATE_USER_TX ,
        PL.PURGE_DT
FROM    dbo.PROCESS_LOG PL
        INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE   SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') IN ( SELECT  *
                                                    FROM    #tmp )
        AND PL.STATUS_CD = 'InProcess'
        AND CAST(PL.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY PD.ID ,
        PL.UPDATE_DT DESC


		SELECT DISTINCT
        SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [TargetService] ,
        PD.STATUS_CD [Process Def Status] ,
        PD.ID [Process Def ID] ,
        PL.ID [Process Log ID] ,
        PL.START_DT ,
        PL.END_DT ,
        PL.STATUS_CD ,
        PL.MSG_TX ,
        PL.CREATE_DT ,
        PL.UPDATE_DT ,
        PL.UPDATE_USER_TX ,
        PL.PURGE_DT
FROM    dbo.PROCESS_LOG PL
        INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE   SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') IN ('UnitracBusinessServiceMatchInC' )
     --   AND PL.STATUS_CD = 'InProcess'
        AND CAST(PL.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY PD.ID ,
        PL.UPDATE_DT DESC

		SELECT * FROM dbo.PROCESS_LOG_ITEM
		WHERE PROCESS_LOG_ID IN (		SELECT DISTINCT
        PL.ID
FROM    dbo.PROCESS_LOG PL
        INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE   SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') IN ('UnitracBusinessServiceMatchInC' )
     --   AND PL.STATUS_CD = 'InProcess'
        AND CAST(PL.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE))



		SELECT * FROM dbo.PROCESS_DEFINITION
		WHERE ID = '1656'


		SELECT * FROM dbo.PROCESS_LOG
		WHERE id = ' 33147875'

		SELECT * FROM dbo.PROCESS_LOG_ITEM
		WHERE PROCESS_LOG_ID =  33147875