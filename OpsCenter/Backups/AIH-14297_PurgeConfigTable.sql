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