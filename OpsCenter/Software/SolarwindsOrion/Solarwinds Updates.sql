USE [SolarwindsOrion]

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.Cortex_Documents') AND name = N'IX_Cortex_Documents_DeletedDate')
BEGIN 
		CREATE NONCLUSTERED INDEX [IX_Cortex_Documents_DeletedDate] ON [dbo].[Cortex_Documents]([DeletedDate] ASC)
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		PRINT 'SUCCESS: [IX_Cortex_Documents_DeletedDate] ON [dbo].[Cortex_Documents] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_Cortex_Documents_DeletedDate] ON [dbo].[Cortex_Documents] was not added'
END











