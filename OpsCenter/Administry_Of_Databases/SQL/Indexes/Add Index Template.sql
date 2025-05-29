USE DATABASENAME 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.nameoftable') AND name = N'nameofindex')
BEGIN
    BEGIN TRY   
		CREATE NONCLUSTERED INDEX [nameofindex] ON [dbo].[nameoftable] ([columns])
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		  END TRY  
    BEGIN CATCH  
		PRINT 'WARNING: [nameofindex] ON [dbo].[nameoftable] was not added either not in the correct database or index itself failed.'
   RETURN
    END CATCH  

PRINT 'SUCCESS:  [nameofindex] ON [dbo].[nameoftable] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [nameofindex] ON [dbo].[nameoftable] was not added either table does not exist or index already exists'
END



