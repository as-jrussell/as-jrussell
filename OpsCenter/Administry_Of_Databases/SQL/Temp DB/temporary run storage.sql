SELECT ssu.session_id, 
(ssu.internal_objects_alloc_page_count + sess_alloc) as allocated, 
(ssu.internal_objects_dealloc_page_count + sess_dealloc) as deallocated 
 , stm.TEXT
from sys.dm_db_session_space_usage as ssu,  
        sys.dm_exec_requests req
        CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS stm ,
(select session_id,  
   sum(internal_objects_alloc_page_count) as sess_alloc, 
   sum (internal_objects_dealloc_page_count) as sess_dealloc 
   from sys.dm_db_task_space_usage group by session_id) as tsk 
where ssu.session_id = tsk.session_id 
and ssu.session_id >50 
and ssu.session_id = req.session_id 
and ssu.database_id = 2 
order by allocated DESC


SELECT allocation_unit_id,
count(allocation_unit_id) 
FROM tempdb.sys.allocation_units
GROUP BY allocation_unit_id
HAVING count(allocation_unit_id) > '2'
;