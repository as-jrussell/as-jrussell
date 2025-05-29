

		
SELECT  *
   FROM    sys.dm_exec_requests a
            LEFT JOIN sys.dm_exec_sessions ses ON ses.session_id = a.session_id
            CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) b
   -- WHERE   a.status <> 'background'
        --    AND DATEDIFF(MINUTE, a.start_time, CURRENT_TIMESTAMP) > 61 --(or 241 in Non Production)
         --   AND nt_user_name NOT IN ('SYSTEM', 'UniTrac-Daemon')
         --   AND wait_type <> 'TRACEWRITE'


