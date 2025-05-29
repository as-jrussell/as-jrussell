use unitrac 

--Run 1st
INSERT INTO PROCESS_DEFINITION (NAME_TX,DESCRIPTION_TX,EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,ONHOLD_IN,FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN)
SELECT 'Loan Document Process OneMain','Loan Document Process OneMain',EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,'N',GETDATE(),GETDATE(),'MsgSrvrEXTInfo',LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,'Y',FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN
FROM PROCESS_DEFINITION
WHERE ID = 696740


--Run 2nd
UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate />
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService>LDHONEMAIN</TargetService>
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <LenderList>
    <LenderID>4665</LenderID>
  </LenderList>
  <AnticipatedNextScheduledDate>7/8/2020 2:39:14 PM</AnticipatedNextScheduledDate>
</ProcessDefinitionSettings>', ACTIVE_IN = 'Y', ONHOLD_IN = 'N'
--SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID IN (SELECT MAX(ID) FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'LOANPRCPA' AND EXECUTION_FREQ_CD <> 'RUNONCE')


--Run 3rd
INSERT INTO CHANGE
(ENTITY_NAME_TX, ENTITY_ID, NOTE_TX, ticket_tx, user_tx, attachment_in, create_dt, agency_id, description_tx, details_in, formatted_in, lock_id, parent_name_tx, parent_id, TRANS_STATUS_CD, trans_status_dt)
SELECT  DISTINCT 'Allied.UniTrac.ProcessHelper.UniTracProcessDefinition', PD.ID, 'Created New Process Definition for ONEMAIN', 'CHG011995', 'CHG011995', 'N', GETDATE(),'1', 'Created New Process Definition for ONEMAIN', 'Y', 'Y','1','Osprey.ProcessMgr.ProcessDefinition', NULL, 'NEW', GETDATE()
FROM dbo.PROCESS_DEFINITION pd
WHERE ID IN (SELECT MAX(ID) FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'LOANPRCPA' AND EXECUTION_FREQ_CD <> 'RUNONCE')
