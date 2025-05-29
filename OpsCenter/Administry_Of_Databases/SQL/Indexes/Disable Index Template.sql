USE DATABASENAME 

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.nameoftable') AND name = N'nameofindex')
BEGIN 
		ALTER INDEX [nameofindex] ON [dbo].[nameoftable] DISABLE
		PRINT 'SUCCESS: [nameofindex] ON [dbo].[nameoftable] successfully disabled'
END 
	ELSE
BEGIN
		PRINT 'WARNING: [nameofindex] ON [dbo].[nameoftable] does not exist can you please check your settings'
END

