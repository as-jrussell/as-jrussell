USE UTL

---UTL Match Setup Stuff!!!!!!!
SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
  status_cd, *
FROM    Process_definition
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
where Process_definition_id in (5)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC


--UTL 2.0 Match 2
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (6)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC


--UTL 2.0 Rematch: Repo Plus
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (7)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC


--UTL 2.0 Rematch: Mid-Size Lenders
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (8)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC


--711292	UTL 2.0 Rematch: Default
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (9)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC



--711292	UTL 2.0 Rematch: Wells Fargo
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (11)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC





--711292	UTL 2.0 Rematch: Santander
 SELECT CONVERT(TIME,END_DT- START_DT),* from process_log
where Process_definition_id in (12)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) 
order by update_dt DESC


