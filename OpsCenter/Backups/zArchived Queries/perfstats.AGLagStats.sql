USE [PerfStats]

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Creat table if it does not exist */
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'AGLagStats'
                      AND type = 'U')
  BEGIN
      CREATE TABLE [perfstats].[AGLagStats]
        (
           [ID]                             [BIGINT] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
           [Lag in Seconds]                 INT,
           [AG Group_Name]                NVARCHAR(400),
           [DatabaseName_secondary_replica] NVARCHAR(400),
           [Logged Time]                    DATETIME
           PRIMARY KEY CLUSTERED(ID) WITH( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
        )
      ON [PRIMARY]
  END 


