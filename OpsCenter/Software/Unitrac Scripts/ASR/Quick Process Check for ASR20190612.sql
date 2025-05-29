use unitrac


SELECT 
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate],
									SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LastFullCycleDate)[1]',
                                    'varchar(50)')[LastFullCycleDate],
 *, SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/ServiceCapabilityList/ServiceCapability)[1]', 'nvarchar(max)'),
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/ServiceCapabilityList/ServiceCapability)[2]', 'nvarchar(max)'), SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] 
	 
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N' AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) >= '2019-06-25 20:00' and  EXECUTION_FREQ_CD <> 'RUNONCE'
	AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)') AS DATETIME)<= '2019-06-26 20:00'
        AND ACTIVE_IN = 'Y' and proc_target_service_name_tx = '//UNITRAC/UBSReadyToExecuteService'
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC


									select COUNT(*), process_type_cd 
										 
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N' AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) >= '2019-06-26 20:00' and  EXECUTION_FREQ_CD <> 'RUNONCE'
	AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)') AS DATETIME)<= '2019-06-27 20:00'
        AND ACTIVE_IN = 'Y' and proc_target_service_name_tx = '//UNITRAC/UBSReadyToExecuteService'
									group by process_type_cd




select ref_cd [Process Type], rc.meaning_tx [Process Meaning], rc.description_tx [Process Description], CONVERT(INT, rca.value_tx)
from ref_code_attribute rca
join ref_code rc on rca.ref_cd = rc.code_cd and rc.domain_cd = 'ProcessType'
where rca.domain_cd = 'ProcessType'
AND ATTRIBUTE_CD = 'PROCESS_Q_PRIORITY_DEFAULT'
ORDER BY CONVERT(INT, rca.value_tx)  ASC
--13845

									
select pd.name_tx,  pd.PROCESS_TYPE_CD, pl.*
from process_log pl
join process_definition pd on pd.id = pl.PROCESS_DEFINITION_id
where pl.update_dt >= '2019-10-31 13:00'
								
								and service_name_tx like 'UnitracBusinessServiceProc%'
								--and pd.name_tx not like '%runonce%'
									order by pl.update_dt desc


select MAX(pl.UPDATE_DT), MAX(pl.ID)
from process_log pl
join process_definition pd on pd.id = pl.PROCESS_DEFINITION_id
where SERVER_TX = 'UTQA2-ASR3'
								--and pd.name_tx not like '%runonce%'
									order by pl.update_dt desc


select * from process_log
where id in (77688090)

SELECT
        pd.PROCESS_TYPE_CD, pd.PROC_PRIORITY_NO,  pd.ONHOLD_IN, COUNT(*) AS CountOfProcesses
FROM dbo.UBSReadyToExecuteQueue AS t1
JOIN sys.conversation_endpoints ce ON t1.conversation_handle = ce.conversation_handle
JOIN PROCESS_DEFINITION pd on pd.ID =  (SELECT
                CAST(MESSAGE_BODY AS XML).value(N'(/MsgRoot/Id/node())[1]', N'bigint')
                FROM dbo.UBSReadyToExecuteQueue t2 WHERE t2.CONVERSATION_HANDLE = t1.CONVERSATION_HANDLE
        )
              GROUP BY pd.PROCESS_TYPE_CD, pd.PROC_PRIORITY_NO, pd.ONHOLD_IN
              ORDER BY PROC_PRIORITY_NO, COUNT(*)



			  SELECT CODE_CD, MEANING_TX 
FROM REF_CODE rc
WHERE rc.DOMAIN_CD = 'ServiceCapability'
ORDER by rc.CODE_CD

			  
