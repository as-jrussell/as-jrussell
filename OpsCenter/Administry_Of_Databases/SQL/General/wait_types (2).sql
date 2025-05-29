SELECT  wait_type ,
        SUM(wait_time_ms / 1000) AS [wait_time_s]
FROM    sys.dm_os_wait_stats DOWS
WHERE   wait_type NOT IN ( 'SLEEP_TASK', 'BROKER_TASK_STOP',
                           'SQLTRACE_BUFFER_FLUSH', 'CLR_AUTO_EVENT',
                           'CLR_MANUAL_EVENT', 'LAZYWRITER_SLEEP' )
--AND wait_type like 'PAGEIOLATCH%'
GROUP BY wait_type
HaVING SUM(wait_time_ms / 1000) > '60000'
ORDER BY SUM(wait_time_ms) DESC
