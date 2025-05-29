
USE [master]


IF EXISTS (SELECT 1
           FROM   sys.master_files
           WHERE  name = 'Applog' AND growth/128 = 1)
BEGIN
			ALTER DATABASE [AppLog] MODIFY FILE ( NAME = N'AppLog', FILEGROWTH = 1GB )
			PRINT 'SUCCESS: FileGrowth increased to 1 GB'
END
	ELSE
BEGIN
			PRINT 'WARNING: FileGrowth was not altered please check your settings'
END




USE [AppLog]

IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.AppLog')
                      AND name = N'IX_Applog_GUID')
BEGIN
    BEGIN TRY  
     	  CREATE UNIQUE CLUSTERED INDEX [IX_Applog_GUID]
        ON [dbo].[AppLog] ( [GUID] ASC )
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    END TRY  
    BEGIN CATCH  
        PRINT 'WARNING: [IX_Applog_GUID] ON [dbo].[AppLog] was not added'
        RETURN
    END CATCH  

PRINT 'SUCCESS: [IX_Applog_GUID] ON [dbo].[AppLog] successfully added'
END
ELSE 
BEGIN 

  PRINT 'WARNING: [IX_Applog_GUID] ON [dbo].[AppLog] already exists or otherwise cannot be added'
  END 

--20 minutes DEV
--72 minutes QA
--21:16.388 minutes STG
  


  USE [AppLog]

IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.AppLog')
                      AND name = N'IX_Applog_Service_Name')
BEGIN
    BEGIN TRY  
     	       CREATE NONCLUSTERED INDEX [IX_Applog_Service_Name]
        ON [dbo].[AppLog] ( [Service_Name] ASC )
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    END TRY  
    BEGIN CATCH  
        PRINT 'WARNING: [IX_Applog_Service_Name] ON [dbo].[AppLog] was not added'
        RETURN
    END CATCH  

PRINT 'SUCCESS: [IX_Applog_Service_Name] ON [dbo].[AppLog] successfully added'
END
ELSE 
BEGIN 

  PRINT 'WARNING: [IX_Applog_Service_Name] ON [dbo].[AppLog] already exists or otherwise cannot be added'
  END 

--10 minutes DEV
--5 minutes QA
--00:02:40.544 STG
USE [AppLog]
GO
ALTER INDEX [IDX_AppLog_Created] ON [dbo].[AppLog] DISABLE
GO
