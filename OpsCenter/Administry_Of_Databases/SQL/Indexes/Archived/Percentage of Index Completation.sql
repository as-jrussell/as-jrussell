 Select session_id, r.command
 , s.text
 , r.start_time
 , r.percent_complete
 , cast(((datediff(second, r.start_time, getdate())) / 3600) As varchar) + ' hour(s), '
 + cast((datediff(second, r.start_time, getdate()) % 3600) / 60 As varchar) + 'min, '
 + cast((datediff(second, r.start_time, getdate()) % 60) As varchar) + ' sec' As running_time
 , cast((r.estimated_completion_time / 3600000) As varchar) + ' hour(s), '
 + cast((r.estimated_completion_time % 3600000) / 60000 As varchar) + 'min, '
 + cast((r.estimated_completion_time % 60000) / 1000 As varchar) + ' sec' As est_time_to_go
 , dateadd(second, r.estimated_completion_time / 1000, getdate()) As est_completion_time
    From sys.dm_exec_requests     r                
   Cross Apply sys.dm_exec_sql_text(r.sql_handle) s
   Where r.command IN ('CREATE Index', 'ALTER INDEX')
     Or r.command Like 'DBCC%'

	 --select GETDATE()