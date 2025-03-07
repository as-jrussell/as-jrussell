SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)'),
 *
	 
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N' AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) >= '2019-02-05 00:00'
	--AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)') AS DATETIME)<= '2019-02-04 20:00'
        AND ACTIVE_IN = 'Y' AND P.PROCESS_TYPE_CD= 'ESCROW' and EXECUTION_FREQ_CD <> 'RUNONCE'
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC


								
SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)'), ID,
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
							   'MSGSRVWF','GLBCKFDPA', 'UTLMTCHIB', 'UTL20MAT', 'KEYIMAGE', 'DASHCACHE', 'LOANPRCPA',
							   'OBCCOMPPRC','OCRINPRCPA', 'AUTOCOMP', 'LPIPRCPA', 'UTL20REMAT', 'FFOSSPRC', 'UTTOVUT', 
							   'GOODTHRUDT'  )
    --  AND EXECUTION_FREQ_CD IN ( '10MINUTE', 'HOUR', 'MINUTE' )
      AND ACTIVE_IN = 'Y'
      AND ONHOLD_IN = 'N'
      AND EXECUTION_FREQ_CD != 'RUNONCE'
	   AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) >= '2019-02-05 00:00'
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC


