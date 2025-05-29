SELECT 
    wait_type, 
    waiting_tasks_count, 
    wait_time_ms, 
    max_wait_time_ms, 
    CASE 
        WHEN wait_type = 'PAGEIOLATCH_NL' THEN 'No latch needed, async prefetching.'
        WHEN wait_type = 'PAGEIOLATCH_KP' THEN 'Keeping latch while waiting for I/O.'
        WHEN wait_type = 'PAGEIOLATCH_SH' THEN 'Waiting to read page in shared mode.'
        WHEN wait_type = 'PAGEIOLATCH_UP' THEN 'Waiting to update a page in memory.'
        WHEN wait_type = 'PAGEIOLATCH_EX' THEN 'Waiting for exclusive access to modify a page.'
        WHEN wait_type = 'PAGEIOLATCH_DT' THEN 'Bulk data transfer waiting on page load.'
        WHEN wait_type = 'PAGEIOLATCH_IW' THEN 'Internal write operation waiting for I/O.'
        WHEN wait_type = 'PAGEIOLATCH_XP' THEN 'External process interaction with SQL pages.'
        WHEN wait_type = 'PAGEIOLATCH_KP_VIRTUAL' THEN 'Virtualized storage keeping latch on I/O.'
        WHEN wait_type = 'PAGEIOLATCH_KP_HARD' THEN 'Hard storage keeping latch on I/O operations.'
        WHEN wait_type = 'PAGEIOLATCH_AH' THEN 'Allocation heap page waiting for disk read.'
        ELSE 'Other PAGEIOLATCH wait type.'
    END AS Explanation
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'PAGEIOLATCH%';
