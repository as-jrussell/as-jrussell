SELECT  wait_type ,
        SUM(wait_time_ms / 1000) AS [wait_time_s]
FROM    sys.dm_os_wait_stats DOWS
WHERE   wait_type NOT IN ( 'SLEEP_TASK', 'BROKER_TASK_STOP',
                           'SQLTRACE_BUFFER_FLUSH', 'CLR_AUTO_EVENT',
                           'CLR_MANUAL_EVENT', 'LAZYWRITER_SLEEP' )
AND wait_type like 'PAGEIOLATCH%'
GROUP BY wait_type
ORDER BY SUM(wait_time_ms) DESC



SELECT  DB_NAME(mf.database_id) AS databaseName ,
        mf.physical_name ,
        divfs.num_of_reads ,
   --other columns removed in this section. See Listing 6.14 for complete code
        GETDATE() AS baselineDate
INTO    #baseline
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
        JOIN sys.master_files AS mf ON mf.database_id = divfs.database_id
                                       AND mf.file_id = divfs.file_id

--Davidson, Louis; Ford, Tim. Performance Tuning with SQL Server Dynamic Management Views . Red Gate Books. Kindle Edition. 


SELECT * FROM  #baseline



WITH  currentLine
        AS ( SELECT   DB_NAME(mf.database_id) AS databaseName ,
                        mf.physical_name ,
                        num_of_reads ,
        --other columms removed
                        GETDATE() AS currentlineDate
             FROM     sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
                        JOIN sys.master_files AS mf
                          ON mf.database_id = divfs.database_id
                             AND mf.file_id = divfs.file_id
             )
  SELECT  currentLine.databaseName ,
        currentLine.physical_name ,
       --gets the time difference in milliseconds since the baseline was taken
        DATEDIFF(millisecond,baseLineDate,currentLineDate) AS elapsed_ms, --gets the change in time since the baseline was taken
        currentLine.num_of_reads - #baseline.num_of_reads AS num_of_reads
        --other columns removed
  FROM  currentLine
      INNER JOIN #baseline ON #baseLine.databaseName = currentLine.databaseName
        AND #baseLine.physical_name = currentLine.physical_name



-- Get a count of SQL connections by IP address
SELECT  dec.client_net_address ,
        des.program_name ,
        des.host_name ,
      --des.login_name ,
        COUNT(dec.session_id) AS connection_count
FROM    sys.dm_exec_sessions AS des
        INNER JOIN sys.dm_exec_connections AS dec
                       ON des.session_id = dec.session_id
-- WHERE   LEFT(des.host_name, 2) = 'WK'
GROUP BY dec.client_net_address ,
         des.program_name ,
         des.host_name
      -- des.login_name
-- HAVING COUNT(dec.session_id) > 1
ORDER BY des.program_name,
         dec.client_net_address

