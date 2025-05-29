IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Report_UTLSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Report_UTLSummary]
GO

/****** Object:  StoredProcedure [dbo].[Report_UTLSummary]    Script Date: 05/14/2012, 04/29/2015 (Optimized) ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report_UTLSummary]
(
	@Lender varchar(10) = 'ALL',
	@StartDate datetime2 (7)=NULL,
	@EndDate datetime2 (7)=NULL,
	@User as nvarchar(15)=NULL,
	@Report_History_ID bigint = NULL
,@Debug As Bit = 0
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @IsFiltered_History As Bit = 0
DECLARE @IsFiltered_Lender As Bit = 0
DECLARE @IsFiltered_User As Bit = 0
	SELECT
	 @IsFiltered_History = CAST(CASE WHEN @Report_History_ID IS NOT NULL AND @Report_History_ID > 0 THEN 1 ELSE 0 END As Bit)
	,@IsFiltered_Lender = CAST(CASE WHEN @Lender IS NOT NULL AND @Lender <> '' AND @Lender <> 'ALL' THEN 1 ELSE 0 END As Bit)
	,@IsFiltered_User = CAST(CASE WHEN @User IS NOT NULL AND @User <> '' AND @User <> '0000' THEN 1 ELSE 0 END As Bit)


IF @IsFiltered_History = 1
BEGIN
  SELECT
   @StartDate = CASE WHEN NullIf(NullIf(Dates.StartDate, ''), '1/1/0001') IS NOT NULL AND IsDate(Dates.StartDate) = 1 THEN Dates.StartDate ELSE @StartDate END 
  ,@EndDate = CASE WHEN NullIf(NullIf(Dates.EndDate, ''), '1/1/0001') IS NOT NULL AND IsDate(Dates.EndDate) = 1 THEN Dates.EndDate ELSE @EndDate END 
  FROM REPORT_HISTORY
  CROSS APPLY (SELECT
   StartDate=REPORT_DATA_XML.value('(/ReportData[1]/Report[1]/StartDate[1]/@value)[1]', 'NVarChar(25)')
  ,EndDate=REPORT_DATA_XML.value('(/ReportData[1]/Report[1]/EndDate[1]/@value)[1]', 'NVarChar(25)')
  ) As Dates
  WHERE ID = @Report_History_ID

  SET @StartDate = DATEADD(HH,0,@StartDate)			
  SET @EndDate = DATEADD(HH,0,@EndDate)				
END

IF @StartDate IS NULL
	SET @StartDate = DATEADD(dd,-1,DATEDIFF(dd,0,GETDATE()))
		
IF @EndDate IS NULL
	SET @EndDate = DATEADD(dd,0,DATEDIFF(dd,0,GETDATE()))

DECLARE @RecordCount bigint = 0
DECLARE @NextDay datetime = DATEADD(dd,1,DATEDIFF(dd,0,@EndDate))
DECLARE @PrevDay datetime = DATEADD(dd,-1,DATEDIFF(dd,0,@StartDate))

DECLARE @Start As Date = Cast(@StartDate As Date)
DECLARE @End As Date = Cast(@EndDate As Date)
DECLARE @Next As Date = Cast(@NextDay As Date)
DECLARE @Prev As Date = Cast(@PrevDay As Date)

DECLARE @GETDATE DateTime = GETDATE()

/*
-- variable Table
-- to hold the "main" data returnset
-- so that we can then subsequently update/apply to it the processing of the XML (from SCORE_DETAIL_XML)
*/
DECLARE @varTable As Table(
 UtlID BigInt NOT NULL
,SORT_BY NVarChar(2200)
,MATCH_SORT NVarChar(20)
,MATCH NVarChar(20)
,[TYPE] NVarChar(1000)
,LenderCode NVarChar(10)
,LenderName NVarChar(100)
,BranchCode NVarChar(20)
,DivisionCode NVarChar(20)
,DivisionDescription NVarChar(1000)
,CoverageTypeCode NVarChar(30)
,CoverageTypeDescription NVarChar(1000)
,PROPERTY_TYPE_CD NVarChar(100)
,MATCH_RESULT_CD NVarChar(10)

--UTL 'Unmatched' columns:
,UTLLoanNumber NVarChar(18)
,UTLLoanComments NVarChar(MAX)
,UTLCollateralNumber Int
,UTLAgencyCollateralCode NVarChar(30)
,UTLBorrowerFirstName NVarChar(30)
,UTLBorrowerLastName NVarChar(30)
,UTLBorrowerDBA NVarChar(50)
,UTLBorrowerAddressLine1 NVarChar(100)
,UTLBorrowerAddressLine2 NVarChar(100)
,UTLBorrowerAddressCity NVarChar(40)
,UTLBorrowerAddressStateProvince NVarChar(30)
,UTLBorrowerAddressPostalCode NVarChar(30)
,UTLVehicleVIN NVarChar(18)
,UTLVehicleModel NVarChar(30)
,UTLVehicleMake NVarChar(30)
,UTLVehicleYear NVarChar(4)
,UTLEquipmentDescription NVarChar(100)
,UTLMortgageAddressLine1 NVarChar(100)
,UTLMortgageAddressLine2 NVarChar(100)
,UTLMortgageAddressCity NVarChar(40)
,UTLMortgageAddressStateProvince NVarChar(30)
,UTLMortgageAddressPostalCode NVarChar(30)
,UTLBorrowerInsuranceCompany NVarChar(30)
,UTLBorrowerInsurancePolicyNumber NVarChar(30)
,UTLBorrowerInsuranceEffDate DateTime2
,UTLBorrowerInsuranceExpDate DateTime2
,UTLBorrowerInsuranceCancelDate DateTime2
,UTLBorrowerInsuranceAgencyName NVarChar(100)
,UTLBorrowerInsuranceAgencyPhone NVarChar(20)
,UTLImpairmentReason NVarChar(1000)
,UTLOtherDeductible Decimal(18, 2) NULL
,UTLComprehensiveDeductible Decimal(18, 2) NULL
,UTLCollisionDeductible Decimal(18, 2) NULL
,UTLMailDate DateTime2
,UTLCPIStatusCode NVarChar(2)
,UTLCPIStatus NVarChar(1000)
,UTL_PROPERTY_DESCRIPTION nvarchar(800) NULL

--UTL 'Matched' columns	 
,MatchLoanNumber NVarChar(18)
,MatchLoanComments NVarChar(MAX)
,MatchCollateralNumber Int
,MatchAgencyCollateralCode NVarChar(30)
,MatchBorrowerFirstName NVarChar(30)
,MatchBorrowerLastName NVarChar(30)
,MatchBorrowerDBA NVarChar(50)
,MatchBorrowerAddressLine1 NVarChar(100)
,MatchBorrowerAddressLine2 NVarChar(100)
,MatchBorrowerAddressCity NVarChar(40)
,MatchBorrowerAddressStateProvince NVarChar(30)
,MatchBorrowerAddressPostalCode NVarChar(30)
,MatchVehicleVIN NVarChar(18)
,MatchVehicleModel NVarChar(30)
,MatchVehicleMake NVarChar(30)
,MatchVehicleYear NVarChar(4)
,MatchEquipmentDescription NVarChar(100)
,MatchMortgageAddressLine1 NVarChar(100)
,MatchMortgageAddressLine2 NVarChar(100)
,MatchMortgageAddressCity NVarChar(40)
,MatchMortgageAddressStateProvince NVarChar(30)
,MatchMortgageAddressPostalCode NVarChar(30)
,MatchBorrowerInsuranceCompany NVarChar(30)
,MatchBorrowerInsurancePolicyNumber NVarChar(30)
,MatchBorrowerInsuranceEffDate DateTime2
,MatchBorrowerInsuranceExpDate DateTime2
,MatchBorrowerInsuranceCancelDate DateTime2
,MatchBorrowerInsuranceAgencyName NVarChar(100)
,MatchBorrowerInsuranceAgencyPhone NVarChar(20)
,MatchImpairmentReason NVarChar(1000)
,MatchOtherDeductible Decimal(18, 2)
,MatchComprehensiveDeductible Decimal(18, 2)
,MatchCollisionDeductible Decimal(18, 2)
,MatchMailDate Date
,MatchCPIStatusCode NVarChar(2)
,MatchCPIStatus NVarChar(1000)
,MATCH_PROPERTY_DESCRIPTION nvarchar(800) NULL

,MSG_LOG_TX NVarChar(MAX)

,UTLMatchedByXML NVarChar(MAX) NULL

,SortLender NVarChar(200)
,SortBranch NVarChar(20)
,SortCoverage NVarChar(30)
,SortUtlLoanNumber NVarChar(18)
,SortUtlCreated Date
,SortUtlPurged Date

,SCORE_DETAIL_XML XML

,OwnerPolicyID BigInt

--New fields
,USER_MATCH_RESULT_CD NVarChar(10)
,USER_MATCH_TX NVarChar(15)
,USER_MATCH_DT datetime
,UTL_CREATE_DT datetime
,LoanStatusAtUTLApply varchar(50)
,UTL_MORT_COVERAGE_AMOUNT Decimal(18, 2) NULL
,MatchLoanId BigInt
)

