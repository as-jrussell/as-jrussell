USE [AppLog]

GO

IF NOT EXISTS (SELECT *
               FROM   sys.schemas
               WHERE  name = N'archive')
  EXEC sys.Sp_executesql
    N'CREATE SCHEMA [archive]'

GO

USE [AppLog];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/****** Object:  Table [archive].[PurgeConfig]    Script Date: 10/14/2021 3:37:43 PM ******/
IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[archive].[PurgeConfig]')
                      AND type IN ( N'U' ))
  BEGIN
      CREATE TABLE [archive].[PurgeConfig]
        (
           [JobName]        [NVARCHAR](100) NOT NULL,
           [DatabaseName]   [NVARCHAR](100) NOT NULL,
           [SchemaName]     [NVARCHAR](100) NOT NULL,
           [TableName]      [NVARCHAR](100) NOT NULL,
           [TableRetention] [INT] NOT NULL,
           [BatchSize]      [INT] NULL,
           [Archive]        BIT,
           [Enabled]        [BIT] NOT NULL
        )
      ON [PRIMARY]
  END;

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;


INSERT INTO [archive].[PurgeConfig]
            ([JobName],
             [DatabaseName],
             [SchemaName],
             [TableName],
             [TableRetention],
             [BatchSize],
             [Archive],
             [Enabled])
VALUES      ('archive-PurgeTable',
             'Applog',
             'dbo',
             'Applog',
             '855',
             '10000',
             1,
             1)

GO

