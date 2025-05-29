USE UniTrac

SELECT
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE,
 * FROM dbo.REPORT_HISTORY rh
JOIN dbo.LENDER L ON L.ID = rh.LENDER_ID
WHERE L.CODE_TX = '6497' AND rh.UPDATE_DT >= '2014-06-07 '
AND rh.UPDATE_DT <= '2014-06-08 '


---4930564





		            ---------------- Setting Report to Re-Pend/Re-Try -------------------
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE()
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN 
(4930564)