INSERT INTO @varTable
Select
 UtlID = UTL.ID,
('Lender: ' + ISNULL(ULND.CODE_TX,'_None_') + ' - ' + ISNULL(ULND.NAME_TX,'_NO_NAME_') + ' / ' + 
	(CASE WHEN ISNULL(ML.BRANCH_CODE_TX,'') = '' THEN '_N/A_' ELSE ML.BRANCH_CODE_TX END) + ' / ' + 
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) + ' / ' + 
	ISNULL(RC_COVERAGETYPE.MEANING_TX,'_None_')) AS SORT_BY,
--CASE (SELECT COUNT(*) FROM REF_CODE WHERE DOMAIN_CD = 'InsuranceValidationException' AND MEANING_TX = UPPER(ISNULL(UTL.MSG_LOG_TX,'')))
--	WHEN 0 THEN CASE SUBSTRING(UTL.MATCH_RESULT_CD,1,3) WHEN 'EXA' THEN 'EXA - EXACT' ELSE 'INX - INEXACT' END
--	ELSE 
--	CASE WHEN (UTL.APPLY_STATUS_CD = 'APP' AND SUBSTRING(CASE WHEN SUBSTRING(ISNULL(UTL.USER_MATCH_RESULT_CD,'   '),1,3) = 'EXA' THEN 'EXACT' ELSE UTL.MATCH_RESULT_CD END,1,3) = 'EXA') THEN 'XCE - EXCEPTION' 
--	ELSE CASE SUBSTRING(UTL.MATCH_RESULT_CD,1,3) WHEN 'EXA' THEN 'EXA - EXACT' ELSE 'INX - INEXACT' END
--	END
--END AS MATCH_SORT,
MATCH_SORT = Sorts.MatchResult
,
CASE (SELECT COUNT(*) FROM REF_CODE WHERE DOMAIN_CD = 'InsuranceValidationException' AND MEANING_TX = UPPER(ISNULL(UTL.MSG_LOG_TX,'')))
	WHEN 0 THEN
		CASE
			SUBSTRING(UTL.MATCH_RESULT_CD,1,3) WHEN 'EXA' THEN 'EXACT' ELSE 'INEXACT'
		END
		+
		CASE
			WHEN UTL.MATCH_RESULT_CD LIKE '%RVW' THEN ' WITH REVIEW' ELSE ''
		END
	ELSE 
		CASE
			WHEN (UTL.APPLY_STATUS_CD = 'APP'
			 AND SUBSTRING(CASE WHEN SUBSTRING(ISNULL(UTL.USER_MATCH_RESULT_CD,'   '),1,3) = 'EXA' THEN 'EXACT' ELSE UTL.MATCH_RESULT_CD END,1,3) = 'EXA')
				THEN 'EXCEPTION' 
			ELSE
			CASE
				SUBSTRING(UTL.MATCH_RESULT_CD,1,3) WHEN 'EXA' THEN 'EXACT' ELSE 'INEXACT'
			END
			+
			CASE
				WHEN UTL.MATCH_RESULT_CD LIKE '%RVW' THEN ' WITH REVIEW' ELSE ''
			END
		END
	END
