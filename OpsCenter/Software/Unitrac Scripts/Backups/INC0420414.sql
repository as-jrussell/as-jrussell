use unitrac


declare @PDID bigint = '499298'
DECLARE @newNextAnticipated nvarchar(25) = '5/17/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0420414'


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@newNextAnticipated")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID


exec UT_HomeStreet_Processes




SELECT  
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate],
 name_tx from process_definition
where EXECUTION_FREQ_CD = 'DAY' and process_type_cd = 'CYCLEPRC' and name_tx like '%3551 %'


select * from process_log
where process_definition_id = 499298
and update_dt >= '2019-05-16'

select * from work_item
where relate_id = 72429317 