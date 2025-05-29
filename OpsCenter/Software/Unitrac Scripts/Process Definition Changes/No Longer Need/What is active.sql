USE UniTrac

SELECT DISTINCT
        SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [TargetService]
INTO    #tmp
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N'
        AND ACTIVE_IN = 'Y'

--DROP TABLE #tmp
     SELECT  ID ,
                SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                                      'nvarchar(max)') [TargetService] ,
                NAME_TX ,
                DESCRIPTION_TX ,
                EXECUTION_FREQ_CD ,
                PROCESS_TYPE_CD ,
                ACTIVE_IN ,
                ONHOLD_IN,
				CREATE_DT
        
		
		
		SELECT *
		FROM    dbo.PROCESS_DEFINITION
        WHERE   ACTIVE_IN = 'Y'
                AND SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                                          'nvarchar(max)') IN ( 'DashboardService' )
        ORDER BY ID ASC
