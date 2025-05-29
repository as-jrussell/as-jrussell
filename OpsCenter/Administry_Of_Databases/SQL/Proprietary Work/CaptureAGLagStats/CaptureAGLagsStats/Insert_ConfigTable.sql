USE [PerfStats]

GO

IF ( EXISTS (SELECT t.NAME
             FROM   PerfStats.sys.tables t
             WHERE  t.NAME = 'ThresholdConfig') )
  BEGIN
      IF Object_id('tempdb..#ThresholdConfig', 'U') IS NOT NULL
        DROP TABLE #ThresholdConfig

      CREATE TABLE #ThresholdConfig
        (
           [EventName]      [NVARCHAR](100),
           [Enabled]        [BIT],
           [broken]         [NVARCHAR](100),
           [normal]         [NVARCHAR](100),
           [info]           [NVARCHAR](100),
           [low]            [NVARCHAR](100),
           [medium]         [NVARCHAR](100),
           [high]           [NVARCHAR](100),
           [UnitsOfMeasure] [NVARCHAR](10)
        )--    WITH (DATA_COMPRESSION = PAGE);
      IF( '$(targetEnv)' = 'PROD' )
        BEGIN
            PRINT 'Set PROD values'

            INSERT INTO #ThresholdConfig
                        ([EventName],
                         [Enabled],
                         [broken],
                         [normal],
                         [info],
                         [low],
                         [medium],
                         [high],
                         [UnitsOfMeasure])
            VALUES      ('[PerfStats].[dbo].[CaptureAGlagstats]',
                         1,
                         NULL,
                         0,
                         1800,
                         7200,
                         10800,
                         14400,
                         'seconds')
        END
      ELSE
        BEGIN
            PRINT 'Set NonProd values'

            INSERT INTO #ThresholdConfig
                        ([EventName],
                         [Enabled],
                         [broken],
                         [normal],
                         [info],
                         [low],
                         [medium],
                         [high],
                         [UnitsOfMeasure])
            VALUES      ('[PerfStats].[dbo].[CaptureAGlagstats]',
                         1,
                         NULL,
                         0,
                         3600,
                         7200,
                         14400,
                         21600,
                         'seconds')
        END

      MERGE [PerfStats].[dbo].[ThresholdConfig] AS TARGET
      USING #ThresholdConfig AS SOURCE
      ON ( TARGET.[EventName] = SOURCE. [EventName] )
      WHEN MATCHED THEN
        UPDATE SET TARGET.[Enabled] = SOURCE.[Enabled],
                   TARGET.[broken] = SOURCE.[broken],
                   TARGET.[normal] = SOURCE.[normal],
                   TARGET.[info] = SOURCE.[info],
                   TARGET.[low] = SOURCE.[low],
                   TARGET.[medium] = SOURCE.[medium],
                   TARGET.[high] = SOURCE.[high],
                   TARGET.[UnitsOfMeasure] = SOURCE.[UnitsOfMeasure]
      /*Inserts records into the target table */
      WHEN NOT MATCHED BY TARGET THEN
        INSERT ([EventName],
                [Enabled],
                [broken],
                [normal],
                [info],
                [low],
                [medium],
                [high],
                [UnitsOfMeasure])
        VALUES (SOURCE.[EventName],
                SOURCE.[Enabled],
                SOURCE.[broken],
                SOURCE.[normal],
                SOURCE.[info],
                SOURCE.[low],
                SOURCE.[medium],
                SOURCE.[high],
                SOURCE.[UnitsOfMeasure])
      /*Delete records that exist in the target table(Utility.dbo.TraceFlagByVersion), but not in the source table(#TraceFlags)*/
      WHEN NOT MATCHED BY SOURCE THEN
        DELETE;

      /*Drop temp table*/
      DROP TABLE #ThresholdConfig;
  END;

GO 