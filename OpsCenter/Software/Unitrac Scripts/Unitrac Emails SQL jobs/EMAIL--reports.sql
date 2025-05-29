Use Unitrac

 Begin
 
CREATE TABLE #tmpRH (ID BIGINT)

INSERT INTO #tmprh
SELECT RH.ID
FROM report_history RH
WHERE CAST(RH.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND rh.REPORT_ID IS NULL

IF ((select count(*) from #tmpRH) >=1 )
BEGIN 


DECLARE @EmailSubject AS VARCHAR(MAX )
declare @EmailSubjectCount AS VARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)

 select @EmailSubjectCount = 
   (SELECT COUNT(ID) FROM #tmpRH)
  BEGIN

 if @EmailSubjectCount >= 1 
 

SELECT ID INTO #tmpRHM FROM dbo.MESSAGE
WHERE RELATE_ID_TX IN (SELECT * FROM #tmpRH)


---Find the report name for the missing ID
SELECT
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE
	INTO #tmpRPTName
	FROM REPORT_HISTORY rh 
WHERE   RH.STATUS_CD = 'ERR' 
        AND CAST(RH.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND rh.REPORT_ID IS NULL


---Place the Name in the description field
SELECT DISTINCT R.ID INTO #tmpRPID
 FROM dbo.REPORT R 
JOIN dbo.REPORT_CONFIG RC ON RC.REPORT_ID = r.ID
JOIN dbo.LENDER_REPORT_CONFIG LRC ON LRC.REPORT_CONFIG_ID = RC.ID
WHERE LRC.DESCRIPTION_TX IN (SELECT * FROM #tmpRPTName)

---Find the report history ID for the missing ID
SELECT ID 
INTO #tmpRHID
FROM REPORT_HISTORY rh 
WHERE   RH.STATUS_CD = 'ERR' 
 AND CAST(RH.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND rh.REPORT_ID IS NULL



---Use the report Id and update ## field and the XXXXXXXX with the report ID
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE()
		,REPORT_ID = (SELECT ID FROM #tmpRPID)
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN (SELECT * FROM #tmpRHID) 




SELECT 	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as NAME_TX INTO #tmpOPP FROM dbo.REPORT_HISTORY RH
WHERE RH.ID IN (SELECT ID FROM #tmpRH)
		
SELECT ID INTO #tmpOP FROM dbo.REPORT_HISTORY RH
WHERE RH.ID IN (SELECT ID FROM #tmpRHM)

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



select @body = 'Reports that with no IDs: 
'  + (SELECT * FROM #tmpOO) + 
'

Report Name : ' + (SELECT * FROM #tmpO) 

  

select @EmailSubject = 'Messages: '  +   CONVERT(VARCHAR(MAX), @EmailSubjectCount) 
		 

 
		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
						@recipients = 'joseph.russell@alliedsolutions.net;',
						@subject = @EmailSubject,
						@body = @body
					RETURN

END END END 

/*
DROP TABLE #tmpRH
DROP TABLE #tmpRHM
DROP TABLE #tmpO
DROP TABLE #tmpOO
DROP TABLE #tmpOP
DROP TABLE #tmpOPP*/