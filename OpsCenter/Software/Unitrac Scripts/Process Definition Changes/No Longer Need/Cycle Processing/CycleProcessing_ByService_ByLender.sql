------- PD's By Service Instance
SELECT  *
FROM    UniTrac..PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD = 'CYCLEPRC'
        AND SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1]',
                                  'varchar(50)') = 'UniTracBusinessServiceCycle3'

------- PD's By Lender ID
SELECT  *
FROM    UniTrac..PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD = 'CYCLEPRC'
        AND SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                                  'INT') = 2241
                                  

SELECT *
FROM    UniTrac..PROCESS_DEFINITION
WHERE ID IN (XXXXXXX)

SELECT * FROM UniTrac..PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (XXXXXXX)


--SELECT * FROM dbo.PROCESS_LOG_ITEM
--WHERE PROCESS_LOG_ID = '26019836'

SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (XXXXXXX)

SELECT * FROM dbo.WORK_QUEUE
WHERE ID = '40'


SELECT Q.ID, Q.NAME_TX, Q.FILTER_XML, * FROM dbo.WORK_QUEUE Q
INNER JOIN dbo.WORK_ITEM WI ON WI.CURRENT_QUEUE_ID = Q.ID
INNER JOIN dbo.PROCESS_LOG PL ON WI.RELATE_ID = PL.ID
INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PD.PROCESS_TYPE_CD = 'CYCLEPRC' AND PD.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                                  'INT') = '2241'



--WI.RELATE_ID = '26110011'

---- Find Lender                                   
SELECT * FROM UniTrac..LENDER
WHERE CODE_TX = 'XXXXXXX'                                  