EXEC xp_ReadErrorLog 0, 1, N'ELDREDGE_A\IgniteMain-Daemon'




IF OBJECT_ID(N'tempdb..#IOWarningResults') IS NOT NULL
DROP TABLE #IOWarningResults

CREATE TABLE #IOWarningResults(LogDate datetime, ProcessInfo sysname, LogText nvarchar(max));
	
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




SELECT LogDate, ProcessInfo, LogText
FROM #IOWarningResults
--WHERE  logtext like '%kill%'

order by LogDate desc 


SELECT min(LogDate)
FROM #IOWarningResults