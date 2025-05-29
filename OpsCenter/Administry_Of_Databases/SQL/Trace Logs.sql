USE tempdb
GO

IF OBJECT_ID('dbo.TraceTable', 'U') IS NOT NULL
	DROP TABLE dbo.TraceTable;

SELECT * INTO TraceTable
FROM ::fn_trace_gettable
--('E:\Program Files\Microsoft SQL Server\MSSQL14.I01\MSSQL\Log\log_58.trc', default)
((SELECT path FROM sys.traces WHERE is_default = 1), default) 

GO

SELECT
	 DatabaseID
	,DatabaseName
	,LoginName
	,HostName
	,ApplicationName
	,StartTime, EventClass
	,CASE
		WHEN EventClass = 46 THEN 'Object:Created'
		WHEN EventClass = 47 THEN 'Object:Dropped'
		WHEN EventClass = 164 THEN 'Object:Altered'
	ELSE 'NONE'
	END AS EventType

FROM tempdb.dbo.TraceTable
	WHERE EventClass NOT IN ('22','115')
	AND 
	EventClass  IN ('46', '47', '164')
	AND
	DatabaseName not in ('Master')

	--	AND (EventClass = 46 /* Event Class 46 refers to Object:Created */
		--	OR EventClass = 47) /* Event Class 47 refers to  */
