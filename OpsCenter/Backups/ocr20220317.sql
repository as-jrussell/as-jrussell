/*
Missing Index Details from SQLQuery1.sql - OCR-SQLPRD-01.OCR (ELDREDGE_A\jrussell (100))
The Query Processor estimates that implementing the following index could improve the query cost by 45.1771%.
*/

/*
USE [OCR]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[ImportImages] ([BatchDate])
INCLUDE ([ContractType],[DocImagePath])


ImportID
ImportID, BatchID, Status
ImportID, ContractType, BatchID, BatchDate, Priority, flg_Fax, Status
GO
*/



/*
Missing Index Details from SQLQuery1.sql - OCR-SQLPRD-01.OCR (ELDREDGE_A\jrussell (100))
The Query Processor estimates that implementing the following index could improve the query cost by 54.649%.
*/

/*
USE [OCR]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[ReRoutedImages] ([ImportTime])
INCLUDE ([DocImagePath],[ContractType])
GO


Status, ImportID, ImportTime
Status


*/



/*
Missing Index Details from SQLQuery1.sql - OCR-SQLPRD-01.OCR (ELDREDGE_A\jrussell (100))
The Query Processor estimates that implementing the following index could improve the query cost by 78.7401%.
*/

/*
USE [OCR]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[OutputImages] ([ContractType],[BatchDate])
INCLUDE ([DocumentPath])
GO


BatchID
ImportID, BatchID, LenderID, LenderName, ContractType, AlliedDocID, DocumentPath, BatchDate, ScanOperator, ValidationOperator, ImportTime, ExportTime, ManualValidation, TransactionType, MailDate, Insured_LastName, Insured_FirstName, Insured_LastName2, Insured_FirstName2, Insured_DBAName, Insured_Addr, Insured_Zip, InsCoName, BIC_ID, InsCoAddr1, InsCoAddr2, InsCoCity, InsCoState, InsCoZip, AgencyCompanyName, AgencyID, AgencyPhone, AgencyFax, AgencyEmail, PolicyNumber, EffectiveDate, ExpirationDate, CancellationDate, CancellationReason, flg_IsApplication, flg_LienholderNameErr, flg_LienholderAddrErr, LoanNumber, flg_LiabilityCard, Veh_Year, Veh_Make, Veh_Model, VIN, veh_CompDeductibleAmt, flg_ComprehensiveCoverage, veh_CollDeductibleAmt, flg_CollisionCoverage, veh_CSL, veh_BIP, veh_BIO, veh_PDO, flg_ExcessLiability, flg_LessorErr, Prop_Addr, Prop_Zip, haz_ADwellCoverageAmt, haz_ADeductibleAmt, haz_ADeductiblePct, flg_HazardCoverage, flood_ADwellCoverageAmt, flood_ADeductibleAmt, flood_ADeductiblePct, flg_FloodCoverage, flood_zone, flood_grandfathered, haz_WindExcluded, wind_ADwellCoverageAmt, wind_ADeductibleAmt, wind_ADeductiblePct, flg_WindCoverage, quake_ADwellCoverageAmt, quake_ADeductibleAmt, quake_ADeductiblePct, flg_EarthquakeCoverage, hurricane_ADwellCoverageAmt, hurricane_ADeductibleAmt, hurricane_ADeductiblePct, flg_HurricaneCoverage, StatedInsValue, CoverageBasis, ExtCvgAmtFixed, ExtCvgAmtPct, bill_RemittanceID, bill_PremiumDue, bill_SupplementalBilled, bill_TotalPremium, bill_DueDate, condo_flg_CondoAssocPolicy, condo_AssocName, condo_Units, condo_WallsInCoverage, condo_flg_OwnersPolicy, flg_FloodNFIP, flg_FloodCertPrivate, Status


*/
