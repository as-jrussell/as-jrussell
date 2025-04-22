DECLARE @sqlCPU NVARCHAR(1000)
DECLARE @sqlMemory NVARCHAR(2000)
DECLARE @sqlMemory1 NVARCHAR(2000)
DECLARE @sqlMemory2 NVARCHAR(2000)
DECLARE @sqlMemory3 NVARCHAR(2000)
DECLARE @sqlLatency NVARCHAR(2000)
DECLARE @sqlLatency1 NVARCHAR(2000)
DECLARE @sqlLatency2 NVARCHAR(2000)
DECLARE @sqlLatency3 NVARCHAR(2000)
DECLARE @sqlPLE NVARCHAR(3000)
DECLARE @DatabaseName SYSNAME = '';
DECLARE @Dryrun BIT =0

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



IF @Dryrun = 0
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
