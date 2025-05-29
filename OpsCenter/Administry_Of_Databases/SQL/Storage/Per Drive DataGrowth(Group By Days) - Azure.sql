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
SELECT DB.name, DatabaseName, 
       te.name, 
       Filename, 
	  CONVERT(date,StartTime) [Date] ,
	   SUM( (IntegerData * 8.0 / 1024)) AS 'ChangeInSize MB',
  LoginName
FROM ::fn_trace_gettable(@0_tracefilename, DEFAULT) t
     INNER JOIN sys.trace_events AS te ON t.EventClass = te.trace_event_id
	       LEFT JOIN sys.databases DB
              ON DB.physical_database_name = t.DatabaseName
WHERE(trace_event_id >= 92
	  AND  DB.name  IN (SELECT name from sys.databases WHERE database_id >=5 AND  name NOT IN ('DBA','Perfstats')) 
      AND trace_event_id <= 95)
	  AND  DB.name like '%'+ @DatabaseName +'%' 
GROUP BY DB.name,DatabaseName, 
       te.name, 
       Filename, 
        CONVERT(date,StartTime),   LoginName
ORDER BY CONVERT(DATE,StartTime) desc


