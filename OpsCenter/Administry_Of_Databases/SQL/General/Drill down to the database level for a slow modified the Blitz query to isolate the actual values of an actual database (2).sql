SELECT DISTINCT
36 AS CheckID ,
( io_stall_read_ms / ( 1.0 + num_of_reads ) ) AS tReadValue ,
'Performance' AS FindingsGroup ,
'Slow Storage Reads on Drive '
+ UPPER(LEFT(mf.physical_name, 1)) AS Finding ,
'http://BrentOzar.com/go/slow' AS URL ,
'Reads are averaging longer than 100ms for at least one database on this drive. For specific database file speeds, run the query from the information link.' AS Details
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
INNER JOIN sys.master_files AS mf ON fs.database_id = mf.database_id
AND fs.[file_id] = mf.[file_id]
WHERE ( io_stall_read_ms / ( 1.0 + num_of_reads ) ) > 100;

SELECT DISTINCT
37 AS CheckID ,
( io_stall_write_ms / ( 1.0 + num_of_writes ) ) AS tWriteValue ,
'Performance' AS FindingsGroup ,
'Slow Storage Writes on Drive '
+ UPPER(LEFT(mf.physical_name, 1)) AS Finding ,
'http://BrentOzar.com/go/slow' AS URL ,
'Writes are averaging longer than 20ms for at least one database on this drive. For specific database file speeds, run the query from the information link.' AS Details
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
INNER JOIN sys.master_files AS mf ON fs.database_id = mf.database_id
AND fs.[file_id] = mf.[file_id]
WHERE ( io_stall_write_ms / ( 1.0 + num_of_writes ) ) > 20;