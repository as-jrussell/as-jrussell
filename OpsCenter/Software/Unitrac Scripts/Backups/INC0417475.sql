use unitrac

select *
into UniTracHDStorage..INC0417475 
 from work_item
where id in (53692699)



------ Reopen Example for Cycle Process Work Item
----REPLACE XXXXXXX WITH THE THE WI ID
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Initial' ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0417475'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0417475 )
        AND WORKFLOW_DEFINITION_ID = 9
        AND ACTIVE_IN = 'Y'


select * from process_definition
where name_tx like '%3551%'
and process_type_cd = 'CYCLEPRC'


select * from process_log
where process_definition_id in (499298)
and update_dt >= '2019-05-01'


select * from work_item
where id in (53715914)

select * from work_item_action
where work_item_id = 53715914


select * from process_log
where id in (71940177)

select count(*), relate_type_cd from process_log_item
where process_log_id = 71964937
group by relate_type_cd
--499298


select * from PROCESS_DEFINITION
where id in (499298)

declare @PDID bigint = '499298'
DECLARE @newNextAnticipated nvarchar(25) = '05/01/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0417475'


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@newNextAnticipated")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID