DECLARE @total_size_mb FLOAT
DECLARE @avg_daily_loss_mb FLOAT
DECLARE @days_to_zero INT

-- Calculate the total size of all database files
SELECT @total_size_mb = SUM(size) * 8.0 / 1024 / 1024
FROM sys.master_files

-- Calculate the average daily loss of storage space
SELECT @avg_daily_loss_mb = SUM((size - FILEPROPERTY(master_files.name, 'SpaceUsed')) * 8.0 / 1024 / 1024) / DATEDIFF(day, create_date, GETDATE())
FROM sys.master_files
JOIN sys.databases ON sys.master_files.database_id = sys.databases.database_id
GROUP BY create_date

-- Calculate the number of days to reach zero storage space
SET @days_to_zero = CASE
    WHEN @avg_daily_loss_mb = 0 THEN 0
    ELSE CAST(@total_size_mb / @avg_daily_loss_mb AS INT)
END

-- Output the results
SELECT @total_size_mb AS 'Total Size (MB)',
       @avg_daily_loss_mb AS 'Avg Daily Loss (MB)',
       @days_to_zero AS 'Days to Zero'
