-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
USE [UniTrac]
GO 

SELECT SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'varchar (50)'),* FROM  dbo.PROCESS_DEFINITION
WHERE UPDATE_USER_TX IN ('LDHPCRA', 'LDHADHOC', 'LDHSrvr')


SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'varchar (50)'),* 
FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'LOANPRCPA'



SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'varchar (50)'),* 
FROM dbo.PROCESS_DEFINITION
WHERE SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'varchar (50)') LIKE 'LDH%'

SELECT TOP 50 *
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 336 
ORDER BY START_DT DESC

SELECT * FROM dbo.PROCESS_DEFINITION WHERE id = '336'

SELECT * FROM UniTracHDStorage..PROCESS_DEFINITION_336