
--Raw look at the sessions that are currently active
select * from sys.dm_exec_sessions

--Raw look at the requests that are running
select * from sys.dm_exec_requests


select req.* 
from sys.dm_exec_sessions se
join sys.dm_exec_requests req on se.session_id = req.session_id