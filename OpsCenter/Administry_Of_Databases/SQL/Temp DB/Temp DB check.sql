SELECT  Database_id ,
        ( ( size * 8 ) / 1024 ) AS SIZE_IN_MB ,
        Name ,
        Type_desc ,
        Physical_Name,*
FROM    sys.master_files
WHERE   database_id = 2


SELECT  Name ,
        ( ( size * 8 ) / 1024 ) AS SIZE_IN_MB, *
FROM    Tempdb.sys.database_files

select * from sys.databases


sp_helpdb 'TempDB'


SELECT SUM(unallocated_extent_page_count) AS [free pages], 
(SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]
FROM sys.dm_db_file_space_usage;


SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
(SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage;


SELECT *
FROM sys.dm_tran_active_snapshot_database_transactions 
ORDER BY elapsed_time_seconds DESC;

SELECT SUM(internal_object_reserved_page_count) AS [internal object pages used],
(SUM(internal_object_reserved_page_count)*1.0/128) AS [internal object space in MB]
FROM sys.dm_db_file_space_usage;

SELECT SUM(user_object_reserved_page_count) AS [user object pages used],
(SUM(user_object_reserved_page_count)*1.0/128) AS [user object space in MB]
FROM sys.dm_db_file_space_usage;

SELECT SUM(size)*1.0/128 AS [size in MB]
FROM tempdb.sys.database_files



    SELECT session_id, 
      SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
    FROM sys.dm_db_task_space_usage 
    GROUP BY session_id;


	EXEC sp_who 182



	select @@VERSION


	--Microsoft SQL Server 2016 (SP2-CU11-GDR) (KB4535706) - 13.0.5622.0 (X64)   Dec 15 2019 08:03:11   Copyright (c) Microsoft Corporation  Enterprise Edition: Core-based Licensing (64-bit) on Windows Server 2016 Datacenter 10.0 <X64> (Build 14393: ) (Hypervisor) 