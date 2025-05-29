USE [Perfstats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Create table if it does not exist */
IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'dbo.CaptureDBTableSize')
                      AND type IN ( N'U' ))
  BEGIN
      CREATE TABLE dbo.CaptureDBTableSize
        (
           [DatabaseName]           SYSNAME,
           [TableName]              [VARCHAR](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
           [SchemaName]             VARCHAR(100),
           [RowCounts]              BIGINT,
           [TotalSpaceGB]           INT,
           [UsedSpaceGB]            INT,
           [UnusedSpaceGB]          INT,
           [PreviousDayUsedSpaceGB] INT,
           [AmountGrown]            INT,
           [HarvestDate]            DATE,
           PRIMARY KEY CLUSTERED ( [TableName] ASC) WITH( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
        )
      ON [PRIMARY]
  END 







