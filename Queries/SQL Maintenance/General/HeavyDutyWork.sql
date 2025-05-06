DECLARE @AvgLatency DECIMAL(18,2), @Stolen BIGINT, @Free BIGINT, @PLEValue INT, @RunnableTasks INT, @PendingIO INT, @CPUMessage NVARCHAR(400), @LatencyMessage NVARCHAR(400), @MemMessage NVARCHAR(400), @PLEMessage NVARCHAR(400), @sqlCPU NVARCHAR(1000), @sqlMemory NVARCHAR(2000), @sqlMemory1 NVARCHAR(2000), @sqlMemory2 NVARCHAR(2000), @sqlMemory3 NVARCHAR(2000), @sqlLatency NVARCHAR(2000), @sqlLatency1 NVARCHAR(2000), @sqlLatency2 NVARCHAR(2000), @sqlLatency3 NVARCHAR(2000), @sqlPLE NVARCHAR(3000);
DECLARE @DatabaseName SYSNAME = '';
DECLARE @Dryrun BIT =0
DECLARE @PerfSucks BIT = 1 -- 1 = Snarky report mode, 0 = Detailed result sets






IF @PerfSucks = 0
  BEGIN
      SELECT TOP 1 @PLEValue = cntr_value
      FROM   sys.dm_os_performance_counters
      WHERE  [object_name] LIKE '%Buffer Node%'
             AND counter_name = 'Page life expectancy';

      SELECT TOP 1 @RunnableTasks = runnable_tasks_count,
                   @PendingIO = pending_disk_io_count
      FROM   sys.dm_os_schedulers
      WHERE  status = 'VISIBLE ONLINE';

      SELECT @Stolen = Sum(virtual_memory_committed_kb),
             @Free = Sum(virtual_memory_reserved_kb)
      FROM   sys.dm_os_memory_clerks;

      -- Disk Latency
      SELECT @AvgLatency = Avg(io_stall / NULLIF(num_of_reads + num_of_writes, 0.0))
      FROM   sys.Dm_io_virtual_file_stats(NULL, NULL);
  END

-- PLE (Page Life Expectancy)
SELECT @sqlPLE = N'
IF EXISTS (SELECT 1 FROM dba.info.host WHERE MachineName IN (''SQLSPRDAWEC13'', ''SQLSPRDAWEC14''))
BEGIN
    SELECT TOP 1 cntr_value AS PLE,
        CASE 
            WHEN cntr_value < 60 
                THEN ''Your server is probably sobbing into a pillow. Consider adding more memory or optimizing queries that cause memory pressure.''
            WHEN cntr_value < 100 
                THEN ''Memory pressure is real. Review the memory allocation and resource usage.''
            WHEN cntr_value < 300 
                THEN ''Bad - Things are rough in the buffer pool. Analyze queries and indexes that may be causing inefficient memory usage.''
            WHEN cntr_value < 1000 
                THEN ''Decent - Could be better, could be worse. Consider optimizing memory-heavy queries.''
            WHEN cntr_value < 5000 
                THEN ''Good - Buffer cache is hanging in there. Keep monitoring the system.''
            ELSE ''Excellent - Your memory is living its best life. Keep up the good work!''
        END AS PLE_Status, ''Server-Level'' [Server/Database Level]
    FROM sys.dm_os_performance_counters
    WHERE [object_name] LIKE ''%Buffer Node%'' 
      AND counter_name = ''Page life expectancy'';
END
ELSE
BEGIN
    SELECT cntr_value AS PLE,
        CASE 
            WHEN cntr_value < 60 
                THEN ''Your server is probably sobbing into a pillow. Consider adding more memory or optimizing queries that cause memory pressure.''
            WHEN cntr_value < 100 
                THEN ''Memory pressure is real. Review the memory allocation and resource usage.''
            WHEN cntr_value < 300 
                THEN ''Bad - Things are rough in the buffer pool. Analyze queries and indexes that may be causing inefficient memory usage.''
            WHEN cntr_value < 1000 
                THEN ''Decent - Could be better, could be worse. Consider optimizing memory-heavy queries.''
            WHEN cntr_value < 5000 
                THEN ''Good - Buffer cache is hanging in there. Keep monitoring the system.''
            ELSE ''Excellent - Your memory is living its best life. Keep up the good work!''
        END AS PLE_Status, ''Server-Level'' [Server/Database Level]
    FROM sys.dm_os_performance_counters
    WHERE [object_name] LIKE ''%Buffer Node%'' 
      AND counter_name = ''Page life expectancy'';