AS MATCH,
RC_UTL_TYPE.MEANING_TX AS TYPE,
ULND.CODE_TX as LenderCode,ULND.NAME_TX as LenderName,ISNULL(UL.BRANCH_CODE_TX,'') as BranchCode, 
CASE WHEN ISNULL(ML.DIVISION_CODE_TX,'') = ''
	THEN '0'
	ELSE ML.DIVISION_CODE_TX
END AS DivisionCode,
ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as DivisionDescription,
URC.TYPE_CD AS CoverageTypeCode,RC_COVERAGETYPE.MEANING_TX as CoverageTypeDescription, 
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD,

--UTL 'Unmatched' columns:
UTL.MATCH_RESULT_CD,
UL.NUMBER_TX as UTLLoanNumber,UL.NOTE_TX AS UTLLoanComments,
UC.COLLATERAL_NUMBER_NO AS UTLCollateralNumber,
UCC.CODE_TX AS UTLAgencyCollateralCode,
UO.FIRST_NAME_TX as UTLBorrowerFirstName,UO.LAST_NAME_TX as UTLBorrowerLastName,
CASE WHEN ISNULL(UDBAO.NAME_TX,'') = '' THEN UDBAO.LAST_NAME_TX ELSE UDBAO.NAME_TX END AS UTLBorrowerDBA,
UAO.LINE_1_TX as UTLBorrowerAddressLine1,UAO.LINE_2_TX as UTLBorrowerAddressLine2,
UAO.CITY_TX as UTLBorrowerAddressCity,UAO.STATE_PROV_TX as UTLBorrowerAddressStateProvince,UAO.POSTAL_CODE_TX as UTLBorrowerAddressPostalCode,
UP.VIN_TX as UTLVehicleVIN,UP.MODEL_TX as UTLVehicleModel,UP.MAKE_TX as UTLVehicleMake,UP.YEAR_TX as UTLVehicleYear,UP.DESCRIPTION_TX as UTLEquipmentDescription,
UAM.LINE_1_TX as UTLMortgageAddressLine1,UAM.LINE_2_TX as UTLMortgageAddressLine2,
UAM.CITY_TX as UTLMortgageAddressCity,UAM.STATE_PROV_TX as UTLMortgageAddressStateProvince,UAM.POSTAL_CODE_TX as UTLMortgageAddressPostalCode,
UOP.BIC_NAME_TX as UTLBorrowerInsuranceCompany,UOP.POLICY_NUMBER_TX as UTLBorrowerInsurancePolicyNumber,
UOP.EFFECTIVE_DT as UTLBorrowerInsuranceEffDate,UOP.EXPIRATION_DT as UTLBorrowerInsuranceExpDate,UOP.CANCELLATION_DT as UTLBorrowerInsuranceCancelDate,
UBIA.NAME_TX as UTLBorrowerInsuranceAgencyName,UBIA.PHONE_TX as UTLBorrowerInsuranceAgencyPhone,
ISNULL(CASE WHEN (SELECT COUNT(*) FROM IMPAIRMENT WHERE REQUIRED_COVERAGE_ID = URC.ID) > 1 THEN 'Multiple'
	ELSE  (SELECT MEANING_TX FROM REF_CODE WHERE DOMAIN_CD = 'ImpairmentReason' AND CODE_CD = (SELECT CODE_CD FROM IMPAIRMENT WHERE REQUIRED_COVERAGE_ID = URC.ID))
	END,'') AS UTLImpairmentReason,

