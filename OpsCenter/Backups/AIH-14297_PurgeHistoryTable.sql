
Use AppLog

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
