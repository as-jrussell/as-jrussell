-- Step 1: Get the initial size of the database
DECLARE @initialSize NUMERIC(38, 2), 
@growthRate DECIMAL(18, 2),
@finalSize NUMERIC(38, 2), 
@growthSize NUMERIC(38, 2), 
@growthRateMB FLOAT, 
@growthRateGB FLOAT;

SELECT @initialSize = MAX(backup_size / 1024 / 1024)  -- Convert size to MB
--select (backup_size / 1024 / 1024 / 1024/1024), type, backup_start_date
FROM msdb.dbo.backupset
WHERE database_name = DB_NAME() AND type = 'D'

-- Step 2: Get the final size of the database

SELECT @finalSize = SUM(CAST(size AS NUMERIC(38, 2)) * 8 / 1024) -- Convert size to MB
FROM sys.master_files
WHERE DB_NAME(database_id) = DB_NAME()  AND type = 0 -- Data file type

-- Step 3: Calculate the absolute growth in size

SET @growthSize = @finalSize - @initialSize;

-- Step 4: Calculate the time difference in months
DECLARE @initialDate date, @finalDate date;
SET @initialDate = CAST(getdate()-1 AS date); -- Replace with your initial date
SET @finalDate = CAST(getdate() AS date); -- Replace with your final date

DECLARE @timeDifference INT;
SET @timeDifference = DATEDIFF(DAY, @initialDate, @finalDate);

-- Step 5: Calculate the growth rate

SET @growthRate = CAST(@growthSize AS DECIMAL(18, 2)) / @timeDifference * 100;
SET @growthRateGB = @growthRate / 1024;

-- Step 6: Display the growth rate
SELECT @growthRate AS GrowthRate

SELECT @growthRate AS GrowthRateMB, @growthRateGB AS GrowthRateGB;

