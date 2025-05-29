use utl



--select * from users

insert USERS (USER_NAME_TX, PASSWORD_TX, FAMILY_NAME_TX, GIVEN_NAME_TX, ACTIVE_IN, EMAIL_TX, EXTERN_MAINT_IN, LOGIN_COUNT_NO, LAST_LOGIN_DT, CREATE_DT, UPDATE_DT, PURGE_DT, UPDATE_USER_TX, LOCK_ID, DEFAULT_AGENCY_ID, SYSTEM_IN)
select USER_NAME_TX, PASSWORD_TX, FAMILY_NAME_TX, GIVEN_NAME_TX, ACTIVE_IN, EMAIL_TX, EXTERN_MAINT_IN, LOGIN_COUNT_NO, LAST_LOGIN_DT, CREATE_DT, UPDATE_DT, PURGE_DT, UPDATE_USER_TX, LOCK_ID, DEFAULT_AGENCY_ID, SYSTEM_IN
from [unitrac-DB01].[Unitrac].[dbo].USERS
where 
user_name_tx IN ('UTLMatch',
'UTLRematchRepoPlus',
'UTLRematchMidSizeLenders',
'UTLRematchDefault',
'UTLMatch2',
'UTLRematchWF', 'UTLRematchAdhoc' )





INSERT INTO PROCESS_DEFINITION (NAME_TX,DESCRIPTION_TX,EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,ONHOLD_IN,FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN)
SELECT 'UTL 2.0 Rematch: Adhoc','UTL 2.0 Rematch: Adhoc',EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,ONHOLD_IN,FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN
FROM PROCESS_DEFINITION
WHERE ID = 711281

UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate />
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService>UTLRematchAdhoc</TargetService>
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <LDAPServer>10.10.18.186</LDAPServer>
  <LDAPPath>ou=groups,ou=internal,dc=as,dc=net</LDAPPath>
  <AnticipatedNextScheduledDate>7/27/2018 5:48:07 AM</AnticipatedNextScheduledDate>
  <LenderList>
    <LenderID LastProcessed="1/1/0001 12:00:00 AM" ManualLender="N" IsEnabled="Y">USDTEST1</LenderID>
  </LenderList>
  <ServiceCapabilityList>
    <SystemRamInGB />
    <SystemProcessorCount />
  </ServiceCapabilityList>
  <PurgeUTL>Y</PurgeUTL>
</ProcessDefinitionSettings>'
WHERE ID = 776632