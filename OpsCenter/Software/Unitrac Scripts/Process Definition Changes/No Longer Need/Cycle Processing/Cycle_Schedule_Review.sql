SELECT  L.CODE_TX AS CODE_TX ,
	L.NAME_TX AS LENDER_NAME ,
			P.Status_CD AS STATUS,
        	P.ID AS PROCESS_DEFINTION_ID ,
        	P.NAME_TX AS PROCESS_DEFINTION_NAME ,
        	SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                              'varchar(50)') AS NEXT_CYCLE_DATE
FROM    PROCESS_DEFINITION P
        JOIN dbo.LENDER L ON L.ID = p.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                                                            'INT')
WHERE   PROCESS_TYPE_CD LIKE 'CYCLEPRC'
        AND SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                       'DATE') >= '10/11/2013'
ORDER BY SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'DATE')


--SELECT * FROM UniTrac..PROCESS_DEFINITION
--WHERE PROCESS_TYPE_CD = 'CYCLEPRC' AND STATUS_CD = 'InProcess'