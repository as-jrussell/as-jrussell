DECLARE @EmailSubject AS VARCHAR(100)
declare @EmailSubjectCount AS int
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount =
( SELECT count(PD_ID) from #TMP_PDId)

 if @EmailSubjectCount > 0
 Begin

		SELECT 
					(SELECT 
						  CAST(PD_ID AS VARCHAR(20)) + ', ' 
					FROM #TMP_PDId
					FOR xml PATH ('')) AS PDIds
		INTO #tmp



		select @body = 'Process ID(s): ' + (select * from #tmp)
		 
		select @EmailSubject = 'Subject ' +  CONVERT(VARCHAR(20), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Profile Name',
						@recipients = 'emails go here',
						@subject = @EmailSubject,
						@body = @body
					RETURN
End