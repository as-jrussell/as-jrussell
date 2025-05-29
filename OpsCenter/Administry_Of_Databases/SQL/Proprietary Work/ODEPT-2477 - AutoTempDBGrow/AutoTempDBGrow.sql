USE [DBA];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[AutoTempDBGrow]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[AutoTempDBGrow] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[AutoTempDBGrow](@Percentage NVARCHAR(5) =NULL,
                                       @FileGrowth INT =NULL,
                                       @Dryrun     BIT = 1,
                                       @Verbose    BIT = 1,
                                       @Force      BIT = 1)
AS
  BEGIN
      /*
      ######################################################################
      Examples
      ######################################################################
      
      
      
      exec  [DBA].[dbo].[AutoTempDBGrow] --Shows data on the system and code that would be done 
      exec  [DBA].[dbo].[AutoTempDBGrow] @Verbose= 0 --Pulls table of the all the data about the temp DB
      exec  [DBA].[dbo].[AutoTempDBGrow] @Percentage= '0.95' ---What ever the percentage entered in it will cut 
										that part of out the drive and use the remaining then subtract the log file 
										from that and divide the rest up for the datafiles. Percent need to be convert to decimals.
      exec  [DBA].[dbo].[AutoTempDBGrow] @FileGrowth= '262144' ---What ever the percentage entered in it will 
										  place as the file and log grow file.  Sizes need to be in KB
      exec  [DBA].[dbo].[AutoTempDBGrow] @Dryrun = 0 ---Does the work
      */
      SET ANSI_NULLS ON;
      SET QUOTED_IDENTIFIER ON;

      /*
      ######################################################################
      Declarations
      ######################################################################
      */
      DECLARE @IsPercentEnabled NVARCHAR(3)
      DECLARE @CurrentFileSize NVARCHAR(10)
      DECLARE @CurrentLogSize NVARCHAR(10)
      DECLARE @ServerLocation NVARCHAR(10)
      DECLARE @LogFile NVARCHAR(10)
      DECLARE @CORES INT
      DECLARE @BASEPATH NVARCHAR(300)
      DECLARE @FILECOUNT INT
      DECLARE @SIZE INT
      DECLARE @GROWTH INT
      DECLARE @ISPERCENT INT
      DECLARE @InstanceName NVARCHAR(255)
      DECLARE @InstanceLocation NVARCHAR(255)
      DECLARE @InstanceEnvironment NVARCHAR(255)
      DECLARE @CurrentLogFileSizeMB INT
      DECLARE @StartingLogFileSizeMB INT
      DECLARE @AvgStartingTempDataSizeMB INT
      DECLARE @AvgCurrentTempDataSizeMB INT
      DECLARE @TotalSizeGB DECIMAL(18, 2)
      DECLARE @UsableSpaceGB DECIMAL(18, 2)
      DECLARE @DataFileNeeded NVARCHAR(500)
      DECLARE @AmountPerDataFileGB DECIMAL(18, 2)
      DECLARE @LogFileAllocation NVARCHAR(50)
      DECLARE @SQL_SCRIPT NVARCHAR(1000)
      DECLARE @FileName NVARCHAR(255)
      DECLARE @PathFileName NVARCHAR(255);
      DECLARE @IsRDS INT
      /*
      ######################################################################
      Is this an RDS instance ?
      ######################################################################
      */
      DECLARE @RDSsql NVARCHAR(MAX) = 'USE MSDB; SELECT @IsRDS = count(name) FROM sys.objects WHERE object_id = OBJECT_ID(N''dbo.rds_backup_database'') AND type in (N''P'', N''PC'')'

      EXEC Sp_executesql
        @RDSsql,
        N'@IsRDS int out',
        @IsRDS OUT;

      /*
        ######################################################################
      Table Population
        ######################################################################
      */
      CREATE TABLE #TempDBUsage
        (
           InstanceName              NVARCHAR(255),
           InstanceLocation          NVARCHAR(255),
           InstanceEnvironment       NVARCHAR(255),
           CurrentLogFileSizeMB      INT,
           StartingLogFileSizeMB     INT,
           AvgStartingTempDataSizeMB INT,
           AvgCurrentTempDataSizeMB  INT,
           TotalSizeGB               DECIMAL(18, 2),
           DataFileNeeded            NVARCHAR(500),
           UsableSpaceForDriveGB     DECIMAL(18, 2),
           AmountPerDatafileGB       DECIMAL(18, 2),
           LogFileGB                 NVARCHAR(50)
        );

      /*
        ######################################################################
            Set
        ######################################################################
        */
      SELECT @IsPercentEnabled = CASE
                                   WHEN m.is_percent_growth = 1 THEN 'Yes'
                                   ELSE 'No'
                                 END
      FROM   sys.master_files AS m
             JOIN tempdb.sys.database_files AS d
               ON m.file_id = d.file_id
      WHERE  Db_name(m.database_id) = 'tempdb'

      SELECT @CurrentFileSize = Max(( d.size * 8 ) / 1024)
      --SELECT *
      FROM   sys.master_files AS m
             JOIN tempdb.sys.database_files AS d
               ON m.file_id = d.file_id
      WHERE  Db_name(m.database_id) = 'tempdb'
             AND D.type = 0

      SELECT @CurrentLogSize = Max(( d.size * 8 ) / 1024)
      --SELECT *
      FROM   sys.master_files AS m
             JOIN tempdb.sys.database_files AS d
               ON m.file_id = d.file_id
      WHERE  Db_name(m.database_id) = 'tempdb'
             AND D.type = 1

      IF @Percentage IS NULL
          OR @Percentage = ''
        BEGIN
            SELECT @Percentage = CASE
                                   WHEN ServerEnvironment NOT IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '.20'
                                   WHEN ServerEnvironment IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '.30'
                                   ELSE '.20'
                                 END
            --select *
            FROM   dba.info.Instance
        END

      IF @FileGrowth IS NULL
          OR @FileGrowth = ''
        BEGIN
            SELECT @FileGrowth = CASE
                                   WHEN ServerEnvironment NOT IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '524288' --500 MB
                                   WHEN ServerEnvironment IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '1048576' --1 GB
                                   ELSE '524288'
                                 END
            --select *
            FROM   dba.info.Instance
        END

      SELECT @LogFile = CASE
                          WHEN ServerEnvironment NOT IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '1'
                          WHEN ServerEnvironment IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '10'
                          ELSE 1
                        END
      --select ServerEnvironment
      FROM   dba.info.Instance

      IF @ServerLocation IS NULL
          OR @ServerLocation = ''
        BEGIN
            SELECT @ServerLocation = CASE
                                       WHEN ServerLocation IS NOT NULL THEN ServerLocation
                                       ELSE ''
                                     END
            --select *
            FROM   dba.info.Instance
        END

      -- TempDB mdf count equal logical cpu count
      SELECT @CORES = cpu_count
      FROM   sys.dm_os_sys_info

      IF @CORES BETWEEN 9 AND 31
        SET @CORES = @CORES / 2

      IF @CORES >= 32
        SET @CORES = @CORES / 4

      --Check and set tempdb files count are multiples of 4
      IF @CORES > 8
        SET @CORES = @CORES - ( @CORES % 4 )

      SET @BASEPATH = (SELECT CASE
                                WHEN Charindex(N'tempdb.mdf', Lower(physical_name)) > 0 THEN Substring(physical_name, 1, Charindex(N'tempdb.mdf', Lower(physical_name)) - 1)
                                ELSE physical_name
                              END
                       FROM   master.sys.master_files
                       WHERE  database_id = 2
                              AND FILE_ID = 1);
      SET @FILECOUNT = (SELECT Count(*)
                        FROM   master.sys.master_files
                        WHERE  database_id = 2
                               AND TYPE_DESC = N'ROWS')

      SELECT @SIZE = size
      FROM   master.sys.master_files
      WHERE  Db_name(database_id) = 'tempdb'
             AND FILE_ID = 1

      SET @SIZE = @SIZE / 128

      SELECT @GROWTH = growth
      FROM   master.sys.master_files
      WHERE  Db_name(database_id) = 'tempdb'
             AND FILE_ID = 1

      SELECT @ISPERCENT = is_percent_growth
      FROM   master.sys.master_files
      WHERE  Db_name(database_id) = 'tempdb'
             AND FILE_ID = 1

      IF @ISPERCENT = 0
        SET @GROWTH = @GROWTH * 8

      /*
        ######################################################################
      Collective work into the table
        ######################################################################
      */
      INSERT INTO #TempDBUsage
      SELECT Isnull(I.SQlServername, @@SERVERNAME)                                                                                                                                                                                                                             [InstanceName],
             Isnull(ServerLocation, 'Research')                                                                                                                                                                                                                                [InstanceLocation],
             Isnull(ServerEnvironment, 'Research')                                                                                                                                                                                                                             [InstanceEnvironment],
             (SELECT size * 8 / 1024
              FROM   sys.master_files
              WHERE  database_id = 2
                     AND type = 1)                                                                                                                                                                                                                                             AS CurrentLogFileSizeMB,
             (SELECT growth * 8 / 1024
              FROM   sys.master_files
              WHERE  database_id = 2
                     AND type = 1)                                                                                                                                                                                                                                             AS StartingLogFileSizeMB,
             (SELECT Avg(size * 8 / 1024)
              FROM   sys.master_files
              WHERE  database_id = 2
                     AND type = 0)                                                                                                                                                                                                                                             AS AvgStartingTempDataSizeMB,
             (SELECT Avg(growth * 8 / 1024)
              FROM   sys.master_files
              WHERE  database_id = 2
                     AND type = 0)                                                                                                                                                                                                                                             AS AvgCurrentTempDataSizeMB,
             Isnull(Round(CONVERT(DECIMAL(18, 2), vs.total_bytes / 1073741824.0), 0), '0')                                                                                                                                                                                     AS [Total Size (GB)],
             CASE
               WHEN Cast(@CORES AS NVARCHAR(100)) > Cast(@FILECOUNT AS NVARCHAR(100)) THEN 'Server ' + I.SQlServername + ' needs '
                                                                                           + Cast(@CORES AS NVARCHAR(100))
                                                                                           + ' TempDB data files, now there is '
                                                                                           + Cast(@FILECOUNT AS NVARCHAR(100))
                                                                                           + Char(10) + Char(13)
               ELSE 'No datafile growth needed'
             END                                                                                                                                                                                                                                                               [Data File Needed],
             Isnull(Round(( CONVERT(DECIMAL(18, 2), vs.total_bytes / 1073741824.0) - CONVERT(DECIMAL(18, 2), ( vs.total_bytes / 1073741824.0 ) * @Percentage) - CONVERT(DECIMAL(18, 2), @LogFile) ), 0), '0')                                                                  [Usable space for drive  (GB)],
             Isnull(Round(CONVERT(DECIMAL(18, 2), ( ( CONVERT(DECIMAL(18, 2), vs.total_bytes / 1073741824.0) - CONVERT(DECIMAL(18, 2), ( vs.total_bytes / 1073741824.0 ) * @Percentage) - CONVERT(DECIMAL(18, 2), @LogFile) ) / Cast(@CORES AS DECIMAL(18, 2)) ), 0), 0), '0') [Amount per datafile  (GB)],
             CASE
               WHEN ServerLocation = 'AWS-EC2'
                    AND ServerEnvironment NOT IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN @LogFile + ' GB'
               WHEN ServerLocation = 'AWS-EC2'
                    AND ServerEnvironment IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN @LogFile + ' GB'
               WHEN ServerLocation = 'AWS-RDS' THEN 'N/A'
               WHEN ServerLocation = '' THEN @LogFile + ' GB'
               ELSE 'Research'
             END                                                                                                                                                                                                                                                               [Log File  (GB)]
      --SELECT *
      FROM   sys.master_files AS m
             JOIN tempdb.sys.database_files AS d
               ON m.file_id = d.file_id
             CROSS APPLY sys.Dm_os_volume_stats(m.database_id, m.[file_id]) AS vs
             OUTER APPLY DBA.INFO.INSTANCE i
      WHERE  Db_name(m.database_id) = 'tempdb'
             AND m.type_desc = 'LOG'
             AND ServerLocation = @ServerLocation

      /*
        ######################################################################
      Second round of variable sets 
        ######################################################################
      */
      SELECT @InstanceName = InstanceName,
             @InstanceLocation = InstanceLocation,
             @InstanceEnvironment = InstanceEnvironment,
             @CurrentLogFileSizeMB = CurrentLogFileSizeMB,
             @StartingLogFileSizeMB = StartingLogFileSizeMB,
             @AvgStartingTempDataSizeMB = AvgStartingTempDataSizeMB,
             @AvgCurrentTempDataSizeMB = AvgCurrentTempDataSizeMB,
             @TotalSizeGB = TotalSizeGB,
             @DataFileNeeded = DataFileNeeded,
             @UsableSpaceGB = UsableSpaceForDriveGB,
             @AmountPerDataFileGB = AmountPerDatafileGB,
             @LogFileAllocation = LogFileGB
      FROM   #TempDBUsage;

      /*
      ######################################################################
      No matter what even if all has been satisfied Force will show a print out of temp info
      ######################################################################
      */
      IF @Force = 0
        BEGIN
            PRINT 'InstanceLocation: ' + @InstanceLocation;

            PRINT 'InstanceEnvironment: '
                  + @InstanceEnvironment;

            PRINT 'Data File Needed: '
                  + Ltrim(Rtrim(Replace(@DataFileNeeded, Char(10) + Char(13), ' ')));

            PRINT 'Tempdb Percentage Enabled: '
                  + @IsPercentEnabled;

            PRINT 'CurrentLogFileSizeMB: '
                  + Cast(@CurrentLogFileSizeMB AS NVARCHAR);

            PRINT 'StartingLogFileSizeMB: '
                  + Cast(@StartingLogFileSizeMB AS NVARCHAR);

            PRINT 'StartingTempDataSizeMB: '
                  + Cast(@AvgStartingTempDataSizeMB AS NVARCHAR);

            PRINT 'LargestCurrentTempDataSizeMB: '
                  + Cast(@CurrentFileSize AS NVARCHAR);

            PRINT 'Total Size of drive (GB): '
                  + Cast(Cast (@TotalSizeGB AS INT) AS NVARCHAR);

            PRINT 'Percentage of drive excluded from consumption: '
                  + Cast(Cast((Cast(@Percentage AS DECIMAL(5, 2))* 100) AS INT) AS NVARCHAR)
                  + '%';

            PRINT 'Usable space for drive (GB): '
                  + Cast(Cast (@UsableSpaceGB AS INT) AS NVARCHAR);

            PRINT 'Amount of file growth (GB): '
                  + Cast(Cast(Cast(@FileGrowth AS INT)/1024.0/1024.0 AS DECIMAL (5, 2) ) AS NVARCHAR)

            PRINT 'Amount per datafile (GB): '
                  + Cast(Cast (@AmountPerDataFileGB AS INT) AS NVARCHAR);

            PRINT 'LogFile Allocation (GB): ' + @Logfile
        END

      /*
      ######################################################################
      Data Population for users to see (Shows only if mismatch are on datafile count, log or file size and if the Percentage is enabled) 
      ######################################################################
      */
      IF @CORES > @FILECOUNT
          OR Cast(@AmountPerDataFileGB * 1024 AS INT) <> @CurrentFileSize
          OR @CurrentLogSize <> Cast(@LogFile * 1024 AS INT)
          OR @IsPercentEnabled = 'Yes' ---This by default on anything different from our standards 
        IF @Verbose = 0
           AND @Dryrun <> 0
          BEGIN
              SELECT *
              FROM   #TempDBUsage
          END
        ELSE
          BEGIN
              PRINT 'InstanceLocation: ' + @InstanceLocation;

              PRINT 'InstanceEnvironment: '
                    + @InstanceEnvironment;

              PRINT 'Data File Needed: '
                    + Ltrim(Rtrim(Replace(@DataFileNeeded, Char(10) + Char(13), ' ')));

              PRINT 'Tempdb Percentage Enabled: '
                    + @IsPercentEnabled;

              PRINT 'CurrentLogFileSizeMB: '
                    + Cast(@CurrentLogFileSizeMB AS NVARCHAR);

              PRINT 'StartingLogFileSizeMB: '
                    + Cast(@StartingLogFileSizeMB AS NVARCHAR);

              PRINT 'StartingTempDataSizeMB: '
                    + Cast(@AvgStartingTempDataSizeMB AS NVARCHAR);

              PRINT 'LargestCurrentTempDataSizeMB: '
                    + Cast(@CurrentFileSize AS NVARCHAR);

              PRINT 'Total Size of drive (GB): '
                    + Cast(Cast (@TotalSizeGB AS INT) AS NVARCHAR);

              PRINT 'Percentage of drive excluded from consumption: '
                    + Cast(Cast((Cast(@Percentage AS DECIMAL(5, 2))* 100) AS INT) AS NVARCHAR)
                    + '%';

              PRINT 'Usable space for drive (GB): '
                    + Cast(Cast (@UsableSpaceGB AS INT) AS NVARCHAR);

              PRINT 'Amount of file growth (GB): '
                    + Cast(Cast(Cast(@FileGrowth AS INT)/1024.0/1024.0 AS DECIMAL (5, 2) ) AS NVARCHAR)

              PRINT 'Amount per datafile (GB): '
                    + Cast(Cast (@AmountPerDataFileGB AS INT) AS NVARCHAR);

              PRINT 'LogFile Allocation (GB): ' + @Logfile

              IF( @IsRDS = 1 )
                BEGIN
                    PRINT '[] Instance IsRDS = '
                          + CONVERT(CHAR(10), @IsRDS);
                END
          END

      /*
      ######################################################################
      As long as it is not a RDS data will populate by plinko down 
      the variables until the system is perfect it also has a try catch on every process
      If all needs are met then no work will be done and 
      ######################################################################
      */
      IF( @IsRDS != 1 )
        BEGIN
            IF Object_id(N'tempdb..#TempFileNames') IS NOT NULL
              DROP TABLE #TempFileNames

            CREATE TABLE #TempFileNames
              (
                 [Name]            NVARCHAR(100),
                 [TempLogFileName] NVARCHAR(255),
                 IsProcessed       BIT
              )

            BEGIN TRY
                IF @CORES > @FILECOUNT ---creating temp files 
                  BEGIN
                      WHILE @CORES > @FILECOUNT
                        BEGIN
                            SET @SQL_SCRIPT = N'ALTER DATABASE tempdb
                ADD FILE (
                               FILENAME = '''
                                              + @BASEPATH + 'tempdb'
                                              + Rtrim(Cast(@CORES AS NCHAR))
                                              + '.ndf'',
                               NAME = tempdev'
                                              + Rtrim(Cast(@CORES AS NCHAR))
                                              + ',
                               SIZE = '
                                              + Rtrim(Cast(Cast(@UsableSpaceGB * 1024 AS INT) AS NCHAR))
                                              + 'MB,
                               FILEGROWTH = '
                                              + Rtrim(Cast(@FileGrowth AS NCHAR))

                            IF @ISPERCENT = 1
                              SET @SQL_SCRIPT = @SQL_SCRIPT + 'KB'
                            ELSE
                              SET @SQL_SCRIPT = @SQL_SCRIPT + 'KB'

                            SET @SQL_SCRIPT = @SQL_SCRIPT + ')'
                            SET @CORES = @CORES - 1

                            IF @DryRun = 0
                              BEGIN
                                  EXEC (@SQL_SCRIPT)

                                  PRINT 'SUCCESS: Files Successfully Created!  File named: tempdev'
                                        + Rtrim(Cast(@CORES AS NCHAR))
                              END
                            ELSE
                              BEGIN
                                  PRINT ( @SQL_SCRIPT )
                              END
                        END
                  END
            END TRY
            BEGIN CATCH
                PRINT 'ERROR: ' + Error_message()
                PRINT 'Error Number: '
                      + Cast(Error_number() AS NVARCHAR)
                PRINT 'Error Severity: '
                      + Cast(Error_severity() AS NVARCHAR)
                PRINT 'Error State: '
                      + Cast(Error_state() AS NVARCHAR)
                PRINT 'Error Line: '
                      + Cast(Error_line() AS NVARCHAR)
                PRINT 'Procedure: '
                      + Isnull(Error_procedure(), 'N/A')
            END CATCH

            BEGIN TRY
                IF Cast(@AmountPerDataFileGB * 1024 AS INT) > @CurrentFileSize
                    OR @IsPercentEnabled = 'YES' --Modifying Datafiles that exist to the sizes 
                  BEGIN
                      INSERT INTO #TempFileNames
                                  ([Name],
                                   [TempLogFileName],
                                   IsProcessed)
                      SELECT NAME,
                             RIGHT(physical_name, Charindex('\', Reverse(physical_name)) - 1),
                             0
                      --SELECT *
                      FROM   sys.master_files AS m
                      WHERE  Db_name(m.database_id) = 'tempdb'
                             AND m.type = 0

                      SELECT @FileName = [name],
                             @PathFileName = [TempLogFileName]
                      FROM   #TempFileNames

                      WHILE EXISTS(SELECT *
                                   FROM   #TempFileNames
                                   WHERE  IsProcessed = 0)
                        BEGIN
                            SELECT TOP 1 @PathFileName = [TempLogFileName]
                            FROM   #TempFileNames
                            WHERE  IsProcessed = 0

                            SELECT TOP 1 @FileName = [name]
                            FROM   #TempFileNames
                            WHERE  IsProcessed = 0

                            SET @SQL_SCRIPT = N'ALTER DATABASE tempdb
                MODIFY FILE (
                               FILENAME = '''
                                              + @BASEPATH + @PathFileName
                                              + ''',
                               NAME = '''
                                              + @FileName
                                              + ''',
                               SIZE = '
                                              + Rtrim(Cast(Cast(@AmountPerDataFileGB * 1024 AS INT) AS NCHAR))
                                              + 'MB,
                               FILEGROWTH = '
                                              + Rtrim(Cast(@FileGrowth AS NCHAR))

                            IF @ISPERCENT = 1
                              SET @SQL_SCRIPT =@SQL_SCRIPT + 'KB'
                            ELSE
                              SET @SQL_SCRIPT = @SQL_SCRIPT + 'KB'

                            SET @SQL_SCRIPT = @SQL_SCRIPT + ')'
                            SET @CORES = @CORES - 1

                            IF @DryRun = 0
                              BEGIN
                                  EXEC(@SQL_SCRIPT)

                                  PRINT 'SUCCESS: Table File Modified for '
                                        + @FileName
                              END
                            ELSE
                              BEGIN
                                  PRINT ( @SQL_SCRIPT )
                              END

                            UPDATE #TempFileNames
                            SET    IsProcessed = 1
                            WHERE  [TempLogFileName] = @PathFileName
                        END
                  END
            END TRY
            BEGIN CATCH
                PRINT 'ERROR: ' + Error_message()
                PRINT 'Error Number: '
                      + Cast(Error_number() AS NVARCHAR)
                PRINT 'Error Severity: '
                      + Cast(Error_severity() AS NVARCHAR)
                PRINT 'Error State: '
                      + Cast(Error_state() AS NVARCHAR)
                PRINT 'Error Line: '
                      + Cast(Error_line() AS NVARCHAR)
                PRINT 'Procedure: '
                      + Isnull(Error_procedure(), 'N/A')
            END CATCH

            BEGIN TRY
                IF @CurrentLogSize > Cast(@LogFile * 1024 AS INT) ----Logs File aren't standard 
                  BEGIN
                      INSERT INTO #TempFileNames
                                  ([Name],
                                   [TempLogFileName],
                                   IsProcessed)
                      SELECT NAME,
                             RIGHT(physical_name, Charindex('\', Reverse(physical_name)) - 1),
                             0
                      --SELECT *
                      FROM   sys.master_files AS m
                      WHERE  Db_name(m.database_id) = 'tempdb'
                             AND m.type = 1

                      SELECT @FileName = [name],
                             @PathFileName = [TempLogFileName]
                      FROM   #TempFileNames

                      WHILE EXISTS(SELECT *
                                   FROM   #TempFileNames
                                   WHERE  IsProcessed = 0)
                        BEGIN
                            SELECT TOP 1 @PathFileName = [TempLogFileName]
                            FROM   #TempFileNames
                            WHERE  IsProcessed = 0

                            SELECT TOP 1 @FileName = [name]
                            FROM   #TempFileNames
                            WHERE  IsProcessed = 0

                            SET @SQL_SCRIPT = N'ALTER DATABASE tempdb
                MODIFY FILE (
                               FILENAME = '''
                                              + @BASEPATH + @PathFileName
                                              + ''',
                               NAME = '''
                                              + @FileName
                                              + ''',
                               SIZE = '
                                              + Rtrim(Cast(Cast(@LogFile * 1024 AS INT) AS NCHAR))
                                              + 'MB,
                               FILEGROWTH = '
                                              + Rtrim(Cast(@FileGrowth AS NCHAR))

                            IF @ISPERCENT = 1
                              SET @SQL_SCRIPT =@SQL_SCRIPT + 'KB'
                            ELSE
                              SET @SQL_SCRIPT = @SQL_SCRIPT + 'KB'

                            SET @SQL_SCRIPT = @SQL_SCRIPT + ')'
                            SET @CORES = @CORES - 1

                            IF @DryRun = 0
                              BEGIN
                                  EXEC(@SQL_SCRIPT)

                                  PRINT 'SUCCESS: Table File Modified for '
                                        + @FileName
                              END
                            ELSE
                              BEGIN
                                  PRINT ( @SQL_SCRIPT )
                              END

                            UPDATE #TempFileNames
                            SET    IsProcessed = 1
                            WHERE  [TempLogFileName] = @PathFileName
                        END
                  END
            END TRY
            BEGIN CATCH
                PRINT 'ERROR: ' + Error_message()
                PRINT 'Error Number: '
                      + Cast(Error_number() AS NVARCHAR)
                PRINT 'Error Severity: '
                      + Cast(Error_severity() AS NVARCHAR)
                PRINT 'Error State: '
                      + Cast(Error_state() AS NVARCHAR)
                PRINT 'Error Line: '
                      + Cast(Error_line() AS NVARCHAR)
                PRINT 'Procedure: '
                      + Isnull(Error_procedure(), 'N/A')
            END CATCH
        END
  END 
