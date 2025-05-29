USE Unitrac

SELECT 
 SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                              'nvarchar(max)') [Lender] ,
     *
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N' 
        AND ACTIVE_IN = 'Y' AND P.PROCESS_TYPE_CD = 'GOODTHRUDT'
		AND P.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                              'nvarchar(max)') IN ('3000')
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC


