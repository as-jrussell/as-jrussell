/*
The default trace should be the first numbered trace running on your SQL Server. 
However, you can verify by looking at the value corresponding to the trace file location. 
This simple query will return that information for all traces running on the system. 
You're looking for a location that matches your default LOG folder
*/

SELECT value FROM ::fn_trace_getinfo(0) where property = 2



/*
Once you have the traceID, you can then query the default trace file using the fn_trace_gettable() function. 
One catch if you use the fn_trace_getinfo() function to determine that the default trace is running: it will return the most current trace file that is open. 
When I ran it, I got a value that ended in log_131.trc. 
However, the starting trace file was log_127.trc. I had to look in the directory to determine the correct file to start from. 
Once you have that, you can display the results as a resultset using the following query (substitute the starting trace file accordingly):
I've ordered it by StartTime, just to get a reasonable order. 
However, you could also use a SELECT INTO and an IDENTITY() column if you need the order perfectly maintained.
*/


SELECT  EventClass, *
FROM    ::FN_TRACE_GETTABLE('C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Log\log_2572.trc',
                          0)
WHERE   EventClass = 104 -- when logins are added or deleted