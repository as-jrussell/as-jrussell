USE [master]
GO


SELECT
	*
FROM sys.dm_os_performance_counters
WHERE dm_os_performance_counters.object_name LIKE '%Buffer Manager%'
AND dm_os_performance_counters.counter_name = 'Page life expectancy';
 


 SELECT
	physical_memory_kb,
	virtual_memory_kb,
	committed_kb,
	committed_target_kb
FROM sys.dm_os_sys_info;
 