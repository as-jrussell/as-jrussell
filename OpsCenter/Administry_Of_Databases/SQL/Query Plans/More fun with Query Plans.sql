SELECT 
		databases.name,
	dm_exec_sql_text.text AS TSQL_Text,
	dm_exec_query_stats.creation_time, 
	dm_exec_query_stats.execution_count,
	dm_exec_query_stats.total_worker_time AS total_cpu_time,
	dm_exec_query_stats.total_elapsed_time, 
	dm_exec_query_stats.total_logical_reads, 
	dm_exec_query_stats.total_physical_reads, 
	dm_exec_query_plan.query_plan,plan_handle,
	CONCAT('DBCC FREEPROCCACHE (',CONVERT(VARCHAR(max), plan_handle, 1), ')')
FROM sys.dm_exec_query_stats 
CROSS APPLY sys.dm_exec_sql_text(dm_exec_query_stats.plan_handle)
CROSS APPLY sys.dm_exec_query_plan(dm_exec_query_stats.plan_handle)
INNER JOIN sys.databases
ON dm_exec_sql_text.dbid = databases.database_id
WHERE dm_exec_sql_text.text LIKE '%%'
order by creation_time desc



SELECT db_name(dbid),OBJECT_NAME(objid), *
FROM Sys. [Syscacheobjects]
where OBJECT_NAME(objid) is not null
and db_name(dbid) = ''
