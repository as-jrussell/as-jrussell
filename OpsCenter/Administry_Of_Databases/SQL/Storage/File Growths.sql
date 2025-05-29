/* This script needs to be ran on the server and connected to the instance that this information is being read from */

-- Trace Events 
select * from sys.trace_events

--Get trace file location
select *
from sys.fn_trace_getinfo(1);


--Get file growths
select
    te.name as event_name,
    tr.DatabaseName,
    tr.FileName,
    tr.StartTime,
    tr.EndTime
from sys.fn_trace_gettable('E:\Program Files\Microsoft SQL Server\MSSQL14.I01\MSSQL\Log\log_49.trc', 0) tr
inner join sys.trace_events te
on tr.EventClass = te.trace_event_id
where tr.EventClass in (92, 93)
order by EndTime;

