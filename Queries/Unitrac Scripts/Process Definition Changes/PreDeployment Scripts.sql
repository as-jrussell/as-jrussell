use unitrac


---Where are YYYY-MM-DD place today's day the times of 15:00 and 22:00 are best to stay to give accurate processes running during those times
SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)'), process_type_cd,
 *
	 
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N' AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) >= 'YYYY-MM-DD 15:00'
	AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)') AS DATETIME)<= 'YYYY-MM-DD 22:00'
        AND ACTIVE_IN = 'Y'   and EXECUTION_FREQ_CD <> 'RUNONCE'
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC


--will show any process that is running please research the history of the process if it has a history of running long please notify Senior Admin, ISS to postpone deployment
SELECT STATUS_CD, process_type_cd, * FROM PROCESS_DEFINITION
where STATUS_CD = 'InProcess' and PROCESS_TYPE_CD NOT IN ( 'RPTGEN', 'LETGEN', 'HISTFORM', 'LDAPSYNC', 'WFEVAL', 'PDUNLOCK', 'WFUNLCK', 'INSDOCPA',
                               'UTLMTCHOB', 'VUTPA', 'FULFILLPRC', 'DWINBOUND', 'DWINBOUND', 'DWOUTBOUND', 'MSGSRV',
                               'GLBCKFDPA', 'UTLMTCHIB', 'UTL20MAT', 'KEYIMAGE', 'DASHCACHE', 'LOANPRCPA',
                               'OCRINPRCPA', 'AUTOCOMP', 'LPIPRCPA', 'UTL20REMAT', 'FFOSSPRC', 'UTTOVUT', 'GOODTHRUDT', 'MSGSRVWF'
                             ) AND ACTIVE_IN = 'Y' and ONHOLD_IN = 'N'

