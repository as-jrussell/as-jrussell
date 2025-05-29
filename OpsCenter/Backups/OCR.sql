USE [OCR] 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ImportImages') AND name = N'IX_ImportImages_BatchID_Status')
BEGIN
    BEGIN TRY   
		CREATE INDEX [IX_ImportImages_BatchID_Status] ON [OCR].[dbo].[ImportImages] ([BatchID], [Status]) INCLUDE ([ImportID], [ContractType], [LenderID], [LenderName], [AlliedDocID], [DocImagePath], [BatchDate], [ScanUser], [Priority], [flg_SpecialAcct], [flg_PremiumDue], [flg_Fax], [ImportTime], [ErrDescription])
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		  END TRY  
    BEGIN CATCH  
		PRINT 'WARNING: [IX_ImportImages_BatchID_Status] ON [dbo].[ImportImages] was not added either not in the correct database or index itself failed.'
   RETURN
    END CATCH  

PRINT 'SUCCESS:  [IX_ImportImages_BatchID_Status] ON [dbo].[ImportImages] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_ImportImages_BatchID_Status] ON [dbo].[ImportImages] was not added either table does not exist or index already exists'
END



