--Processes Setup for ASR
SELECT *
FROM PROCESS_DEFINITION
WHERE LOAD_BALANCE_IN = 'Y'

--Processes Setup for ASR (Alternate Query)
SELECT *
FROM PROCESS_DEFINITION
WHERE PROC_TARGET_SERVICE_NAME_TX = '//UNITRAC/UBSReadyToExecuteService'


--SP executed by Distributor
exec ENQUEUE_WORK

--Query to Manually Enqueue Work:

exec ENQUEUE_WORK @processDefinitionId=461020,@capabilityRequirements=17,@targetServiceName='//UNITRAC/UBSReadyToExecuteService',@updateUser='UBSDist'


--Processes by Next Scheduled Date
SELECT CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime) ,P.*
FROM    PROCESS_DEFINITION P
        JOIN dbo.LENDER L ON L.ID = p.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]','INT')
WHERE   (PROCESS_TYPE_CD IN ('CYCLEPRC' ,'ESCROW') OR (PROCESS_TYPE_CD IN ('BILLING') AND SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/CancelRefund)[1]','varchar(10)') = 'Y'))
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS Date) <> '0001-01-01'
        AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime) >= '2017-04-06 10:00:00'
       AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)')AS DateTime) <= '2017-04-07 10:00:00'
and P.ONHOLD_IN = 'N' AND AGENCY_ID = 1
--233

--Query to pull back work being done by each ASR service
SELECT COUNT(PL.ID), pd.process_type_cd, pl.status_cd
FROM PROCESS_LOG pl
join PROCESS_DEFINITION pd on pd.id = pl.process_definition_id
WHERE PL.UPDATE_USER_TX IN ('UBSDist','UBSProc1','UBSProc2','UBSProc4','UBSProc5','UBSProc6','UBSProc7')
and PL.start_dt >= '2019-07-15 00:00:01'
and PL.STATUS_CD = 'Error'
group by pd.process_type_cd, pl.status_cd


begin tran

update pd set sending_trading_partner_id = 0
--select * 
from message pd
where id in (1000000)


commit


select *FROM PROCESS_LOG pl
join PROCESS_DEFINITION pd on pd.id = pl.process_definition_id
WHERE PL.UPDATE_USER_TX IN ('UBSDist','UBSProc1','UBSProc2','UBSProc4','UBSProc5','UBSProc6','UBSProc7')
and PL.start_dt >= '2019-07-15 00:00:01'
and PL.STATUS_CD = 'Error'
order by pl.update_dt desc

SELECT *
FROM PROCESS_LOG pl
join PROCESS_DEFINITION pd on pd.id = pl.process_definition_id
WHERE PL.UPDATE_USER_TX IN ('UBSDist','UBSProc1','UBSProc2','UBSProc4','UBSProc5','UBSProc6','UBSProc7')
--pl.server_tx like 'UTQA2-ASR%'
and PL.start_dt >= '2019-07-31' 
order by pl.update_dt desc

SELECT COUNT(PL.ID), pd.process_type_cd, pl.status_cd, MIN(PL.UPDATE_DT) 
  from process_log pl
  join PROCESS_DEFINITION pd on pd.id = pl.process_definition_id
where msg_tx = 'GetAnticipatedNextRunDateTime, LastScheduledDate cannot be calculated, Reached the Threshold'
and 
PL.UPDATE_USER_TX IN ('UBSDist')
and PL.start_dt >= '2019-06-01 00:00:01'
and PL.STATUS_CD = 'Error'
group by pd.process_type_cd, pl.status_cd



--Server/Service Capabilities

SELECT * 
FROM REF_CODE rc
WHERE rc.DOMAIN_CD = 'ServiceCapability'
ORDER by rc.CODE_CD

UTPROD-ASR1 - 2CPU/4GBRAM	UBSDist		(SMALL)
UTPROD-ASR2 - 4CPU/8GBRAM	UBSProc1	(MEDIUM)
UTPROD-ASR3 - 4CPU/8GBRAM	UBSProc2	(MEDIUM)
UTPROD-ASR4 - 4CPU/8GBRAM	UBSProc4	(MEDIUM)
UTPROD-ASR5 - 4CPU/8GBRAM	UBSProc5	(MEDIUM)
UTPROD-ASR6 - 8CPU/32GBRAM	UBSProc6	(LARGE)
UTPROD-ASR7 - 4CPU/8GBRAM	UBSProc7	(MEDIUM)

UTQA2-ASR1 - 2CPU/4GBRAM	UBSProc1	(SMALL)
UTQA2-ASR2 - 4CPU/8GBRAM	UBSProc2	(MEDIUM)
UTQA2-ASR3 - 2CPU/4GBRAM	UBSProc3	(SMALL)

UTSTAGE-ASR1 - 2CPU/4GBRAM	UBSProc1	(SMALL)
UTSTAGE-ASR2 - 4CPU/8GBRAM	UBSProc2	(MEDIUM)
UTSTAGE-ASR3 - 2CPU/4GBRAM	UBSProc3	(SMALL)



--Processes Being Worked

SELECT SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/ServiceCapabilityList/ServiceCapability)[1]', 'nvarchar(max)'), PROCESS_LOG.START_DT, PROCESS_LOG.END_DT, PROCESS_LOG.STATUS_CD, PROCESS_LOG.MSG_TX,
PROCESS_LOG.UPDATE_USER_TX, PROCESS_LOG.SERVER_TX, PROCESS_LOG.SERVICE_NAME_TX,PROCESS_DEFINITION.*
FROM PROCESS_DEFINITION 
INNER JOIN PROCESS_LOG ON PROCESS_DEFINITION.ID = PROCESS_LOG.PROCESS_DEFINITION_ID
WHERE PROCESS_DEFINITION.id in (SELECT PROCESS_DEFINITION_ID
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (SELECT ID FROM PROCESS_DEFINITION WHERE PROC_TARGET_SERVICE_NAME_TX = '//UNITRAC/UBSReadyToExecuteService')
AND START_DT >= '2017-07-10 00:00:01' and update_user_tx like 'UBSProc%' AND STATUS_CD in ('Expired','InProcess','Complete')) AND PROCESS_LOG.UPDATE_USER_TX <> 'UBSDist'
ORDER BY PROCESS_LOG.START_DT DESC




--Processes Upcoming:

SELECT SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/ServiceCapabilityList/ServiceCapability)[1]', 'nvarchar(max)'),
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/ServiceCapabilityList/ServiceCapability)[2]', 'nvarchar(max)'),
* 
FROM PROCESS_DEFINITION WHERE PROC_TARGET_SERVICE_NAME_TX = '//UNITRAC/UBSReadyToExecuteService'
AND ACTIVE_IN = 'Y' and status_cd = 'InQueue'


