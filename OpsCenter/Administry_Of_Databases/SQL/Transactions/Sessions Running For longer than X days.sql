DECLARE @days_old SMALLINT
SELECT  @days_old = 2
 SELECT  des.session_id ,
        des.login_time ,
        des.last_request_start_time ,
        des.last_request_end_time ,
        des.[status] ,
        des.[program_name] ,
        des.cpu_time ,
        des.total_elapsed_time ,
        des.memory_usage ,
		des.total_scheduled_time ,
        des.total_elapsed_time ,
        des.reads ,
        des.writes ,
        des.logical_reads ,
        des.row_count ,
        des.is_user_process
FROM    sys.dm_exec_sessions des
        INNER JOIN sys.dm_tran_session_transactions dtst
                       ON des.session_id = dtst.session_id
WHERE   des.is_user_process = 1
        AND DATEDIFF(dd, des.last_request_end_time, GETDATE()) > @days_old
  --      AND des.status != 'Running'
ORDER BY des.last_request_end_time
