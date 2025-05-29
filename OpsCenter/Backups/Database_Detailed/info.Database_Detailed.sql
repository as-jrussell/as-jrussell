USE [DBA]

GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Creat table if it does not exist */
IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[info].[Database_Detailed]')
                      AND type IN ( N'U' ))
  BEGIN
      CREATE TABLE [info].[Database_Detailed]
        (
           [ID]                       [SMALLINT] IDENTITY(1, 1) NOT NULL,
           [DatabaseName]             NVARCHAR(250) NOT NULL,
           [Logical_Name]             VARCHAR(250) NOT NULL,
           [File_Path]                VARCHAR(250) NOT NULL,
           [TYPE]                     NVARCHAR(10) NOT NULL,
           [FileGrowth]               NVARCHAR(1000) NOT NULL,
           [Growth Enabled/Disabled]  VARCHAR(100) NOT NULL,
           [MAX Growth MB] VARCHAR(100) NOT NULL,
           [CurrentSizeMB]            VARCHAR(15) NOT NULL,
           [SpaceUsedMB]              VARCHAR(15) NOT NULL,
           [FreeSpaceMB]              VARCHAR(15) NOT NULL,
           [Free Space %]             INT,
           [Create_Date]              DATETIME NOT NULL,
           CONSTRAINT [ID] PRIMARY KEY CLUSTERED ( ID ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
      ON [PRIMARY]
  END; 
