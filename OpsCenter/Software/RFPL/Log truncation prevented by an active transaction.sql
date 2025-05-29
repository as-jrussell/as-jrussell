
SELECT [database_name] = db_name(s.database_id)
, tat.transaction_id, tat.transaction_begin_time, tst.session_id 
, session_open_transaction_count = tst.open_transaction_count --uncommitted and unrolled back transactions open. 
, transaction_duration_s = datediff(s, tat.transaction_begin_time, sysdatetime())
, input_buffer = ib.event_info
, request_text = CASE  WHEN r.statement_start_offset = 0 and r.statement_end_offset= 0 THEN left(est.text, 4000)
                       ELSE    SUBSTRING ( est.[text],    r.statement_start_offset/2 + 1, 
                                           CASE WHEN r.statement_end_offset = -1 THEN LEN (CONVERT(nvarchar(max), est.[text])) 
                                                ELSE r.statement_end_offset/2 - r.statement_start_offset/2 + 1
                                           END  )  END
, request_status = r.status
, request_blocked_by = r.blocking_session_id
, transaction_state = CASE tat.transaction_state    
                     WHEN 0 THEN 'The transaction has not been completely initialized yet.'
                     WHEN 1 THEN 'The transaction has been initialized but has not started.'
                     WHEN 2 THEN 'The transaction is active - has not been committed or rolled back.'
                     WHEN 3 THEN 'The transaction has ended. This is used for read-only transactions.'
                     WHEN 4 THEN 'The commit process has been initiated on the distributed transaction. This is for distributed transactions only. The distributed transaction is still active but further processing cannot take place.'
                     WHEN 5 THEN 'The transaction is in a prepared state and waiting resolution.'
                     WHEN 6 THEN 'The transaction has been committed.'
                     WHEN 7 THEN 'The transaction is being rolled back.'
                     WHEN 8 THEN 'The transaction has been rolled back.' END 
, transaction_name = tat.name
, azure_dtc_state    --Applies to: Azure SQL Database only
             =    CASE tat.dtc_state 
                 WHEN 1 THEN 'ACTIVE'
                 WHEN 2 THEN 'PREPARED'
                 WHEN 3 THEN 'COMMITTED'
                 WHEN 4 THEN 'ABORTED'
                 WHEN 5 THEN 'RECOVERED' END
, transaction_type = CASE tat.transaction_type    WHEN 1 THEN 'Read/write transaction'
                                             WHEN 2 THEN 'Read-only transaction'
                                             WHEN 3 THEN 'System transaction'
                                             WHEN 4 THEN 'Distributed transaction' END
, tst.is_user_transaction
, local_or_distributed = CASE tst.is_local WHEN 1 THEN 'Local transaction, not distributed' WHEN 0 THEN 'Distributed transaction or an enlisted bound session transaction.' END
, transaction_uow    --for distributed transactions. 
, s.login_time, s.host_name, s.program_name, s.client_interface_name, s.login_name, s.is_user_process
, session_cpu_time = s.cpu_time, session_logical_reads = s.logical_reads, session_reads = s.reads, session_writes = s.writes
, observed = sysdatetimeoffset()
FROM sys.dm_tran_active_transactions AS tat 
INNER JOIN sys.dm_tran_session_transactions AS tst  on tat.transaction_id = tst.transaction_id
INNER JOIN Sys.dm_exec_sessions AS s on s.session_id = tst.session_id 
LEFT OUTER JOIN sys.dm_exec_requests AS r on r.session_id = s.session_id
CROSS APPLY sys.dm_exec_input_buffer(s.session_id, null) AS ib 
OUTER APPLY sys.dm_exec_sql_text (r.sql_handle) AS est;