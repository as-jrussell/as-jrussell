USE [Applog]

GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

/* Creat table if it does not exist */
IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[Applog_New]')
                      AND type IN ( N'U' ))
  BEGIN
      CREATE TABLE [dbo].[Applog_New]
        (
           [ID]                  [BIGINT] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
           [GUID]                [UNIQUEIDENTIFIER] NULL,
           [Service_User_Name]   [NVARCHAR](50) NOT NULL,
           [Service_Source_Code] [NVARCHAR](50) NOT NULL,
           [Service_Name]        [NVARCHAR](50) NOT NULL,
           [Service_Method]      [NVARCHAR](50) NOT NULL,
           [Client_ID_Number]    [INT] NOT NULL,
           [VUT_Lender_ID]       [NVARCHAR](50) NOT NULL,
           [Started]             [DATETIME] NOT NULL,
           [Finished]            [DATETIME] NOT NULL,
           [Created]             [DATETIME] NOT NULL,
           [Modified]            [DATETIME] NOT NULL,
           [UserID]              [NVARCHAR](50) NOT NULL,
           [CurrentUser]         [NVARCHAR](50) NULL,
           [Input]               [NVARCHAR](max) NULL,
           [Output]              [NVARCHAR](max) NULL,
           [Comment1]            [NVARCHAR](max) NULL,
           [Comment2]            [NVARCHAR](max) NULL,
           [Comment3]            [NVARCHAR](max) NULL
           PRIMARY KEY CLUSTERED(ID) WITH( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
        )
      ON [PRIMARY]
  END

/* ADD columns that changed after initial deploy */
IF NOT EXISTS(SELECT *
              FROM   sys.default_constraints
              WHERE  Object_name(parent_object_id) = 'Applog_NEW'
                     AND definition = '(newid())')
  BEGIN
      ALTER TABLE [dbo].[Applog_New]
        ADD DEFAULT (Newid()) FOR [GUID]
  END;

---Index 2 (Non Clustered Index 1)
IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.Applog_New')
                      AND name = N'IX_Applog_Modified')
  BEGIN
      BEGIN TRY
          CREATE NONCLUSTERED INDEX [IX_Applog_Modified]
            ON [dbo].[Applog_New] ( [Modified] ASC )
            INCLUDE([GUID], [Service_User_Name], [Service_Source_Code], [Service_Name], [Service_Method], [Client_ID_Number], [VUT_Lender_ID], [Started], [Finished], [Created], [UserID], [CurrentUser], [Input], [Output], [Comment1], [Comment2], [Comment3]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: [IX_Applog_Modified] ON [dbo].[Applog_New] was not added either not in the correct database or index itself failed.'
          RETURN
      END CATCH

      PRINT 'SUCCESS: [IX_Applog_GUID] ON [dbo].[AppLog] successfully added'
  END
ELSE
  BEGIN
      PRINT 'WARNING: [IX_Applog_Modified] ON [dbo].[Applog_New] was not added either table does not exist or index already exists'
  END

---Index 3 (Non Clustered Index 2)
IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.Applog_New')
                      AND name = N'IX_Applog_Created')
  BEGIN
      BEGIN TRY
          CREATE NONCLUSTERED INDEX [IX_Applog_Created]
            ON [dbo].[Applog_New] ( [Created], [Service_Name] ASC )
            WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
      END TRY
      BEGIN CATCH
          PRINT 'WARNING: [IX_Applog_Created] ON [dbo].[Applog_New] was not added either not in the correct database or index itself failed.'
          RETURN
      END CATCH

      PRINT 'SUCCESS: [IX_Applog_GUID] ON [dbo].[AppLog] successfully added'
  END
ELSE
  BEGIN
      PRINT 'WARNING: [IX_Applog_Created] ON [dbo].[Applog_New] was not added either table does not exist or index already exists'
  END 
