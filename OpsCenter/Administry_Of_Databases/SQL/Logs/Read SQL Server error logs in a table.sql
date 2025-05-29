
IF OBJECT_ID(N'tempdb..#IOWarningResults') IS NOT NULL
DROP TABLE #IOWarningResults

CREATE TABLE #IOWarningResults(LogDate datetime, ProcessInfo sysname, LogText nvarchar(1000));
	
	INSERT INTO #IOWarningResults 
	EXEC xp_readerrorlog 0, 1, N'';

	INSERT INTO #IOWarningResults 
	EXEC xp_readerrorlog 1, 1, N'';

	INSERT INTO #IOWarningResults 
	EXEC xp_readerrorlog 2, 1, N'';

	INSERT INTO #IOWarningResults 
	EXEC xp_readerrorlog 3, 1, N'';

	INSERT INTO #IOWarningResults 
	EXEC xp_readerrorlog 4, 1, N'';

	INSERT INTO #IOWarningResults 
	EXEC xp_readerrorlog 5, 1, N'';
		
	INSERT INTO #IOWarningResults 
	EXEC xp_readerrorlog 6, 1, N'';

	INSERT INTO #IOWarningResults 
	EXEC xp_readerrorlog 7, 1, N'';

	
	INSERT INTO #IOWarningResults 
	EXEC xp_readerrorlog 8, 1, N'';



	
SELECT LogDate, ProcessInfo, LogText
FROM #IOWarningResults
WHERE LogText LIKE '%%'
ORDER BY LogDate DESC;







	
SELECT LogDate, ProcessInfo, LogText
--select  count(*) math, '+'
FROM #IOWarningResults
WHERE CAST(LogDate AS DATE) >= cast(getdate() AS date)
and processinfo <> 'Backup'
and logtext not like '%Backup passed.%'
and logtext not like '%DBCC CHECKDB%'
and logtext not like '%All rights reserved.%'
and logtext not like '%Attempting to cycle error log. This is an informational message only; no user action is required.%'
and logtext not like '%UTC adjustment: %:00%'
and logtext not like '%DBCC CHECKDB%'
and logtext not like '%System Manufacturer: ''VMware, Inc.'', System Model: ''VMware Virtual Platform''.%'
and logtext not like '%Server process ID is%'
and logtext not like '%Authentication mode is %'
and logtext not like '%(c) Microsoft Corporation.%'
and logtext not like '%Default collation: SQL_Latin1_General_CP1_CI_AS (us_english 1033)%'
and logtext not like '%The service account is %. This is an informational message; no user action is required.%'
and logtext not like '%This is an informational message%'
and logtext not like '%The error log has been reinitialized. See the previous log for older entries.%'
and logtext not like '%The Service Broker endpoint is in disabled or stopped state.%'
and logtext not like '%Microsoft SQL Server %'
and logtext not like '%Logging SQL Server messages in file %'
and logtext not like '%System Manufacturer: %'
and logtext not like '%I/O was resumed %'
and logtext not like '%I/O is frozen %'
and logtext not like 'Login succeeded%'
and logtext not like 'Error:%'
and ProcessInfo != 'Logon'
ORDER BY LogDate DESC;

