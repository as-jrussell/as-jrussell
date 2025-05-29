USE UniTrac


---Check Backfeed files
SELECT CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [TargetService],
     *
 FROM dbo.PROCESS_DEFINITION
where active_in = 'Y' and onhold_in = 'N' and Process_type_cd = 'INSBCKFD'
and CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) <= '2018-12-03 15:00'


---Lender Unitrac Transaction Supports Notes and/or Memo Backfeed
SELECT CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [TargetService],
     *
 FROM dbo.PROCESS_DEFINITION
where active_in = 'Y' and onhold_in = 'N' and Process_type_cd = 'LUTPRC'
and status_cd <> 'Expired'
and update_dt <= '2018-12-03 12:00'



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
                               'OCRINPRCPA', 'AUTOCOMP', 'LPIPRCPA', 'UTL20REMAT', 'FFOSSPRC', 'UTTOVUT', 'GOODTHRUDT'
                             )
      AND EXECUTION_FREQ_CD IN ( '10MINUTE', 'HOUR', 'MINUTE' )
      AND ACTIVE_IN = 'Y'
      AND ONHOLD_IN = 'N'
      AND EXECUTION_FREQ_CD != 'RUNONCE'
ORDER BY EXECUTION_FREQ_CD ASC;






--Check service

SELECT CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [TargetService], * from process_definition
where active_in = 'Y' and onhold_in = 'N' and  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)')= 'UnitracBusinessService'
and CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) <= '2018-12-03 17:00'
								   and execution_freq_cd != 'RUNONCE'



						