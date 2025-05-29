;WITH s
     AS (SELECT s.session_id,
                [pages] = Sum(s.user_objects_alloc_page_count
                              + s.internal_objects_alloc_page_count)
         FROM   sys.dm_db_session_space_usage AS s
         GROUP  BY s.session_id
         HAVING Sum(s.user_objects_alloc_page_count
                    + s.internal_objects_alloc_page_count) > 0),
     task_space_usage
     AS (
        -- SUM alloc/delloc pages
        SELECT session_id,
               request_id,
               Sum(internal_objects_alloc_page_count)   AS alloc_pages,
               Sum(internal_objects_dealloc_page_count) AS dealloc_pages
         FROM   sys.dm_db_task_space_usage WITH (NOLOCK)
         WHERE  session_id <> @@SPID
         GROUP  BY session_id,
                   request_id)
SELECT tst.session_id,
       ( database_transaction_log_bytes_reserved / 1000000. ) [database_transaction_log_bytes_reserved MB],
       TSU.alloc_pages * 1.0 / 128                            AS [internal object MB space],
       TSU.dealloc_pages * 1.0 / 128                          AS [internal object dealloc MB space],
       s.[pages],
       EST.text,
       query_text                                             = COALESCE((SELECT Substring(text, erq.statement_start_offset / 2 + 1, ( CASE
                                                                                             WHEN statement_end_offset = -1 THEN Len(CONVERT(NVARCHAR(max), text)) * 2
                                                                                             ELSE statement_end_offset
                                                                                           END - erq.statement_start_offset ) / 2)
                              FROM   sys.Dm_exec_sql_text(erq.sql_handle)), 'Not currently executing'),
       EQP.query_plan
--select *
FROM   sys.dm_tran_database_transactions AS tdt
       LEFT JOIN sys.dm_tran_session_transactions AS tst
                 LEFT JOIN task_space_usage AS TSU
                        ON tst.session_id = TSU.session_id
                 LEFT JOIN s
                        ON tst.session_id = s.session_id
                 LEFT JOIN sys.dm_exec_requests ERQ WITH (NOLOCK)
                        ON tst.session_id = ERQ.session_id
                 OUTER APPLY sys.Dm_exec_sql_text(ERQ.sql_handle) AS EST
                 OUTER APPLY sys.Dm_exec_query_plan(ERQ.plan_handle) AS EQP
              ON tdt.transaction_id = tst.transaction_id
WHERE  tst.session_id > 50 AND
 tst.session_id <> @@SPID 



EXEC [PerfStats].[dbo].[Capturetempdblogusage]


/*

SELECT TOP 3 *
FROM   [PerfStats].[dbo].[TempDBLogUsage]
WHERE  ( Task_Alloc_GB <> '0'
          OR Task_Dealloc_GB <> '0' )
ORDER  BY Capture_DT DESC 



*/