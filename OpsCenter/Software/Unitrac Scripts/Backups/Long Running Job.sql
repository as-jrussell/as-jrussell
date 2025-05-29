USE [msdb]
GO

/****** Object:  Alert [ALERT: Long Running Transactions]    Script Date: 3/7/2017 11:49:40 AM ******/
EXEC msdb.dbo.sp_add_alert @name=N'ALERT: Long Running Transactions', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=3600, 
		@include_event_description_in=1, 
		@notification_message=N'Time should be in seconds(1800 = 30 minutes).', 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'Transactions|Longest Transaction Running Time||>|7200', 
		@job_id=N'0071156a-bf8e-4088-8794-4c8dbd3f0eaa'
GO

