SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
        CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,
     *
	 
--SELECT P.*
	-- INTO #tmpPD
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N' 
        AND ACTIVE_IN = 'Y' AND P.ID = '352526'
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC



									UPDATE PD
									SET ACTIVE_IN = P.ACTIVE_IN,  ONHOLD_IN = P.ONHOLD_IN
									--SELECT *
									FROM dbo.PROCESS_DEFINITION PD 
									JOIN #tmpPD P ON P.ID = PD.ID 
									
									WHERE   SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                                  'nvarchar(max)') = 'UnitracBusinessService'  AND ID NOT IN (352526) AND ACTIVE_IN = 'Y' AND ONHOLD_IN= 'N'



UPDATE  PD
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "UnitracBusinessServiceMatchIn"') ,
        LOCK_ID = LOCK_ID + 1, UPDATE_DT = GETDATE(), ACTIVE_IN = 'Y', ONHOLD_IN = 'N'
--SELECT * 
FROM dbo.PROCESS_DEFINITION PD
WHERE   ID = '352526'

SELECT * FROM dbo.USERS

SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '352526'


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = '38146176'