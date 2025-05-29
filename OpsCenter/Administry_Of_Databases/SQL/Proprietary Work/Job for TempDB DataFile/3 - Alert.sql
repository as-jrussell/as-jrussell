USE [msdb]
GO

/****** Object:  Alert [Perfstats -TempDB data files]    Script Date: 11/23/2021 2:37:48 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'Perfstats -TempDB data files', 
		@message_id=17117, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@notification_message=N'There is a temp database datafile mismatch for more details on how to resolve in sharepoint doc:
https://alliedsolutions.sharepoint.com/:w:/r/teams/DatabaseServices/Shared%20Documents/AlertSupport/TempDataFiles.docx?d=w565f438fa85944639b3c534a6214660d&csf=1&web=1&e=gErjTq

SQL Agent Alert: Perfstats -TempDB data files
SQL Agent Job: Perfstats - TempDataFilesCheck', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

