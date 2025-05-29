--Backup Cycle Processes
select CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime)[AnticipatedNextScheduledDate],
CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]','varchar(50)')AS DateTime)[NextFullCycleDate],
* INTO UnitracHDStorage.dbo.PROCESS_DEFINITION_08_03_2019
from PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD IN ('CYCLEPRC') and ONHOLD_IN = 'N' and ACTIVE_IN = 'Y' AND EXECUTION_FREQ_CD <> 'RUNONCE' AND LOAD_BALANCE_IN = 'Y'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime) >= '2019-08-03 00:00:00.000'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime) <= '2019-08-03 11:59:00.000'

--1) Update 12:30 AnticipatedNextScheduledDate

--SET QUOTED_IDENTIFIER OFF

declare @tonight datetime = DATEADD(MINUTE,0,'2019-08-03 00:10:00.000')

UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@tonight")'),LOCK_ID = LOCK_ID + 1
--select CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime),* from PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD IN ('CYCLEPRC') and ONHOLD_IN = 'N' and ACTIVE_IN = 'Y' AND EXECUTION_FREQ_CD <> 'RUNONCE' AND LOAD_BALANCE_IN = 'Y'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime) = '2019-08-03 00:30:00.000'
--199

--SET QUOTED_IDENTIFIER ON



--2) Update 12:30 NextFullCycleDate

--SET QUOTED_IDENTIFIER OFF

declare @tonight2 datetime = DATEADD(MINUTE,0,'2019-08-03 00:10:00.000')

UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@tonight2")'), LOCK_ID = LOCK_ID + 1
--select CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]','varchar(50)')AS DateTime),* from PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD IN ('CYCLEPRC') and ONHOLD_IN = 'N' and ACTIVE_IN = 'Y' AND EXECUTION_FREQ_CD <> 'RUNONCE' AND LOAD_BALANCE_IN = 'Y'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]','varchar(50)')AS DateTime) = '2019-08-03 00:30:00.000'
--199

--SET QUOTED_IDENTIFIER ON

--3) Update 12:30 TimeOfDay

UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TimeOfDay/text())[1] with "00:10:00"'),LOCK_ID = LOCK_ID + 1
--select CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TimeOfDay)[1]','varchar(50)')AS DateTime),* from PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD IN ('CYCLEPRC') and ONHOLD_IN = 'N' and ACTIVE_IN = 'Y' AND EXECUTION_FREQ_CD <> 'RUNONCE' AND LOAD_BALANCE_IN = 'Y'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TimeOfDay)[1]','varchar(50)')AS DateTime) = '1900-01-01 00:30:00.000'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime) = '2019-08-03 00:10:00.000'



--4) Update 12:45 AnticipatedNextScheduledDate

--SET QUOTED_IDENTIFIER OFF

declare @tonight datetime = DATEADD(MINUTE,0,'2019-08-03 00:15:00.000')

UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with sql:variable("@tonight")'),LOCK_ID = LOCK_ID + 1
--select CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime),* from PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD IN ('CYCLEPRC') and ONHOLD_IN = 'N' and ACTIVE_IN = 'Y' AND EXECUTION_FREQ_CD <> 'RUNONCE' AND LOAD_BALANCE_IN = 'Y'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime) = '2019-08-03 00:45:00.000'
--199

--SET QUOTED_IDENTIFIER ON



--5) Update 12:45 NextFullCycleDate

--SET QUOTED_IDENTIFIER OFF

declare @tonight2 datetime = DATEADD(MINUTE,0,'2019-08-03 00:15:00.000')

UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@tonight2")'), LOCK_ID = LOCK_ID + 1
--select CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]','varchar(50)')AS DateTime),* from PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD IN ('CYCLEPRC') and ONHOLD_IN = 'N' and ACTIVE_IN = 'Y' AND EXECUTION_FREQ_CD <> 'RUNONCE' AND LOAD_BALANCE_IN = 'Y'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]','varchar(50)')AS DateTime) = '2019-08-03 00:45:00.000'
--199

--SET QUOTED_IDENTIFIER ON



--6) Update 12:45 TimeOfDay


UPDATE PROCESS_DEFINITION
SET SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TimeOfDay/text())[1] with "00:15:00"'),LOCK_ID = LOCK_ID + 1
--select CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TimeOfDay)[1]','varchar(50)')AS DateTime),* from PROCESS_DEFINITION
WHERE   PROCESS_TYPE_CD IN ('CYCLEPRC') and ONHOLD_IN = 'N' and ACTIVE_IN = 'Y' AND EXECUTION_FREQ_CD <> 'RUNONCE' AND LOAD_BALANCE_IN = 'Y'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TimeOfDay)[1]','varchar(50)')AS DateTime) = '1900-01-01 00:45:00.000'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime) = '2019-08-03 00:15:00.000'


