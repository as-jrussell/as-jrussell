
USE UniTrac

update pd
set pd.SETTINGS_XML_IM = dp.SETTINGS_XML_IM
from PROCESS_DEFINITION pd
join UnitracHDStorage..INC0455298 dp on dp.id = pd.id



select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)')[AnticipatedNextScheduledDate],
* 
from PROCESS_DEFINITION
where id in (18335)
 