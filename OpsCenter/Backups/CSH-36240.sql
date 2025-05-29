USE OCR 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.OutputImages') AND name = N'IDX_OutputImageInsert')
BEGIN 
		CREATE NONCLUSTERED INDEX [IDX_OutputImageInsert] ON [dbo].[OutputImages] (ContractType	ASC,
 LenderID	ASC,
 LenderName	ASC,
 BatchID	ASC,
 AlliedDocID	ASC,
 BatchDate	ASC,
 ScanOperator	ASC,
 DocumentPath	ASC,
 EffectiveDate	ASC,
 MailDate	ASC,
 VIN ASC,
[Status]	ASC,
 ExportTime ASC)
 INCLUDE (   AgencyPhone, flg_IsApplication, ImportID,  ImportTime	, InsCoName	, Insured_FirstName	, Insured_LastName	, ManualValidation	, PolicyNumber	, TransactionType	, flg_CollisionCoverage	, flg_ComprehensiveCoverage	, flg_LessorErr	, flg_LienholderAddrErr	, flg_LienholderNameErr	, veh_CollDeductibleAmt	, veh_CompDeductibleAmt	,  Veh_Make	, Veh_Model	, Veh_Year	,ValidationOperator, flg_LiabilityCard)		
 WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


		PRINT 'SUCCESS: [IDX_OutputImageInsert] ON [dbo].[OutputImages] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IDX_OutputImageInsert] ON [dbo].[OutputImages] was not added'
END



IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ReRoutedImages') AND name = N'IDX_ReRoutedImages_ImportID')
BEGIN 

CREATE NONCLUSTERED INDEX [IDX_ReRoutedImages_ImportID]
ON [dbo].[ReRoutedImages] ([ImportID])
 WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


		PRINT 'SUCCESS: [IDX_ReRoutedImages_ImportID] ON [dbo].[ReRoutedImages] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IDX_ReRoutedImages_ImportID] ON [dbo].[ReRoutedImages] was not added'
END
