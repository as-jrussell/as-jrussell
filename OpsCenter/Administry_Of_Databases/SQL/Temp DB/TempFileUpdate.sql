-- Declare variables
DECLARE @FileType VARCHAR(10) = NULL; -- Set to 'ROWS', 'LOG', or NULL for all file types
DECLARE @SQLCmd VARCHAR(MAX);
DECLARE @DryRun BIT = 1; -- Set to 1 for dry run, 0 to execute
DECLARE @Verbose BIT = 1; -- Set to 1 to display the code, 0 to hide
DECLARE @TargetFileSizeMB INT 
DECLARE @FileName VARCHAR(255);


IF NOT EXISTS (SELECT 1 FROM DBA.INFO.Instance)
    SET @TargetFileSizeMB = 128;
ELSE
    SELECT TOP 1 @TargetFileSizeMB = CASE
        WHEN i.ServerEnvironment IN ('PRD', 'PROD', 'ADM') THEN 1024
        WHEN i.ServerEnvironment IN ('STG', 'TST') THEN 512
        WHEN i.ServerEnvironment IN ('DEV') THEN 256
        ELSE 128
    END
    FROM DBA.INFO.Instance i;

-- Check if the temporary table already exists
IF OBJECT_ID('tempdb..#FilesToUpdate') IS NOT NULL
    DROP TABLE #FilesToUpdate;

-- Create a temporary table to hold the files under the target size
SELECT name, 0 AS Processed  -- Add a Processed column initialized to 0
INTO #FilesToUpdate
FROM sys.master_files
WHERE database_id = 2 -- tempdb database_id
AND type_desc = ISNULL(@FileType, type_desc)  -- Filter for specified file type or all if NULL
AND CAST(size AS BIGINT) * 8 / 1024 < @TargetFileSizeMB; -- Filter for files under the target size

-- Check if any files need updating
IF EXISTS (SELECT 1 FROM #FilesToUpdate WHERE Processed = 0)
BEGIN
    -- Loop through the files in the temporary table
    WHILE EXISTS (SELECT 1 FROM #FilesToUpdate WHERE Processed = 0)
    BEGIN
        -- Get the next file name that has not been processed
        SELECT TOP 1 @FileName = name 
        FROM #FilesToUpdate 
        WHERE Processed = 0;

        -- Construct the dynamic SQL to alter the tempdb database
        SET @SQLCmd = '
        ALTER DATABASE tempdb 
        MODIFY FILE (NAME = ''' + @FileName + ''', SIZE = ' + CAST(@TargetFileSizeMB AS VARCHAR) + 'MB);';

        -- Display the code if Verbose is enabled
        IF @Verbose = 1
            PRINT @SQLCmd;

        -- Execute the dynamic SQL if Dry Run is disabled
        IF @DryRun = 0
            EXEC (@SQLCmd);

        PRINT 'Tempdb file ''' + @FileName + ''' would be increased to ' + CAST(@TargetFileSizeMB AS VARCHAR) + ' MB.';

        -- Mark the processed file in the temporary table
        UPDATE #FilesToUpdate SET Processed = 1 WHERE name = @FileName;
    END
END
ELSE
    PRINT 'All tempdb files already meet the minimum size requirement.';