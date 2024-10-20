SELECT LAST_SCHEDULED_DT, LAST_RUN_DT, SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
        CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,
     *
	 
--SELECT P.*
	-- INTO #tmpPD
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N'  AND PROCESS_TYPE_CD = 'CYCLEPRC' AND  CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) >= '2019-01-27 00:00'
								   and CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) <= '2019-01-27 00:00'
        AND ACTIVE_IN = 'Y' AND EXECUTION_FREQ_CD <> 'RUNONCE'
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC



