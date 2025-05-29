USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule  @job_name=N'DCOM-BackupMaintenance_LF-SQLDEV-01', @name=N'Daily', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20211027, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO



USE [msdb]
GO
EXEC msdb.dbo.sp_update_job  @job_name=N'DCOM-BackupMaintenance_LF-SQLDEV-01', 
		@enabled=1
GO
