Use Unitrac

 Begin
 
CREATE TABLE #tmpEmptyPL (PD_ID BIGINT)

INSERT INTO #tmpEmptyPL
SELECT DISTINCT PD.ID 
FROM    dbo.PROCESS_LOG PL
        JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE   CAST(PL.UPDATE_DT AS DATE) = CAST(GETDATE()  AS DATE)
        AND PD.PROCESS_TYPE_CD = 'CYCLEPRC'
        AND (PL.MSG_TX = 'Total WorkItems processed: 0' OR  PL.MSG_TX IS  NULL OR PL.MSG_TX LIKE '%Error%')
		AND PL.STATUS_CD = 'Complete'

IF ((select count(*) from #tmpEmptyPL)>= 1)

BEGIN

DECLARE @EmailSubject AS VARCHAR(1000)
declare @EmailSubjectCount AS VARCHAR(1000)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(PD_ID) FROM #tmpEmptyPL)
 

 if @EmailSubjectCount >= 1 
 
 BEGIN
SELECT NAME_TX INTO #tmpOP FROM dbo.PROCESS_DEFINITION
WHERE ID IN (SELECT * FROM #tmpEmptyPL)
		
 

 	SELECT 
					(SELECT 
						  CAST(NAME_TX AS NVARCHAR(1000)) + '; ' 
					FROM #tmpOP
					FOR XML PATH ('')) AS OutBatchID
		INTO #tmpO

 	SELECT 
					(SELECT 
						  CAST(PD_ID AS NVARCHAR(1000)) + ', ' 
					FROM #tmpEmptyPL
					FOR XML PATH ('')) AS PD_ID
		INTO #tmpOO


select @body = 'These Process Definition Names are showing zero work items: '  + (SELECT * FROM #tmpO)+

'

The Process Ids are: ' + (SELECT * FROM #tmpOO)
   END 

select @EmailSubject = 'Empty Work Items: '  +   CONVERT(VARCHAR(1000), @EmailSubjectCount) 
		 

  
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients ='Joseph.Russell@alliedsolutions.net; ISS@alliedsolutions.net; Jennifer.Mitchell@alliedsolutions.net',
						@subject = @EmailSubject,
						@body = @body
					RETURN

			END END 
			