USE [UniTrac]
GO 

SELECT
COUNT(*) [Counts], rh.STATUS_CD [Status]
FROM REPORT_HISTORY rh 
WHERE CAST(RH.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY	rh.STATUS_CD


SELECT COUNT(*)[Number of Reports Done by UBSRPT], MAX(UPDATE_DT) [Last Report Done by UBSRPT]
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'COMP'
AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
		AND UPDATE_USER_TX = 'UBSRPT'

	