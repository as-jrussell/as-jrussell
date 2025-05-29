USE [UniTrac]
GO


 -- select *

  SELECT   COUNT(umr.id) [Back Offs For the Month], MONTH(purge_dt), Year(purge_dt)
FROM WORK_ITEM umr
WHERE workflow_definition_id = 9 and update_user_tx = 'CYCBACKOFF' and 
purge_dt >= '2016-01-01'
 GROUP BY  MONTH(purge_dt), Year(purge_dt)
order by MONTH(purge_dt) , Year(purge_dt) ASC