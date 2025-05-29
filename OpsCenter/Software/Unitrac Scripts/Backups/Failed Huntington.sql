SET QUOTED_IDENTIFIER ON

SELECT * INTO #TMP_PDId FROM dbo.MESSAGE M
WHERE   M.RECEIVED_STATUS_CD = 'ERR'
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE()  AS DATE) AND UPDATE_USER_TX = 'MsgSrvrEXTHUNT'
ORDER BY M.CREATE_DT DESC


SELECT COUNT(ID) FROM #TMP_PDId






DECLARE @EmailSubject AS VARCHAR(100)
declare @EmailSubjectCount AS int
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
( SELECT count(ID) from #TMP_PDId)

 if @EmailSubjectCount > 0
 Begin

		SELECT 
					(SELECT 
						  CAST(ID AS VARCHAR(20)) + ', ' 
					FROM #TMP_PDId
					FOR xml PATH ('')) AS PDIds
		INTO #tmp



		select @body = 'Failed Message Count: ' + (select * from #tmp)
		
		select @EmailSubject = 'Huntington Lender Message has failed! '
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients = 'joseph.russell@alliedsolutions.net',
						@subject = @EmailSubject,
						@body = @body
					RETURN
END


