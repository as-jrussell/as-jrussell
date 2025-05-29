
--Lists all Database Mail profiles, including their names, descriptions, and associated accounts.
EXEC msdb.dbo.sysmail_help_profile_sp;


--Lists all Database Mail accounts, including their names, email addresses, server types, and other settings.
EXEC msdb.dbo.sysmail_help_account_sp;

--Lists the accounts associated with one or more Database Mail profiles.
EXEC msdb.dbo.sysmail_help_profileaccount_sp;

--Provides comprehensive information about SQL Agent jobs, including their names, descriptions, schedules, and more.
EXEC msdb.dbo.sp_help_job;

--Retrieves details about the steps within a SQL Agent job, such as step name, command, and execution options.
EXEC msdb.dbo.sp_help_jobstep;