---Search for all process by Service
--USE UniTrac


select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate],
 SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') , pd.update_dt,
							  * 
							-- into #tmp 
							  FROM dbo.PROCESS_DEFINITION pd
							  WHERE  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') like ('OAIOperationalDashboard')
							  AND ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N' --and process_type_cd = 'CYCLEPRC'
							  and EXECUTION_FREQ_CD <> 'RUNONCE'
							  and SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') not like ('UnitracBusinessServiceProc%') 
							  order by pd.update_dt DESC, SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') 
