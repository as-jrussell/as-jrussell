SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID IN ( 180451, 15545)




UPDATE dbo.PROCESS_DEFINITION
SET LOCK_ID = LOCK_ID + 1  ,
STATUS_CD = 'Complete',
SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate />
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService>UnitracBusinessServiceRPT</TargetService>
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <LDAPServer>10.10.18.186</LDAPServer>
  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
  <AnticipatedNextScheduledDate>1/1/0001 12:00:00 AM</AnticipatedNextScheduledDate>
  <LenderList>
    <LenderID IsEnabled="Y">1810</LenderID>
  </LenderList>
  <LCGCTList>
    <LCGCTId>2047</LCGCTId>
    <LCGCTId>2048</LCGCTId>
    <LCGCTId>2049</LCGCTId>
    <LCGCTId>2050</LCGCTId>
    <LCGCTId>2051</LCGCTId>
    <LCGCTId>2052</LCGCTId>
    <LCGCTId>2053</LCGCTId>
    <LCGCTId>2054</LCGCTId>
    <LCGCTId>2055</LCGCTId>
    <LCGCTId>2058</LCGCTId>
    <LCGCTId>2060</LCGCTId>
    <LCGCTId>2061</LCGCTId>
    <LCGCTId>2062</LCGCTId>
    <LCGCTId>2063</LCGCTId>
    <LCGCTId>2064</LCGCTId>
    <LCGCTId>2065</LCGCTId>
    <LCGCTId>2067</LCGCTId>
  </LCGCTList>
  <LenderReportConfigList>
    <LenderReportConfigId>59957</LenderReportConfigId>
  </LenderReportConfigList>
  <EscrowProcessMode>
    <Mode>DUEDTRANGE</Mode>
    <StartDate>04/01/2015</StartDate>
    <EndDate>04/28/2015</EndDate>
  </EscrowProcessMode>
</ProcessDefinitionSettings>',
EXECUTION_FREQ_CD = 'MINUTE',
UPDATE_USER_TX = 'UBSRPT'
WHERE ID = 180451





---180805, 180811, 180796,
--UPDATE dbo.PROCESS_DEFINITION
--SET LOCK_ID = LOCK_ID + 1  ,
--SETTINGS_XML_IM = '<ProcessDefinitionSettings>
--  <LastProcessedDate />
--  <TargetServerList>
--    <TargetServer />
--  </TargetServerList>
--  <TargetServiceList>
--    <TargetService>UnitracBusinessServiceCycle</TargetService>
--  </TargetServiceList>
--  <PredecessorProcessList>
--    <PredecessorProcess />
--  </PredecessorProcessList>
--  <LDAPServer>10.10.18.186</LDAPServer>
--  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
--  <ForcedPlcyOptBlanketAuditDate>1/1/0001 12:00:00 AM</ForcedPlcyOptBlanketAuditDate>
--  <AnticipatedNextScheduledDate>9/9/2015 9:10:00 AM</AnticipatedNextScheduledDate>
--  <LenderList>
--    <LenderID IsEnabled="Y">1921</LenderID>
--  </LenderList>
--  <LCGCTList>
--    <LCGCTId>5479</LCGCTId>
--    <LCGCTId>5481</LCGCTId>
--    <LCGCTId>7031</LCGCTId>
--  </LCGCTList>
--  <SProcList>
--    <SProc IsEnabled="Y">UpdatePaymentIncrease</SProc>
--  </SProcList>
--  <OriginatorWorkItemId>24638422</OriginatorWorkItemId>
--</ProcessDefinitionSettings>'
--WHERE ID = 180796



--UPDATE dbo.PROCESS_DEFINITION
--SET LOCK_ID = LOCK_ID + 1  ,
--STATUS_CD = 'Complete'
--,  SETTINGS_XML_IM = '<ProcessDefinitionSettings>
--  <LastProcessedDate />
--  <TargetServerList>
--    <TargetServer />
--  </TargetServerList>
--  <TargetServiceList>
--    <TargetService>UnitracBusinessService</TargetService>
--  </TargetServiceList>
--  <PredecessorProcessList>
--    <PredecessorProcess />
--  </PredecessorProcessList>
--  <LDAPServer>10.10.18.186</LDAPServer>
--  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
--  <LenderCode>2771</LenderCode>
--  <LenderList>
--    <LenderID IsEnabled="Y">1810</LenderID>
--  </LenderList>
--  <EscrowWorkItemId>25055484</EscrowWorkItemId>
--  <OriginatorWorkItemId>25055484</OriginatorWorkItemId>
-- <AnticipatedNextScheduledDate>1/1/0001 12:00:00 AM</AnticipatedNextScheduledDate>
--</ProcessDefinitionSettings>'
--WHERE ID = 180811


--UPDATE dbo.PROCESS_DEFINITION
--SET LOCK_ID = LOCK_ID + 1  ,
--STATUS_CD = 'Expired'
--WHERE ID = 180811



--UPDATE dbo.PROCESS_DEFINITION
--SET LOCK_ID = LOCK_ID + 1  ,
--STATUS_CD = 'Complete'
----,  SETTINGS_XML_IM = '<ProcessDefinitionSettings>
--  <LastProcessedDate />
--  <TargetServerList>
--    <TargetServer />
--  </TargetServerList>
--  <TargetServiceList>
--    <TargetService>UnitracBusinessService</TargetService>
--  </TargetServiceList>
--  <PredecessorProcessList>
--    <PredecessorProcess />
--  </PredecessorProcessList>
--  <LDAPServer>10.10.18.186</LDAPServer>
--  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
--  <LenderCode>2771</LenderCode>
--  <LenderList>
--    <LenderID IsEnabled="Y">1810</LenderID>
--  </LenderList>
--  <EscrowWorkItemId>25058800</EscrowWorkItemId>
--  <OriginatorWorkItemId>25058800</OriginatorWorkItemId>
--  <AnticipatedNextScheduledDate>1/1/0001 12:00:00 AM</AnticipatedNextScheduledDate>
--</ProcessDefinitionSettings>'
--WHERE ID = 180805



