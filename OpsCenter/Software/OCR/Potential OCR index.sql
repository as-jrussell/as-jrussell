use OCR

exec OCR.dbo.GetPendingOCRBatches
SELECT *  
FROM ReRoutedImages  
WHERE [Status] = 'PEND'  
ORDER BY ImportID ASC
--00:00:17.787 without any new index 
--00:00:00.810 with this IX_OutputBatches_Status
--00:00:15.294 with IX_OutputImages_BatchID with BatchID as primary
--00:00:00.810 with this IX_OutputImages_Status with Status as primary

/*
USE [OCR]
GO
--CREATE NONCLUSTERED INDEX [IX_OutputBatches_Status] ON [dbo].[OutputImages] ([Status]) INCLUDE ([BatchID],[EffectiveDate])
--00:00:49.604

--CREATE INDEX [IX_OutputImages_BatchID] ON [OCR].[dbo].[OutputImages] ([BatchID]) INCLUDE ([ImportID], [Status], [LenderID], [LenderName], [ContractType], [AlliedDocID], [DocumentPath], [BatchDate], [ScanOperator], [ValidationOperator], [ImportTime], [ExportTime], [ManualValidation], [TransactionType], [MailDate], [Insured_LastName], [Insured_FirstName], [Insured_LastName2], [Insured_FirstName2], [Insured_DBAName], [Insured_Addr], [Insured_Zip], [InsCoName], [BIC_ID], [InsCoAddr1], [InsCoAddr2], [InsCoCity], [InsCoState], [InsCoZip], [AgencyCompanyName], [AgencyID], [AgencyPhone], [AgencyFax], [AgencyEmail], [PolicyNumber], [EffectiveDate], [ExpirationDate], [CancellationDate], [CancellationReason], [flg_IsApplication], [flg_LienholderNameErr], [flg_LienholderAddrErr], [LoanNumber], [flg_LiabilityCard], [Veh_Year], [Veh_Make], [Veh_Model], [VIN], [veh_CompDeductibleAmt], [flg_ComprehensiveCoverage], [veh_CollDeductibleAmt], [flg_CollisionCoverage], [veh_CSL], [veh_BIP], [veh_BIO], [veh_PDO], [flg_ExcessLiability], [flg_LessorErr], [Prop_Addr], [Prop_Zip], [haz_ADwellCoverageAmt], [haz_ADeductibleAmt], [haz_ADeductiblePct], [flg_HazardCoverage], [flood_ADwellCoverageAmt], [flood_ADeductibleAmt], [flood_ADeductiblePct], [flg_FloodCoverage], [flood_zone], [flood_grandfathered], [haz_WindExcluded], [wind_ADwellCoverageAmt], [wind_ADeductibleAmt], [wind_ADeductiblePct], [flg_WindCoverage], [quake_ADwellCoverageAmt], [quake_ADeductibleAmt], [quake_ADeductiblePct], [flg_EarthquakeCoverage], [hurricane_ADwellCoverageAmt], [hurricane_ADeductibleAmt], [hurricane_ADeductiblePct], [flg_HurricaneCoverage], [StatedInsValue], [CoverageBasis], [ExtCvgAmtFixed], [ExtCvgAmtPct], [bill_RemittanceID], [bill_PremiumDue], [bill_SupplementalBilled], [bill_TotalPremium], [bill_DueDate], [condo_flg_CondoAssocPolicy], [condo_AssocName], [condo_Units], [condo_WallsInCoverage], [condo_flg_OwnersPolicy], [flg_FloodNFIP], [flg_FloodCertPrivate])
--00:14:22.537

--CREATE INDEX [IX_OutputImages_Status] ON [OCR].[dbo].[OutputImages] ([Status]) INCLUDE ([ImportID], [BatchID], [LenderID], [LenderName], [ContractType], [AlliedDocID], [DocumentPath], [BatchDate], [ScanOperator], [ValidationOperator], [ImportTime], [ExportTime], [ManualValidation], [TransactionType], [MailDate], [Insured_LastName], [Insured_FirstName], [Insured_LastName2], [Insured_FirstName2], [Insured_DBAName], [Insured_Addr], [Insured_Zip], [InsCoName], [BIC_ID], [InsCoAddr1], [InsCoAddr2], [InsCoCity], [InsCoState], [InsCoZip], [AgencyCompanyName], [AgencyID], [AgencyPhone], [AgencyFax], [AgencyEmail], [PolicyNumber], [EffectiveDate], [ExpirationDate], [CancellationDate], [CancellationReason], [flg_IsApplication], [flg_LienholderNameErr], [flg_LienholderAddrErr], [LoanNumber], [flg_LiabilityCard], [Veh_Year], [Veh_Make], [Veh_Model], [VIN], [veh_CompDeductibleAmt], [flg_ComprehensiveCoverage], [veh_CollDeductibleAmt], [flg_CollisionCoverage], [veh_CSL], [veh_BIP], [veh_BIO], [veh_PDO], [flg_ExcessLiability], [flg_LessorErr], [Prop_Addr], [Prop_Zip], [haz_ADwellCoverageAmt], [haz_ADeductibleAmt], [haz_ADeductiblePct], [flg_HazardCoverage], [flood_ADwellCoverageAmt], [flood_ADeductibleAmt], [flood_ADeductiblePct], [flg_FloodCoverage], [flood_zone], [flood_grandfathered], [haz_WindExcluded], [wind_ADwellCoverageAmt], [wind_ADeductibleAmt], [wind_ADeductiblePct], [flg_WindCoverage], [quake_ADwellCoverageAmt], [quake_ADeductibleAmt], [quake_ADeductiblePct], [flg_EarthquakeCoverage], [hurricane_ADwellCoverageAmt], [hurricane_ADeductibleAmt], [hurricane_ADeductiblePct], [flg_HurricaneCoverage], [StatedInsValue], [CoverageBasis], [ExtCvgAmtFixed], [ExtCvgAmtPct], [bill_RemittanceID], [bill_PremiumDue], [bill_SupplementalBilled], [bill_TotalPremium], [bill_DueDate], [condo_flg_CondoAssocPolicy], [condo_AssocName], [condo_Units], [condo_WallsInCoverage], [condo_flg_OwnersPolicy], [flg_FloodNFIP], [flg_FloodCertPrivate])
--00:02:33.664

--CREATE CLUSTERED INDEX [IX_ImportId_Status] ON [dbo].[ReRoutedImages]
(
	[ImportID] ASC,
	[Status] ASC,
	[ImportTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO



DROP INDEX [IX_ImportId_Status] ON [dbo].[ReRoutedImages]
DROP INDEX [IX_OutputImages_Status] ON [OCR].[dbo].[OutputImages]

*/





