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
        PL.PURGE_DT, 
		PL.SERVER_TX, PL.SERVICE_NAME_TX
FROM    dbo.PROCESS_LOG PL
        INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE   SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') IN ( 'UnitracBusinessServicePRT' )
         AND CAST(PL.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY PD.ID ,
        PL.UPDATE_DT DESC





		SELECT * FROM dbo.PROCESS_DEFINITION
		WHERE ID IN (83,
15545)