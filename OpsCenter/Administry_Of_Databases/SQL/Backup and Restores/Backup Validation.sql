DECLARE @DatabaseName NVARCHAR(128) = 'UNITRAC_MORTGAGE' -- Change this to your database
DECLARE @BackupPath NVARCHAR(255) = '\\dbbkprdawstgy01.as.local\alss3sqlsprd01\sqlsprdawcl02$UTAG\UNITRAC_MORTGAGE\FULL\sqlsprdawcl02$UTAG_UniTrac_Maintenance_FULL_20250213_002222_1.bak' -- Full Path with extension is fine
DECLARE @FileName NVARCHAR(500)
DECLARE @FileIndex INT = 1
DECLARE @FileCount INT 
DECLARE @VerifyCommand NVARCHAR(MAX)
DECLARE @DryRun INT =1 -- Change to 0 to execute, anything else prints the commands

IF @FileCount is null  Set @FileCount = 8
-- Remove any existing "_X.bak" from @BackupPath
IF @BackupPath LIKE '%_[0-9].bak' OR @BackupPath LIKE '%_.bak'  
BEGIN  
    SET @BackupPath = LEFT(@BackupPath, LEN(@BackupPath) - CHARINDEX('_', REVERSE(@BackupPath)))  
END

-- Store 8 backup file paths
DECLARE @BackupFiles TABLE (ID INT IDENTITY(1,1), FilePath NVARCHAR(500))

WHILE @FileIndex <= @FileCount
BEGIN
    SET @FileName = @BackupPath + '_'+ CAST(@FileIndex AS NVARCHAR(10)) + '.bak'
    INSERT INTO @BackupFiles (FilePath) VALUES (@FileName)
    SET @FileIndex = @FileIndex + 1
END

-- Verify backup if not on Instance 2

    SET @VerifyCommand = 'RESTORE VERIFYONLY FROM ' + 
        STUFF((SELECT ', DISK = ''' + FilePath + '''' 
               FROM @BackupFiles
               FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')+' WITH STATS =10'

    IF @DryRun = 0
    BEGIN
        PRINT 'Verifying backup...'
        BEGIN TRY
            EXEC ( @VerifyCommand)
            PRINT 'Backup verified successfully.'
        END TRY
        BEGIN CATCH
            PRINT 'Verification failed: ' + ERROR_MESSAGE()
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'DryRun mode: Verify command:'
        PRINT (@VerifyCommand)
    END

