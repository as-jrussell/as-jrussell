SELECT TOP 10
		databases.name,
	dm_exec_sql_text.text AS TSQL_Text,
	dm_exec_query_stats.creation_time, 
	dm_exec_query_stats.execution_count,
	dm_exec_query_stats.total_worker_time AS total_cpu_time,
	dm_exec_query_stats.total_elapsed_time, 
	dm_exec_query_stats.total_logical_reads, 
	dm_exec_query_stats.total_physical_reads, 
	dm_exec_query_plan.query_plan,plan_handle
FROM sys.dm_exec_query_stats 
CROSS APPLY sys.dm_exec_sql_text(dm_exec_query_stats.plan_handle)
CROSS APPLY sys.dm_exec_query_plan(dm_exec_query_stats.plan_handle)
INNER JOIN sys.databases
ON dm_exec_sql_text.dbid = databases.database_id
WHERE dm_exec_sql_text.text LIKE 'fn_EscrowEx_PDAP%'

DBCC FREEPROCCACHE(0x0500050066B8455B30FC44521300000001000000000000000000000000000000000000000000000000000000)
