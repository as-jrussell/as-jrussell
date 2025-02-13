USE [PerfStats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CaptureIOerrorUsage]') AND type in (N'P', N'PC') )

BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CaptureIOerrorUsage] AS RETURN 0;';
END;
GO

ALTER PROCEDURE [dbo].[CaptureIOerrorUsage] ( @DryRun bit = 1, @Verbose bit = 0 )
AS
-- EXEC [dbo].[CaptureIOerrorUsage] 
-- EXEC [dbo].[CaptureIOerrorUsage] @Verbose = 1
-- EXEC [dbo].[CaptureIOerrorUsage] @DryRun = 0, @Verbose = 1
-- EXEC [dbo].[CaptureIOerrorUsage] @DryRun = 0 --Job step

BEGIN

	declare @query nvarchar(max)
	set @query = 	
			'SELECT
			DB_NAME(t.[dbid]) AS [Database Name],
			TA.session_id, TA.wait_type, RE.start_time,
			CO.last_read, CO.last_write,
			last_execution_time, execution_count, RE.[status], RE.command, SE.LOGIN_Name, SE.[host_name], SE.[program_name],
			TA.blocking_session_id,
			t.[text] AS [Query Text], qp.query_plan AS [Query Plan]
		FROM sys.dm_exec_query_stats AS qs
		CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t 
		CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
			JOIN sys.dm_exec_requests RE ON RE.query_plan_hash = qs.query_plan_hash
			JOIN SYS.dm_exec_connections CO ON RE.session_id = CO.session_id
			JOIN sys.dm_os_waiting_tasks TA ON CO.session_id = TA.session_id
			JOIN sys.dm_exec_sessions SE on SE.session_id = TA.session_id
		ORDER BY RE.start_time DESC
		OPTION
		(RECOMPILE);
'



        IF( @Verbose = 1 )
        BEGIN
            PRINT @query
	
        END;

        IF( @dryrun = 0 )
            BEGIN
	            INSERT PerfStats.dbo.IOerrorUsage
		            EXEC (@query)
            END
        ELSE
            BEGIN
                 EXEC (@query)
            END

/*--BODY OF EMAIL - Edit for your environment
SET @body ='<html><H1>Tempdb Large Query</H1>
<body bgcolor=white>The query below with the <u>highest task allocation 
and high task deallocation</u> is most likely growing the tempdb. NOTE: Please <b>do not kill system tasks</b> 
that may be showing up in the table below.
<U>Only kill the query that is being run by a user and has the highest task allocation/deallocation.</U><BR> 
<BR>
To stop the query from running, do the following:<BR>
<BR>
1. Open <b>SQL Server Management Studio</b><BR>
2. <b>Connect to database engine using Windows Authentication</b><BR>
3. Click on <b>"New Query"</b><BR>
4. Type <b>KILL [type session_id number from table below];</b> - It should look something like this:  KILL 537; <BR>
5. Hit the <b>F5</b> button to run the query<BR>
<BR>
This should kill the session/query that is growing the large query.  It will also kick the individual out of the application.<BR>
You have just stopped the growth of the tempdb, without having to restart SQL Services, and have the large-running query available for your review.
<BR>
<BR>
<table border = 2><tr><th>Session_ID</th><th>Login_Name</th><th>Command</th><th>Task_Alloc</th><th>Task_Dealloc</th><th>Query_Text</th></tr>' 
SET @body = @body + @xml +'</table></body></html>'
--Send email to recipients:
EXEC msdb.dbo.sp_send_dbmail
@recipients =N'dba@domain.com', --Insert the TO: email Address here
@copy_recipients ='dba_Manager@domain.com', --Insert the CC: Address here; If multiple addresses, separate them by a comma (,)
@body = @body,@body_format ='HTML',
@importance ='High',
@subject ='THIS IS A TEST', --Provide a subject for the email
@profile_name = 'DatabaseMailProfile' --Database Mail profile here*/

END


