SELECT  ID ,
        NAME_TX ,
        SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                              'varchar(50)') AS NextDate
FROM    UniTrac..PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD LIKE 'CYCLEPRC'
        AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                       'varchar(50)') AS DATE) >= '8/17/2013'
        AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                       'varchar(50)') AS DATE) < '8/18/2013'
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATE)