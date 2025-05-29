USE UniTrac


---Find the report name for the missing ID
SELECT
rh.ID
	INTO #tmpRHID
	FROM REPORT_HISTORY rh 
WHERE   RH.STATUS_CD = 'ERR' 
        AND CAST(RH.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND rh.REPORT_ID ='35'



---Use the report Id and update ## field and the XXXXXXXX with the report ID
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE(), DOCUMENT_CONTAINER_ID = NULL, OUTPUT_TYPE_CD ='E'
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN (SELECT * FROM #tmpRHID) 


/*
DROP TABLE #tmpRHID
DROP TABLE #tmpRPID
DROP TABLE #tmpRPTName
*/


