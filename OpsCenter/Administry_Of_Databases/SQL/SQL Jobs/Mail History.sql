

   SELECT 
    log.mailitem_id,
    mail.subject,
    log.event_type,
    log.log_date,
    log.description
FROM msdb.dbo.sysmail_event_log log
JOIN msdb.dbo.sysmail_allitems mail ON log.mailitem_id = mail.mailitem_id
ORDER BY log.log_date DESC;

