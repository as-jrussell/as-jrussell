

-----Complete
SELECT COUNT(*)[Number of Reports Done by UBSRPT], MAX(UPDATE_DT) [Last Report Done by UBSRPT]
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'COMP'
AND UPDATE_DT >= '2016-03-02 14:00:00'
		AND UPDATE_USER_TX = 'UBSRPT'
        AND GENERATION_SOURCE_CD = 'u'
        AND MSG_LOG_TX IS NOT NULL
		 

-----Complete
SELECT *
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'COMP'
AND UPDATE_DT >= '2016-03-02 12:00:00'
		--AND UPDATE_USER_TX = 'UBSRPT'
        AND GENERATION_SOURCE_CD = 'u'
        AND MSG_LOG_TX IS NOT NULL
ORDER BY RECORD_COUNT_NO DESC

--UPDATE dbo.REPORT_HISTORY
--SET STATUS_CD = 'HOLD'


SELECT * FROM dbo.REPORT_HISTORY
		WHERE 
STATUS_CD = 'PEND'  --AND REPORT_ID <> '27'
		ORDER BY CREATE_DT ASC


		SELECT * FROM dbo.WORK_ITEM
		WHERE id = '29896013'

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (31561710)
