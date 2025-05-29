USE UNITRAC

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)')[AnticipatedNextScheduledDate],
* 
into UnitracHDStorage..INC0454545
from PROCESS_DEFINITION
where id in (82796)
 



 

declare @PDID bigint = '82796'
DECLARE @NextFullCycleDate nvarchar(25) = '10/30/2019 12:15:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0454545'
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
where ID = @PDID
 
 
 
 
DECLARE @LastFullCycleDate nvarchar(25) = '9/19/2019 3:01:12 AM'  --remember to ensure that it is in the central time zone 
/*In addition to remembering that this is centeral time zone make sure that the last full cycle meets the time frame of the execution period, i.e. if its 14 days 
make sure the last time it last ran was 14 days previous to get an accurate full cycle run*/
 
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/LastFullCycleDate/text())[1] with sql:variable("@LastFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID



DECLARE @newNextAnticipated nvarchar(25) = '9/21/2019 12:15:00 AM'  --remember to ensure that it is in the central time zone 

 update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@newNextAnticipated")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID
--Verify what the Last Full Cycle Date, and Next Full Cycle Date  are 


 
--Verify what the Last Full Cycle Date, and Next Full Cycle Date  are 

 

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)')[AnticipatedNextScheduledDate],
* from PROCESS_DEFINITION
where id in (82796)







---
insert into CHANGE
(ENTITY_NAME_TX, ENTITY_ID, NOTE_TX, ticket_tx, user_tx, attachment_in, create_dt, agency_id, description_tx, details_in, formatted_in, lock_id, parent_name_tx, parent_id, TRANS_STATUS_CD, trans_status_dt)
select 'Allied.UniTrac.ProcessHelper.UniTracProcessDefinition', '82796', 'Setting per user standards', 'INC0454545', 'INC0454545', 'N', GEtDATE(),'1', 'Setting per user standards', 'Y', 'Y','1','Osprey.ProcessMgr.ProcessDefinition', NULL, 'NEW', GETDATE()



select * from PROCESS_LOG
where process_definition_id = '82796'
AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)



--Pulls Full Cycle work items

select l.code_tx, l.name_tx,CONTENT_XML.value('(/Content/Cycle/CycleMode)[1]', 'varchar (50)') [Cycle Mode], wi.* 
from WORK_ITEM wi
join lender L on l.id = wi.lender_id
where CONTENT_XML.value('(/Content/Cycle/CycleMode)[1]', 'varchar (50)') is not null
and l.code_tx = '6614'
order by update_dt desc





