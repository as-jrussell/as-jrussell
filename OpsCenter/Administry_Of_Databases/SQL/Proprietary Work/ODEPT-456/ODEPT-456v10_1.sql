DECLARE @drive_letter VARCHAR(14) = 'F:\SQL\Data05' -- Replace with the appropriate drive letter

DECLARE @total_size_gb FLOAT
DECLARE @avg_daily_loss_gb FLOAT
DECLARE @days_to_zero INT

-- Calculate the total size of the drive in GB
SELECT @total_size_gb = total_bytes / 1024 / 1024 / 1024
FROM sys.master_files
CROSS APPLY sys.dm_os_volume_stats(DB_ID(), file_id)

-- Calculate the average daily loss of storage space in GB
SELECT @avg_daily_loss_gb = AVG((size * 8.0) / 1024 / 1024 / 1024) / DATEDIFF(day, MIN(create_date), GETDATE())
--select SUBSTRING(physical_name, 1, 14), *
FROM sys.master_files
JOIN sys.databases ON sys.master_files.database_id = sys.databases.database_id
CROSS APPLY sys.dm_os_volume_stats(DB_ID(), file_id)
WHERE SUBSTRING(physical_name, 1, 14) = @drive_letter

-- Calculate the number of days to reach zero storage space
SET @days_to_zero = CASE
    WHEN @avg_daily_loss_gb <= 0 THEN -1 -- Indicates indefinite time to reach zero
    ELSE CAST(@total_size_gb / @avg_daily_loss_gb AS INT)
END

-- Output the results
SELECT @drive_letter, @total_size_gb AS 'Total Size (GB)',
       @avg_daily_loss_gb AS 'Avg Daily Loss (GB)',
       @days_to_zero AS 'Days to Zero'
