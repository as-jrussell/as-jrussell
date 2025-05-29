USE [PerfStats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[action].[StartOrResumeIndexRebuild]') AND type IN (N'P', N'PC'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [action].[StartOrResumeIndexRebuild] AS RETURN 0;';
END;
GO

ALTER PROCEDURE [action].[StartOrResumeIndexRebuild] 
    @minutes INT = 5,
    @database_name SYSNAME = NULL,
    @index_name NVARCHAR(200) = NULL,
    @table_name NVARCHAR(200) = NULL,
	 @Debug BIT = 0,
    @WhatIf INT = 1
AS
BEGIN

  /*
    ######################################################################
		Examples
    ######################################################################
  
    EXEC [Perfstats]. [action].[StartOrResumeIndexRebuild] @database_name ='Unitrac', @index_name = 'PK_INTERACTION_HISTORY', @table_name = 'INTERACTION_HISTORY', @WhatIF=1, @minutes =1
    
    
    EXEC [Perfstats]. [action].[StartOrResumeIndexRebuild] @database_name ='Unitrac', @index_name = 'IDX_LOAN_LENDER_ID_RECORD_TYPE_CD_PURGE_DT', @table_name = ''
    
    
    EXEC [Perfstats]. [action].[StartOrResumeIndexRebuild] @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'Interaction_History', @WhatIF=0
    */
	    IF( @Debug = 0 ) SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    /*
    ######################################################################
		Declarations
    ######################################################################
    */
	DECLARE @version NVARCHAR(128);
    DECLARE @SQLCMD NVARCHAR(MAX);
    DECLARE @startTime DATETIME;
    DECLARE @endTime DATETIME;
    DECLARE @duration INT = 0;  -- Default to 0
    DECLARE @status NVARCHAR(50) = 'Failure'; -- Default to Failure

    -- Log the start time
    SET @startTime = GETDATE();

	/*
    ######################################################################
					    Is this an RDS instance ?
    ######################################################################
    */
	DECLARE @IsRDS int
    DECLARE @IsRDSsql nVARCHAR(MAX) = 'USE MSDB; SELECT @IsRDS = count(name) FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.rds_backup_database'') AND type in (N''P'', N''PC'')'
            
    EXEC sp_executesql @IsRDSsql, N'@IsRDS int out', @IsRDS OUT;  

    IF( @Debug = 1 ) PRINT 'Instance IsRDS: '+ convert(char(1), @IsRDS)

    IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'rdsadmin')
    BEGIN
        PRINT 'RDS instance detected. Operation cannot proceed.';
        -- Insert Failure log with 0 duration and exit
        INSERT INTO [Perfstats].[dbo].[IndexRebuildLog] (DatabaseName, TableName, IndexName, ExecutionDate, DurationMinutes, [Status],[User])
        VALUES (UPPER(@database_name),UPPER(@table_name), UPPER(@index_name), GETDATE(), 0, 'Failure', (SELECT SYSTEM_USER));
        RETURN;
    END

	/*
    ######################################################################
					    Check for SQL version compatibility
    ######################################################################
    */
    SELECT @version = CONVERT(NVARCHAR, SERVERPROPERTY('ProductVersion'));

    IF @database_name IS NULL OR @index_name IS NULL OR @table_name IS NULL OR @database_name = '' OR @index_name = '' OR @table_name = ''
    BEGIN
        PRINT 'Required parameters @database_name, @index_name, or @table_name are missing.';
        RETURN;
    END
    ELSE
    BEGIN
        IF LEFT(@version, CHARINDEX('.', @version) - 1) < 14 -- SQL Server 2017 or newer
        BEGIN
            PRINT 'This feature is only supported in SQL Server 2017 or newer.';
        END
        ELSE
        BEGIN
	/*
    ######################################################################
					    Construct the dynamic SQL
    ######################################################################
    */
            SET @SQLCMD = '
                USE [' + @database_name + '];

                BEGIN TRY
                    -- Check for existing resumable operation
                    IF NOT EXISTS (SELECT 1 FROM sys.index_resumable_operations WHERE name = ''' + @index_name + ''')
                    BEGIN
                        PRINT ''Starting index rebuild for [' + @index_name + '] on [' + @table_name + '].'';
                        ALTER INDEX [' + @index_name + '] ON [dbo].[' + @table_name + '] REBUILD WITH (ONLINE = ON, RESUMABLE = ON, MAX_DURATION = ' + CAST(@minutes AS NVARCHAR(10)) + ' MINUTES);
                    END
                    ELSE
                    BEGIN
                        PRINT ''Resuming index rebuild for [' + @index_name + '] on [' + @table_name + '].'';
                        ALTER INDEX [' + @index_name + '] ON [dbo].[' + @table_name + '] RESUME WITH (MAX_DURATION = ' + CAST(@minutes AS NVARCHAR(10)) + ' MINUTES);
                    END;

                    -- Set status to success if no errors
                    SET @status = ''Success'';
                END TRY
                BEGIN CATCH
                    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
                    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
                    DECLARE @ErrorState INT = ERROR_STATE();
                    PRINT ''Error occurred: '' + @ErrorMessage + ''. Severity: '' + CAST(@ErrorSeverity AS NVARCHAR) + ''. State: '' + CAST(@ErrorState AS NVARCHAR);
                END CATCH;
            ';
	/*
    ######################################################################
			Execute the dynamic SQL and pass the status variable
    ######################################################################
    */
            IF @WhatIf = 0
            BEGIN
                EXEC sp_executesql 
                    @SQLCMD, 
                    N'@status NVARCHAR(50) OUTPUT', 
                    @status = @status OUTPUT;
            END
            ELSE
            BEGIN
                PRINT @SQLCMD;
            END;
        END
    END
	/*
    ######################################################################
			Log the end time and calculate duration
    ######################################################################
    */
    SET @endTime = GETDATE();
    SET @duration = ISNULL(DATEDIFF(MINUTE, @startTime, @endTime), 0); -- Set duration to 0 if DATEDIFF returns NULL
	/*
    ######################################################################
			 Insert log data
    ######################################################################
    */
    INSERT INTO [Perfstats].[dbo].[IndexRebuildLog] (DatabaseName, TableName, IndexName, ExecutionDate, DurationMinutes, [Status],[User])
    VALUES (UPPER(@database_name),UPPER(@table_name), UPPER(@index_name), @startTime, @duration, @status, (SELECT SYSTEM_USER));
END;
