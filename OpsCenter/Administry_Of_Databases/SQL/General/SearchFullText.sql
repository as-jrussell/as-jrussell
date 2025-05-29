xp_readerrorlog 0, 1, N'Logging SQL Server messages in file'

 SELECT * FROM sys.dm_fts_active_catalogs 


 SELECT * FROM sys.dm_fts_active_catalogs 

 SELECT * FROM sys.dm_fts_fdhosts 

 SELECT * FROM sys.dm_fts_index_population 
 SELECT * FROM sys.dm_fts_memory_buffers 

 SELECT * FROM sys.dm_fts_memory_pools 

 SELECT * FROM sys.dm_fts_outstanding_batches 
 SELECT * FROM sys.dm_fts_population_ranges 



 SELECT FULLTEXTCATALOGPROPERTY('UTL_FULLTEXT', 'accentsensitivity'); 
 use utl
 select * from sys.fulltext_catalogs 


 select * from sys.fulltext_indexes
 
 
 DECLARE @CatalogName VARCHAR(MAX)
SET     @CatalogName = 'IDX_SEARCH_FULLTEXT_LENDER_ID'

SELECT
    DATEADD(ss, FULLTEXTCATALOGPROPERTY(@CatalogName,'PopulateCompletionAge'), '1/1/1990') AS LastPopulated
    ,(SELECT CASE FULLTEXTCATALOGPROPERTY(@CatalogName,'PopulateStatus')
        WHEN 0 THEN 'Idle'
        WHEN 1 THEN 'Full Population In Progress'
        WHEN 2 THEN 'Paused'
        WHEN 3 THEN 'Throttled'
        WHEN 4 THEN 'Recovering'
        WHEN 5 THEN 'Shutdown'
        WHEN 6 THEN 'Incremental Population In Progress'
        WHEN 7 THEN 'Building Index'
        WHEN 8 THEN 'Disk Full.  Paused'
        WHEN 9 THEN 'Change Tracking' END) AS PopulateStatus





		Use UTL
select OBJECTPROPERTYEX ( 1106102981 , 'TableFullTextPendingChanges' )


SELECT [t].[name] [table_name], 
       [i].[name] [index_name],
       [fi].[change_tracking_state_desc], 
       [fi].[has_crawl_completed], 
       [fi].[crawl_type_desc], 
       [fi].[crawl_end_date],
       [ius].[last_user_update], 
       [ius].[last_user_seek],
       (SELECT [name]+',' FROM [sys].[fulltext_index_columns] [fc] INNER JOIN [sys].[columns] [c] ON [c].[object_id] = [fc].[object_id] AND [c].[column_id] = [fc].[column_id] WHERE [fc].[object_id] = [fi].[object_id] FOR XML PATH('')) [columns],
       (CASE WHEN [fi].[crawl_end_date] < ISNULL([ius].[last_user_update], [ius].[last_user_seek]) THEN 'ALTER FULLTEXT INDEX ON ['+[t].[name]+'] SET CHANGE_TRACKING MANUAL; ALTER FULLTEXT INDEX ON ['+[t].[name]+'] SET CHANGE_TRACKING AUTO' ELSE '' END) [Command]
FROM [sys].[fulltext_indexes] [fi]
INNER JOIN [sys].[indexes] [i] ON [i].[index_id] = [fi].[unique_index_id] AND [i].[object_id] = [fi].[object_id]
INNER JOIN [sys].[tables] [t] ON [t].[object_id] = [fi].[object_id]
LEFT JOIN [sys].[dm_db_index_usage_stats] [ius] ON [ius].[index_id] = [fi].[unique_index_id] AND [ius].[object_id] = [fi].[object_id] AND [ius].[database_id] = DB_ID()
ORDER BY [table_name], [index_name]


