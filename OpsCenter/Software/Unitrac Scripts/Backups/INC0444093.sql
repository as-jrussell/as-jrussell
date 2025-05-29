use UniTrac

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
 SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate] , status_cd,
* from PROCESS_DEFINITION
where id in (12649)


declare @PDID bigint = '12649'
DECLARE @NextFullCycleDate nvarchar(25) = '8/14/2019 12:15:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0444093'
 
 
update PROCESS_DEFINITION
set active_in = 'Y', ONHOLD_IN = 'N', EXECUTION_FREQ_CD = '14DAYS',
SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
where ID = @PDID
 
 
 
 
DECLARE @LastFullCycleDate nvarchar(25) = '07/31/2019 2:43:23 AM'  --remember to ensure that it is in the central time zone 
/*In addition to remembering that this is centeral time zone make sure that the last full cycle meets the time frame of the execution period, i.e. if its 14 days 
make sure the last time it last ran was 14 days previous to get an accurate full cycle run*/
 
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/LastFullCycleDate/text())[1] with sql:variable("@LastFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID
 

 DECLARE @newNextAnticipated nvarchar(25) = '8/14/2019 1:00:00 AM'  --remember to ensure that it is in the central time zone 

 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@newNextAnticipated")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID
--Verify what the Last Full Cycle Date, and Next Full Cycle Date  are 







select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
 SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate] , status_cd,
* from PROCESS_DEFINITION
where id in (12649)



select l.code_tx, l.name_tx,CONTENT_XML.value('(/Content/Cycle/CycleMode)[1]', 'varchar (50)') [Cycle Mode], wi.* 
from WORK_ITEM wi
join lender L on l.id = wi.lender_id
where CONTENT_XML.value('(/Content/Cycle/CycleMode)[1]', 'varchar (50)') = 'Full'
and l.code_tx = '6426'


use UniTrac

select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
 SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate] , status_cd,
* from PROCESS_DEFINITION
where id in (12649)


declare @PDID bigint = '12649'
DECLARE @NextFullCycleDate nvarchar(25) = '8/26/2019 12:15:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0444093'
 
 
update PROCESS_DEFINITION
set active_in = 'Y', ONHOLD_IN = 'N', EXECUTION_FREQ_CD = 'SEMIMONTH',
SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
where ID = @PDID
 
 
 
 
DECLARE @LastFullCycleDate nvarchar(25) = '08/11/2019 2:43:23 AM'  --remember to ensure that it is in the central time zone 
/*In addition to remembering that this is centeral time zone make sure that the last full cycle meets the time frame of the execution period, i.e. if its 14 days 
make sure the last time it last ran was 14 days previous to get an accurate full cycle run*/
 
 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/LastFullCycleDate/text())[1] with sql:variable("@LastFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID
 

 DECLARE @newNextAnticipated nvarchar(25) = '8/15/2019 1:00:00 AM'  --remember to ensure that it is in the central time zone 

 
update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@newNextAnticipated")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID
--Verify what the Last Full Cycle Date, and Next Full Cycle Date  are 


Select l.* from property p
join collateral c on c.property_id = p.id
join loan l on l.id = c.loan_id
where VIN_TX = 'SAJWA2GE1BMV01951'  




select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)') [NextFullCycleDate] ,
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
 SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate] , status_cd,
* from PROCESS_DEFINITION
where id in (12649)



