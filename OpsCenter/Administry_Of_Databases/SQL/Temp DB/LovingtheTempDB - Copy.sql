USE DBA



---Variables that can be altered 
DECLARE @Percentage DECIMAL(5, 2) =NULL
DECLARE @Dryrun BIT = 0
DECLARE @Verbose BIT = 0


----Embedded into Stored Proc
DECLARE @ServerLocation NVARCHAR(10)
DECLARE @LogFile NVARCHAR(10)
DECLARE @CORES INT
DECLARE @BASEPATH NVARCHAR(300)
DECLARE @FILECOUNT INT
DECLARE @SIZE INT
DECLARE @GROWTH INT
DECLARE @ISPERCENT INT
DECLARE @InstanceName NVARCHAR(255);
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



IF @Percentage IS NULL
    OR @Percentage = ''
  BEGIN
SELECT @Percentage = CASE
                    WHEN ServerLocation = @ServerLocation
                         AND ServerEnvironment NOT IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '.20'
                    WHEN ServerLocation = @ServerLocation
                         AND ServerEnvironment IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '.25'
                    ELSE '.20'
                  END
--select *
FROM   dba.info.Instance
END 


SELECT @LogFile = CASE
                    WHEN ServerLocation = @ServerLocation
                         AND ServerEnvironment NOT IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '1'
                    WHEN ServerLocation = @ServerLocation
                         AND ServerEnvironment IN ( 'PRD', 'PROD', 'ADMIN', 'ADM' ) THEN '10'
                    ELSE 1
                  END
--select *
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
WHERE  database_id = 2
       AND FILE_ID = 1

SET @SIZE = @SIZE / 128

SELECT @GROWTH = growth
FROM   master.sys.master_files
WHERE  database_id = 2
       AND FILE_ID = 1

SELECT @ISPERCENT = is_percent_growth
FROM   master.sys.master_files
WHERE  database_id = 2
       AND FILE_ID = 1

IF @ISPERCENT = 0
  SET @GROWTH = @GROWTH * 8

IF Object_id('tempdb..#TempDBUsage', 'U') IS NOT NULL
  DROP TABLE #TempDBUsage;

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



---force this to only show for either just dryrun or just verbose if dryrun is 0 this isn't needed
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
       AND ( ( d.size * 8 ) / 1024 ) <= ( @LogFile * 1024 )
       AND ServerLocation = @ServerLocation

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

IF @CORES > @FILECOUNT --- let's make this a few IFs to see if this will work.


      IF @Verbose = 0
        BEGIN
            SELECT *
            FROM   #TempDBUsage
        END
      ELSE IF @DryRun <> 0
        BEGIN
            PRINT 'InstanceLocation: ' + @InstanceLocation;

            PRINT 'InstanceEnvironment: '
                  + @InstanceEnvironment;

            PRINT 'CurrentLogFileSizeMB: '
                  + Cast(@CurrentLogFileSizeMB AS NVARCHAR);

            PRINT 'StartingLogFileSizeMB: '
                  + Cast(@StartingLogFileSizeMB AS NVARCHAR);

            PRINT 'AvgStartingTempDataSizeMB: '
                  + Cast(@AvgStartingTempDataSizeMB AS NVARCHAR);

            PRINT 'AvgCurrentTempDataSizeMB: '
                  + Cast(@AvgCurrentTempDataSizeMB AS NVARCHAR);

            PRINT 'Total Size (GB): '
                  + Cast(@TotalSizeGB AS NVARCHAR);

            PRINT 'Usable space for drive (GB): '
                  + Cast(@UsableSpaceGB AS NVARCHAR);

            PRINT 'Amount per datafile (GB): '
                  + Cast(@AmountPerDataFileGB AS NVARCHAR);

            PRINT 'Data File Needed: ' +    LTRIM(RTRIM(REPLACE(@DataFileNeeded, CHAR(10) + CHAR(13), ' ')));

            PRINT 'LogFile Allocation: ' + @LogFileAllocation+
			'
			' 
        END



IF @CORES > @FILECOUNT
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
                              + Rtrim(Cast(CAST(@UsableSpaceGB * 1024 AS INT) AS NCHAR)) 
                              + 'MB,
                               FILEGROWTH = '
                              + Rtrim(Cast(@GROWTH AS NCHAR))

            IF @ISPERCENT = 1
              SET @SQL_SCRIPT =@SQL_SCRIPT + 'KB'
            ELSE
              SET @SQL_SCRIPT = @SQL_SCRIPT + 'KB'

            SET @SQL_SCRIPT = @SQL_SCRIPT + ')'
            SET @CORES = @CORES - 1

            IF @DryRun = 0
              BEGIN
               --   EXEC (@SQL_SCRIPT)
			   Print 'You made to the end of the game Mario thanks for saving the Princess!!!!'
              END
            ELSE
              BEGIN
                  PRINT ( @SQL_SCRIPT )
              END
        END

  END 





