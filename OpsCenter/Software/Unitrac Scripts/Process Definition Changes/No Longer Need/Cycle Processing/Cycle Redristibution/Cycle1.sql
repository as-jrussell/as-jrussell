





UPDATE PROCESS_DEFINITION 
SET SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "UnitracBusinessServiceCycle"')
, LOCK_ID = LOCK_ID + 1
WHERE PROCESS_TYPE_CD='CYCLEPRC'
and ID IN (	)