--UPCOTHER.DEDUCTIBLE_NO as UTLOtherDeductible,
--UPCV1.DEDUCTIBLE_NO as UTLComprehensiveDeductible,UPCV2.DEDUCTIBLE_NO as UTLCollisionDeductible,
 UTLOtherDeductible = NULL
,UTLComprehensiveDeductible = NULL
,UTLCollisionDeductible = NULL

,UOP.MOST_RECENT_MAIL_DT as UTLMailDate,
URC.CPI_STATUS_CD AS UTLCPIStatusCode,URCISRef.MEANING_TX AS UTLCPIStatus,
dbo.fn_GetPropertyDescriptionForReports(UC.ID) UTL_PROPERTY_DESCRIPTION,

--UTL 'Matched' columns:
ML.NUMBER_TX as MatchLoanNumber,ML.NOTE_TX as MatchLoanComments,
MC.COLLATERAL_NUMBER_NO AS MatchCollateralNumber,
MCC.CODE_TX AS MatchAgencyCollateralCode,
MO.FIRST_NAME_TX as MatchBorrowerFirstName,MO.LAST_NAME_TX as MatchBorrowerLastName, 
CASE WHEN ISNULL(MDBAO.NAME_TX,'') = '' THEN MDBAO.LAST_NAME_TX ELSE MDBAO.NAME_TX END AS MatchBorrowerDBA,
MAO.LINE_1_TX as MatchBorrowerAddressLine1,MAO.LINE_2_TX as MatchBorrowerAddressLine2,
MAO.CITY_TX as MatchBorrowerAddressCity,MAO.STATE_PROV_TX as MatchBorrowerAddressStateProvince,MAO.POSTAL_CODE_TX as MatchBorrowerAddressPostalCode,
MP.VIN_TX as MatchVehicleVIN,MP.MODEL_TX as MatchVehicleModel,MP.MAKE_TX as MatchVehicleMake,MP.YEAR_TX as MatchVehicleYear,MP.DESCRIPTION_TX as MatchEquipmentDescription,
MAM.LINE_1_TX as MatchMortgageAddressLine1,MAM.LINE_2_TX as MatchMortgageAddressLine2,
MAM.CITY_TX as MatchMortgageAddressCity,MAM.STATE_PROV_TX as MatchMortgageAddressStateProvince,MAM.POSTAL_CODE_TX as MatchMortgageAddressPostalCode,
MOP.BIC_NAME_TX as MatchBorrowerInsuranceCompany,MOP.POLICY_NUMBER_TX as MatchBorrowerInsurancePolicyNumber,
MOP.EFFECTIVE_DT as MatchBorrowerInsuranceEffDate,MOP.EXPIRATION_DT as MatchBorrowerInsuranceExpDate,MOP.CANCELLATION_DT as MatchBorrowerInsuranceCancelDate,
MBIA.NAME_TX as MatchBorrowerInsuranceAgencyName,MBIA.PHONE_TX as MatchBorrowerInsuranceAgencyPhone,
ISNULL(CASE WHEN (SELECT COUNT(*) FROM IMPAIRMENT WHERE REQUIRED_COVERAGE_ID = MRC.ID) > 1 THEN 'Multiple'
	ELSE  (SELECT MEANING_TX FROM REF_CODE WHERE DOMAIN_CD = 'ImpairmentReason' AND CODE_CD = (SELECT CODE_CD FROM IMPAIRMENT WHERE REQUIRED_COVERAGE_ID = MRC.ID))
	END,'') AS MatchImpairmentReason,

--MPCOTHER.DEDUCTIBLE_NO as MatchOtherDeductible,
--MPCV1.DEDUCTIBLE_NO as MatchComprehensiveDeductible,MPCV2.DEDUCTIBLE_NO as MatchCollisionDeductible,
 UTLOtherDeductible = NULL
,UTLComprehensiveDeductible = NULL
,UTLCollisionDeductible = NULL
,
MOP.MOST_RECENT_MAIL_DT as MatchMailDate,
MRC.CPI_STATUS_CD AS MatchCPIStatusCode,MRCISRef.MEANING_TX AS MatchCPIStatus,

dbo.fn_GetPropertyDescriptionForReports(MC.ID) MATCH_PROPERTY_DESCRIPTION,
UTL.MSG_LOG_TX,

--(SELECT CASE WHEN SCORE_DETAIL_XML IS NULL THEN '' ELSE
--  IsNull('' + UTLScores.RuleCode1, '') + IsNull('(' + UTLScores.Score1 + ')', '') +
--  IsNull(', ' + UTLScores.RuleCode2, '') + IsNull('(' + UTLScores.Score2 + ')', '') +
--  IsNull(', ' + UTLScores.RuleCode3, '') + IsNull('(' + UTLScores.Score3 + ')', '') +
--  IsNull(', ' + UTLScores.RuleCode4, '') + IsNull('(' + UTLScores.Score4 + ')', '') +
--  IsNull(', ' + UTLScores.RuleCode5, '') + IsNull('(' + UTLScores.Score5 + ')', '') +
--  IsNull(', ' + UTLScores.RuleCode6, '') + IsNull('(' + UTLScores.Score6 + ')', '')
-- END) AS UTLMatchedByXML
UTLMatchedByXML = NULL
 
