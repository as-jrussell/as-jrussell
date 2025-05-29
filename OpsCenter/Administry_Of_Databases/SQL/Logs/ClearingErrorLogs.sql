DECLARE @Path nvarchar(250) 

SELECT @Path = REPLACE(CONCAT(CONCAT('\\', CONVERT(nvarchar, @@SERVERNAME)), '\',CONVERT(nvarchar(100), SERVERPROPERTY('ErrorLogFileName')), '\'),':','$')   


IF Object_id(N'tempdb..#ErrorLogs') IS NOT NULL
DROP TABLE #ErrorLogs

CREATE TABLE #ErrorLogs (ArchiveNumber NVARCHAR(1), [Date] DATE, [Log File] INT)

INSERT INTO #ErrorLogs
EXEC sys.sp_enumerrorlogs

IF EXISTS (SELECT 1 FROM #ErrorLogs WHERE ArchiveNumber = 0 AND [Log File] >= 50000000000) 

BEGIN 
EXEC sp_cycle_errorlog;
PRINT 'File path is: '+ @Path 
PRINT 'SUCCESS:Logs were cleared but file not deleted until it reaches the max number!' 
END
ELSE 
BEGIN
PRINT 'File path is: '+ @Path 
PRINT 'ERROR: File did not meet criteria size to clear!'
END