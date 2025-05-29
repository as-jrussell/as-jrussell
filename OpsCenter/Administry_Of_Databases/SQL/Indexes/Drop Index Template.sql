USE DATABASENAME 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.nameoftable') AND name = N'nameofindex')
BEGIN 
		DROP INDEX [nameofindex] ON [dbo].[nameoftable]
		PRINT 'SUCCESS: [nameofindex] ON [dbo].[nameoftable] successfully dropped'
END 
	ELSE
BEGIN
		PRINT 'WARNING: [nameofindex] ON [dbo].[nameoftable] does not exist can you please check your settings'
END