,SortLender = Sorts.Lender
,SortBranch = Sorts.Branch
,SortCoverage = Sorts.Coverage
,SortUtlLoanNumber = Sorts.UtlLoanNumber
,SortUtlCreated = Sorts.UtlCreated
,SortUtlPurged = Sorts.UtlPurged

,SCORE_DETAIL_XML = NULL -- 'placeholder'

,OwnerPolicyID = UOP.ID

--New fields
,CASE 
	WHEN ISNULL(UTL.USER_MATCH_RESULT_CD,'') = '' THEN NULL
	WHEN UTL.USER_MATCH_RESULT_CD = 'NO' THEN 'No Match'
	ELSE 'Match'
END AS USER_MATCH_RESULT_CD
,CASE 
	WHEN ISNULL(UTL.MATCH_RESULT_CD,'') = 'EXACT' THEN 'System'
	ELSE UTL.USER_MATCH_TX
END AS USER_MATCH_TX
,CASE WHEN ISNULL(UTL.USER_MATCH_RESULT_CD,'') = ''
	THEN NULL
	ELSE UTL.UPDATE_DT
END AS USER_MATCH_DT
,UL.CREATE_DT UTL_CREATE_DT
,ML.STATUS_CD LoanStatusAtUTLApply
,UTL_MORT_COVERAGE_AMOUNT = NULL
,ML.ID

--comment out "PURGE_DT IS NULL" for 'Unmatched' portion of joins - unmatched are all purged at some point so the purge date should not be checked
--we need to use the index on the indexed view in order to optimize performance more
--but we cannot use the index if/since it does not exist
--FROM UTL_MATCH_RESULT_VIEW UTL WITH(NOLOCK, NOEXPAND, INDEX(IDX_UTL_MATCH_RESULT_VIEW_DATE_UTLSUM, IDX_UTL_MATCH_RESULT_VIEW_DATE_ID))
FROM UTL_MATCH_RESULT UTL
--Join LENDER ULND on ULND.ID = UTL.LENDER_ID AND ULND.PURGE_DT IS NULL
Join LOAN UL on UL.ID = UTL.UTL_LOAN_ID --AND UL.PURGE_DT IS NULL
Join LENDER ULND on ULND.ID = UL.LENDER_ID AND ULND.PURGE_DT IS NULL
Join dbo.UTLMATCH_REQ_COV_RELATE UTLRELATE on UTLRELATE.UTL_MATCH_RESULT_ID = UTL.ID --AND UTLRELATE.PURGE_DT IS NULL	
--Join (Select Distinct UTL_MATCH_RESULT_ID, REQUIRED_COVERAGE_ID, UTL_REQUIRED_COVERAGE_ID, OWNER_POLICY_ID FROM dbo.UTLMATCH_REQ_COV_RELATE UTLRELATE) UTLRELATE on UTLRELATE.UTL_MATCH_RESULT_ID = UTL.ID --AND UTLRELATE.PURGE_DT IS NULL	
Join REQUIRED_COVERAGE URC on URC.ID = UTLRELATE.UTL_REQUIRED_COVERAGE_ID --AND URC.PURGE_DT IS NULL	
--Join REQUIRED_COVERAGE URC on URC.ID = UTL.UTL_REQUIRED_COVERAGE_ID --AND URC.PURGE_DT IS NULL	
Join COLLATERAL UC on UC.LOAN_ID = UTL.UTL_LOAN_ID AND UC.PROPERTY_ID = URC.PROPERTY_ID --AND UC.PURGE_DT IS NULL
LEFT JOIN COLLATERAL_CODE UCC ON UCC.ID = UC.COLLATERAL_CODE_ID --AND UCC.PURGE_DT IS NULL								
Join PROPERTY UP on UP.ID = UC.PROPERTY_ID --AND UP.PURGE_DT IS NULL
Join OWNER_LOAN_RELATE ULR on ULR.LOAN_ID = UL.ID AND ISNULL(ULR.PRIMARY_IN,'N') = 'Y' --AND ULR.PURGE_DT IS NULL

LEFT JOIN OWNER_LOAN_RELATE ULRDBA ON ULRDBA.LOAN_ID = UL.ID AND ISNULL(ULRDBA.OWNER_TYPE_CD,'') = 'DBA' --AND ULRDBA.PURGE_DT IS NULL
LEFT JOIN [OWNER] UDBAO on UDBAO.ID = ULRDBA.OWNER_ID --AND UDBAO.PURGE_DT IS NULL
Join [OWNER] UO on UO.ID = ULR.OWNER_ID --AND UO.PURGE_DT IS NULL
left Join [OWNER_ADDRESS] UAO on UAO.ID = UO.ADDRESS_ID --AND UAO.PURGE_DT IS NULL
left Join [OWNER_ADDRESS] UAM on UAM.ID = UP.ADDRESS_ID	--AND UAM.PURGE_DT IS NULL		
left Join OWNER_POLICY UOP on UOP.ID = UTL.UTL_OWNER_POLICY_ID --AND UOP.PURGE_DT IS NULL
left Join BORROWER_INSURANCE_AGENCY UBIA on UBIA.ID = UOP.BIA_ID AND UBIA.PURGE_DT IS NULL
left Join REF_CODE RC_COVERAGETYPE on RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = URC.TYPE_CD
left Join REF_CODE URCISRef on URCISRef.DOMAIN_CD = 'RequiredCoverageInsStatus' and URCISRef.CODE_CD = URC.CPI_STATUS_CD

