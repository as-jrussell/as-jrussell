use OCR		

IF NOT EXISTS (SELECT  1 FROM OCR.sys.indexes  -- Someday this will be the standard 
               WHERE name ='IX_OutputImages_Status' and OBJECT_NAME(object_id) = 'OutputImages')
BEGIN 
	CREATE INDEX [IX_OutputImages_Status] ON [OCR].[dbo].[OutputImages] ([Status]) INCLUDE ([ImportID], [BatchID], [LenderID], [LenderName], [ContractType], [AlliedDocID], [DocumentPath], [BatchDate], [ScanOperator], [ValidationOperator], [ImportTime], [ExportTime], [ManualValidation], [TransactionType], [MailDate], [Insured_LastName], [Insured_FirstName], [Insured_LastName2], [Insured_FirstName2], [Insured_DBAName], [Insured_Addr], [Insured_Zip], [InsCoName], [BIC_ID], [InsCoAddr1], [InsCoAddr2], [InsCoCity], [InsCoState], [InsCoZip], [AgencyCompanyName], [AgencyID], [AgencyPhone], [AgencyFax], [AgencyEmail], [PolicyNumber], [EffectiveDate], [ExpirationDate], [CancellationDate], [CancellationReason], [flg_IsApplication], [flg_LienholderNameErr], [flg_LienholderAddrErr], [LoanNumber], [flg_LiabilityCard], [Veh_Year], [Veh_Make], [Veh_Model], [VIN], [veh_CompDeductibleAmt], [flg_ComprehensiveCoverage], [veh_CollDeductibleAmt], [flg_CollisionCoverage], [veh_CSL], [veh_BIP], [veh_BIO], [veh_PDO], [flg_ExcessLiability], [flg_LessorErr], [Prop_Addr], [Prop_Zip], [haz_ADwellCoverageAmt], [haz_ADeductibleAmt], [haz_ADeductiblePct], [flg_HazardCoverage], [flood_ADwellCoverageAmt], [flood_ADeductibleAmt], [flood_ADeductiblePct], [flg_FloodCoverage], [flood_zone], [flood_grandfathered], [haz_WindExcluded], [wind_ADwellCoverageAmt], [wind_ADeductibleAmt], [wind_ADeductiblePct], [flg_WindCoverage], [quake_ADwellCoverageAmt], [quake_ADeductibleAmt], [quake_ADeductiblePct], [flg_EarthquakeCoverage], [hurricane_ADwellCoverageAmt], [hurricane_ADeductibleAmt], [hurricane_ADeductiblePct], [flg_HurricaneCoverage], [StatedInsValue], [CoverageBasis], [ExtCvgAmtFixed], [ExtCvgAmtPct], [bill_RemittanceID], [bill_PremiumDue], [bill_SupplementalBilled], [bill_TotalPremium], [bill_DueDate], [condo_flg_CondoAssocPolicy], [condo_AssocName], [condo_Units], [condo_WallsInCoverage], [condo_flg_OwnersPolicy], [flg_FloodNFIP], [flg_FloodCertPrivate])
	PRINT 'IX_OutputImages_Status has been created Successfully'
END
ELSE 
BEGIN 
	PRINT 'WARNING: IX_OutputImages_Status Index on OutputImages failed'
END 



IF EXISTS (SELECT  1 FROM OCR.sys.indexes  -- Someday this will be the standard 
               WHERE name ='IX_ImportId_Status' and OBJECT_NAME(object_id) = 'ReRoutedImages')
BEGIN 

	CREATE CLUSTERED INDEX [IX_ImportId_Status] ON [dbo].[ReRoutedImages]
	(
		[ImportID] ASC,
		[Status] ASC,
		[ImportTime] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		PRINT 'IX_ImportId_Status has been created Successfully'
END 
ELSE 
BEGIN 
	PRINT 'WARNING: IX_ImportId_Status Index on ReRoutedImages failed'
END 



/*
USE [OCR]
GO

DROP INDEX [IX_ImportId_Status] ON [dbo].[ReRoutedImages]
DROP INDEX [IX_OutputImages_Status] ON [OCR].[dbo].[OutputImages]

IF NOT EXISTS (SELECT  1 FROM OCR.sys.indexes  -- Someday this will be the standard 
               WHERE name ='IX_ImportId_Status' and OBJECT_NAME(object_id) = 'ReRoutedImages')
BEGIN 

		CREATE CLUSTERED INDEX IX_ImportId_Status ON dbo.ReRoutedImages (ImportID)

END 

ELSE 

BEGIN 
		PRINT 'IX_ImportId_Status has been already created please check the Indexes on dbo.ReRoutedImages'

END


*/
