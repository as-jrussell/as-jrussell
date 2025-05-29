DECLARE @EmailSubject AS VARCHAR(100)
declare @EmailSubjectCount AS VARCHAR(100)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount =
( SELECT COUNT(*)
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = 'Approve'
AND CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') IS NULL)

 if @EmailSubjectCount > 20
 Begin

		SELECT 
					(SELECT COUNT(*) [WI in Approve needs to be processed and not touched]
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = 'Approve'
AND CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') IS NULL) AS PDIds
		INTO #tmp

		
select @body = 'The current count of the Work Items that has not been started to be processed is: '  +  @EmailSubjectCount +
'

If the count is over 50 please move some messages to ADHOC process'

select @EmailSubject = 'WI need to process is: ' +  @EmailSubjectCount
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients = 'joseph.russell@alliedsolutions.net',
						@subject = @EmailSubject,
						@body = @body
					RETURN
END


--DROP TABLE #tmp

