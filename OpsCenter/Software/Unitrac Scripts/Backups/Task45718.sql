USE [UniTrac]
GO





   select wi.* into #tmp from work_item wi
   join LENDER l on l.id = wi.LENDER_ID
   where wi.status_cd = 'Withdrawn'
   and l.CODE_TX  in ('8500')
   and CAST(wi.UPDATE_DT AS DATE) >= CAST(GETDATE()-30 AS DATE) and workflow_definition_id = 4


   update wi
   set status_cd= 'Initial', update_user_tx= 'Task45718', update_dt = GETDATE()
 from work_item wi
   where ID in (select ID from #tmp)
