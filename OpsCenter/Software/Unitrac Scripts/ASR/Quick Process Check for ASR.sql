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
                                    'varchar(50)') AS DATETIME) >= '2019-06-12 20:00' and  EXECUTION_FREQ_CD <> 'RUNONCE' and process_type_cd = 'CYCLEPRC'
	AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)') AS DATETIME)<= '2019-06-13 20:00'
        AND ACTIVE_IN = 'Y' and proc_target_service_name_tx = '//UNITRAC/UBSReadyToExecuteService'
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC


1:55


590663
646989

select *
from process_log
									where update_dt >= '2019-06-12 13:00' and UPDATE_DT <= '2019-06-12 14:00'
									and SERVER_TX like 'UTPROD-ASR4' --and status_cd = 'InProcess'

--13845
									
select *
from process_log
									where update_dt >= '2019-06-11 14:40' and UPDATE_DT <= '2019-06-11 14:59'
									and SERVER_TX like 'UTPROD-ASR3'


									select count(*), service_name_tx from process_log
									where update_dt >= '2019-06-12 13:00' --and UPDATE_DT <= '2019-06-12 07:00'
									and SERVER_TX like 'UTPROD-ASR%'-- and end_dt is not null
									group by service_name_tx



SELECT CONVERT(Month,pl.update_dt) AS [Process Log Create Date], COUNT(pl.id) [Cycles]
from process_log
where update_dt >= '2019-06-12 13:00' 
and SERVER_TX like 'UTPROD-ASR%'
group by service_name_tx




--06/12
189	UnitracBusinessServiceProc1
210	UnitracBusinessServiceProc2
125	UnitracBusinessServiceProc4
118	UnitracBusinessServiceProc5
246	UnitracBusinessServiceProc6
218	UnitracBusinessServiceProc7



--06/11
4	UnitracBusinessServiceProc2
193	UnitracBusinessServiceProc1
177	UnitracBusinessServiceProc4
209	UnitracBusinessServiceProc5
206	UnitracBusinessServiceProc6
227	UnitracBusinessServiceProc7


--06/09
44	UnitracBusinessServiceProc4
15	UnitracBusinessServiceProc5
298	UnitracBusinessServiceProc1
319	UnitracBusinessServiceProc2
345	UnitracBusinessServiceProc6
340	UnitracBusinessServiceProc7



SELECT 
SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [Next Schedule Date],*
into #tmpPD
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N' AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)') AS DATETIME) >= '2019-06-12 20:00' 
and  EXECUTION_FREQ_CD <> 'RUNONCE'
AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)') AS DATETIME)<= '2019-07-01 08:00'
AND ACTIVE_IN = 'Y' and proc_target_service_name_tx = '//UNITRAC/UBSReadyToExecuteService'


select * from #tmpPD

SELECT convert(date,[Next Schedule Date]) AS [Process Date], count(*) , p.process_type_cd
FROM    PROCESS_DEFINITION P 
join #tmpPD PD on P.ID = PD.ID
WHERE   P.ONHOLD_IN = 'N' AND CAST(p.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)') AS DATETIME) >= '2019-06-12 20:00' 
and  p.EXECUTION_FREQ_CD <> 'RUNONCE'
--AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]','varchar(50)') AS DATETIME)<= '2019-06-13 08:00'
AND p.ACTIVE_IN = 'Y' and p.proc_target_service_name_tx = '//UNITRAC/UBSReadyToExecuteService'
							   group by p.process_type_cd , convert(date,[Next Schedule Date])


							   
SELECT CONVERT(Month,pl.update_dt) AS [Process Log Create Date], COUNT(pl.id) [Cycles]



