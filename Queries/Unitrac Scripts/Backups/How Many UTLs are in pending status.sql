USE UniTrac

SELECT COUNT(utl.id), CONVERT(DATE, utl.CREATE_DT)
--select *
FROM dbo.UTL_MATCH_RESULT utl
WHERE APPLY_STATUS_CD  IN ('PEND') AND PURGE_DT IS NULL
AND CONVERT(DATE, utl.CREATE_DT) >= '2020-08-29 00:00'
GROUP BY CONVERT(DATE, utl.CREATE_DT)
ORDER BY CONVERT(DATE, utl.CREATE_DT)