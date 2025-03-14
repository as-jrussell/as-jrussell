SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
        CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,
     *
	 
--SELECT P.*
	-- INTO #tmpPD
FROM    PROCESS_DEFINITION P
WHERE  PROCESS_TYPE_CD = 'CYCLEPRC'
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC



UPDATE  PD
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with "2018-03-17 00:00:00.000"') ,
        LOCK_ID = LOCK_ID + 1, UPDATE_DT = GETDATE(), EXECUTION_FREQ_CD = 'ANNUAL', ONHOLD_IN = 'Y'
--SELECT * 
FROM dbo.PROCESS_DEFINITION PD
WHERE   PROCESS_TYPE_CD = 'CYCLEPRC'
