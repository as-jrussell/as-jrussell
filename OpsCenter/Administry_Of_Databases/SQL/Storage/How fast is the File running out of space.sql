SELECT d.name, LEFT(m.physical_name,1) AS drive_letter,
    SUM(size)*8.0/1024/1024 AS total_size_mb,
    SUM(growth)*8.0/1024/1024/DATEDIFF(day,d.create_date,GETDATE()) AS avg_daily_growth_mb,
    CASE 
        WHEN SUM(growth) = 0 THEN 0 
        ELSE CAST((SUM(size)*8.0/1024/1024)/(SUM(growth)*8.0/1024/1024/DATEDIFF(day,d.create_date,GETDATE())) AS INT)
    END AS days_to_zero
FROM sys.master_files m
JOIN sys.databases d ON m.database_id = d.database_id
GROUP BY d.name,LEFT(m.physical_name,1), d.create_date
ORDER BY LEFT(m.physical_name,1)
