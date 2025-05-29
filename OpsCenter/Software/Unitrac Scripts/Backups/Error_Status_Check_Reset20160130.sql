USE UniTrac

-------- Check for Process Definitions With Status Code Equal To Error
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE STATUS_CD = 'Error'


SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE EXECUTION_FREQ_CD = 'MONTHLY' AND PROCESS_TYPE_CD = 'CYCLEPRC'
AND ACTIVE_IN = 'Y' AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)



-------- Reset Process Definitions (All)
UPDATE  UniTrac..PROCESS_DEFINITION
SET     LAST_RUN_DT = GETDATE() ,
        LAST_SCHEDULED_DT = GETDATE() ,
        LOCK_ID = CASE WHEN LOCK_ID < 255 THEN LOCK_ID + 1
                       ELSE 1
                  END , UPDATE_USER_TX = 'jrussell', ACTIVE_IN = 'Y',
        STATUS_CD = 'Complete', SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate />
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService>UnitracBusinessServiceCycle4</TargetService>
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <LDAPServer>10.10.18.186</LDAPServer>
  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
  <TimeOfDay>01:30:00</TimeOfDay>
  <ForcedPlcyOptBlanketAuditDate>1/1/0001 12:00:00 AM</ForcedPlcyOptBlanketAuditDate>
  <AnticipatedNextScheduledDate>1/30/2016 1:30:00 AM</AnticipatedNextScheduledDate>
  <LenderList>
    <LenderID IsEnabled="Y">146</LenderID>
  </LenderList>
  <LCGCTList>
    <LCGCTId>117</LCGCTId>
    <LCGCTId>118</LCGCTId>
    <LCGCTId>119</LCGCTId>
    <LCGCTId>120</LCGCTId>
  </LCGCTList>
  <LenderReportConfigList />
  <NoticeList />
  <SProcList>
    <SProc IsEnabled="Y">UpdatePaymentIncrease</SProc>
  </SProcList>
</ProcessDefinitionSettings>'
--SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE   ID IN (17032)




SELECT * FROM  UniTrac..PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (17032)
AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (SELECT ID FROM  dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (17032)
AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE))


SELECT * FROM UniTrac..WORK_ITEM
WHERE WORKFLOW_DEFINITION_ID = '1'
AND RELATE_ID = '5246299'




SELECT * FROM UniTrac..MESSAGE
WHERE id = '5246299'

SELECT * FROM UniTrac..TRADING_PARTNER
WHERE iD = '2283'
