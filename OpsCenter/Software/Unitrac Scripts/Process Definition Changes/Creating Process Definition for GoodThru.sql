USE Unitrac





INSERT dbo.PROCESS_DEFINITION (   NAME_TX ,
                                       DESCRIPTION_TX ,
                                       EXECUTION_FREQ_CD ,
                                       PROCESS_TYPE_CD ,
                                       PRIORITY_NO ,
                                       ACTIVE_IN ,
                                       CREATE_DT ,
                                       UPDATE_DT ,
                                       UPDATE_USER_TX ,
                                       LOCK_ID ,
                                       SETTINGS_XML_IM ,
                                       INCLUDE_WEEKENDS_IN ,
                                       INCLUDE_HOLIDAYS_IN ,
                                       DAYS_OF_WEEK_XML ,
                                       LAST_SCHEDULED_DT ,
                                       OVERRIDE_DT ,
                                       SCHEDULE_GROUP ,
                                       STATUS_CD ,
                                       ONHOLD_IN ,
                                       FREQ_MULTIPLIER_NO ,
                                       CHECKED_OUT_OWNER_ID ,
                                       CHECKED_OUT_DT ,
                                       LAST_RUN_DT ,
                                       USE_LAST_SCHEDULED_DT_IN ,
                                       PURGE_DT ,
                                       LOAD_BALANCE_IN ,
                                       PROC_TARGET_SERVICE_NAME_TX ,
                                       PROC_PRIORITY_NO ,
                                       LAST_PROCESS_HEARTBEAT_DT ,
                                       CONVERSATION_HANDLE_GUID
                                   )
VALUES (   N'GoodThru Lender XXXX' ,       -- NAME_TX - nvarchar(100)
           N'GoodThru Lender XXXX' ,       -- DESCRIPTION_TX - nvarchar(2000)
           N'10MINUTE' ,       -- EXECUTION_FREQ_CD - nvarchar(10)
           N'GOODTHRUDT' ,       -- PROCESS_TYPE_CD - nvarchar(10)
           1 ,         -- PRIORITY_NO - int
           'Y' ,        -- ACTIVE_IN - char(1)
           GETDATE() , -- CREATE_DT - datetime
           GETDATE() , -- UPDATE_DT - datetime
           N'UBSDist' ,       -- UPDATE_USER_TX - nvarchar(15)
           1 ,      -- LOCK_ID - numeric(4, 0)
           '<ProcessDefinitionSettings>
  <LastProcessedDate />
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService />
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <LDAPServer>10.10.18.186</LDAPServer>
  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
  <LenderListThrottle>10</LenderListThrottle>
  <AnticipatedNextScheduledDate>8/27/2017 5:26:39 PM</AnticipatedNextScheduledDate>
  <LenderList>
    <LenderID LastProcessed="1/1/2000 5:20:31 PM">XXXX</LenderID>
  </LenderList>
  <ServiceCapabilityList>
    <ServiceCapability>RAMSMALL</ServiceCapability>
    <ServiceCapability>CPUSMALL</ServiceCapability>
  </ServiceCapabilityList>
</ProcessDefinitionSettings>' ,      -- SETTINGS_XML_IM - xml
           'Y' ,        -- INCLUDE_WEEKENDS_IN - char(1)
           'Y' ,        -- INCLUDE_HOLIDAYS_IN - char(1)
           NULL ,      -- DAYS_OF_WEEK_XML - xml
           GETDATE() , -- LAST_SCHEDULED_DT - datetime
           GETDATE() , -- OVERRIDE_DT - datetime
           0 ,         -- SCHEDULE_GROUP - bigint
           N'Complete' ,       -- STATUS_CD - nvarchar(10)
           'N' ,        -- ONHOLD_IN - char(1)
           1 ,         -- FREQ_MULTIPLIER_NO - int
           NULL ,         -- CHECKED_OUT_OWNER_ID - bigint
           GETDATE() , -- CHECKED_OUT_DT - datetime
           GETDATE() , -- LAST_RUN_DT - datetime
           'Y' ,        -- USE_LAST_SCHEDULED_DT_IN - char(1)
           NULL , -- PURGE_DT - datetime
           'Y' ,        -- LOAD_BALANCE_IN - char(1)
           N'//UNITRAC/UBSReadyToExecuteService' ,       -- PROC_TARGET_SERVICE_NAME_TX - nvarchar(100)
           50 ,         -- PROC_PRIORITY_NO - int
           GETDATE() , -- LAST_PROCESS_HEARTBEAT_DT - datetime
           NULL        -- CONVERSATION_HANDLE_GUID - uniqueidentifier
       )