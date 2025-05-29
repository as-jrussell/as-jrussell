use unitrac


--declare @PDID bigint = ''
DECLARE @newNextAnticipated nvarchar(25) = '4/8/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0410894'


update pd
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@newNextAnticipated")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
--select *
from process_definition pd
join unitrachdstorage..INC0410894 c on c.[Process ID ] = pd.id
where id in (12513)