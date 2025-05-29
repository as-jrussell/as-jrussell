-- Declare variables
DECLARE @DBName VARCHAR(255) = NULL;  -- Specify the database name here (or leave NULL for all)
DECLARE @LogFileName VARCHAR(255);
DECLARE @LogFileSizeMB INT;
DECLARE @SQLCmd VARCHAR(MAX);
DECLARE @DryRun BIT = 1;  -- Set to 1 for dry run, 0 to execute
DECLARE @Verbose BIT = 1;  -- Set to 1 to display the code, 0 to hide
DECLARE @TargetLogFileSizeMB INT = 100;  -- Set the desired log file size in MB

-- Check if a specific database name is provided
IF @DBName IS NULL OR @DBName = ''
BEGIN
    -- If no specific database is provided, create a temporary table to hold the databases
    IF OBJECT_ID('tempdb..#DatabasesToUpdate') IS NOT NULL
        DROP TABLE #DatabasesToUpdate;

    SELECT name, 0 AS Processed  -- Add a Processed column initialized to 0
    INTO #DatabasesToUpdate
    FROM sys.databases
    WHERE database_id > 4;  -- Exclude system databases

    -- Loop through the databases in the temporary table
    WHILE EXISTS (SELECT 1 FROM #DatabasesToUpdate WHERE Processed = 0)
    BEGIN
        -- Get the next database name that has not been processed
        SELECT TOP 1 @DBName = name 
        FROM #DatabasesToUpdate 
        WHERE Processed = 0;

        -- Get the log file name
        SELECT TOP 1 @LogFileName = name
        FROM sys.master_files
        WHERE database_id = DB_ID(@DBName) AND type_desc = 'LOG';

        -- Get the log file size in MB
        SELECT @LogFileSizeMB = CAST(size AS BIGINT) * 8 / 1024 
        FROM sys.master_files
        WHERE database_id = DB_ID(@DBName) AND type_desc = 'LOG';

        -- Check if the log file size is less than the target size
        IF @LogFileSizeMB < @TargetLogFileSizeMB
        BEGIN
            -- Construct the dynamic SQL to alter the database
            SET @SQLCmd = '
            ALTER DATABASE [' + @DBName + '] 
            MODIFY FILE (NAME = ''' + @LogFileName + ''', SIZE = ' + CAST(@TargetLogFileSizeMB AS VARCHAR) + 'MB);';

            -- Display the code if Verbose is enabled
            IF @Verbose = 1
                PRINT @SQLCmd;

            -- Execute the dynamic SQL if Dry Run is disabled
            IF @DryRun = 0
                EXEC (@SQLCmd);

            PRINT 'Log file size for database ' + @DBName + ' would be increased to ' + CAST(@TargetLogFileSizeMB AS VARCHAR) + ' MB.';
        END

        -- Mark the processed database in the temporary table
        UPDATE #DatabasesToUpdate SET Processed = 1 WHERE name = @DBName;
    END
END
ELSE
BEGIN
    -- If a specific database is provided, process only that database
    -- Get the log file name
    SELECT TOP 1 @LogFileName = name
    FROM sys.master_files
    WHERE database_id = DB_ID(@DBName) AND type_desc = 'LOG';

    -- Get the log file size in MB
    SELECT @LogFileSizeMB = CAST(size AS BIGINT) * 8 / 1024 
    FROM sys.master_files
    WHERE database_id = DB_ID(@DBName) AND type_desc = 'LOG';

    -- Check if the log file size is less than the target size
    IF @LogFileSizeMB < @TargetLogFileSizeMB
    BEGIN
        -- Construct the dynamic SQL to alter the database
        SET @SQLCmd = '
        ALTER DATABASE [' + @DBName + '] 
        MODIFY FILE (NAME = ''' + @LogFileName + ''', SIZE = ' + CAST(@TargetLogFileSizeMB AS VARCHAR) + 'MB);';

        -- Display the code if Verbose is enabled
        IF @Verbose = 1
            PRINT @SQLCmd;

        -- Execute the dynamic SQL if Dry Run is disabled
        IF @DryRun = 0
            EXEC (@SQLCmd);

        PRINT 'Log file size for database ' + @DBName + ' would be increased to ' + CAST(@TargetLogFileSizeMB AS VARCHAR) + ' MB.';
    END
END