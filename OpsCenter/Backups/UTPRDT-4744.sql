USE HDTStorage

SELECT 
    t.name AS TableName,
    ROUND(SUM(a.total_pages) * 8 / 1024 / 1024, 2) AS TotalSpaceGB,
    ROUND(SUM(a.used_pages) * 8 / 1024 / 1024, 2) AS UsedSpaceGB,
    ROUND((SUM(a.total_pages) - SUM(a.used_pages)) * 8 / 1024 / 1024, 2) AS FreeSpaceGB,
    MAX(us.last_user_update) AS LastModified, CAST(GETDATE() AS DATE) AS CurrentTime
FROM 
    UNITRAC.sys.tables t
INNER JOIN      
   UNITRAC.sys.indexes i ON t.object_id = i.object_id
INNER JOIN 
    UNITRAC.sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN 
    UNITRAC.sys.allocation_units a ON p.partition_id = a.container_id
LEFT JOIN 
    UNITRAC.sys.dm_db_index_usage_stats us ON t.object_id = us.object_id AND i.index_id = us.index_id
WHERE 
    t.is_ms_shipped = 0
GROUP BY 
    t.name
ORDER BY 
    TotalSpaceGB DESC;
