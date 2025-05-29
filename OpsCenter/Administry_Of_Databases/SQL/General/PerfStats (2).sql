USE PerfStats

SELECT * FROM PerfStats..LongRunningTransactions L
WHERE transaction_begin_time >= '2017-05-01 00:00:00.000'
ORDER BY transaction_begin_time ASC 


--SELECT * FROM PerfStats..IOStatsTemp


--SELECT name as Database_Name, database_id as Database_ID, * FROM sys.databases




--SELECT * FROM dbo.OS_Schedulers


