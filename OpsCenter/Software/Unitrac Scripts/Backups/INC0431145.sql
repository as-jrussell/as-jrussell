select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
* from PROCESS_DEFINITION
where id in (14103)
 
 

 

declare @PDID bigint = '14103'
DECLARE @NextFullCycleDate nvarchar(25) = '7/4/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0431145'
 
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
where ID = @PDID
 
 
 
 
DECLARE @LastFullCycleDate nvarchar(25) = '6/20/2019 1:52:47 PM'  --remember to ensure that it is in the central time zone 
 
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/LastFullCycleDate/text())[1] with sql:variable("@LastFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID
 


 
--Verify what the Last Full Cycle Date, and Next Full Cycle Date  are 

 

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
* from PROCESS_DEFINITION
where id in (XXXX)