--UTL 'Matched' joins 
Join LOAN ML on ML.ID = UTL.LOAN_ID AND ML.PURGE_DT IS NULL
Join COLLATERAL MC on MC.LOAN_ID = UTL.LOAN_ID AND MC.PROPERTY_ID = UTL.PROPERTY_ID AND MC.PURGE_DT IS NULL
Join PROPERTY MP on MP.ID = UTL.PROPERTY_ID AND MP.PURGE_DT IS NULL
LEFT JOIN COLLATERAL_CODE MCC ON MCC.ID = MC.COLLATERAL_CODE_ID AND MCC.PURGE_DT IS NULL								
Left Join REQUIRED_COVERAGE MRC on MRC.ID = UTLRELATE.REQUIRED_COVERAGE_ID AND MRC.PURGE_DT IS NULL					

Join OWNER_LOAN_RELATE MOL on MOL.LOAN_ID = ML.ID AND ISNULL(MOL.PRIMARY_IN,'N') = 'Y' AND MOL.PURGE_DT IS NULL
LEFT JOIN OWNER_LOAN_RELATE MLRDBA ON MLRDBA.LOAN_ID = ML.ID AND ISNULL(MLRDBA.OWNER_TYPE_CD,'') = 'DBA' AND MLRDBA.PURGE_DT IS NULL	
LEFT JOIN [OWNER] MDBAO on MDBAO.ID = MLRDBA.OWNER_ID AND MDBAO.PURGE_DT IS NULL
Join [OWNER] MO on MO.ID = MOL.OWNER_ID AND MO.PURGE_DT IS NULL
left Join [OWNER_ADDRESS] MAO on MAO.ID = MO.ADDRESS_ID AND MAO.PURGE_DT IS NULL
left Join [OWNER_ADDRESS] MAM on MAM.ID = MP.ADDRESS_ID	AND MAM.PURGE_DT IS NULL
left Join OWNER_POLICY MOP on MOP.ID = UTLRELATE.OWNER_POLICY_ID AND MOP.PURGE_DT IS NULL			
left Join BORROWER_INSURANCE_AGENCY MBIA on MBIA.ID = MOP.BIA_ID AND MBIA.PURGE_DT IS NULL
left Join REF_CODE MRCISRef on MRCISRef.DOMAIN_CD = 'RequiredCoverageInsStatus' and MRCISRef.CODE_CD = MRC.CPI_STATUS_CD
Left Join REF_CODE RC_UTL_TYPE ON RC_UTL_TYPE.DOMAIN_CD = 'RecordType' and RC_UTL_TYPE.CODE_CD = UL.RECORD_TYPE_CD
left Join REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = ML.DIVISION_CODE_TX
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND MCC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
CROSS APPLY
(SELECT
 Lender = (ULND.CODE_TX + ' - ' + ISNULL(ULND.NAME_TX,'_NO_NAME_')) 
,Branch = (CASE WHEN ISNULL(ML.BRANCH_CODE_TX,'') = '' THEN '_N/A_' ELSE ML.BRANCH_CODE_TX END)
,Division = ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)
,Coverage = URC.TYPE_CD
,MatchResult = CASE (SELECT COUNT(*) FROM REF_CODE WHERE DOMAIN_CD = 'InsuranceValidationException' AND MEANING_TX = UPPER(ISNULL(UTL.MSG_LOG_TX,'')))
	WHEN 0 THEN 
		CASE SUBSTRING(UTL.MATCH_RESULT_CD,1,3) 
			WHEN 'EXA' THEN 'EXA - EXACT' 
			ELSE 'INX - INEXACT' 
		END
	ELSE 
		CASE WHEN (UTL.APPLY_STATUS_CD = 'APP' 
		AND SUBSTRING(CASE WHEN SUBSTRING(ISNULL(UTL.USER_MATCH_RESULT_CD,'   '),1,3) = 'EXA' THEN 'EXACT' 
			ELSE UTL.MATCH_RESULT_CD END,1,3) = 'EXA') THEN 'XCE - EXCEPTION' 
			ELSE CASE SUBSTRING(UTL.MATCH_RESULT_CD,1,3) 
				WHEN 'EXA' THEN 'EXA - EXACT' 
				ELSE 'INX - INEXACT' 
			END
		END
	END
,UtlCreated = Cast(UTL.CREATE_DT As Date)
,UtlPurged = Cast(UTL.PURGE_DT As Date)
,UtlLoanNumber = Right(Replicate('0', 18) + UL.NUMBER_TX, 18)
) As Sorts

