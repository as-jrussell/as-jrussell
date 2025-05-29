
--Total Pending

SELECT COUNT(*)TotalPending FROM report_history WHERE STATUS_CD = 'pend'


--Pending based on created date

SELECT CAST(rh.create_dt AS date) CreateDate, COUNT(*) AS TotalPending FROM REPORT_HISTORY RH
WHERE RH.STATUS_CD = 'pend'
GROUP BY CAST(rh.create_dt AS date)
ORDER BY CAST(rh.create_dt AS date)


SELECT
	COUNT(*) TotalErrorToday
FROM REPORT_HISTORY
WHERE STATUS_CD = 'err' AND CAST(UPDATE_DT AS date) = CAST(GETDATE() AS date) AND GENERATION_SOURCE_CD = 'u'
AND MSG_LOG_TX IS NOT NULL

--Total Completed
SELECT COUNT(*)TotalCompleted FROM report_history WHERE STATUS_CD = 'COMP' and UPDATE_DT >= DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)

--Pending Per Report Type Per Create Date, Ordered by total

SELECT R.DISPLAY_NAME_TX, report_id, MIN(rh.CREATE_DT) EarliestCreateDate, COUNT(*) AS TotalPending FROM REPORT_HISTORY RH
JOIN REPORT R ON RH.REPORT_ID = R.id
WHERE RH.STATUS_CD = 'pend'
GROUP BY R.DISPLAY_NAME_TX, report_id, CAST(rh.create_dt AS date)
ORDER BY COUNT(*) desc



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
WHERE STATUS_CD = 'comp'
AND UPDATE_DT >= '2022-05-06'
GROUP BY	rh.REPORT_ID,
			tt.REPORT_DOMAIN_CD
ORDER BY REPORT_DOMAIN_CD DESC


--Breakdown of pending individual loan stat (id 27) reports


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