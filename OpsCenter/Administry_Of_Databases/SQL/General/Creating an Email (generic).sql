DECLARE @EmailSubject AS VARCHAR(100) = 'test'
DECLARE @Profile AS VARCHAR(200) 
declare @Email AS  VARCHAR(200) = 'joseph.russell@alliedsolutions.net'
DECLARE @body NVARCHAR(MAX) = 'Hi'
 

select @Profile = name from msdb.dbo.sysmail_profile
		 order by last_mod_datetime desc 


EXEC msdb.dbo.sp_send_dbmail @profile_name = @profile,
						@recipients = @Email,
						@subject = @EmailSubject,
						@body = @body



/*

BEGIN
            EXEC msdb.dbo.sp_send_dbmail 
			@Subject= 'EDI Error Report',
			@profile_name = 'Unitrac-prod',
			@body = 'Attached are all EDI errors from the past 72 hours.',
			@recipients = 'mike.breitsch@alliedsolutions.net;rene.cannon@alliedsolutions.net;kevin.flaherty@alliedsolutions.net;joseph.russell@alliedsolutions.net;benjamin.helmuth@alliedsolutions.net',
			 @file_attachments= 'C:\Reports\EDIErrorReport.csv';
            RETURN
        END


		
EXEC msdb.dbo.sysmail_help_profile_sp;





						use DBA
						SELECT * FROM INFO.EMAIL


						        EXEC [DBA].[info].[GetEmailStatus] @dryRun = 0

		*/