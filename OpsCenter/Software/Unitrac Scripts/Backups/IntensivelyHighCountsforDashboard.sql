USE PerfStats

SELECT CONVERT(DATE, current_dt) AS [Current], COUNT(session_id)  [Count], host_name
FROM dbo.LongRunningTransactions
WHERE login_name = 'UTdbInternalDashWinServiceProd'
AND current_dt >= '2017-04-01 '
GROUP BY CONVERT(DATE, current_dt), host_name
ORDER BY CONVERT(DATE, current_dt) DESC 


--2017-08-28



SELECT *
FROM dbo.LongRunningTransactions
WHERE login_name = 'UTdbInternalDashWinServiceProd'
AND current_dt >= '2017-10-19 '
GROUP BY CONVERT(DATE, current_dt), host_name
ORDER BY CONVERT(DATE, current_dt) DESC 


