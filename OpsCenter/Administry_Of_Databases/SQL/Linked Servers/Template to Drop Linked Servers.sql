DECLARE @sqlcmd VARCHAR(MAX);
DECLARE @retval INT = -1;
DECLARE @ServerName SYSNAME = '';
DECLARE @DryRun INT = 0;
DECLARE @Force INT = 0;

--exec sp_linkedservers



-- Check if the linked server exists
IF EXISTS (
    SELECT 1
    FROM master.dbo.sysservers
    WHERE srvname = @ServerName
)
BEGIN
    BEGIN TRY
        EXEC @retval = sys.sp_testlinkedserver @ServerName;
    END TRY
    BEGIN CATCH
        SET @retval = 1; -- Failed test = broken connection
    END CATCH
END
ELSE
BEGIN
    PRINT 'FAIL: LINKED SERVER ''' + ISNULL(@ServerName, '') + ''' DOES NOT EXIST!';
    RETURN;
END

-- Process logic based on linked server test result
IF @retval = 0
BEGIN
    -- Server connects successfully
    IF @Force = 0
    BEGIN
        PRINT 'WARNING: LINKED SERVER ''' + @ServerName + ''' IS ACTIVE BUT @Force = 0. No drop will occur.';
        SET @sqlcmd = '
BEGIN TRY
    EXEC master.dbo.sp_dropserver @server = ''' + @ServerName + ''', @droplogins = ''droplogins'';
END TRY
BEGIN CATCH
    PRINT ''ERROR: Failed to drop server. '' + ERROR_MESSAGE();
END CATCH';
    END
    ELSE
    BEGIN
        PRINT 'SUCCESS: LINKED SERVER ''' + @ServerName + ''' IS ACTIVE AND WILL NOT BE DROPPED BECAUSE @Force = 1.';
        SET @sqlcmd = NULL;
    END
END
ELSE IF @retval = 1
BEGIN
    -- Server test failed
    PRINT 'WARNING: LINKED SERVER ''' + @ServerName + ''' IS BROKEN. Preparing to drop.';
    SET @sqlcmd = '
BEGIN TRY
    EXEC master.dbo.sp_dropserver @server = ''' + @ServerName + ''', @droplogins = ''droplogins'';
END TRY
BEGIN CATCH
    PRINT ''ERROR: Failed to drop server. '' + ERROR_MESSAGE();
END CATCH';
END
ELSE
BEGIN
    PRINT 'ERROR: Unexpected @retval value: ' + CAST(@retval AS VARCHAR);
    RETURN;
END

-- Execute or show the drop command
IF @DryRun = 0
BEGIN
    IF @sqlcmd IS NOT NULL
        EXEC (@sqlcmd);
    ELSE
        PRINT 'INFO: Nothing to execute. Conditions did not warrant server drop.';
END
ELSE
BEGIN
    PRINT 'DRY RUN OUTPUT:';
    PRINT ISNULL(@sqlcmd, 'No command generated. Nothing to do.');
END
