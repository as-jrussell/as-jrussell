USE [UniTrac]
GO


--From the alert that we have going out daily
SELECT ID, NAME_TX, DESCRIPTION_TX, EXECUTION_FREQ_CD, PROCESS_TYPE_CD, ACTIVE_IN, ONHOLD_IN,SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]', 'nvarchar(30)') as NEXT_RUN_DATE,UPDATE_USER_TX
FROM PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('CYCLEPRC','BILLING','ESCROW','EOMRPTG') 
AND ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N' AND EXECUTION_FREQ_CD <> 'RUNONCE'
ORDER BY EXECUTION_FREQ_CD ASC 



---What nonprocessed job is running that should not be
SELECT ID,
       NAME_TX,
       DESCRIPTION_TX,
       EXECUTION_FREQ_CD,
       PROCESS_TYPE_CD,
       ACTIVE_IN,
       ONHOLD_IN,
       SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]', 'nvarchar(30)') AS NEXT_RUN_DATE,
       UPDATE_USER_TX
FROM PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD NOT IN ( 'RPTGEN', 'LETGEN', 'HISTFORM', 'LDAPSYNC', 'WFEVAL', 'PDUNLOCK', 'WFUNLCK', 'INSDOCPA',
                               'UTLMTCHOB', 'VUTPA', 'FULFILLPRC', 'DWINBOUND', 'DWINBOUND', 'DWOUTBOUND', 'MSGSRV',
                               'GLBCKFDPA', 'UTLMTCHIB', 'UTL20MAT', 'KEYIMAGE', 'DASHCACHE', 'LOANPRCPA',
                               'OCRINPRCPA', 'AUTOCOMP', 'LPIPRCPA', 'UTL20REMAT', 'FFOSSPRC', 'UTTOVUT', 'GOODTHRUDT', 'MSGSRVWF'
                             )
      AND EXECUTION_FREQ_CD IN ( '10MINUTE', 'HOUR', 'MINUTE' )
      AND ACTIVE_IN = 'Y'
      AND ONHOLD_IN = 'N'
      AND EXECUTION_FREQ_CD != 'RUNONCE'
ORDER BY EXECUTION_FREQ_CD ASC;



SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.ENTITY_ID IN (645554) AND C.ENTITY_NAME_TX IN ('Allied.UniTrac.ProcessHelper.UniTracProcessDefinit')
ORDER BY C.CREATE_DT DESC 


update pd set ONHOLD_IN = 'N'
--select * 
FROM Unitrac..PROCESS_DEFINITION pd
WHERE ID = 543465
							 


				SELECT ID,SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
       NAME_TX,
       DESCRIPTION_TX,
       EXECUTION_FREQ_CD,
       PROCESS_TYPE_CD,
       ACTIVE_IN,
       ONHOLD_IN,
       SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]', 'nvarchar(30)') AS NEXT_RUN_DATE,
       UPDATE_USER_TX							 
							 from process_definition
							 where SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') like 'UnitracBusinessService%'
							        AND ACTIVE_IN = 'Y'
      AND ONHOLD_IN = 'N' and status_cd != 'Expired' and PROCESS_TYPE_CD NOT IN ( 'RPTGEN', 'LETGEN', 'HISTFORM', 'LDAPSYNC', 'WFEVAL', 'PDUNLOCK', 'WFUNLCK', 'INSDOCPA',
                               'UTLMTCHOB', 'VUTPA', 'FULFILLPRC', 'DWINBOUND', 'DWINBOUND', 'DWOUTBOUND', 'MSGSRV',
                               'GLBCKFDPA', 'UTLMTCHIB', 'UTL20MAT', 'KEYIMAGE', 'DASHCACHE', 'LOANPRCPA',
                               'OCRINPRCPA', 'AUTOCOMP', 'LPIPRCPA', 'UTL20REMAT', 'FFOSSPRC', 'UTTOVUT', 'GOODTHRUDT', 'MSGSRVWF'
                             ) and SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') NOT IN ('UnitracBusinessService')
ORDER BY EXECUTION_FREQ_CD ASC;
