--CPU
SELECT 
    scheduler_id, 
    cpu_id, 
    status, 
    is_online, 
    is_idle, 
    current_tasks_count, 
    runnable_tasks_count
FROM sys.dm_os_schedulers
WHERE status = 'VISIBLE ONLINE';




--PLE

SELECT 
    cntr_value AS PLE,
    CASE 
        WHEN cntr_value < 60 THEN 'Your server is probably sobbing into a pillow ??'
        WHEN cntr_value < 100 THEN 'Red alert ?? - Memory pressure is real'
        WHEN cntr_value < 300 THEN 'Bad ?? - Things are rough in the buffer pool'
        WHEN cntr_value < 1000 THEN 'Decent ?? - Could be better, could be worse'
        WHEN cntr_value < 5000 THEN 'Good ?? - Buffer cache is hanging in there'
        ELSE 'Excellent ?? - Your memory is living its best life'
    END AS PLE_Status, *
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Buffer Node%' 
  AND counter_name = 'Page life expectancy';



  SELECT 
    [LazyWrites/sec] = (SELECT cntr_value 
                        FROM sys.dm_os_performance_counters 
                        WHERE counter_name = 'Lazy Writes/sec'),
    [PageReads/sec] = (SELECT cntr_value 
                       FROM sys.dm_os_performance_counters 
                       WHERE counter_name = 'Page reads/sec'),
    [Memory Grants Pending] = (SELECT cntr_value 
                               FROM sys.dm_os_performance_counters 
                               WHERE counter_name = 'Memory Grants Pending');



---How memory is distrubted 
SELECT 
    COUNT(*) AS page_count,
    (COUNT(*) * 8 / 1024) AS size_MB,
    (COUNT(*) * 8 / 1024 / 1024) AS size_GB,
    DB_NAME(database_id) AS database_name
FROM sys.dm_os_buffer_descriptors
WHERE database_id NOT IN (1, 2, 3, 4) -- skip system DBs
GROUP BY database_id
ORDER BY size_MB DESC;



--DBCC MEMORYSTATUS 