--WHERE (@IsFiltered_Lender = 0 OR UTL.LenderCode = @Lender)
WHERE (@IsFiltered_Lender = 0 OR ULND.CODE_TX = @Lender) 
--AND (UTL.PURGE_DT IS NULL OR UTL.PURGE_DT > @StartDate)
--AND UTL.CREATE_DATE > @Prev AND UTL.CREATE_DATE < @Next
AND UTL.CREATE_DT >= @StartDate AND UTL.CREATE_DT < @NextDay
AND (UTL.USER_MATCH_TX = @User OR @IsFiltered_User = 0)

ORDER BY
 Case When @IsFiltered_Lender = 1 Then NULL Else Sorts.Lender End
,Case When @IsFiltered_Lender = 1 Then NULL Else Sorts.Branch End
,Sorts.Coverage
,Sorts.MatchResult
,MO.LAST_NAME_TX, MO.FIRST_NAME_TX
,Sorts.UtlLoanNumber
--,Sorts.UtlCreated
--,Sorts.UtlPurged

OPTION(RECOMPILE)
--OPTION(OPTIMIZE FOR (@StartDate = '1/1/2015', @NextDay UNKNOWN))
--OPTION(OPTIMIZE FOR (@Start = '1/1/2015', @Next UNKNOWN))

--Check for Loan StatusCd on the day UTL was applied
SELECT DISTINCT varTable.UtlID, MAX(pcu.CHANGE_ID) CHANGE_ID
INTO #tmpPCU
FROM PROPERTY_CHANGE_UPDATE pcu
	JOIN @varTable varTable ON varTable.MatchLoanId = pcu.TABLE_ID
WHERE pcu.TABLE_NAME_TX='LOAN' 
AND pcu.COLUMN_NM = 'STATUS_CD'
AND pcu.CREATE_DT <= varTable.USER_MATCH_DT
GROUP BY varTable.UtlID
ORDER BY varTable.UtlID ASC

SELECT DISTINCT tmp.UtlID, pcu.TO_VALUE_TX
INTO #tmpLoanStatus
FROM PROPERTY_CHANGE_UPDATE pcu
	JOIN #tmpPCU tmp ON tmp.CHANGE_ID = pcu.CHANGE_ID 
WHERE pcu.TABLE_NAME_TX='LOAN' 
AND pcu.COLUMN_NM = 'STATUS_CD'

--Check if Match is a DOCUMENT
SELECT umr.ID UTLID, 'Document' TYPE_CD
INTO #tmpUTLDocument
FROM UTL_MATCH_RESULT umr
	JOIN @varTable varTable ON varTable.UtlID = umr.ID
	JOIN INTERACTION_HISTORY ihUTL on ihUTL.RELATE_ID = umr.UTL_OWNER_POLICY_ID AND ihUTL.RELATE_CLASS_TX = 'Allied.UniTrac.OwnerPolicy' AND ihUTL.TYPE_CD = 'OWNERPOLICY'
	JOIN INTERACTION_HISTORY ihG on ihG.PROPERTY_ID = umr.PROPERTY_ID AND ihG.TYPE_CD = 'DOCUMENT'
WHERE ihUTL.SPECIAL_HANDLING_XML.value('(/SH/TransactionId)[1]', 'bigint') = ihG.SPECIAL_HANDLING_XML.value('(/SH/TransactionId)[1]', 'bigint')
AND umr.USER_MATCH_RESULT_CD = 'EXACT'

/* NOW update @varTable.UTLMatchedByXML, using SCORE_DETAIL_XML
-- (this is done AFTER the "main query" so as to NOT perform any unneccessary XPath queries)
*/
UPDATE varTable
SET
 UTLMatchedByXML =
(SELECT CASE WHEN SCORE.DETAIL_XML IS NULL THEN '' ELSE
  IsNull('' + UTLScores.RuleCode1, '') + IsNull('(' + UTLScores.Score1 + ')', '') +
  IsNull(', ' + UTLScores.RuleCode2, '') + IsNull('(' + UTLScores.Score2 + ')', '') +
  IsNull(', ' + UTLScores.RuleCode3, '') + IsNull('(' + UTLScores.Score3 + ')', '') +
  IsNull(', ' + UTLScores.RuleCode4, '') + IsNull('(' + UTLScores.Score4 + ')', '') +
  IsNull(', ' + UTLScores.RuleCode5, '') + IsNull('(' + UTLScores.Score5 + ')', '') +
  IsNull(', ' + UTLScores.RuleCode6, '') + IsNull('(' + UTLScores.Score6 + ')', '')
 END)
  , LoanStatusAtUTLApply = ISNULL(tmpLS.TO_VALUE_TX, LoanStatusAtUTLApply)
  , USER_MATCH_RESULT_CD = ISNULL(tmpDoc.TYPE_CD, varTable.USER_MATCH_RESULT_CD)
FROM @varTable As varTable
LEFT OUTER JOIN #tmpLoanStatus tmpLS ON tmpLS.UtlID = varTable.UtlID
LEFT OUTER JOIN #tmpUTLDocument tmpDoc on tmpDoc.UTLID = varTable.UtlID
Inner Join UTL_MATCH_RESULT As Utl On Utl.ID = varTable.UtlID
CROSS APPLY
(SELECT DETAIL_XML = IsNull(varTable.SCORE_DETAIL_XML, Utl.SCORE_DETAIL_XML)) As SCORE 
CROSS APPLY
(SELECT
 RuleCode1 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@RuleCode)[1]', 'NVARCHAR(10)'), '') END
