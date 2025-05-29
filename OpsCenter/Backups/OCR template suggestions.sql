USE DATABASENAME 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.BatchCatalog') AND name = N'IX_BatchCatalog_ClassName_BatchType')
BEGIN 
		CREATE INDEX [IX_BatchCatalog_ClassName_BatchType] ON [ACSYSTEM].[dbo].[BatchCatalog] ([ClassName], [BatchType]) INCLUDE ([ExternalBatchID], [BatchName], [BatchDefID], [ProcessID], [State], [Priority], [CreationDate], [StationID], [ContainsErrors], [InProgressState], [InProgressString], [BatchGUID], [CreationTimeZone], [CreationSiteGUID], [CreationSiteName], [CreationSiteTZName], [ReceivedDate], [ReceivedTimeZone], [ReceivedSiteGUID], [ReceivedSiteName], [ReceivedSiteTZName], [ValProfileKey], [ProbablyInUse], [ActualPages], [ActualDocs], [InternalFlags], [Description], [OldState], [LockID], [NextSiteGUID], [NextSiteName], [ScanStationID], [ScanUserID], [Reserved01], [DequeueTime], [BatchReferenceID], [LockUserID])
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


		PRINT 'SUCCESS: [IX_BatchCatalog_ClassName_BatchType] ON [dbo].[BatchCatalog] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_BatchCatalog_ClassName_BatchType] ON [dbo].[BatchCatalog] was not added'
END



IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.Processes') AND name = N'IX_Processes_PublishedBatchDefID')
BEGIN 
		CREATE INDEX [IX_Processes_PublishedBatchDefID] ON [ACSYSTEM].[dbo].[Processes] ([PublishedBatchDefID])
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		PRINT 'SUCCESS: [IX_Processes_PublishedBatchDefID] ON [dbo].[Processes] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_Processes_PublishedBatchDefID] ON [dbo].[Processes] was not added'
END




IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.BatchField') AND name = N'IX_BatchField_BatchID_DocID')
BEGIN 
		CREATE INDEX [IX_BatchField_BatchID_DocID] ON [ACSYSTEM].[dbo].[BatchField] ([BatchID],[DocID]) INCLUDE ([BatchFieldID], [IndexFieldID], [FolderID], [TableID], [TablesRowID], [Value], [PageNumber], [ConfidenceVal], [RectTop], [RecogType], [RectLeft], [RectWidth], [RectHeight], [RowNumber], [AutoIndexed], [MarkedValue], [Valid])
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		PRINT 'SUCCESS: [IX_BatchField_BatchID_DocID] ON [dbo].[BatchField] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_BatchField_BatchID_DocID] ON [dbo].[BatchField] was not added'
END




IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.User_Group') AND name = N'IX_User_Group_GroupProfilePrimaryKey')
BEGIN 
		CREATE INDEX [IX_User_Group_GroupProfilePrimaryKey] ON [dbo].[User_Group] ([GroupProfilePrimaryKey] ASC ) INCLUDE([UserProfilePrimaryKey]) 
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		PRINT 'SUCCESS: [IX_User_Group_GroupProfilePrimaryKey] ON [dbo].[User_Group] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_User_Group_GroupProfilePrimaryKey] ON [dbo].[User_Group] was not added'
END
