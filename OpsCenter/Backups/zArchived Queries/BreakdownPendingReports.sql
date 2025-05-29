----- DATASET 1 (TotalComplete)
DECLARE @CURRDATE AS DATETIME
SET @CURRDATE = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)

SELECT COUNT(*)TotalComplete FROM UniTrac..REPORT_HISTORY
WHERE STATUS_CD = 'Comp' AND (CREATE_DT - @CURRDATE)> 00

----- DATASET 2 (TotalPending)
SELECT COUNT(*)TotalPending FROM report_history WHERE STATUS_CD = 'pend'

----- DATASET 3 (TotalPending With CreateDate)
SELECT CAST(rh.create_dt AS date) CreateDate, COUNT(*) AS TotalPending FROM REPORT_HISTORY RH
WHERE RH.STATUS_CD = 'pend'
GROUP BY CAST(rh.create_dt AS date)
ORDER BY CAST(rh.create_dt AS date)

----- DATASET 4 (TotalErrorToday)
SELECT
	COUNT(*) TotalErrorToday
FROM REPORT_HISTORY
WHERE STATUS_CD = 'err' AND CAST(UPDATE_DT AS date) = CAST(GETDATE() AS date) AND GENERATION_SOURCE_CD = 'u'
AND MSG_LOG_TX IS NOT NULL

----- DATASET 5 (Pending Per Report Type Per Create Date, Ordered by total)
SELECT DISTINCT
	REPORT_ID,
	REPORT_DOMAIN_CD INTO #tmptable
FROM REPORT_CONFIG

SELECT
	rh.REPORT_ID,
	tt.REPORT_DOMAIN_CD,
	MIN(CREATE_DT) EarliestCreateDate,
	COUNT(*) PendingCount
FROM REPORT_HISTORY rh
JOIN #tmptable tt
	ON rh.REPORT_ID = tt.REPORT_ID
WHERE STATUS_CD = 'pend'
GROUP BY	rh.REPORT_ID,
			tt.REPORT_DOMAIN_CD
ORDER BY COUNT(*) DESC

----- DATASET 6 (Breakdown of pending individual loan stat (id 27) reports)
select rh.report_id, r.DISPLAY_NAME_TX, rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as 'ReportType' 
INTO #t
from REPORT_HISTORY rh
  join REPORT r on rh.REPORT_ID = r.ID
where rh.STATUS_CD = 'PEND' and rh.PURGE_DT is null and REPORT_ID in (27)

SELECT t.REPORT_ID,t.DISPLAY_NAME_TX,t.ReportType, COUNT(*) AS TotalPending FROM #t t
GROUP BY t.REPORT_ID,t.DISPLAY_NAME_TX,t.ReportType
ORDER BY COUNT(*) desc

DROP TABLE #t
DROP TABLE #tmptable

----