USE [msdb]
GO

/****** Object:  Job [Alert: Daily console check]    Script Date: 10/20/2016 11:11:17 AM ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'4feeb384-e318-472d-b74f-a96932af6874', @delete_unused_schedule=1
GO

