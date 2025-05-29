use unitrac

declare @PDID bigint = '804205'
DECLARE @NextFullCycleDate nvarchar(25) = '06/21/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone  
DECLARE @Task nvarchar(15) = 'INC0430053'


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
where ID = @PDID




declare @PDID bigint = '804205'
DECLARE @LastFullCycleDate nvarchar(25) = '6/07/2019 3:00:41 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0430053'


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/LastFullCycleDate/text())[1] with sql:variable("@LastFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID



select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)'),
									SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)'),
									* from PROCESS_DEFINITION
where id in (804205)