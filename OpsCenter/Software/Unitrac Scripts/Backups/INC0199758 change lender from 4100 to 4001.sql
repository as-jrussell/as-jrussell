------- PD's By Service Instance, 
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
                                  'INT') = 186



SELECT  *
FROM    UniTrac..PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD = 'CYCLEPRC'
        AND SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                                  'INT') = 2256                                  
---- Find Lender                                   
SELECT * FROM UniTrac..LENDER
WHERE CODE_TX = '4100'      



UPDATE dbo.PROCESS_DEFINITION
SET NAME_TX = 'New 4001 / Omega Federal Credit Union / All / Veh / PD', DESCRIPTION_TX = 'New 4001 / Omega Federal Credit Union / All / Veh / PD'    
WHERE ID = '207767'  


SELECT * FROM dbo.LENDER
WHERE CODE_TX = '4100'        


UPDATE dbo.LENDER
SET CODE_TX ='4001'
WHERE ID = 2256