USE [PerfStats]

GO

/****** Object:  StoredProcedure [dbo].[CaptureDBFileUsage]    Script Date: 5/28/2024 4:14:09 PM ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[Capturedbfileusage](@TargetDB   NVARCHAR(100) = '',
                                           @TargetType NVARCHAR(10) = '',
                                           @WhatIF     BIT = 1,
                                           @Verbose    BIT = 0)
AS
    IF Object_id('tempdb..#dbserversize') IS NOT NULL
      DROP TABLE #dbserversize;

    --  EXEC [dbo].[CaptureDBFileUsage] @TargetDB = 'TEMPDB'
    CREATE TABLE #dbserversize
      (
         [databaseName]  SYSNAME,
         [Drive]         VARCHAR(3),
         [Logical Name]  SYSNAME,
         [Physical Name] VARCHAR(MAX),
         [File Size MB]  DECIMAL(38, 2),
         [Space Used MB] DECIMAL(38, 2),
         [Free Space]    DECIMAL(38, 2),
         [%Free Space]   DECIMAL(38, 2),
         [Max Size]      VARCHAR(MAX),
         [Growth Rate]   VARCHAR(MAX)
      );

    DECLARE @id INT;
    DECLARE @dbname SYSNAME;
    DECLARE @sqltext NVARCHAR(MAX);
    DECLARE @freespacePct INT;
    DECLARE @CaptureDate DATETIME = Getdate();
    DECLARE @NORMALTHRESHOLD INT;
    DECLARE @LOWTHRESHOLD INT;
    DECLARE @MEDIUMTHRESHOLD INT;
    DECLARE @HIGHTHRESHOLD INT;

    SELECT @NORMALTHRESHOLD = [Normal]
    FROM   [PerfStats].[dbo].[ThresholdConfig]
    WHERE  EventName = '[PerfStats].[dbo].[CaptureDBFileUsage]';

    SELECT @LOWTHRESHOLD = [low]
    FROM   [PerfStats].[dbo].[ThresholdConfig]
    WHERE  EventName = '[PerfStats].[dbo].[CaptureDBFileUsage]';

    SELECT @MEDIUMTHRESHOLD = [medium]
    FROM   [PerfStats].[dbo].[ThresholdConfig]
    WHERE  EventName = '[PerfStats].[dbo].[CaptureDBFileUsage]';

    SELECT @HIGHTHRESHOLD = [high]
    FROM   [PerfStats].[dbo].[ThresholdConfig]
    WHERE  EventName = '[PerfStats].[dbo].[CaptureDBFileUsage]';

    IF Object_id('tempdb..#Database_List') IS NOT NULL
      DROP TABLE #Database_List

    CREATE TABLE #Database_List
      (
         DatabaseName NVARCHAR(max),
         DatabaseType NVARCHAR(max),
         IsProcessed  INT
      );

    INSERT INTO #Database_List
    SELECT Concat('', [name], ''),-- select * ,
           CASE
             WHEN NAME IN ( 'master', 'model', 'tempdb', 'MSDB', 'rdsadmin' ) THEN 'SYSTEM'
             WHEN NAME IN ( 'DBA', 'PerfStats', 'InventoryDWH' ) THEN 'ADMIN'
             ELSE 'USER'
           END,
           0
    FROM   master.sys.databases
    WHERE  is_read_only != 1
           AND state_desc = 'ONLINE'
           AND [name] = CASE
                          WHEN @TargetDB = '' THEN [name]
                          ELSE @TargetDB
                        END
    ORDER  BY name

    /* trim waste ? */
    IF ( @TargetType != '' )
      DELETE FROM #Database_List
      WHERE  DatabaseType != @TargetType

    WHILE EXISTS (SELECT TOP 1 *
                  FROM   #Database_List
                  WHERE  IsProcessed = 0)
      BEGIN
          SELECT TOP 1 @dbname = DatabaseName
          FROM   #Database_List
          WHERE  IsProcessed = 0

          SET @sqltext = N' use [' + @dbname + N'];' + N' 
								insert into #dbserversize
								select 
								
								''' + @dbname
                         + N''' as [databaseName]
								,substring([physical_name], 1, 3) as [Drive]
								,name as  [Logical Name]
								,[physical_name] as [Physical Name]
								,cast(CAST([size] as decimal(38, 2)) / 128.0 as decimal(38, 2)) as [File Size MB]
								,cast(CAST(FILEPROPERTY([name], ''SpaceUsed'') as decimal(38, 2)) / 128.0 as decimal(38, 2)) as [Space Used MB]
								,cast((CAST([size] as decimal(38, 0)) / 128) - (CAST(FILEPROPERTY([name], ''SpaceUsed'') as decimal(38, 0)) / 128.) as decimal(38, 2)) as [Free Space]
								,cast(((CAST([size] as decimal(38, 2)) / 128) - (CAST(FILEPROPERTY([name], ''SpaceUsed'') as decimal(38, 2)) / 128.0)) * 100.0 / (CAST([size] as decimal(38, 2)) / 128) as decimal(38, 2)) as [%Free Space]
								,case
								when cast([max_size] as varchar(max)) = - 1
								then ''UNLIMITED''
								else cast([max_size] as varchar(max))
								end as [Max Size]
								,case
								when is_percent_growth = 1
								then cast([growth] as varchar(20)) + ''%''
								else cast([growth] as varchar(20)) + ''MB''
								end as [Growth Rate]
								from sys.database_files
								where type IN (0,1)';

          exec (@sqltext);

          UPDATE #Database_List
          SET    IsProcessed = 1
          WHERE  IsProcessed = 0
                 AND DatabaseName = @dbname
      END;

    BEGIN
        IF ( @WhatIF = 1 )
     BEGIN
              /* Do NOT invoke any change - display what would happen */
              SELECT *,
                     CASE
                       WHEN [Max Size] = 'UNLIMITED'
                             OR [Max Size] = '268435456' THEN 'Normal'
                       WHEN [%Free Space] > @NORMALTHRESHOLD THEN 'Normal'
                       WHEN [%Free Space] >= @LOWTHRESHOLD THEN 'Low'
                       WHEN [%Free Space] >= @MEDIUMTHRESHOLD THEN 'Medium'
                       WHEN [%Free Space] >= @HIGHTHRESHOLD THEN 'HIGH'
                       ELSE 'Critical'
                     END AS STATUS
              FROM   #dbserversize;
          END;
        ELSE
          BEGIN
              /* Invoke changes */
              INSERT INTO [dbo].[FileSizeHistory]
                          ([HarvestDate],
                           [DatabaseName],
                           [Drive],
                           [LogicalName],
                           [PhysicalName],
                           [FileSizeMB],
                           [SpaceUsedMB],
                           [FreeSpace],
                           [%FreeSpace],
                           [MaxSize],
                           [AutoGrowthRate])
              SELECT @CaptureDate,
                     [databaseName],
                     [Drive],
                     [Logical Name],
                     [Physical Name],
                     [File Size MB],
                     [Space Used MB],
                     [Free Space],
                     [%Free Space],
                     [Max Size],
                     [Growth Rate]
              FROM   #dbserversize;
          END;
      END; 
    /* Drop previous version */
    IF EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[GetFileSize]')
                      AND type IN ( N'P', N'PC' ))
      BEGIN
          DROP PROCEDURE [dbo].[GetFileSize]
      END; 
