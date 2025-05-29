USE [PerfStats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[CaptureErrorLogFile]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[CaptureErrorLogFile] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[CaptureErrorLogFile](@WhatIf BIT = 1,
                                            @Force  BIT = 1)
AS
  BEGIN
    /*
    ######################################################################
        Examples
    ######################################################################

      exec  [PerfStats].[dbo].[CaptureErrorLogFile] @WhatIF= 1 Shows network file; code
      exec  [PerfStats].[dbo].[CaptureErrorLogFile] @WhatIF= 0 Adds to table if it's over 10 GB if not produces how much the combined error logs are 
      exec  [PerfStats].[dbo].[CaptureErrorLogFile] @Force=0 Forces the system to use a new errorlog file 
	
    */

	SET ANSI_NULLS ON;
	SET QUOTED_IDENTIFIER ON;
	
    /*
    ######################################################################
        Declarations
    ######################################################################
    */

	   DECLARE @Debug Bit = 1,  @Path  NVARCHAR(250),@ErrorLogSize   NVARCHAR(100),@ErrorLogSizeKB NVARCHAR(100),@ErrorLogSizeGB NVARCHAR(100), @MaxCount NVARCHAR(100),@ExecCommand  VARCHAR(150), @ProcedureName  NVARCHAR(128),@info NVARCHAR(100), @low   NVARCHAR(100),@medium  NVARCHAR(100), @high  NVARCHAR(100);


    /*
    ######################################################################
		Is this an RDS instance ?
    ######################################################################
    */
    DECLARE @IsRDS INT
    DECLARE @RDSsql NVARCHAR(MAX) = 'USE MSDB; SELECT @IsRDS = count(name) FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.rds_backup_database'') AND type in (N''P'', N''PC'')'
            
    EXEC sp_executesql @RDSsql, N'@IsRDS int out', @IsRDS OUT; 

    IF( @IsRDS = 1 ) 
    BEGIN
        IF( @Debug = 1 ) PRINT '[] Instance IsRDS = '+ convert(CHAR(10), @IsRDS); 
    END

	/*
    ######################################################################
		Table Population
    ######################################################################
	*/
      CREATE TABLE #ErrorLogs
        (
           ArchiveNumber INT,
           [Date]        DATE,
           [Log_File]    INT
        )

	  INSERT INTO #ErrorLogs
      EXEC sys.Sp_enumerrorlogs

	/*
    ######################################################################
        Set
    ######################################################################
    */

	      IF (SELECT Count(*)
          FROM   DBA.INFO.Instance) >= 1
        BEGIN
            SELECT @Path = Replace(Replace(Concat(Concat('\\', CONVERT(NVARCHAR, MachineName)), '\', CONVERT(NVARCHAR(100), Serverproperty('ErrorLogFileName')), '\'), ':', '$'), 'LOG\ERROR', '')
            --select * 
            FROM   DBA.INFO.INSTANCE
        END
      ELSE
        BEGIN
            SELECT @Path = Replace(Replace(Concat(Concat('\\', CONVERT(NVARCHAR, @@SERVERNAME)), '\', CONVERT(NVARCHAR(100), Serverproperty('ErrorLogFileName')), '\'), ':', '$'), 'LOG\ERROR', '')
        END

      SELECT @ProcedureName = Quotename(Db_name()) + '.'
                              + Quotename(Object_schema_name(@@PROCID, Db_id()))
                              + '.'
                              + Quotename(Object_name(@@PROCID, Db_id()));

      SELECT 
	  /* all thresholds from DPA - even if not defined for event */ @info = Isnull([info], 20),/* Default value in seconds */
                                                                    @low = Isnull([low], 30),
                                                                    @medium = Isnull([medium], 40),
                                                                    @high = Isnull([high], 60)
      /* event levels: broken , normal, infor, low, med , high! */
      -- select *
      FROM   [PerfStats].[dbo].[ThresholdConfig]
      WHERE  [EventName] = @ProcedureName





      SELECT @ErrorLogSizeKB = Sum([Log_File]) / 1024
      FROM   #ErrorLogs

      SELECT @ErrorLogSize = Sum([Log_File]) / 1024 / 1024
      FROM   #ErrorLogs

      SELECT @ErrorLogSizeGB = Sum([Log_File]) / 1024 / 1024 / 1024
      FROM   #ErrorLogs

      SELECT @MaxCount = Count(ArchiveNumber)
      FROM   #ErrorLogs

	/*
    ######################################################################
	Validation of Job Owners
    ######################################################################
	*/
  IF @WhatIf = 0
        BEGIN
        IF @ErrorLogSize >= 20000 -- this is in MB which translates to 20 GB
              BEGIN
                  MERGE [Perfstats].[dbo].[ErrorLogFileInfo] AS old
                  USING (SELECT DISTINCT [ArchiveNumber],
                                         [Date],
                                          CAST([Log_File] / (1024.0 * 1024.0) AS DECIMAL(10, 2)) AS [Log_File],
                                         CASE
                                           WHEN @ErrorLogSizeGB <= @info THEN 'Info'
                                           WHEN @ErrorLogSizeGB BETWEEN @info AND @low THEN 'Low'
                                           WHEN @ErrorLogSizeGB BETWEEN @low AND @medium THEN 'Medium'
                                           WHEN @ErrorLogSizeGB BETWEEN @medium AND @high THEN 'High'
                                           WHEN @ErrorLogSizeGB >= @high THEN 'High'
                                         END       AS 'Threshold level',
                                         Getdate() [Date_Harvested]
                         FROM   #ErrorLogs) AS new ( [ArchiveNumber], [Date], [Log_File], [Threshold_Level], [Date_Harvested] )
                  ON old.[ArchiveNumber] = new.[ArchiveNumber]
                  WHEN MATCHED AND (old.[Date] = new.[Date] AND old.[Date_Harvested] = new.[Date_Harvested] AND old.[Log_File_MB] = new.[Log_File] ) THEN
                    UPDATE SET old. [ArchiveNumber] = old. [ArchiveNumber],
                               old.[Date] = new.[Date],
                               OLD.[Threshold_Level] = new.[Threshold_Level],
                               old.[Date_Harvested] = new.[Date_Harvested]
                  WHEN NOT MATCHED THEN
                    INSERT ([ArchiveNumber],
                            [Date],
                            [Log_File_MB],
                            [Threshold_Level],
                            [Date_Harvested])
                    VALUES (new.[ArchiveNumber],
                            new.[Date],
                            new.[Log_File],
                            new.[Threshold_Level],
                            new.[Date_Harvested])
                  WHEN NOT MATCHED BY SOURCE THEN
                    DELETE;

		
	/*
    ######################################################################
	 This is in MB which translates to 75 GB; System will auto force the log 
	 to be recreated so that it can be removed if desired (or protection of continous problem).
    ######################################################################
	*/
                  IF @ErrorLogSize >= 75000 AND   @IsRDS = 0 
                    BEGIN
                        EXEC Sp_cycle_errorlog;

                        SET @ExecCommand = 'EXEC ' + @ProcedureName +  ' @WhatIf = '
                                           + CONVERT(CHAR(1), @WhatIf) +', @Force = '
                                           + CONVERT(CHAR(1), @Force) + ';'

                        INSERT INTO DBA.[deploy].[ExecHistory]
                                    ([TimeStampUTC],
                                     [UserName],
                                     [Command],
                                     [ErrorMessage],
                                     [Result])
                        VALUES      ( Getdate(),
                                      Original_login(),
                                      @ExecCommand,
                                      'No error handling',
                                      1 )
                    END
              END
            ELSE
              BEGIN

			         SELECT DISTINCT [ArchiveNumber],
                                         [Date],
                                          CAST([Log_File] / (1024.0 * 1024.0) AS DECIMAL(10, 2)) AS [Log_File],
                                         CASE
                                           WHEN @ErrorLogSizeGB <= @info THEN 'Info'
                                           WHEN @ErrorLogSizeGB BETWEEN @info AND @low THEN 'Low'
                                           WHEN @ErrorLogSizeGB BETWEEN @low AND @medium THEN 'Medium'
                                           WHEN @ErrorLogSizeGB BETWEEN @medium AND @high THEN 'High'
                                           WHEN @ErrorLogSizeGB >= @high THEN 'High'
                                         END       AS 'Threshold level',
                                         Getdate() [Date_Harvested]
            FROM   #ErrorLogs
                  PRINT '
				File path is: ' + @Path

                  PRINT CASE
                          WHEN @ErrorLogSize < '1' THEN '
				ERROR: File did not meet criteria size to clear! Size is currently at: '
                                                        + @ErrorLogSizeKB + ' KB'
                          WHEN @ErrorLogSize BETWEEN '1' AND '999' THEN '
				ERROR: File did not meet criteria size to clear! Size is currently at: '
                                                                        + @ErrorLogSize + ' MB'
                          ELSE '
				ERROR: File did not meet criteria size to clear! Size is currently at: '
                               + @ErrorLogSizeGB + ' GB'
                        END

                  PRINT '
				If work this was executed this is the work that was done: EXEC sp_cycle_errorlog ;'
              END
        END
		/*
    ######################################################################
	 No matter what the size is the system will auto force the log to be 
	 recreated so that it can be removed if desired (or protection of continous problem).
    ######################################################################
	*/
      ELSE IF @Force = 0 AND ( @IsRDS = 0 ) 
        BEGIN
            EXEC Sp_cycle_errorlog;

                        SET @ExecCommand = 'EXEC ' + @ProcedureName +  ' @WhatIf = '
                                           + CONVERT(CHAR(1), @WhatIf) +', @Force = '
                                           + CONVERT(CHAR(1), @Force) + ';'

            INSERT INTO DBA.[deploy].[ExecHistory]
                        ([TimeStampUTC],
                         [UserName],
                         [Command],
                         [ErrorMessage],
                         [Result])
            VALUES      ( Getdate(),
                          Original_login(),
                          @ExecCommand,
                          'No error handling',
                          1 )

            PRINT 'SUCCESS: Logs were cleared by force but file will not be removed by the system until it reaches the max number: '
                  + @MaxCount
                  + ' (but it can be manually deleted this will leave a gap in the file retrieval but the system will be okay)!'
        END
      ELSE
        BEGIN
            PRINT '
				File path is: ' + @Path

            PRINT '
				If work this was executed this is the work that was done: EXEC sp_cycle_errorlog ;'

       SELECT DISTINCT [ArchiveNumber],
                                         [Date],
                                          CAST([Log_File] / (1024.0 * 1024.0) AS DECIMAL(10, 2)) AS [Log_File],
                                         CASE
                                           WHEN @ErrorLogSizeGB <= @info THEN 'Info'
                                           WHEN @ErrorLogSizeGB BETWEEN @info AND @low THEN 'Low'
                                           WHEN @ErrorLogSizeGB BETWEEN @low AND @medium THEN 'Medium'
                                           WHEN @ErrorLogSizeGB BETWEEN @medium AND @high THEN 'High'
                                           WHEN @ErrorLogSizeGB >= @high THEN 'High'
                                         END       AS 'Threshold level',
                                         Getdate() [Date_Harvested]
            FROM   #ErrorLogs
        END


END
