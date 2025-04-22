-- Copy-paste this baby into SSMS
DECLARE @PerfSucks BIT = 0; -- 1 = Snarky report mode, 0 = Detailed result sets

-- Page Life Expectancy
DECLARE @PLEValue INT, @PLEMessage NVARCHAR(400);
SELECT TOP 1 @PLEValue = cntr_value
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Buffer Node%' AND counter_name = 'Page life expectancy';

IF @PerfSucks = 1
BEGIN
    SELECT @PLEMessage = CASE 
        WHEN @PLEValue < 60 THEN 'PLE < 60: Your server is crying in the break room. Optimize queries or throw RAM at it.'
        WHEN @PLEValue < 100 THEN 'PLE < 100: Memory pressure is knocking.'
        WHEN @PLEValue < 300 THEN 'PLE < 300: Rough ride. Check queries and indexes.'
        WHEN @PLEValue < 1000 THEN 'PLE < 1000: Meh. Room for improvement.'
        WHEN @PLEValue < 5000 THEN 'PLE < 5000: Nice. Keep an eye.'
        ELSE 'Excellent! Your memory is zen.'
    END;
    PRINT '--- Page Life Expectancy Diagnostic ---';
    PRINT 'PLE Value: ' + CAST(@PLEValue AS NVARCHAR);
    PRINT 'Analysis: ' + @PLEMessage;
END
ELSE
BEGIN
    SELECT * FROM sys.dm_os_performance_counters
    WHERE [object_name] LIKE '%Buffer Node%' AND counter_name = 'Page life expectancy';
END;

-- CPU + IO
DECLARE @RunnableTasks INT, @PendingIO INT, @CPUMessage NVARCHAR(400);
SELECT TOP 1 @RunnableTasks = runnable_tasks_count, @PendingIO = pending_disk_io_count
FROM sys.dm_os_schedulers WHERE status = 'VISIBLE ONLINE';

IF @PerfSucks = 1
BEGIN
    SELECT @CPUMessage = CASE 
        WHEN @RunnableTasks > 0 AND @PendingIO > 0 THEN 'CPU + I/O contention = Chaos. Tune queries or consider upgrades.'
        WHEN @RunnableTasks > 0 THEN 'CPU bottleneck. Bad queries or not enough cores.'
        WHEN @PendingIO > 0 THEN 'I/O queue is sad. Check your disk subsystem.'
        ELSE 'CPU is chillin. Nothing to see here.'
    END;
    PRINT '--- CPU Diagnostic ---';
    PRINT 'Runnable Tasks: ' + CAST(@RunnableTasks AS NVARCHAR);
    PRINT 'Pending I/O: ' + CAST(@PendingIO AS NVARCHAR);
    PRINT 'Analysis: ' + @CPUMessage;
END
ELSE
BEGIN
    SELECT * FROM sys.dm_os_schedulers WHERE status = 'VISIBLE ONLINE';
END;

-- Memory
DECLARE @Stolen BIGINT, @Free BIGINT, @MemMessage NVARCHAR(400);
SELECT 
    @Stolen = SUM(virtual_memory_committed_kb),
    @Free = SUM(virtual_memory_reserved_kb)
FROM sys.dm_os_memory_clerks;

IF @PerfSucks = 1
BEGIN
    SELECT @MemMessage = CASE 
        WHEN @Stolen > @Free THEN 'Memory under siege. RAM might be your bottleneck.'
        ELSE 'Memory is balanced. No drama here.'
    END;
    PRINT '--- Memory Diagnostic ---';
    PRINT 'Stolen: ' + CAST(@Stolen AS NVARCHAR);
    PRINT 'Free: ' + CAST(@Free AS NVARCHAR);
    PRINT 'Analysis: ' + @MemMessage;
END
ELSE
BEGIN
    SELECT type, SUM(virtual_memory_committed_kb) AS committed_kb,
           SUM(virtual_memory_reserved_kb) AS reserved_kb
    FROM sys.dm_os_memory_clerks
    GROUP BY type
    ORDER BY committed_kb DESC;
END;

-- Disk Latency
DECLARE @LatencyMessage NVARCHAR(400);
DECLARE @AvgLatency DECIMAL(18,2);
SELECT @AvgLatency = AVG(io_stall / NULLIF(num_of_reads + num_of_writes, 0.0))
FROM sys.dm_io_virtual_file_stats(NULL, NULL);

IF @PerfSucks = 1
BEGIN
    SELECT @LatencyMessage = CASE
        WHEN @AvgLatency IS NULL THEN 'No latency data? Something''s up with monitoring.'
        WHEN @AvgLatency > 100 THEN 'Disk latency is tragic. You need better storage or less chaos in the queries.'
        WHEN @AvgLatency > 30 THEN 'Disk latency could be better. Keep an eye on it.'
        ELSE 'Disk latency is solid. Storage is holding the line.'
    END;
    PRINT '--- Disk Latency Diagnostic ---';
    PRINT 'Avg Latency (ms): ' + CAST(@AvgLatency AS NVARCHAR);
    PRINT 'Analysis: ' + @LatencyMessage;
END
ELSE
BEGIN
    SELECT 
        DB_NAME(database_id) AS database_name,
        file_id,
        io_stall,
        num_of_reads,
        num_of_writes,
        io_stall_read_ms,
        io_stall_write_ms,
        size_on_disk_bytes
    FROM sys.dm_io_virtual_file_stats(NULL, NULL);
END;