END';

-- Memory Distribution and Dirty Pages
SELECT @sqlMemory1 = N'
SELECT 
    DB_NAME(bd.database_id) AS database_name,
    COUNT(*) AS page_count,
    (COUNT(*) * 8 / 1024) AS size_MB,
    (COUNT(*) * 8 / 1024 / 1024) AS size_GB,
    SUM(CASE WHEN bd.is_modified = 1 THEN 1 ELSE 0 END) AS dirty_page_count,
    SUM(vf.io_stall_write_ms) AS total_io_stall_write_ms,
    SUM(vf.num_of_writes) AS total_writes,
    CASE 
        WHEN SUM(CASE WHEN bd.is_modified = 1 THEN 1 ELSE 0 END) > 10000 
             AND (SUM(vf.io_stall_write_ms) / NULLIF(SUM(vf.num_of_writes), 0)) > 10 
            THEN ''High dirty pages + slow disk = Potential I/O bottleneck. Review the disk system and queries contributing to dirty pages. Consider adding faster storage or optimizing queries.''
        WHEN SUM(CASE WHEN bd.is_modified = 1 THEN 1 ELSE 0 END) > 10000 
             AND SUM(vf.num_of_writes) > 100000 
            THEN ''Sudden spike in dirty pages = Heavy write workload (INSERT/UPDATE/DELETE). Consider optimizing write-heavy queries or upgrading disk subsystems.''
        WHEN SUM(CASE WHEN bd.is_modified = 1 THEN 1 ELSE 0 END) > 5000 
             AND SUM(vf.num_of_writes) < 100 
            THEN ''Dirty pages staying high = Lazy writer or checkpoint delay. Review lazy writer configuration and checkpoint intervals. Consider adjusting the checkpoint frequency.''
        WHEN SUM(CASE WHEN bd.is_modified = 1 THEN 1 ELSE 0 END) < 1000 
             AND SUM(vf.num_of_writes) > 10000 
            THEN ''Low dirty pages, high activity = Disk keeping up. All good. Continue monitoring.''
        ELSE ''Memory usage seems stable. Monitor if pattern changes.''
    END AS [interpretation], ''Database-Level'' [Server/Database Level]
FROM sys.dm_os_buffer_descriptors AS bd
JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS vf
    ON bd.database_id = vf.database_id
WHERE bd.database_id NOT IN (1, 2, 3, 4)
'

IF @DatabaseName <> ''
  BEGIN
      SELECT @sqlMemory2 = 'AND DB_NAME(bd.database_id) = '''
                           + @DatabaseName + ''' ';
  END

SELECT @sqlMemory3 = '
GROUP BY bd.database_id
ORDER BY page_count DESC';

-- CPU Distribution
SELECT @sqlCPU = N'
SELECT 
    cpu_id, 
    current_tasks_count, 
    runnable_tasks_count, 
    pending_disk_io_count,
    CASE 
      WHEN runnable_tasks_count > 0 AND pending_disk_io_count > 0 
          THEN ''Potential CPU and I/O contention detected. Investigate heavy queries or consider upgrading disk and CPU resources.''
      WHEN runnable_tasks_count > 0 
          THEN ''Potential CPU bottleneck. Investigate long-running or CPU-intensive queries and try optimizing them.''
      WHEN pending_disk_io_count > 0 
          THEN ''Potential I/O bottleneck. Review disk usage and IO-related queries. Consider optimizing disk subsystem.''
      ELSE ''CPU is happy. No issues detected.''
    END AS status, ''Server-Level'' [Server/Database Level]
FROM sys.dm_os_schedulers
WHERE status = ''VISIBLE ONLINE''';

-- Latency per File
SELECT @sqlLatency1 = N'
SELECT
   DB_NAME([vfs].[database_id]) AS [DB],
   LEFT([mf].[physical_name], 2) AS [Drive],
   [mf].[physical_name],
   [ReadLatency] = CASE WHEN [num_of_reads] = 0 THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END,
   [WriteLatency] = CASE WHEN [num_of_writes] = 0 THEN 0 ELSE ([io_stall_write_ms] / [num_of_writes]) END,
   [Latency] = CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0) THEN 0 ELSE ([io_stall] / ([num_of_reads] + [num_of_writes])) END,
   [Latency Desc] = CASE 
        WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0) THEN ''N/A''
        WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 2 THEN ''Excellent. No issue with I/O performance.''
        WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 6 THEN ''Very good. Consider optimizing read/write-intensive queries to reduce stall time.''
        WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 11 THEN ''Good. Keep monitoring and consider upgrading storage if needed.''
        WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 21 THEN ''Poor. Disk latency is noticeable, consider investigating storage subsystems. Check disk health or upgrade to faster disks.''
        WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 101 THEN ''Bad. Significant disk I/O issues, consider upgrading the disk system to improve performance.''
        WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 501 THEN ''Yikes! Disk I/O is severely impacted. Immediate investigation and resolution needed.''
        ELSE ''YIKES!! Unbearable I/O delay, urgent resolution required.''
   END, ''Database-Level'' [Server/Database Level]
