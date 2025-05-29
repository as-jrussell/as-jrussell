DECLARE @current_tracefilename VARCHAR(500);
DECLARE @0_tracefilename VARCHAR(500);
DECLARE @indx INT;

DECLARE @DatabaseName VARCHAR(100) = 'hdtstorage'
DECLAre @Username VARCHAR(100) = 'ELDREDGE_A\'

SELECT @current_tracefilename = path
FROM sys.traces
WHERE is_default = 1;
SET @current_tracefilename = REVERSE(@current_tracefilename);
SELECT @indx = PATINDEX('%\%', @current_tracefilename);
SET @current_tracefilename = REVERSE(@current_tracefilename);
SET @0_tracefilename = LEFT(@current_tracefilename, LEN(@current_tracefilename) - @indx) + '\log.trc';
SELECT DatabaseName, 
       te.name, 
       Filename, 
	  CONVERT(date,StartTime) [Date] ,
       (IntegerData * 8.0 / 1024) AS 'ChangeInSize MB', 
	   	(t.duration)/1000000.0 as Duration_Secs,   LoginName, objectname,StartTime
FROM ::fn_trace_gettable(@0_tracefilename, DEFAULT) t
     INNER JOIN sys.trace_events AS te ON t.EventClass = te.trace_event_id
WHERE loginname like '%'+ @Username+'%' and 
	   DatabaseName like '%'+ @DatabaseName +'%' 
	   AND te.name <> 'Audit Backup/Restore Event'
ORDER BY CONVERT(DATE,StartTime) desc


--select * from AIH22117_LocationServices_VrmClients
--select * from AIH22117_1_LocationServices_VrmClients
--select * from  AIH22117_1_LocationServices_VrmClients
--select * from AIH22117_LocationServices_VrmClients