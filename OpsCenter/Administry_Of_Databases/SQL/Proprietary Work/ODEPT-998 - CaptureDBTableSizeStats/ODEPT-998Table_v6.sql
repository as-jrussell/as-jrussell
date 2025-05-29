USE [Perfstats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Create table if it does not exist */
IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'dbo.TableSizeStats')
                      AND type IN ( N'U' ))
  BEGIN
      CREATE TABLE perfstats.TableSizeStats
        (
           [DatabaseName]           SYSNAME,
           [TableName]              VARCHAR(128),
           [SchemaName]             VARCHAR(100),
           [RowCounts]              BIGINT,
           [TotalSpaceGB]           bigint,
           [UsedSpaceGB]            bigint,
           [PreviousDayUsedSpaceGB] bigint,
           [AmountGrown]            bigint,
           [HarvestDate]            DATE,
		   [ID]                  [BIGINT] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL
           PRIMARY KEY CLUSTERED ( [ID] ASC) WITH( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
        )
      ON [PRIMARY]
  END 



 

