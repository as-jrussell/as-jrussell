
USE msdb

BEGIN TRAN
--QA  - 67083305-EF7E-4B82-A687-A345AED2D835
--PROD - 93720C1C-AAD4-47E2-910A-631B7DA50F75

DECLARE @job_name nvarchar(50) = 'Report: Generate and eMail Daily UTL match & rematch stats'
DECLARE @job_id nvarchar(150)  ='93720C1C-AAD4-47E2-910A-631B7DA50F75'
DECLARE @step_id nvarchar(1) = '3'
DECLARE @RowsToPreserveWI bigint;


IF EXISTS (SELECT 1
 FROM msdb.dbo.sysjobs sj
WHERE name = 'Report: Generate and eMail Daily UTL match & rematch stats')

BEGIN 
EXEC dbo.sp_update_jobstep @job_id=@job_id, -- uniqueidentifier
    @step_id=@step_id, -- int
    @command='		use UTL  set QUOTED_IDENTIFIER on     CREATE TABLE #Temp  ( [pd_id]  [varchar](40),   [pd_name_tx]  [varchar](40),   [days_pend_rematch_now] [varchar](40) )  INSERT INTO #Temp exec UT_DailyUTL_Breakdown        DECLARE @xml NVARCHAR(MAX) DECLARE @body NVARCHAR(MAX)  SET @xml = CAST(( SELECT [pd_id]  AS ''td'','''', [pd_name_tx] AS ''td'','''', [days_pend_rematch_now] AS ''td'',''''  FROM #Temp   ORDER BY pd_id FOR XML PATH(''tr''), ELEMENTS ) AS NVARCHAR(MAX))  SET @body =''Here is todays Daily UTL Rematch Report (see attachment above)  <html><body><H3>DaysPendingRematch</H3> <table border = 1>  <tr> <th> Process Definition # </th> <th>Process Definition Name</th><th> Count </th></tr> ''      SET @body = @body + @xml +''</table></body></html>''                EXEC msdb.dbo.sp_send_dbmail     @Subject= ''Daily UTL Rematch Report'',    @profile_name = ''Unitrac-prod'',    @body = @body,    @body_format =''HTML'',    @recipients = ''sysadmin-oncall@alliedsolutions.net;noc@alliedsolutions.net'',     @file_attachments= ''D:\SQL\DailyUTL.csv''; ' -- nvarchar(max)

PRINT 'Successful'
COMMIT 
END
ELSE
BEGIN 
PRINT 'Reverting back'
ROLLBACK
END
 


