USE UniTrac

---UTL Match Setup Stuff!!!!!!!
SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
  status_cd, *
FROM    UniTrac..Process_definition
where PROCESS_TYPE_CD like '%utl20%'
and active_in = 'Y' and onhold_in = 'N'


/*

711279	UTL 2.0 Match
719239	UTL 2.0 Match 2
711280	UTL 2.0 Rematch: Repo Plus
711281	UTL 2.0 Rematch: Mid-Size Lenders
711292	UTL 2.0 Rematch: Default

*/

--UTL 2.0 Match
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (711279)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC


--UTL 2.0 Match 2
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (719239)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC


--UTL 2.0 Rematch: Repo Plus
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (711280)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC


--UTL 2.0 Rematch: Mid-Size Lenders
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (711281)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC


--711292	UTL 2.0 Rematch: Default
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (711292)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC




