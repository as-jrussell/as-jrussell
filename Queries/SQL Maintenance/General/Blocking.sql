﻿USE Master
GO



SELECT * 
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
GO

SELECT session_id, wait_duration_ms, wait_type, blocking_session_id
FROM sys.dm_os_waiting_tasks 
WHERE blocking_session_id <> 0

GO


sp_who2

