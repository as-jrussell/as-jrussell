
SELECT B.SESSION_ID 'SESSION ID',
CAST(DB_NAME(A.DATABASE_ID) AS varchar(20)) 'Database Name',
c.command, 
SUBSTRING(st.text, (C.statement_start_offset / 2) +1, 
(( CASE C.statement_end_offset
WHEN -1 THEN DATALENGTH(st.text) 
ELSE c.statement_end_offset
END
-
c.statement_start_offset ) / 2) +1)
statement_text, 
COALESCE(QUOTENAME(DB_NAME(ST.DBID)) + N'.' + QUOTENAME(
OBJECT_SCHEMA_NAME(St.OBJECTID, ST.DBID)) + 
N'.'+ QUOTENAME(OBJECT_NAME(ST.OBJECTID, ST.DBID)), '')
command_text,
c.wait_type,
c.wait_time,
a.database_transaction_log_record_count  'Record Count',
a.database_transaction_log_bytes_used / 1024.0 /1024.0 'MB used',
a.database_transaction_log_bytes_used_system / 1024.0 /1024.0 'MB used system',
a.database_transaction_log_bytes_reserved / 1024.0 /1024.0 'MB Reserved',
a.database_transaction_log_bytes_reserved_system / 1024.0 /1024.0 'MB Reserved system'
--select *
FROM sys.dm_tran_database_transactions a
join sys.dm_tran_session_transactions b on a.transaction_id = b.transaction_id
join sys.dm_exec_requests c 
CROSS APPLY sys.dm_exec_sql_text(c.SQL_HANDLE) AS ST 
ON B.session_id = C.session_id


DBCC OPENTRAN 