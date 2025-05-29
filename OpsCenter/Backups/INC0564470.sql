
--Validation

USE msdb
   EXEC dbo.sp_help_job  
    @job_name = N'Perf: Check and Clear Adhoc Plan Cache',  
    @job_aspect = N'ALL' ;  
GO  


exec perfstats.dbo.perf_check_and_clear_adhoc_plancache


--IMplementation 
/*
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name='Unitrac-UTL' AND category_class=1)
BEGIN
    EXEC msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name='Unitrac-UTL' 
END


	EXEC dbo.sp_update_job @job_id='93720C1C-AAD4-47E2-910A-631B7DA50F75', -- uniqueidentifier
	    @category_name='Unitrac-UTL' -- sysname


EXEC dbo.sp_update_jobstep @job_id='93720C1C-AAD4-47E2-910A-631B7DA50F75', -- uniqueidentifier
    @step_id=3, -- int
    @command=N'	use UTL  set QUOTED_IDENTIFIER on     CREATE TABLE #Temp  ( [pd_id]  [varchar](40),   [pd_name_tx]  [varchar](40),   [days_pend_rematch_now] [varchar](40) )  INSERT INTO #Temp exec UT_DailyUTL_Breakdown        DECLARE @xml NVARCHAR(MAX) DECLARE @body NVARCHAR(MAX)  SET @xml = CAST(( SELECT [pd_id]  AS ''td'','''', [pd_name_tx] AS ''td'','''', [days_pend_rematch_now] AS ''td'',''''  FROM #Temp   ORDER BY pd_id FOR XML PATH(''tr''), ELEMENTS ) AS NVARCHAR(MAX))  SET @body =''Here is todays Daily UTL Rematch Report (see attachment above)  <html><body><H3>DaysPendingRematch</H3> <table border = 1>  <tr> <th> Process Definition # </th> <th>Process Definition Name</th><th> Count </th></tr> ''      SET @body = @body + @xml +''</table></body></html>''                EXEC msdb.dbo.sp_send_dbmail     @Subject= ''Daily UTL Rematch Report'',    @profile_name = ''Unitrac-prod'',    @body = @body,    @body_format =''HTML'',    @recipients = ''sysadmin-oncall@alliedsolutions.net;noc@alliedsolutions.net;Kenalea.Lawing@alliedsolutions.net'',     @file_attachments= ''D:\SQL\DailyUTL.csv''; ' -- nvarchar(max)


	
USE msdb
   EXEC dbo.sp_help_job  
    @job_name = N'Report: Generate and eMail Daily UTL match & rematch stats',  
    @job_aspect = N'ALL' ;  
GO  

*/


--Backout

/*


EXEC dbo.sp_delete_category @class=N'JOB', @name='Unitrac-UTL' 


	EXEC dbo.sp_update_job @job_id='93720C1C-AAD4-47E2-910A-631B7DA50F75', -- uniqueidentifier
	    @category_name='[Uncategorized (Local)]' -- sysname


EXEC dbo.sp_update_jobstep @job_id='93720C1C-AAD4-47E2-910A-631B7DA50F75', -- uniqueidentifier
    @step_id=3, -- int
    @command=N'	use UTL  set QUOTED_IDENTIFIER on     CREATE TABLE #Temp  ( [pd_id]  [varchar](40),   [pd_name_tx]  [varchar](40),   [days_pend_rematch_now] [varchar](40) )  INSERT INTO #Temp exec UT_DailyUTL_Breakdown        DECLARE @xml NVARCHAR(MAX) DECLARE @body NVARCHAR(MAX)  SET @xml = CAST(( SELECT [pd_id]  AS ''td'','''', [pd_name_tx] AS ''td'','''', [days_pend_rematch_now] AS ''td'',''''  FROM #Temp   ORDER BY pd_id FOR XML PATH(''tr''), ELEMENTS ) AS NVARCHAR(MAX))  SET @body =''Here is todays Daily UTL Rematch Report (see attachment above)  <html><body><H3>DaysPendingRematch</H3> <table border = 1>  <tr> <th> Process Definition # </th> <th>Process Definition Name</th><th> Count </th></tr> ''      SET @body = @body + @xml +''</table></body></html>''                EXEC msdb.dbo.sp_send_dbmail     @Subject= ''Daily UTL Rematch Report'',    @profile_name = ''Unitrac-prod'',    @body = @body,    @body_format =''HTML'',    @recipients = '';julie.seery@alliedsolutions.net;nicholas.schaub@alliedsolutions.net;Kenalea.Lawing@alliedsolutions.net;lindsey.cusson@ospreysoftware.com ;jerry.lamb@ospreysoftware.com;bob.paquette@ospreysoftware.com; mike.funiciello@ospreysoftware.com;lisa.mcanulty@ospreysoftware.com;stacey.richardson@ospreysoftware.com;noc@alliedsolutions.net; aston.sanders@ospreysoftware.com;erik.gold@ospreysoftware.com;joseph.russell@alliedsolutions.net;alison.moran@alliedsolutions.net'',     @file_attachments= ''D:\SQL\DailyUTL.csv''; ' -- nvarchar(max)



*/
