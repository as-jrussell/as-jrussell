Use Unitrac

 Begin
 
CREATE TABLE #tmpEmptyPL (PD_ID BIGINT)

INSERT INTO #tmpEmptyPL
SELECT PD.ID FROM dbo.PROCESS_LOG PL JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID WHERE CAST(PL.UPDATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE) AND PROCESS_TYPE_CD = 'CYCLEPRC' AND PL.MSG_TX = 'Total WorkItems processed: 0'

DECLARE @EmailSubject AS VARCHAR(100)
declare @EmailSubjectCount AS VARCHAR(100)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(PD_ID) FROM #tmpEmptyPL)
 

 if @EmailSubjectCount >= 1 
 

SELECT NAME_TX INTO #tmpOP FROM dbo.PROCESS_DEFINITION
WHERE ID IN (SELECT * FROM #tmpEmptyPL)
		
 

 	SELECT 
					(SELECT 
						  CAST(NAME_TX AS NVARCHAR(20)) + '; ' 
					FROM #tmpOP
					FOR XML PATH ('')) AS OutBatchID
		INTO #tmpO



select @body = 'These Process Definition ID are showing zero work items: 
'  + (SELECT * FROM #tmpO)

   END 

select @EmailSubject = 'Empty Work Items: '  +   CONVERT(VARCHAR(20), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients = 'joseph.russell@alliedsolutions.net',
						@subject = @EmailSubject,
						@body = @body
					RETURN


					--DROP TABLE #tmpEmptyPL
					--DROP TABLE #tmpO
					--DROP TABLE #tmpOP