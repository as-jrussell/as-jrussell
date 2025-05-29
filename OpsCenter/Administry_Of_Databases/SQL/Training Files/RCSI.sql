/* How to verify / enable RCSI  

To check whether RCSI has been enabled:  

If this returns 1 then RCSI is enabled. If not, follow the below instructions to enable it.  */



/*
Benefits of RCSI:

provides a consistent view of the data at the time the query started
no blocking
fewer locks / escalations

*/

SELECT [name], is_read_committed_snapshot_on FROM sys.databases


/*

Disadvantages: if your application was not designed for optimistic locking, 
RCS could break some of your business logic or lead to incorrect results.

 More load (size and activity) on TempDB.

We have concurrency issues. 
  (The root cause of these concurrency issues is poor design, but that - alas - is water under the bridge.)
  */