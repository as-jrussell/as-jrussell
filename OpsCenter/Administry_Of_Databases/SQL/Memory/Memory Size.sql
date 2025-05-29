SELECT object_name, cntr_value
  FROM sys.dm_os_performance_counters
  WHERE counter_name IN ('Total Server Memory (KB)', 'Target Server Memory (KB)');
