use tempdb
go


-- report the new file sizes
SELECT name, size
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');
GO



--Determining the Longest Running Transaction
SELECT transaction_id,*
FROM sys.dm_tran_active_snapshot_database_transactions 
ORDER BY elapsed_time_seconds DESC;

--Obtaining the space consumed by internal objects in all currently running tasks in each session.
   SELECT session_id, 
      SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
    FROM sys.dm_db_task_space_usage 
    GROUP BY session_id;
