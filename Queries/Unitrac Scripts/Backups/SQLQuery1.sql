SELECT TOP 100 *
FROM dbo.REPORT_HISTORY 

WHERE REPORT_ID = 27 AND STATUS_CD = 'pend'
--AND CREATE_DT < = ' 2015/10/20 23:59:59'
ORDER BY CREATE_DT DESC


SELECT * FROM dbo.REF_CODE
WHERE MEANING_TX LIKE 'AUDIT'

SELECT * FROM dbo.LENDER
WHERE CODE_TX = '3180'


SELECT * FROM dbo.LOAN L
INNER JOIN dbo.PROPERTY P ON P.LENDER_ID = L.LENDER_ID
INNER JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
WHERE L.LENDER_ID = '2063' AND L.CREATE_DT < '8/1/15'  
AND RC.STATUS_CD = 'A'


SELECT DISTINCT TYPE_CD  FROM	dbo.LOAN

SELECT TOP 4 * FROM dbo.REQUIRED_COVERAGE

SELECT TOP 3 * FROM dbo.PROPERTY