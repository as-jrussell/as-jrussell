
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.APP_LOG') AND name = N'IX_APP_LOG_TimeStamp')
BEGIN 
		CREATE INDEX [IX_APP_LOG_TimeStamp] ON [PRL_ALLIEDSYS_DEV].[dbo].[APP_LOG] ([TimeStamp]) 
		INCLUDE ([Priority])
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


		PRINT 'SUCCESS: [IX_APP_LOG_TimeStamp] ON [dbo].[APP_LOG] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_APP_LOG_TimeStamp] ON [dbo].[APP_LOG] was not added'
END