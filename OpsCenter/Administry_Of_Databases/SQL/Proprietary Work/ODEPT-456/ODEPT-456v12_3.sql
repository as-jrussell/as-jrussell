DECLARE @current_tracefilename VARCHAR(500);
DECLARE @0_tracefilename VARCHAR(500);
DECLARE @indx INT;

SELECT @current_tracefilename = path
FROM sys.traces
WHERE is_default = 1;
SET @current_tracefilename = REVERSE(@current_tracefilename);
SELECT @indx = PATINDEX('%\%', @current_tracefilename);
SET @current_tracefilename = REVERSE(@current_tracefilename);
SET @0_tracefilename = LEFT(@current_tracefilename, LEN(@current_tracefilename) - @indx) + '\log.trc';
SELECT 
	   	AVG( (IntegerData * 8.0 / 1024)) AS 'Daily Avg in MB',
	   volume_mount_point

FROM ::fn_trace_gettable(@0_tracefilename, DEFAULT) t
     INNER JOIN sys.trace_events AS te ON t.EventClass = te.trace_event_id
	 INNER JOIN  sys.master_files AS f WITH (NOLOCK) ON f.name = Filename
CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.[file_id]) AS vs 
WHERE(trace_event_id >= 92
      AND trace_event_id <= 95)
GROUP BY  volume_mount_point 