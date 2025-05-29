-- Get SQL Agent Job Notifications
SELECT 
    j.job_id,
    j.name AS JobName,
    j.notify_email_operator_id AS OperatorId,
    o.name AS OperatorName,
    CASE 
        WHEN j.notify_level_email = 1 THEN 'On Success'
        WHEN j.notify_level_email = 2 THEN 'On Failure'
        WHEN j.notify_level_email = 3 THEN 'On Completion'
        ELSE 'Unknown'
    END AS NotificationMethod
FROM 
    msdb.dbo.sysjobs j
LEFT JOIN 
    msdb.dbo.sysoperators o ON j.notify_email_operator_id = o.id
ORDER BY 
    j.name;
