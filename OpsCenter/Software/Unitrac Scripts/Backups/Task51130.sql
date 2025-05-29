use unitrac

select
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[3]',
                                    'varchar(50)'), *

from process_definition pd
where id in (13633 )


select
 *
 into unitrachdstorage..Task51130
from process_definition pd
where id in (13633 )



update PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('insert <LenderID>7476</LenderID> into (/ProcessDefinitionSettings/LenderList)[1]')
where ID = 13633


insert into CHANGE
(ENTITY_NAME_TX, ENTITY_ID, NOTE_TX, ticket_tx, user_tx, attachment_in, create_dt, agency_id, description_tx, details_in, formatted_in, lock_id, parent_name_tx, parent_id, TRANS_STATUS_CD, trans_status_dt)
select 'Allied.UniTrac.ProcessHelper.UniTracProcessDefinition', '13633', 'New lender add: 7476', 'ticket #', 'ticket #', 'N', GEtDATE(),'1', 'New lender add: 7476', 'Y', 'Y','1','Osprey.ProcessMgr.ProcessDefinition', NULL, 'NEW', GETDATE()




select * from process_log
where process_definition_id = 13633 and update_dt >= '2019-12-09 14:00'

---Backout 
UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('delete (/ProcessDefinitionSettings/LenderList/LenderID)[3]')
where ID = 13633