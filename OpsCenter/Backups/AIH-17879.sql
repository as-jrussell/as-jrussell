USE [SysLog]

GO



/****** Object:  Table [dbo].[SysLog]    Script Date: 12/16/2022 9:45:57 AM ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[Syslog_New]')
                      AND type IN ( N'U' ))
  BEGIN
      CREATE TABLE [dbo].[Syslog_New]
        (
           [ID]       [BIGINT] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
           [Type]     [NVARCHAR](100) NULL,
           [Time]     [DATETIME] NULL,
           [System]   [NVARCHAR](100) NULL,
           [Source]   [NVARCHAR](100) NULL,
           [Message]  [NVARCHAR](max) NULL,
           [Subject]  [NVARCHAR](100) NULL,
           [GUID]     [UNIQUEIDENTIFIER] NULL,
           [User]     [NVARCHAR](100) NULL,
           [PRI]      [NVARCHAR](10) NULL,
           [VERSION]  [INT] NULL,
           [HOSTNAME] [NVARCHAR](max) NULL,
           [APPNAME]  [NVARCHAR](max) NULL,
           [PROCID]   [INT] NULL,
           [MSGID]    [NVARCHAR](50) NULL,
           [MSG]      [NVARCHAR](max) NULL,
           [MSGTIME]  [DATETIMEOFFSET](7) NULL
           PRIMARY KEY CLUSTERED(ID) WITH( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
        )
      ON [PRIMARY]
      TEXTIMAGE_ON [PRIMARY]
  END

IF NOT EXISTS(SELECT Object_name(parent_object_id),
                     definition,
                     *
              FROM   sys.default_constraints
              WHERE  Object_name(parent_object_id) = 'Syslog_New'
                     AND definition = '(getutcdate())')
  BEGIN
      ALTER TABLE [dbo].[Syslog]
        DROP CONSTRAINT [DF_SysLog_Time]

      ALTER TABLE [dbo].[Syslog_New]
        ADD CONSTRAINT [DF_SysLog_Time] DEFAULT (Getutcdate()) FOR [Time]
  END;

IF NOT EXISTS(SELECT Object_name(parent_object_id),
                     definition,
                     *
              FROM   sys.default_constraints
              WHERE  Object_name(parent_object_id) = 'Syslog_New'
                     AND definition = '(newid())')
  BEGIN
      ALTER TABLE [dbo].[Syslog]
        DROP CONSTRAINT [DF_SysLog_GUID]

      ALTER TABLE [dbo].[Syslog_New]
        ADD CONSTRAINT [DF_SysLog_GUID] DEFAULT (Newid()) FOR [GUID]

      PRINT 'SUCCESS: Dropped old constraints from previous table and added onto new table!!'
  END;

---Index 2 (Non Clustered Index 1)
IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.Syslog_New')
                      AND name = N'IDX_SYSLOG_MSGTIME')
  BEGIN
      BEGIN TRY
          CREATE NONCLUSTERED INDEX [IDX_SYSLOG_MSGTIME]
            ON [dbo].[SysLog_New] ( [MSGTIME] ASC )
            WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: [IDX_SYSLOG_MSGTIME] ON [dbo].[Syslog_New] was not added either not in the correct database or index itself failed.'
          RETURN
      END CATCH

      PRINT 'SUCCESS: [IDX_SYSLOG_MSGTIME] ON [dbo].[Syslog_New] successfully added'
  END
ELSE
  BEGIN
      PRINT 'WARNING: [IDX_SYSLOG_MSGTIME] ON [dbo].[Syslog_New] was not added either table does not exist or index already exists'
  END

---Index 3 (Non Clustered Index 2)
IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.Syslog_New')
                      AND name = N'IDX_SYSLOG_TIME')
  BEGIN
      BEGIN TRY
          CREATE NONCLUSTERED INDEX [IDX_SYSLOG_TIME]
            ON [dbo].[Syslog_New] ( [Time] ASC )
            WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: [IDX_SYSLOG_TIME] ON [dbo].[Syslog_New] was not added either not in the correct database or index itself failed.'
          RETURN
      END CATCH

      PRINT 'SUCCESS: [IDX_SYSLOG_TIME] ON [dbo].[Syslog_New] successfully added'
  END
ELSE
  BEGIN
      PRINT 'WARNING: [IDX_SYSLOG_TIME] ON [dbo].[Syslog_New] was not added either table does not exist or index already exists'
  END

---Index 4 (Non Clustered Index 3)  
IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.Syslog_New')
                      AND name = N'IDX_SYSLOG_PROCID_USER')
  BEGIN
      BEGIN TRY
          CREATE NONCLUSTERED INDEX [IDX_SYSLOG_PROCID_USER]
            ON [dbo].[SysLog_New] ( [PROCID] ASC, [User] ASC )
            WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: [IDX_SYSLOG_PROCID_USER] ON [dbo].[Syslog_New] was not added either not in the correct database or index itself failed.'
          RETURN
      END CATCH

      PRINT 'SUCCESS: [IDX_SYSLOG_PROCID_USER] ON [dbo].[Syslog_New] successfully added'
  END
ELSE
  BEGIN
      PRINT 'WARNING: [IDX_SYSLOG_PROCID_USER] ON [dbo].[Syslog_New] was not added either table does not exist or index already exists'
  END

---Table Rename Old 
IF EXISTS (SELECT 1
           FROM   sys.tables
           WHERE  name = 'Syslog')
  BEGIN
      BEGIN TRY
          EXEC Sp_rename
            'dbo.Syslog',
            'Syslog_old';
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: Table was not renamed either not in the correct database or name convention itself failed.'
          RETURN
      END CATCH

      PRINT 'SUCCESS: Table Renamed '
  END
ELSE
  BEGIN
      PRINT 'WARNING: Table was not added either table does not exist or table name already exists'
  END

---Table Rename the blank it's spot 
IF EXISTS (SELECT 1
           FROM   sys.tables
           WHERE  name = 'Syslog_New')
  BEGIN
      BEGIN TRY
          EXEC Sp_rename
            'dbo.Syslog_New',
            'Syslog';
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: Table was not renamed either not in the correct database or name convention itself failed.'
          RETURN
      END CATCH

      PRINT 'SUCCESS: Table Renamed '
  END
ELSE
  BEGIN
      PRINT 'WARNING: Table was not added either table does not exist or table name already exists'
  END

---Clean up Work 
IF EXISTS (SELECT 1
           FROM   sys.tables
           WHERE  name = 'Syslog_9122018')
  BEGIN
      DROP TABLE [Syslog_9122018]

      PRINT 'SUCCESS: Table Dropped!!!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: Table name does not exist!'
  END

---Clean up Work 
IF EXISTS (SELECT 1
           FROM   sys.tables
           WHERE  name = 'SysLog_bak4272018')
  BEGIN
      DROP TABLE [SysLog_bak4272018]

      PRINT 'SUCCESS: Table Dropped!!!'
  END
ELSE
  BEGIN
      PRINT 'WARNING: Table name does not exist!'
  END 
