USE RepoPlusAnalytics 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.IsoClaimData') AND name = N'idx_IsoClaimData_Modified')
BEGIN
    BEGIN TRY   
		CREATE INDEX idx_IsoClaimData_Modified ON IsoClaimData (Modified)
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		  END TRY  
    BEGIN CATCH  
		PRINT 'WARNING: [idx_IsoClaimData_Modified] ON [dbo].[IsoClaimData] was not added either not in the correct database or index itself failed.'
   RETURN
    END CATCH  

PRINT 'SUCCESS:  [idx_IsoClaimData_Modified] ON [dbo].[IsoClaimData] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [idx_IsoClaimData_Modified] ON [dbo].[IsoClaimData] was not added either table does not exist or index already exists'
END



USE RepoPlusAnalytics 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.IsoClaimData') AND name = N'idx_IsoClaimData_ClaimNumber')
BEGIN
    BEGIN TRY   
		CREATE INDEX idx_IsoClaimData_ClaimNumber ON IsoClaimData (Modified)
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		  END TRY  
    BEGIN CATCH  
		PRINT 'WARNING: [idx_IsoClaimData_ClaimNumber] ON [dbo].[IsoClaimData] was not added either not in the correct database or index itself failed.'
   RETURN
    END CATCH  

PRINT 'SUCCESS:  [idx_IsoClaimData_ClaimNumber] ON [dbo].[IsoClaimData] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [idx_IsoClaimData_ClaimNumber] ON [dbo].[IsoClaimData] was not added either table does not exist or index already exists'
END



