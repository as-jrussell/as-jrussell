USE UniTrac

SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
        *
	 
--SELECT P.*
	-- INTO #tmpPD
FROM    PROCESS_DEFINITION P
WHERE   PROCESS_TYPE_CD = 'CYCLEPRC'


UPDATE  PD
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with "2018-04-19 00:00:00.000"') ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        EXECUTION_FREQ_CD = 'ANNUAL' ,
        ONHOLD_IN = 'Y' ,
        ACTIVE_IN = 'Y' ,
        UPDATE_USER_TX = 'PreProdRefresh'
--SELECT * 
FROM    dbo.PROCESS_DEFINITION PD
WHERE   PROCESS_TYPE_CD = 'CYCLEPRC'
        AND EXECUTION_FREQ_CD != 'RUNONCE'


--Verify information

SELECT CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,
        *
FROM    PROCESS_DEFINITION P
WHERE   PROCESS_TYPE_CD = 'CYCLEPRC' AND ACTIVE_IN = 'Y' AND ONHOLD_IN = 'Y'
ORDER BY   CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) ASC




