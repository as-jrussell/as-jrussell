

-----Complete
SELECT COUNT(*)[Number of Reports Done by UBSRPT], MAX(UPDATE_DT) [Last Report Done by UBSRPT]
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'COMP'
AND UPDATE_DT >= '2016-03-15 20:00:00'
		AND UPDATE_USER_TX = 'UBSRPT'
        AND GENERATION_SOURCE_CD = 'u'
        AND MSG_LOG_TX IS NOT NULL
		 

-----Complete
SELECT *
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'COMP'
AND UPDATE_DT >= '2016-03-15 20:00:00'
		AND UPDATE_USER_TX = 'UBSRPT'
        AND GENERATION_SOURCE_CD = 'u'
        AND MSG_LOG_TX IS NOT NULL
ORDER BY UPDATE_DT DESC


SELECT *
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'PEND'
ORDER BY UPDATE_DT DESC

SELECT *
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'PEND'
ORDER BY UPDATE_DT DESC

	
-----Complete
SELECT *
--INTO UniTracHDStorage..ErrorReports_ID_20160315
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'ERR' AND
UPDATE_DT >= '2016-03-15 00:00:00' --AND ID IN (9059152,9059141)
ORDER BY UPDATE_DT DESC



SELECT TOP 1 *
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'COMP'
ORDER BY UPDATE_DT DESC



SELECT * FROM dbo.REPORT_HISTORY
WHERE RECORD_COUNT_NO = '606722'



SELECT * FROM dbo.DOCUMENT_CONTAINER
WHERE ID = '55349125'



SELECT * FROM dbo.LENDER
WHERE ID = '2184'

UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE()
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN (9066644, 9066648, 9066643)