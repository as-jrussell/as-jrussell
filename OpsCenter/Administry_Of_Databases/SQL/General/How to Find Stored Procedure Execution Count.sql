--How to Find Stored Procedure Execution Count 
SELECT DB_NAME(database_id) DatabaseName,
OBJECT_NAME(object_id) ProcedureName,
cached_time, type_desc, last_execution_time, execution_count,
total_elapsed_time/execution_count AS avg_elapsed_time,
total_elapsed_time/execution_count/1000 AS avg_elapsed_time_in_seconds,
total_elapsed_time/execution_count/1000/60 AS avg_elapsed_time_in_minutes
--select  OBJECT_NAME(object_id), *
FROM sys.dm_exec_procedure_stats
WHERE DB_NAME(database_id) in (SELECT db_name())
ORDER BY avg_elapsed_time DESC ;


 

