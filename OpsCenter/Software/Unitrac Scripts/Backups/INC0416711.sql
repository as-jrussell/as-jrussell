use unitrac


--declare @PDID bigint = ''
DECLARE @newNextAnticipated nvarchar(25) = '05/20/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0416711'


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@newNextAnticipated")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID IN(18335, 12140, 8944, 12680)