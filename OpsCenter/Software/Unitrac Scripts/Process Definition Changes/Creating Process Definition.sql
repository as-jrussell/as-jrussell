/*


INSERT INTO PROCESS_DEFINITION (NAME_TX,DESCRIPTION_TX,EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,ONHOLD_IN,FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN)
SELECT 'LFP Message Server Info Extract','Informatica Extract Instance of Message Server',EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,'N',GETDATE(),GETDATE(),'MsgSrvrEXTInfo',LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,'Y',FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN
FROM PROCESS_DEFINITION
WHERE ID = 7920

UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate>9/9/2012 5:09:08 AM</LastProcessedDate>
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService>MSGSRVREXTINFO</TargetService>
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <SupportedTPTypes>
    <TPType FileType="IMPORT">LFP_TP</TPType>
  </SupportedTPTypes>
  <LenderList>
    <LenderID>0000</LenderID>
  </LenderList>
  <AnticipatedNextScheduledDate>7/24/2015 9:51:28 AM</AnticipatedNextScheduledDate>
</ProcessDefinitionSettings>'
WHERE ID = 199525


*/


