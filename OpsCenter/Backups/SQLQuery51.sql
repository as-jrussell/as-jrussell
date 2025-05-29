/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [EventName],
                  [Enabled],
                  [broken],
                  [normal],
                  [info],
                  [low],
                  [medium],
                  [high],
                  [UnitsOfMeasure]
FROM   [PerfStats].[dbo].[ThresholdConfig] T

USE [master]

ALTER DATABASE [Bond_Main]

SET HADR SUSPEND;

GO

ALTER DATABASE [WinSvcLog]

SET HADR SUSPEND;

GO


use master

ALTER DATABASE [Bond_Main] SET HADR RESUME;

GO

ALTER DATABASE [WinSvcLog]
 SET HADR RESUME;

GO


EXEC [PerfStats].[dbo].[ResumeDatabase] @DryRun = 0

EXEC [PerfStats].[dbo].[Captureaglagstats] 

EXEC [PerfStats].[dbo].[Captureaglagstats]  @verbose = 1

EXEC [PerfStats].[dbo].[Captureaglagstats]
  @DryRun = 1

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [seconds behind]
      ,[Threshold_Level]
      ,[ServerName]
      ,[DatabaseName - secondary_replica]
      ,[Is_Suspended]
      ,[group_name]
      ,[availability_mode_desc]
      ,[Current_DT]
      ,[ID]
  FROM [PerfStats].[BOND-STAGE-DBs].[AGLagStats]
  order by id desc 




  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [seconds behind]
      ,[Threshold_Level]
      ,[ServerName]
      ,[DatabaseName - secondary_replica]
      ,[Is_Suspended]
      ,[group_name]
      ,[availability_mode_desc]
      ,[Current_DT]
      ,[ID]
  FROM [PerfStats].[IQQ-STAGE-DBs].[AGLagStats]
    order by id desc 









