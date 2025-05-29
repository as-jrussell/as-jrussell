USE [AppLog]

IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.AppLog')
                      AND name = N'IX_Applog_GUID')
BEGIN
    BEGIN TRY  
     	  CREATE UNIQUE CLUSTERED INDEX [IX_Applog_GUID]
        ON [dbo].[AppLog] ( [GUID] ASC )
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
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
  

