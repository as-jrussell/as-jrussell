
-- =============================================
-- Script to check when Database Mail was turned off
-- =============================================

-- Check the SQL Server Logs for Database Mail events (start or stop)
-- This will display entries related to 'Database Mail' activity
EXEC xp_readerrorlog 0, 1, 'Database Mail', NULL, NULL, NULL, 'DESC';

-- Check SQL Server Agent Job Logs for failures related to sending emails
-- This query checks if any SQL Server Agent jobs failed due to email issues
SELECT job.name AS JobName, 
       h.run_date, 
       h.run_time, 
       h.message
FROM msdb.dbo.sysjobhistory h
JOIN msdb.dbo.sysjobs job ON h.job_id = job.job_id
WHERE h.message LIKE '%mail%failed%'
ORDER BY h.run_date DESC, h.run_time DESC;

-- Check the sysmail_event_log table for errors or stop events
-- It will show entries where Database Mail was stopped or failed, including error details
SELECT *
FROM msdb.dbo.sysmail_event_log
WHERE event_type = 'error' 
   or  description  NOT IN ('DatabaseMail process is started', 'DatabaseMail process is shutting down' ) 
ORDER BY log_date DESC;
