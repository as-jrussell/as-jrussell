USE UNITRAC

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)')[AnticipatedNextScheduledDate],
* from PROCESS_DEFINITION
where id in (828830)
 

 

declare @PDID bigint = '828830'
DECLARE @NextFullCycleDate nvarchar(25) = '9/16/2019 12:10:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0452714'
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
where ID = @PDID
 
 
 
 
DECLARE @LastFullCycleDate nvarchar(25) = '9/14/2019 2:00:24 AM'  --remember to ensure that it is in the central time zone 
/*In addition to remembering that this is centeral time zone make sure that the last full cycle meets the time frame of the execution period, i.e. if its 14 days 
make sure the last time it last ran was 14 days previous to get an accurate full cycle run*/
 
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/LastFullCycleDate/text())[1] with sql:variable("@LastFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1, EXECUTION_FREQ_CD = 'DAY'
where ID = @PDID





 
--Verify what the Last Full Cycle Date, and Next Full Cycle Date  are 

 

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)')[AnticipatedNextScheduledDate],
* from PROCESS_DEFINITION
where id in (828830)


select * from process_log
where process_definition_id = 828830
and update_dt >= '2019-09-15'


select * from work_item
where relate_id = 76699034
and workflow_definition_id = 9


---
insert into CHANGE
(ENTITY_NAME_TX, ENTITY_ID, NOTE_TX, ticket_tx, user_tx, attachment_in, create_dt, agency_id, description_tx, details_in, formatted_in, lock_id, parent_name_tx, parent_id, TRANS_STATUS_CD, trans_status_dt)
select 'Allied.UniTrac.ProcessHelper.UniTracProcessDefinition', '828830', 'Force to run to get full cycle', 'INC0452714', 'INC0452714', 'N', GEtDATE(),'1', 'Force to run to get full cycle', 'Y', 'Y','1','Osprey.ProcessMgr.ProcessDefinition', NULL, 'NEW', GETDATE()



select * from PROCESS_LOG
where process_definition_id = 'Process Definition ID #'
AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)



--Pulls Full Cycle work items

select l.code_tx, l.name_tx,CONTENT_XML.value('(/Content/Cycle/CycleMode)[1]', 'varchar (50)') [Cycle Mode], wi.* 
from WORK_ITEM wi
join lender L on l.id = wi.lender_id
where CONTENT_XML.value('(/Content/Cycle/CycleMode)[1]', 'varchar (50)') is not null
and l.code_tx = '2442'
order by update_dt desc



insert into CHANGE
(ENTITY_NAME_TX, ENTITY_ID, NOTE_TX, ticket_tx, user_tx, attachment_in, create_dt, agency_id, description_tx, details_in, formatted_in, lock_id, parent_name_tx, parent_id, TRANS_STATUS_CD, trans_status_dt)
select 'Allied.UniTrac.ProcessHelper.UniTracProcessDefinition', '828830', 'Changed: Update per user settings from ticket', 'INC0452714', 'INC0452714',  'N', GEtDATE(),'1', 'Changed: Update per user settings from ticket', 'Y', 'Y','1','Osprey.ProcessMgr.ProcessDefinition', NULL, 'NEW', GETDATE()





select * from change c
--join change_update cu on c.id = cu.change_id
where entity_name_tx = 'Allied.UniTrac.ProcessHelper.UniTracProcessDefinition'
and ENTITY_ID = 828830