use unitrac


declare @PDID bigint = '15307'
DECLARE @newNextAnticipated nvarchar(25) = '05/18/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0419104'


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@newNextAnticipated")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID