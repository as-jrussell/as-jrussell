Use Unitrac

 Begin

 
CREATE TABLE #TMP (OUTBATCH_ID NVARCHAR(4000))

INSERT INTO #TMP
 SELECT EXTERNAL_ID  FROM dbo.OUTPUT_BATCH WHERE STATUS_CD = 'IP'
AND  UPDATE_DT <= DATEADD(HOUR, -8, GETDATE())
 AND EXTERNAL_ID NOT LIKE 'RPT%' AND EXTERNAL_ID NOT IN ('NTC_46869418_1464209',
'NTC_46869418_1464210',
'NTC_46869418_1464211',
'NTC_46871213_1464601',
'FPC_46871213_1464602',
'NTC_46871255_1464615')


IF ((select count(*) from #TMP) >=1 )
BEGIN



DECLARE @EmailSubject AS VARCHAR(100)
declare @EmailSubjectCount AS VARCHAR(100)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(OUTBATCH_ID) FROM #tmp)

	SELECT 
					(SELECT 
						  CAST(OUTBATCH_ID AS VARCHAR(20)) + ', ' 
					FROM #tmp
					FOR XML PATH ('')) AS OutBatchID
		INTO #tmpO


		
select @body = 'These batches are currently still in process: '  + (SELECT * FROM #tmpO)


select @EmailSubject = 'Batches in Process 
'  +   CONVERT(VARCHAR(20), @EmailSubjectCount) 
		 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients = 'joseph.russell@alliedsolutions.net; anthony.newbern@alliedsolutions.net',
						@subject = @EmailSubject,
						@body = @body
					RETURN
END


END