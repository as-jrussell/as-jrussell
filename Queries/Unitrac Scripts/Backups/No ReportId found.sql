USE UniTrac


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
