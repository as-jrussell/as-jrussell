
/*
Use this event to run a job when the replica becomes primary
*/
USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'AG Failover Detected - Now Primary',
@message_id=1480,
@severity=0,
@enabled=1,
@delay_between_responses=0,
@include_event_description_in=0,
@event_description_keyword=N'"RESOLVING" to "PRIMARY"',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
/*
Use this event to run a job when the replica becomes secondary
*/
USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'AG Failover Detected - Now Secondary',
@message_id=1480,
@severity=0,
@enabled=1,
@delay_between_responses=0,
@include_event_description_in=0,
@event_description_keyword=N'"RESOLVING" to "SECONDARY"',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO