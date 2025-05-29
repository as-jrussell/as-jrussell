Use Unitrac

 Begin

 
CREATE TABLE #TMP (OUTBATCH_ID BIGINT)

INSERT INTO #TMP
 SELECT ID  FROM dbo.OUTPUT_BATCH WHERE STATUS_CD = 'ERR' AND CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
   AND EXTERNAL_ID not LIKE 'RPT%'





DECLARE @EmailSubject AS VARCHAR(100)
declare @EmailSubjectCount AS VARCHAR(100)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(OUTBATCH_ID) FROM #tmp)
 

 if @EmailSubjectCount > 0
 
 
 UPDATE dbo.OUTPUT_BATCH
 SET STATUS_CD = 'PEND', LOCK_ID = LOCK_ID+1
 WHERE ID IN (SELECT OUTBATCH_ID FROM #tmp)

 	SELECT 
					(SELECT 
						  CAST(OUTBATCH_ID AS VARCHAR(20)) + ', ' 
					FROM #tmp
					FOR XML PATH ('')) AS OutBatchID
		INTO #tmpO

		
select @body = 'These batches ID were in error: '  + (SELECT * FROM #tmpO)

   END 

select @EmailSubject = 'Batches in Error '  +   CONVERT(VARCHAR(20), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients = 'joseph.russell@alliedsolutions.net',
						@subject = @EmailSubject,
						@body = @body
					RETURN