,Score1 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@Score)[1]', 'NVARCHAR(10)'), '') END
,RuleCode2 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@RuleCode)[2]', 'NVARCHAR(10)'), '') END
,Score2 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@Score)[2]', 'NVARCHAR(10)'), '') END
,RuleCode3 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@RuleCode)[3]', 'NVARCHAR(10)'), '') END
,Score3 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@Score)[3]', 'NVARCHAR(10)'), '') END
,RuleCode4 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@RuleCode)[4]', 'NVARCHAR(10)'), '') END
,Score4 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@Score)[4]', 'NVARCHAR(10)'), '') END
,RuleCode5 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@RuleCode)[5]', 'NVARCHAR(10)'), '') END
,Score5 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@Score)[5]', 'NVARCHAR(10)'), '') END
,RuleCode6 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@RuleCode)[6]', 'NVARCHAR(10)'), '') END
,Score6 = CASE WHEN SCORE.DETAIL_XML IS NULL THEN NULL ELSE NullIf(SCORE.DETAIL_XML.value('(/UTLScores[1]/UTLScore/@Score)[6]', 'NVARCHAR(10)'), '') END
) As UTLScores

/* NOW update @varTable.UTLOtherDeductible, UTLComprehensiveDeductible, UTLCollisionDeductible
*/
;With UPC(OWNER_POLICY_ID, DEDUCTIBLE_NO, TYPE_CD, SUB_TYPE_CD, START_DT, AMOUNT_NO)
 As
(
	Select Top 100 Percent pc.OWNER_POLICY_ID, pc.DEDUCTIBLE_NO, pc.TYPE_CD, pc.SUB_TYPE_CD, pc.START_DT, pc.AMOUNT_NO
    From POLICY_COVERAGE As pc
	Inner Join @varTable As varTable On varTable.OwnerPolicyID = pc.OWNER_POLICY_ID
    Where @GETDATE BETWEEN pc.START_DT AND pc.END_DT -- pc.START_DT <= @GETDATE And pc.END_DT > @GETDATE
	--And pc.PURGE_DT IS NULL
	Order By pc.OWNER_POLICY_ID, pc.TYPE_CD
	,Case When pc.PURGE_DT IS NULL Then 1 Else 2 End
	,pc.START_DT Desc
	,pc.UPDATE_DT Desc
)
UPDATE varTable
SET
 UTLOtherDeductible = IsNull(UPCOTHER.DEDUCTIBLE_NO, UTLOtherDeductible)
,UTLComprehensiveDeductible = IsNull(UPCV1.DEDUCTIBLE_NO, UTLComprehensiveDeductible)
,UTLCollisionDeductible = IsNull(UPCV2.DEDUCTIBLE_NO, UTLCollisionDeductible)
,LoanStatusAtUTLApply = ISNULL(rc.MEANING_TX, LoanStatusAtUTLApply)
,UTL_MORT_COVERAGE_AMOUNT = IsNull(UPCOTHER.AMOUNT_NO, UTL_MORT_COVERAGE_AMOUNT)
FROM @varTable As varTable
JOIN REF_CODE rc ON rc.DOMAIN_CD ='LoanStatus' AND rc.CODE_CD = varTable.LoanStatusAtUTLApply AND rc.PURGE_DT IS NULL
AND PURGE_DT IS NULL
Outer Apply (
	Select Top 1 DEDUCTIBLE_NO, AMOUNT_NO
    From UPC
    Where varTable.OwnerPolicyID = OWNER_POLICY_ID
    And TYPE_CD != 'PHYS-DAMAGE'
    And TYPE_CD = varTable.CoverageTypeCode
	And (DEDUCTIBLE_NO Is NOT Null OR AMOUNT_NO IS NOT NULL)
    --Order By START_DT
	) As UPCOTHER
Outer Apply (
	Select Top 1 DEDUCTIBLE_NO, AMOUNT_NO
    From UPC
    Where varTable.OwnerPolicyID = OWNER_POLICY_ID
    And TYPE_CD = 'PHYS-DAMAGE' And SUB_TYPE_CD = 'COMP'
	And (DEDUCTIBLE_NO Is NOT Null OR AMOUNT_NO IS NOT NULL)
    --Order By START_DT
	) As UPCV1
Outer Apply (
	Select Top 1 DEDUCTIBLE_NO, AMOUNT_NO
    From UPC
    Where varTable.OwnerPolicyID = OWNER_POLICY_ID
    And TYPE_CD = 'PHYS-DAMAGE' And SUB_TYPE_CD = 'COLL'
	And (DEDUCTIBLE_NO Is NOT Null OR AMOUNT_NO IS NOT NULL)
    --Order By START_DT
	) As UPCV2

;SELECT * FROM @varTable

SELECT @RecordCount = COUNT(*) FROM @varTable -- @@ROWCOUNT

IF @Report_History_ID IS NOT NULL
BEGIN
  UPDATE REPORT_HISTORY
  SET
   RECORD_COUNT_NO = @RecordCount
  ,UPDATE_DT = GETDATE()
  WHERE ID = @Report_History_ID
END

END
GO
