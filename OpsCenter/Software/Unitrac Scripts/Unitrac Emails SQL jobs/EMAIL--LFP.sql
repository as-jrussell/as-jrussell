Use Unitrac

 Begin
 
CREATE TABLE #tmpM (ID BIGINT)

INSERT INTO #tmpM
SELECT WI.RELATE_ID 
FROM dbo.WORK_ITEM WI
WHERE WI.STATUS_CD = 'Approve' AND 
WORKFLOW_DEFINITION_ID = '1'  
AND WI.LENDER_ID = '867'

IF ((select count(*) from #tmpM) >=1 )
BEGIN 


DECLARE @EmailSubject AS VARCHAR(MAX )
declare @EmailSubjectCount AS VARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(ID) FROM #tmpM)
  BEGIN

 if @EmailSubjectCount >= 1 
 

SELECT ID INTO #tmpMM FROM dbo.MESSAGE
WHERE RELATE_ID_TX IN (SELECT * FROM #tmpM
)


UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'OBADHOC'
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   ID IN (SELECT * FROM #tmpMM)



SELECT TP.NAME_TX INTO #tmpOPP FROM dbo.MESSAGE M
JOIN dbo.TRADING_PARTNER TP ON TP.ID = M.RECEIVED_FROM_TRADING_PARTNER_ID
WHERE M.ID IN (SELECT ID FROM #tmpMM)
		
SELECT ID INTO #tmpOP FROM dbo.MESSAGE
WHERE ID IN (SELECT ID FROM #tmpMM)

 	SELECT 
					(SELECT 
						  CAST(NAME_TX AS NVARCHAR(max)) + '; ' 
					FROM #tmpOPP
					FOR XML PATH ('')) AS OutBatchID
		INTO #tmpO

 	SELECT 
					(SELECT 
						  CAST(ID AS NVARCHAR(max)) + ', ' 
					FROM #tmpOP
					FOR XML PATH ('')) AS OutBatchID
		INTO #tmpOO



select @body = 'The Message Id(s) that is were moved to ADHOC: 
'  + (SELECT * FROM #tmpOO) + 
'

Lender : ' + (SELECT * FROM #tmpO) 

  

select @EmailSubject = 'Messages: '  +   CONVERT(VARCHAR(MAX), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients = 'joseph.russell@alliedsolutions.net;',
						@subject = @EmailSubject,
						@body = @body
					RETURN

END END END 

/*
DROP TABLE #tmpM
DROP TABLE #tmpMM
DROP TABLE #tmpO
DROP TABLE #tmpOO
DROP TABLE #tmpOP
DROP TABLE #tmpOPP*/