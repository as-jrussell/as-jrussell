USE [DBA];

GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

GO

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[GetTempDBFiles]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[GetTempDBFiles] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[GetTempDBFiles] (@DryRun             BIT = 1,
                                        @Debug              BIT = 0,
                                        @Verbose            BIT = 0,
                                        @FreeSpaceThreshold INT = 25 -- Parameter for custom low space threshold
)
AS
  BEGIN
  /*
  ######################################################################
      Examples 11/1/2024 11:49:44 AM
  ######################################################################
  
  EXEC [DBA].[dbo].[GetTempDBFiles] @Debug = 0, @Verbose = 1;
  EXEC [DBA].[dbo].[GetTempDBFiles] @Debug = 1, @Verbose = 1, @DryRun = 0;
  EXEC [DBA].[dbo].[GetTempDBFiles]  @DryRun = 0;
  */
      /*
      ######################################################################
          Declare Variables
      ######################################################################
      */
      DECLARE @SQLCMD NVARCHAR(MAX);
      DECLARE @LowSpaceFiles NVARCHAR(MAX) = ''; -- Variable to store filenames with low space
      /*
      ######################################################################
          Create and Populate Temp Table
      ######################################################################
      */
      IF ( @Debug = 1 )
        PRINT '[Debug] Creating #TempDBFileUsage table for monitoring file details.';

      IF Object_id('tempdb..#TempDBFileUsage') IS NOT NULL
        DROP TABLE #TempDBFileUsage;

      CREATE TABLE #TempDBFileUsage
        (
           FileName        NVARCHAR(128),
           TotalSize_MB    INT,
           UsedSpace_MB    INT,
           FreeSpace_MB    INT,
           [Free Space %]  INT,
           Growth_MB       INT,
           GrowthType      NVARCHAR(10),
           [MAX Growth MB] VARCHAR(100),
           FilePath        NVARCHAR(256),
           FileState       NVARCHAR(20)
        );

      IF ( @Verbose = 1 )
        PRINT '[Verbose] Executing SQL Command for TempDB File Usage.';

      /*
      ######################################################################
          Processing
      ######################################################################
      */
      SET @SQLCMD = N'
    USE [tempdb];
    INSERT INTO #TempDBFileUsage (FileName, TotalSize_MB, UsedSpace_MB, FreeSpace_MB, [Free Space %], Growth_MB, GrowthType,  [MAX Growth MB], FilePath, FileState)
    SELECT 
        name AS FileName,
        size / 128 AS TotalSize_MB,
        FILEPROPERTY(name, ''SpaceUsed'') / 128 AS UsedSpace_MB,
        (size - FILEPROPERTY(name, ''SpaceUsed'')) / 128 AS FreeSpace_MB,
        [Free Space %] = CASE 
            WHEN (max_size = -1 OR growth > 0) 
            THEN CONVERT(INT, ABS(CONVERT(DECIMAL(10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) / 128.0) / CONVERT(DECIMAL(10,2), size / 128.0) * 100 - 100))
            ELSE CONVERT(INT, ABS(CONVERT(DECIMAL(10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT) / 128.0) / CONVERT(DECIMAL(10,2), max_size / 128.0) * 100 - 100))
        END,
        growth * 8 / 1024 AS Growth_MB,
        CASE is_percent_growth 
            WHEN 1 THEN ''Percent''
            ELSE ''MB''
        END AS GrowthType, CASE WHEN growth = 0 THEN ''Autogrowth is off'' ELSE CASE WHEN max_size = -1 THEN ''Unlimited'' WHEN growth= 0 THEN ''Unlimited'' WHEN max_size = 268435456 THEN ''2 TB''  ELSE CAST(max_size/128 AS VARCHAR(10))    + '' MB'' END END 
		, 
        physical_name AS FilePath,
        state_desc AS FileState
    FROM 
        tempdb.sys.database_files
    WHERE 
        type_desc IN (''ROWS'', ''LOG'');';

      IF ( @Verbose = 1 )
        PRINT ( @SQLCMD );

      IF ( @DryRun = 1 )
        BEGIN
            EXEC (@SQLCMD);

            SELECT 'TempDB File Usage'                                                      AS DataCategory,
                   T. FileName,
                   TotalSize_MB,
                   UsedSpace_MB,
                   FreeSpace_MB,
                   [Free Space %],
                   Growth_MB,
                   GrowthType,
                   [MAX Growth MB],
                   CONVERT(DECIMAL(18, 2), vs.available_bytes / 1073741824.0)               AS [Available on Drive (GB)],
				    FilePath,
                   T.FileState
            FROM   #TempDBFileUsage T
                   JOIN sys.master_files AS f WITH (NOLOCK)
                     ON f.name = T.filename
                   CROSS APPLY sys.Dm_os_volume_stats(f.database_id, f.[file_id]) AS vs
        -- WHERE [Free Space %] < @FreeSpaceThreshold;
        END
      ELSE
        BEGIN
            EXEC (@SQLCMD);

            IF @Verbose = 1
              PRINT '[Verbose] Checking files for low free space.';

            SELECT           T. FileName,
                   TotalSize_MB,
                   UsedSpace_MB,
                   FreeSpace_MB,
                   [Free Space %],
                   Growth_MB,
                   GrowthType,
                   [MAX Growth MB],
                   CONVERT(DECIMAL(18, 2), vs.available_bytes / 1073741824.0)               AS [Available on Drive (GB)],
				    FilePath,
                   T.FileState
            FROM   #TempDBFileUsage T
                   JOIN sys.master_files AS f WITH (NOLOCK)
                     ON f.name = T.filename
                   CROSS APPLY sys.Dm_os_volume_stats(f.database_id, f.[file_id]) AS vs
            WHERE  [Free Space %] < @FreeSpaceThreshold
			AND CONVERT(DECIMAL(18, 2), vs.available_bytes / 1073741824.0) < '5.00' ;

            -- Collect filenames with low free space
            SELECT @LowSpaceFiles = String_agg(FileName, ', ')
            FROM   #TempDBFileUsage T
                   JOIN sys.master_files AS f WITH (NOLOCK)
                     ON f.name = T.filename
                   CROSS APPLY sys.Dm_os_volume_stats(f.database_id, f.[file_id]) AS v
            WHERE  [Free Space %] < @FreeSpaceThreshold;

            IF @LowSpaceFiles IS NOT NULL
              BEGIN
                  PRINT '[Warning] Low space detected in the following TempDB files: '
                        + @LowSpaceFiles;
              END
            ELSE
              BEGIN
                  PRINT '[Info] No files in tempdb are critically low on free space.';
              END
        END;
  END;

GO 
