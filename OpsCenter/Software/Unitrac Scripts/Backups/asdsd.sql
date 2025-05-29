USE [msdb]
GO

/****** Object:  Alert [ALERT: ExcessivePageIOLatchWaits]    Script Date: 7/30/2017 5:32:16 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'ALERT: ExcessivePageIOLatchWaits', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'Wait Statistics|Page IO latch waits|Average wait time (ms)|>|500', 
		@job_id=N'0071156a-bf8e-4088-8794-4c8dbd3f0eaa'
GO

