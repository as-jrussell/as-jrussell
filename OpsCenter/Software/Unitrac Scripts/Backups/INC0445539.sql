USE UNITRAC

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
									SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate] ,
* from PROCESS_DEFINITION
where id in (804205)
 
 

 

declare @PDID bigint = '804205'
DECLARE @NextFullCycleDate nvarchar(25) = '08/16/2019 12:10:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'Ticket Number #'
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
where ID = @PDID
 
 
 
 
DECLARE @LastFullCycleDate nvarchar(25) = '8/2/2019 1:37:06 PM'  --remember to ensure that it is in the central time zone 
/*In addition to remembering that this is centeral time zone make sure that the last full cycle meets the time frame of the execution period, i.e. if its 14 days 
make sure the last time it last ran was 14 days previous to get an accurate full cycle run*/
 
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/LastFullCycleDate/text())[1] with sql:variable("@LastFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID
 


DECLARE @newNextAnticipated nvarchar(25) = '8/16/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone 


 update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@newNextAnticipated")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID
--Verify what the Last Full Cycle Date, and Next Full Cycle Date  are 
--8/19/2019 12:10:00 AM

 
--Verify what the Last Full Cycle Date, and Next Full Cycle Date  are 

 

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate] ,
* from PROCESS_DEFINITION
where id in (804205)

