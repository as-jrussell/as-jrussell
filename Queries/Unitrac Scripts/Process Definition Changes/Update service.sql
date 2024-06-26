use UniTrac

SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,

 *
	 
FROM    PROCESS_DEFINITION P
WHERE   SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') IN ('LDHServiceUSD')
							  and ACTIVE_IN = 'Y'-- and EXECUTION_FREQ_CD <> 'RUNONCE'
							  and status_cd != 'Expired' and onhold_in = 'N' and purge_dt is null 
							  order by update_dt desc



SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,

 *
	 
FROM    PROCESS_DEFINITION P
WHERE   name_tx like '%2771%' and ACTIVE_IN = 'Y' and EXECUTION_FREQ_CD <> 'RUNONCE'
and onHold_IN = 'N'
							  order by update_dt desc

							
								
UPDATE  PD
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "MSGSRVRONEMAIN"') ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,status_cd = 'Complete'
--SELECT * 
FROM    dbo.PROCESS_DEFINITION PD
WHERE  id in (1229682) 

select * from process_definition
where name_tx like '%sant%' and process_type_cd = 'CyclePRC'



SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss.ms], * from process_log
where update_dt >= '2019-09-15'
and end_dt is not null
and service_name_tx = 'UnitracBusinessService'



use UniTrac


select * from process_definition
where process_type_cd = 'WFEVAL'



select * from process_log
where CREATE_DT >= DateAdd(MINUTE, -60, getdate())
and PROCESS_DEFINITION_ID in (34,
6449,
6450,
9944,
777094) and server_tx = 'UTSTAGE-APP1'


select * from process_log
where CREATE_DT >= DateAdd(min, -15, getdate())
and PROCESS_DEFINITION_ID IN
(39,
19880,
336,
92379,
80642,
696740,
75189,
58339)
order by update_dt desc

