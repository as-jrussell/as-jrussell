DECLARE @current_tracefilename VARCHAR(500);
DECLARE @0_tracefilename VARCHAR(500);
DECLARE @indx INT;

DECLARE @DatabaseName VARCHAR(100) = ''


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
	   	(t.duration)/1000000.0 as Duration_Secs,   LoginName
FROM ::fn_trace_gettable(@0_tracefilename, DEFAULT) t
     INNER JOIN sys.trace_events AS te ON t.EventClass = te.trace_event_id
WHERE(trace_event_id >= 92
--	  AND DatabaseName  IN (SELECT name from sys.databases WHERE database_id >=5 AND  name NOT IN ('DBA','Perfstats')) 
      AND trace_event_id <= 95)
	  AND DatabaseName like '%'+ @DatabaseName +'%' 
GROUP BY DatabaseName, 
       te.name, 
       Filename, 
       StartTime, 
       EndTime, 
       (IntegerData * 8.0 / 1024),
	   	   	(t.duration)/1000000.0 ,   LoginName
ORDER BY CONVERT(DATE,StartTime) desc