/****** Object:  Table [archive].[PurgeHistory]    Script Date: 10/14/2021 3:37:43 PM ******/
IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[archive].[PurgeHistory]')
                      AND type IN ( N'U' ))
  BEGIN
      CREATE TABLE [archive].[PurgeHistory]
        (
           [RunID]        [BIGINT] IDENTITY(1, 1) NOT NULL,
           [JobName]      [NCHAR](100) NOT NULL,
           [DatabaseName] [NVARCHAR](100) NOT NULL,
           [SChemaName]   [NVARCHAR](100) NOT NULL,
           [TableName]    [NVARCHAR](100) NOT NULL,
           [RemoveCount]  [BIGINT] NOT NULL,
           [RetainCount]  [BIGINT] NOT NULL,
           [RunDate]      [DATETIME] NOT NULL,
           CONSTRAINT [PK_TableCleanupHistory] PRIMARY KEY CLUSTERED ( [RunID] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
      ON [PRIMARY]
  END



USE AppLog

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[archive].[PurgeTable]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [archive].[PurgeTable] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [archive].[Purgetable] (@JobName      NVARCHAR(100)='archive-PurgeTable',
                                        @DatabaseName [NVARCHAR](100) ='Applog',
                                        @SchemaName   [NVARCHAR](100)='dbo',
                                        @TableName    [NVARCHAR](100)='Applog',
                                        @WhatIf       BIT = 0)
AS
  BEGIN
      -- DECLARE @JobName varchar(100) = 'archive-LedgerCleanup'
      -- DECLARE @TableName varchar(100) = 'LedgerDeliveries'
      DECLARE @NumberOfDaysToKeep INT,
              @RetainRows         INT
      DECLARE @BatchSize  INT,
              @Enabled    INT,
              @RemoveRows INT
      DECLARE @SQLStatement NVARCHAR(200)

      -- SELECT * FROM [OUR_FIRST_DATABASE].[archive].[AgentJobTableRetention]
      SELECT @NumberOfDaysToKeep = TableRetention,
             @BatchSize = BatchSize,
             @Enabled = Enabled
      FROM   [AppLog].[archive].[PurgeConfig]
      WHERE  JobName = @JobName
             AND TableName = @TableName;

      -- Record Beginning counts
      SELECT @SQLStatement = 'SELECT @RemoveCount = count(*) FROM ['
                             + @DatabaseName + '].[dbo].[' + @TableName
                             + '] WHERE DateDiff(day, Modified, GetDate()) > '
                             + CONVERT(VARCHAR(10), @NumberOfDaysToKeep)

      EXEC Sp_executesql
        @SQLStatement,
        N'@RemoveCount int out',
        @RemoveRows out

      SELECT @SQLStatement = 'SELECT @RetainCount = count(*) FROM['
                             + @DatabaseName + '].[dbo].[' + @TableName
                             + '] WHERE DateDiff(day, Modified, GetDate()) < '
                             + CONVERT(VARCHAR(10), @NumberOfDaysToKeep)

      EXEC Sp_executesql
        @SQLStatement,
        N'@RetainCount int out',
        @RetainRows out

      PRINT 'JobName: ' + @jobName + ' 
    TableName: '
            + @TableName + ' 
    Keeping: '
            + CONVERT(VARCHAR(10), @NumberOfDaysToKeep)
            + ' Days 
    BatchSize: '
            + CONVERT(VARCHAR(10), @BatchSize)
            + ' rows 
    Enabled: '
            + CONVERT(VARCHAR(10), @Enabled)
            + ' 
    Rows to be deleted: '
            + CONVERT(VARCHAR(10), @RemoveRows)
            + ' 
    Rows to remain: '
            + CONVERT(VARCHAR(10), @RetainRows)

      IF( ( @Enabled = 1 )
          AND ( @RemoveRows > 0 ) )
        BEGIN
            INSERT INTO [AppLog].[archive].[PurgeHistory]
                        ([JobName],
                         [DatabaseName],
                         [SChemaName],
                         [TableName],
                         [RemoveCount],
                         [RetainCount],
                         [RunDate])
            VALUES      ( @jobName,
                          @DatabaseName,
                          @SchemaName,
                          @TableName,
                          @RemoveRows,
                          @RetainRows,
                          Getdate() )

            /* Insert statement will return @@RowCount = 1 */
            WHILE ( @@ROWCOUNT > 0 )
              BEGIN
                  -- Ledger table cleanup
                  SELECT @SQLStatement = 'DELETE TOP('
                                         + CONVERT(VARCHAR(10), @BatchSize)
                                         + ') FROM [' + @DatabaseName
                                         + '] .[dbo].[' + @TableName
                                         + '] WHERE DateDiff(day, Modified, GetDate()) > '
                                         + CONVERT(VARCHAR(10), @NumberOfDaysToKeep)

                  -- PRINT @SQLStatement
                  EXEC(@SQLStatement)
              END
        -- SELECT * FROM [OUR_FIRST_DATABASE].[archive].[PurgeHistory]
        END
      ELSE
        BEGIN
            IF( @Enabled = 0 )
              BEGIN
                  PRINT 'Nothing Processed - Table Disabled.'
              END
            ELSE
              BEGIN
                  PRINT 'No rows to delete.'
              END
        END
  END;

USE [msdb];

/* Set variables */
DECLARE @JobName        VARCHAR(200) = 'CTPT-PurgeAppLogTable',
        @EnableNewJobs  BIT = 0,/* 1 will create jobs as Enabled (for online DBs and server-side jobs), 0 will ceate jobs as Disabled */
        @ScheduleID     INT,
        @StepID         INT = 0,
        @StartStep      INT = 1,
        @StepName       VARCHAR(100),
        @ScheduleName   VARCHAR(256),
        @JobCategory    VARCHAR(100) = 'Applog',
        @description    VARCHAR(256),
        @notifyOperator VARCHAR(100) = '[TeamOperator]';

SELECT @description = 'Records table counts in Applog.CTPT.TableCleanupHistory
Does not archive data.'

/* Create Standard job schedule */
SELECT @ScheduleName = @jobName + '_Schedule'

/* JOB required parameter */
DECLARE @Version NUMERIC(18, 10),
        @cmd     NVARCHAR(MAX),
        @output  NVARCHAR(MAX)

/* Add necessary categories */
IF NOT EXISTS (SELECT *
               FROM   msdb.dbo.syscategories
               WHERE  name = @JobCategory
                      AND category_class = 1)
  BEGIN
      EXEC msdb.dbo.Sp_add_category
        @class=N'JOB',
        @type=N'LOCAL',
        @name= @JobCategory
  END

/*Check if the job exists and create if it doesn't */
IF NOT EXISTS (SELECT *
               FROM   msdb..sysjobs
               WHERE  name = @JobName)
  BEGIN
      EXEC msdb.dbo.Sp_add_job
        @job_name= @JobName,
        @enabled=0;
  END
ELSE
  BEGIN
      /* Does job exist - maintain current enabled status */
      SELECT @EnableNewJobs = enabled
      FROM   msdb..sysjobs
      WHERE  name = @JobName
  END;

/* Update the job */
EXEC msdb.dbo.Sp_update_job
  @job_name= @JobName,
  @enabled= @EnableNewJobs,
  @notify_level_eventlog=2,
  @notify_level_email=2,
  @notify_level_netsend=0,
  @notify_level_page=0,
  @delete_level=0,
  @description= @description,
  @category_name= @JobCategory,
  @owner_login_name=N'sa',
  @notify_email_operator_name=@notifyOperator

/* Check if the job step exists and create if it doesn't */
SELECT @StepID = @StepID + 1;

SET @StepName = 'Applog table cleanup' -- Can be poetic - can be EXEC dbo.StoreProcedure 
IF NOT EXISTS (SELECT *
               FROM   sysjobsteps jb
                      INNER JOIN sysjobs j
                              ON j.job_id = jb.job_id
               WHERE  j.name = @JobName
                      AND jb.step_name = @StepName)
  BEGIN
      EXEC msdb.dbo.Sp_add_jobstep
        @job_name= @JobName,
        @step_name= @StepName;
  END;

/* Update the job step */
EXEC msdb.dbo.Sp_update_jobstep
  @job_name= @JobName,
  @step_name= @StepName,
  @step_id=@StepID,
  @cmdexec_success_code=0,
  @on_success_action=1,-- 3=go to next step, 1=quit with succes
  @on_success_step_id=0,
  @on_fail_action=2,
  @on_fail_step_id=0,
  @retry_attempts=0,
  @retry_interval=0,
  @os_run_priority=0,
  @subsystem=N'TSQL',
  @command=N'EXEC [archive].[PurgeTable]',
  @database_name=N'AppLog',
  @flags=0;

/* Set Start Step */
EXEC msdb.dbo.Sp_update_job
  @job_name= @JobName,
  @start_step_id = @StartStep

/* Check if the job schedule exists and create if it doesn't */
IF NOT EXISTS(SELECT *
              FROM   sysjobschedules js
                     INNER JOIN sysjobs j
                             ON js.job_id = j.job_id
                     INNER JOIN sysschedules s
                             ON js.schedule_id = s.schedule_id
              WHERE  j.name = @JobName
                     AND s.name = @ScheduleName)
  BEGIN
      EXEC msdb.dbo.Sp_add_jobschedule
        @job_name = @JobName,
        @name=@ScheduleName;
  END;

/* Update the job schedule */
EXEC msdb.dbo.Sp_update_jobschedule
  @job_name = @JobName,
  @name= @ScheduleName,
  @enabled= @EnableNewJobs,
  @freq_type=4,-- 4 = daily
  @freq_interval=1,
  @freq_subday_type=1,
  @freq_subday_interval=0,
  @freq_relative_interval=0,
  @freq_recurrence_factor=0,
  @active_start_date=20190227,
  @active_end_date=99991231,
  @active_start_time=12000,
  @active_end_time=235959

/* Detach any existing "wrong" schedules */
WHILE EXISTS (SELECT *
              FROM   msdb.dbo.sysjobschedules
              WHERE  job_id = (SELECT job_id
                               FROM   msdb.dbo.sysjobs
                               WHERE  Name = @JobName)
                     AND Schedule_id <> (SELECT Schedule_id
                                         FROM   msdb.dbo.sysschedules
                                         WHERE  Name = @ScheduleName))
  BEGIN
      SELECT TOP 1 @ScheduleID = Schedule_ID
      FROM   msdb.dbo.sysjobschedules
      WHERE  job_id = (SELECT job_id
                       FROM   msdb.dbo.sysjobs
                       WHERE  Name = @JobName)
             AND Schedule_id <> (SELECT Schedule_id
                                 FROM   msdb.dbo.sysschedules
                                 WHERE  Name = @ScheduleName);

      EXEC msdb.dbo.Sp_detach_schedule
        @job_name = @JobName,
        @schedule_id = @ScheduleID,
        @delete_unused_schedule = 1;
  END;

/* Add job to target local server if it is not already */
IF ( NOT EXISTS (SELECT *
                 FROM   msdb.dbo.sysjobservers js
                        JOIN msdb..sysjobs j
                          ON js.job_id = j.job_id
                 WHERE  name = @JobName) )
  BEGIN
      EXEC msdb.dbo.Sp_add_jobserver
        @job_name = @JobName,
        @server_name = N'(local)';
  END; 

