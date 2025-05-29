use unitrac

declare @PDID bigint = '7274'
DECLARE @NextFullCycleDate nvarchar(25) = '06/09/2019 1:45:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0426133'


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID



select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)'),
									* from PROCESS_DEFINITION
where id in (7274)