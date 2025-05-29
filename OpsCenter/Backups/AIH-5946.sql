USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Remove TempDB file on Startup', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=1, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ELDREDGE_A\jrussell', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Remove TempDB file on Startup', @server_name = N'ON-SQLPRDCLST-2'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Remove TempDB file on Startup', @step_name=N'Script to remove tempdb file', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE tempdb;  
GO  

 IF EXISTS (select * from sys.database_files where name = ''tempdev10'')
BEGIN 
		DBCC SHRINKFILE(''tempdev10'', EMPTYFILE)  
		ALTER DATABASE tempdb  
		REMOVE FILE tempdev10; 
END 
ELSE 
BEGIN
		PRINT ''WARNING: No TempDB name temp10''

	/* ALTER DATABASE [tempdb] ADD FILE ( NAME = N''tempdev10'', FILENAME = N''E:\SQL\Data02\tempdb10.ndf'' , 
	SIZE = 174345344KB , MAXSIZE = 1073741824KB , FILEGROWTH = 5242880KB ) 
	GO */
		

END ', 
		@database_name=N'tempdb', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Remove TempDB file on Startup', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=1, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ELDREDGE_A\jrussell', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Remove TempDB file on Startup', @name=N'At Startup', 
		@enabled=1, 
		@freq_type=64, 
		@freq_interval=1, 
		@freq_subday_type=0, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210707, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