FROM sys.dm_io_virtual_file_stats (NULL, NULL) AS [vfs]
JOIN sys.master_files AS [mf] 
    ON [vfs].[database_id] = [mf].[database_id] 
    AND [vfs].[file_id] = [mf].[file_id]'

IF @DatabaseName <> ''
  BEGIN
      SELECT @sqlLatency2 = '
WHERE DB_NAME([vfs].[database_id]) = '''
                            + @DatabaseName + ''' ';
  END

SELECT @sqlLatency3 = '

ORDER BY  [Latency] DESC';

IF @DatabaseName <> ''
  BEGIN
      SET @sqlMemory = ( @sqlMemory1 ) + ( @sqlMemory2 ) + ( @sqlMemory3 )
      SET @sqlLatency = ( @sqlLatency1 ) + ( @sqlLatency2 ) + ( @sqlLatency3 )
  END
ELSE
  BEGIN
      SET @sqlMemory = ( @sqlMemory1 ) + ( @sqlMemory3 )
      SET @sqlLatency = ( @sqlLatency1 ) + ( @sqlLatency3 )
  END

IF @PerfSucks = 0
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

      PRINT 'PLE Value: '
            + Cast(@PLEValue AS NVARCHAR);

      PRINT 'Analysis: ' + @PLEMessage;

      SELECT @CPUMessage = CASE
                             WHEN @RunnableTasks > 0
                                  AND @PendingIO > 0 THEN 'CPU + I/O contention = Chaos. Tune queries or consider upgrades.'
                             WHEN @RunnableTasks > 0 THEN 'CPU bottleneck. Bad queries or not enough cores.'
                             WHEN @PendingIO > 0 THEN 'I/O queue is sad. Check your disk subsystem.'
                             ELSE 'CPU is chillin. Nothing to see here.'
                           END;

      PRINT '--- CPU Diagnostic ---';

      PRINT 'Runnable Tasks: '
            + Cast(@RunnableTasks AS NVARCHAR);

      PRINT 'Pending I/O: '
            + Cast(@PendingIO AS NVARCHAR);

      PRINT 'Analysis: ' + @CPUMessage;

      SELECT @MemMessage = CASE
                             WHEN @Stolen > @Free THEN 'Memory under siege. RAM might be your bottleneck.'
                             ELSE 'Memory is balanced. No drama here.'
                           END;

      PRINT '--- Memory Diagnostic ---';

      PRINT 'Stolen: ' + Cast(@Stolen AS NVARCHAR);

      PRINT 'Free: ' + Cast(@Free AS NVARCHAR);

      PRINT 'Analysis: ' + @MemMessage;

      SELECT @LatencyMessage = CASE
                                 WHEN @AvgLatency IS NULL THEN 'No latency data? Something''s up with monitoring.'
                                 WHEN @AvgLatency > 100 THEN 'Disk latency is tragic. You need better storage or less chaos in the queries.'
                                 WHEN @AvgLatency > 30 THEN 'Disk latency could be better. Keep an eye on it.'
                                 ELSE 'Disk latency is solid. Storage is holding the line.'
                               END;

      PRINT '--- Disk Latency Diagnostic ---';

      PRINT 'Avg Latency (ms): '
            + Cast(@AvgLatency AS NVARCHAR);

      PRINT 'Analysis: ' + @LatencyMessage;
  END
ELSE IF @Dryrun = 0
  BEGIN
       EXEC ( @sqlPLE)

      EXEC ( @sqlCPU);

      EXEC ( @sqlMemory)

      EXEC ( @sqlLatency)
  END
ELSE
  BEGIN
      PRINT ( @sqlPLE )

      PRINT ( @sqlCPU );

      PRINT ( @sqlMemory )

      PRINT ( @sqlLatency )
  END 
