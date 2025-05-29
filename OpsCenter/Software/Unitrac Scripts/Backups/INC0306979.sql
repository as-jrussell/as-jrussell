USE unitrac

select id, name_Tx from work_queue
where workflow_definition_id = 4
and active_in = 'n'
and purge_dt is null
and id <> 15
and id <> 357



SELECT * 
INTO UniTracHDStorage..INC0306979
FROM dbo.WORK_QUEUE
WHERE ID IN (select id FROM work_queue
where workflow_definition_id = 4
and active_in = 'n'
and purge_dt is null
and id <> 15
and id <> 357
)


UPDATE WQ
SET PURGE_DT = GETDATE(), UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0306979'
--SELECT * 
FROM dbo.WORK_QUEUE WQ
WHERE ID IN (select id FROM work_queue
where workflow_definition_id = 4
and active_in = 'n'
and purge_dt is null
and id <> 15
and id <> 357
)