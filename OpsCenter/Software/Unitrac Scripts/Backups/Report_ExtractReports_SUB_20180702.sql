USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Report_ExtractReports]    Script Date: 7/2/2018 9:42:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_ExtractReports] 
--declare
	@ReportType as nvarchar(50)='EXTRXCPT',
	@ReportConfig as varchar(50)='0000',
	@Branch as nvarchar(max)=NULL,
	@Division as nvarchar(10)=NULL,
	@GroupByCode as nvarchar(50)=NULL,
	@SortByCode as nvarchar(50)=NULL,
	@Report_History_ID as bigint=NULL
	,@Debug as int=0
AS

BEGIN

SET NOCOUNT ON

--Get rid of residual #temp tables
IF OBJECT_ID(N'tempdb..#Loans',N'U') IS NOT NULL
  DROP TABLE #Loans
IF OBJECT_ID(N'tempdb..#Collaterals',N'U') IS NOT NULL
  DROP TABLE #Collaterals
IF OBJECT_ID(N'tempdb..#Customers',N'U') IS NOT NULL
  DROP TABLE #Customers
IF OBJECT_ID(N'tempdb..#tmpTable',N'U') IS NOT NULL
  DROP TABLE #tmpTable
IF OBJECT_ID(N'tempdb..#tmpfilter',N'U') IS NOT NULL
  DROP TABLE #tmpfilter
IF OBJECT_ID(N'tempdb..#t2',N'U') IS NOT NULL
  DROP TABLE #t2
IF OBJECT_ID(N'tempdb..#EX',N'U') IS NOT NULL
  DROP TABLE #EX
IF OBJECT_ID(N'tempdb..#work_list',N'U') IS NOT NULL
  DROP TABLE #work_list

DECLARE @FillerZero AS varchar(18)
DECLARE @LenderID AS bigint
SET @FillerZero = '000000000000000000'

DECLARE @DocumentID as bigint
DECLARE @RunDate as Datetime2 (7)
DECLARE @ReportConfigID as bigint

Declare @GroupBySQL as varchar(1000)
Declare @SortBySQL as varchar(1000)
Declare @FilterBySQL as varchar(1000)
Declare @HeaderTx as varchar(1000)
Declare @FooterTx as varchar(1000)
Declare @RecordCount as bigint
Declare @sqlstring as nvarchar(3000)

DECLARE @DEBUGGING as char(1) = 'F' 
IF @DEBUGGING = 'T' AND @Report_History_ID IS NULL
BEGIN
		SET @DocumentID =  1427346 
		SET @ReportConfigID = 724
END
ELSE
BEGIN
	IF @Report_History_ID is not NULL
		Begin
			SELECT TOP 1 @DocumentID=REPORT_DATA_XML.value('(//ReportData/Report/DocumentID/@value)[1]', 'bigint'),
			@ReportConfigID = REPORT_DATA_XML.value('(//ReportData/Report/ReportConfigID/@value)[1]', 'bigint')
			FROM REPORT_HISTORY WITH(NOLOCK) WHERE ID = @Report_History_ID
		End
END

DECLARE @BranchTable AS TABLE(ID int, STRVALUE nvarchar(30))
	INSERT INTO @BranchTable SELECT * FROM SplitFunction(@Branch, ',')

--Sets the ReportConfig for main subreport
IF @ReportConfig = '0000'
	SET @ReportConfig = @ReportType


	Select Top 1 @GroupBySQL=GROUP_TX 
		,@SortBySQL=SORT_TX 
		,@HeaderTx=HEADER_TX 
		,@FooterTx=FOOTER_TX from REPORT_CONFIG WITH(NOLOCK) where REPORT_DOMAIN_CD = 'Report_Extract' and CODE_TX = @ReportConfig

	if @GroupBySQL is NULL or @GroupBySQL = ''
		Begin
			if @GroupByCode is NULL or @GroupByCode = ''
				Select Top 1 @GroupBySQL=GROUP_TX from REPORT_CONFIG WITH(NOLOCK) where REPORT_DOMAIN_CD = 'Report_Extract' and CODE_TX = @ReportConfig
			else
				Select Top 1 @GroupBySQL=DESCRIPTION_TX from REF_CODE WITH(NOLOCK) where DOMAIN_CD = 'Report_GroupBy' and CODE_CD = @GroupByCode
		End
	if @SortBySQL is NULL or @SortBySQL = ''
		Begin
			if @SortByCode is NULL or @SortByCode = ''
				Select Top 1 @SortBySQL=SORT_TX from REPORT_CONFIG WITH(NOLOCK) where REPORT_DOMAIN_CD = 'Report_Extract' and CODE_TX = @ReportConfig
			else
				Select Top 1 @SortBySQL=DESCRIPTION_TX from REF_CODE WITH(NOLOCK) where DOMAIN_CD = 'Report_SortBy' and CODE_CD = @SortByCode
		End

DECLARE @TransactionID bigint = 0						
DECLARE @LoanUpdatesOnlyOnWI AS bit = NULL

SELECT TOP 1 @TransactionID = [TRANSACTION].ID,
	@LenderID = T2.Loc.value('(./LenderID)[1]','decimal'),
	@LoanUpdatesOnlyOnWI = ISNULL(T2.Loc.value('(./OptionLenderSummaryMatchResult/LoanUpdatesOnly)[1]', 'bit'), 0)
FROM [TRANSACTION] WITH(NOLOCK) CROSS APPLY DATA.nodes('/Lender/Lender') As T2(Loc) WHERE DOCUMENT_ID = @DocumentID AND PURGE_DT IS NULL and isnull(RELATE_TYPE_CD,'') != 'INFA'


--get the actual date the file posted to UniTrac
SELECT @RunDate = MAX(WIA.UPDATE_DT) FROM WORK_ITEM WI WITH(NOLOCK) JOIN WORK_ITEM_ACTION WIA WITH(NOLOCK) ON WI.ID =WIA.WORK_ITEM_ID
WHERE WI.RELATE_ID IN (SELECT MESSAGE_ID FROM [DOCUMENT] WITH(NOLOCK) where ID = @DocumentID) AND  WIA.ACTION_CD = 'Import Completed'


CREATE TABLE [dbo].[#tmpTable](
	[ReportLoanUnMatch] [bit] NOT NULL DEFAULT 0,
	[ReportCollateralUnMatch] [bit] NOT NULL DEFAULT 0,
	[ReportNewLoan] [bit] NOT NULL DEFAULT 0,
	[ReportNewCollateral] [bit] NOT NULL DEFAULT 0,
	[ReportNameChange] [bit] NOT NULL DEFAULT 0,
	[ReportAddressChange] [bit] NOT NULL DEFAULT 0,
	[ReportCollDescriptionChange] [bit] NOT NULL DEFAULT 0,
	[ReportEffDateChange] [bit] NOT NULL DEFAULT 0,
	[ReportBalanceIncrease] [bit] NOT NULL DEFAULT 0,
	[ReportIsDropZeroBalance] [bit] NOT NULL DEFAULT 0,
	[ReportLoanReOccurance] [bit] NOT NULL DEFAULT 0,
	[ReportBadData] [bit] NOT NULL DEFAULT 0,
	[ReportUTLCollateral] [bit] NOT NULL DEFAULT 0,
	[ReportCPIInPlace] [bit] NOT NULL DEFAULT 0,
	[ReportPayOffRelease] [bit] NOT NULL DEFAULT 0,
	[ReportDeleteCount] [bit] NOT NULL DEFAULT 0,
	[ReportINSPolicyExist] [bit] NOT NULL DEFAULT 0,
	[ReportINSUTL] [bit] NOT NULL DEFAULT 0,
	[ReportINSUTLCollateral] [bit] NOT NULL DEFAULT 0,
	[ReportINSUTLCoverage] [bit] NOT NULL DEFAULT 0,
	[ReportCollRetainIndicator] [bit] NULL,
	[LOAN_OFFICER_CODE_TX] [nvarchar] (20) NULL,
	[LOAN_BRANCHCODE_TX] [nvarchar](20) NULL,
	[LOAN_DIVISIONCODE_TX] [nvarchar](20) NULL,
	[LOAN_TYPE_TX] [nvarchar](1000) NULL,
	[REQUIREDCOVERAGE_CODE_TX] [nvarchar](30) NULL,
	[REQUIREDCOVERAGE_TYPE_TX] [nvarchar](1000) NULL,
--LOAN
	[LOAN_NUMBER_TX] [nvarchar](20) NOT NULL,
	[LOAN_NUMBERSORT_TX] [nvarchar](22) NULL,
	[LOAN_EFFECTIVE_DT] [datetime2] NULL,
	[LOAN_EFFECTIVE_DT_BEFORE_CHANGE_DT] [datetime2] NULL,
	[LOAN_BALANCE_NO] [decimal](19, 2) NULL,					
	[LOAN_BALANCESORT_TX] [nvarchar](22) NULL,			
	[LOAN_BALANCE_BEFORE_CHANGE_NO] [decimal] (19,2) NULL,
	[CREDIT_LINE] [int] NULL,
	[CREDIT_LINE_AMOUNT_NO] [decimal](19, 2) NULL,				
	[PAYOFF_DT] [datetime2] NULL,								
	[LOAN_CREDITSCORECODE_TX] [nvarchar](20) NULL,
	[FILE_LOAN_CREDITSCORECODE_TX] [nvarchar](20) NULL,
--LENDER
	[LENDER_CODE_TX] [nvarchar](10) NULL,
	[LENDER_NAME_TX] [nvarchar](40) NULL,
--COLLATERAL
	[COLLATERAL_NUMBER_NO] [int] NULL,							
	[COLLATERAL_CODE_TX] [nvarchar](max) NULL,					
	[LENDER_COLLATERAL_CODE_TX] [nvarchar](10) NULL,			
	[FILE_LENDER_COLLATERAL_CODE_TX] [nvarchar](10) NULL,
	[LOAN_STATUSCODE] [nvarchar] (2) NULL,
	[COLLATERAL_STATUSCODE] [nvarchar] (2) NULL,
--OWNER
	[OWNER_LASTNAME_TX] [nvarchar](30) NULL,
	[OWNER_FIRSTNAME_TX] [nvarchar](30) NULL,
	[OWNER_MIDDLEINITIAL_TX] [char](1) NULL,
	[OWNER_NAME_TX] [nvarchar](max) NULL,
	[OWNER_COSIGN_TX] [nvarchar](1) NULL,
	[OWNER_LINE1_TX] [nvarchar](100) NULL,
	[OWNER_LINE2_TX] [nvarchar](100) NULL,
	[OWNER_STATE_TX] [nvarchar](30) NULL,						
	[OWNER_CITY_TX] [nvarchar](40) NULL,
	[OWNER_ZIP_TX] [nvarchar](30) NULL,
--PROPERTY
	[PROPERTY_TYPE_CD] [nvarchar](30) NULL,
	[PROPERTY_DESCRIPTION] [nvarchar](200) NULL,				
	[PROPERTY_DESCRIPTION_FILE] [nvarchar](200) NULL,			
	[COLLATERAL_VIN_TX] [nvarchar](18) NULL,					
	[COLLATERAL_VIN_FILE_TX] [nvarchar](18) NULL,					
	[COLLATERAL_STATE_TX] [nvarchar](30) NULL,					
--LENDER
	[LENDER_STATE_TX] [nvarchar](30) NULL,
--COVERAGE
	[REQUIREDCOVERAGE_REQUIREDAMOUNT_NO] [decimal](18, 2) NULL,
	[COVERAGE_STATUS_TX] [nvarchar](1000) NULL,					
	[COVERAGEWAIVE_MEANING_TX] [nvarchar](1000) NULL,			
	[REQUIREDCOVERAGE_STATUSCODE] [nvarchar](4) NULL,
	[COVERAGE_SUMMARY_SUB_STATUS_CD] [nvarchar](4) NULL,
	[CPI_ACTIVE_TX] [varchar](1) NULL,
--INSURANCE
	[INSCOMPANY_NAME_TX] [nvarchar](max) NULL, 					
	[INSCOMPANY_POLICY_NO] [nvarchar](30) NULL,					
	[CPI_PREMIUM_AMOUNT_NO] [decimal](18, 2) NULL,
	[PC_PREMIUM_AMOUNT_NO] [decimal](18, 2) NULL,
--BORROWER INSURANCE
	[BORRINSCOMPANY_EFF_DT] [datetime2](7) NULL,				
	[BORRINSCOMPANY_EXP_DT] [datetime2](7) NULL,				
	[BORRINSCOMPANY_CAN_DT] [datetime2](7) NULL,				
	[INSAGENCY_NAME_TX] [nvarchar](100) NULL,					
	[INSAGENCY_PHONE_TX] [nvarchar](20) NULL,					
	[INSAGENCY_EMAIL_TX] [nvarchar](100) NULL,					
	[INSAGENCY_FAX_TX] [nvarchar](20) NULL,						
--IDs, STATUS
	[LOAN_ID] [bigint] NULL,
	[COLLATERAL_ID] [bigint] NULL,
	[PROPERTY_ID] [bigint] NULL,
	[REQUIREDCOVERAGE_ID] [bigint] NULL,
	[LOAN_RECORDTYPE_TX][char](1) NULL,
	[RC_RECORDTYPE_TX][char](1) NULL,
	[P_RECORDTYPE_TX][char](1) NULL,
--LENDER FILE
	[EXTR_COVERAGE_STATUS_TX] [nvarchar](1000) NULL,			
	[EXTR_EXCEPTION] [nvarchar](1000) NULL,						
	[EXTR_RUN_DT] [datetime2](7) NULL,
	[WORK_ITEM_ID] [bigint] NULL,
	[LoanUpdatesOnlyOnLoan] char(1) NULL,								
--PARAMETERS
	[REPORT_GROUPBY_TX] [nvarchar](1000) NULL,
	[REPORT_SORTBY_TX] [nvarchar](1000) NULL,
	[REPORT_HEADER_TX] [nvarchar](1000) NULL,
	[REPORT_FOOTER_TX] [nvarchar](1000) NULL,
	[CPI_QUOTE_ID] bigint null

) ON [PRIMARY]

CREATE TABLE [dbo].[#tmpfilter](
	[ATTRIBUTE_CD] [nvarchar](50) NULL,
	[VALUE_TX] [nvarchar](50) NULL
) ON [PRIMARY]


Insert into #tmpfilter (
	ATTRIBUTE_CD,
	VALUE_TX)
Select
RAD.ATTRIBUTE_CD,
Case
  when Custom.VALUE_TX is not NULL then Custom.VALUE_TX
  when RA.VALUE_TX is not NULL then RA.VALUE_TX
  else RAD.VALUE_TX
End as VALUE_TX
from REF_CODE RC WITH(NOLOCK)
Join REF_CODE_ATTRIBUTE RAD WITH(NOLOCK) on RAD.DOMAIN_CD = RC.DOMAIN_CD and RAD.REF_CD = 'DEFAULT' and RAD.ATTRIBUTE_CD like 'FIL%'
left Join REF_CODE_ATTRIBUTE RA WITH(NOLOCK) on RA.DOMAIN_CD = RC.DOMAIN_CD and RA.REF_CD = RC.CODE_CD and RA.ATTRIBUTE_CD = RAD.ATTRIBUTE_CD
left Join
  (
  Select CODE_TX,REPORT_CD,REPORT_DOMAIN_CD,REPORT_REF_ATTRIBUTE_CD,VALUE_TX from REPORT_CONFIG RC WITH(NOLOCK)
  Join REPORT_CONFIG_ATTRIBUTE RCA WITH(NOLOCK) on RCA.REPORT_CONFIG_ID = RC.ID
  ) Custom
   on /**/Custom.CODE_TX = @ReportConfig and Custom.REPORT_DOMAIN_CD = RAD.DOMAIN_CD and Custom.REPORT_REF_ATTRIBUTE_CD = RAD.ATTRIBUTE_CD --and Custom.REPORT_CD = @ReportConfig
where RC.DOMAIN_CD = 'Report_Extract' and RC.CODE_CD = @ReportType

DECLARE @ACTIVE_POLICIES AS VARCHAR(1) = 'N'	
DECLARE @CPICOVERAGE AS VARCHAR(1) = 'N'	
DECLARE @CPIINPLACE AS VARCHAR(1) = 'N'	
DECLARE @EXTRNEW AS VARCHAR(1) = 'N'	
DECLARE @EXTRNUC AS VARCHAR(1) = 'N'	
DECLARE @EXTRXCPT AS VARCHAR(1) = 'N'	
DECLARE @EXTRXCPTNAME AS VARCHAR(1) = 'N'	
DECLARE @EXTRXCPTOTER AS VARCHAR(1) = 'N'	
DECLARE @GOODLOANS AS VARCHAR(1) = 'N'	
DECLARE @LOANPAYOFFDATEISNOTNULL AS VARCHAR(1) = 'N'	
DECLARE @NOCOSIGNER AS VARCHAR(1) = 'N'	
DECLARE @NOTREPOSSESSION AS VARCHAR(1) = 'N'	
DECLARE @NOTUNMATCHED AS VARCHAR(1) = 'N'	
DECLARE @PROPEXCEP AS VARCHAR(1) = 'N'	
DECLARE @REPOSSESSION AS VARCHAR(1) = 'N'	
DECLARE @SHOW_WORK_ITEM_ID AS VARCHAR(1) = 'N'

Select @ACTIVE_POLICIES =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_ACTIVE_POLICIES'
Select @CPICOVERAGE =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_CPICOVERAGE'
Select @CPIINPLACE =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_CPIINPLACE'
Select @EXTRNEW =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_EXTRNEW'
Select @EXTRNUC =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_EXTRNUC'
Select @EXTRXCPT =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_EXTRXCPT'
Select @EXTRXCPTNAME =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_EXTRXCPTNAME'
Select @EXTRXCPTOTER =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_EXTRXCPTOTER'
Select @GOODLOANS =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_GOODLOANS'
Select @LOANPAYOFFDATEISNOTNULL =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_LOANPAYOFFDATEISNOTNULL'
Select @NOCOSIGNER =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_NOCOSIGNER'
Select @NOTREPOSSESSION =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_NOTREPOSSESSION'
Select @NOTUNMATCHED =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_NOTUNMATCHED'
Select @PROPEXCEP =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_PROPEXCEP'
Select @REPOSSESSION =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_REPOSSESSION'
Select @SHOW_WORK_ITEM_ID =  ISNULL(Value_TX, 'N') from #tmpfilter where ATTRIBUTE_CD = 'FIL_SHOW_WORK_ITEM_ID'		

If @Debug > 0
Begin
	Select 'Debug'='#tmptilter:',* From #tmpfilter

	Select
	 'Debug'='@:'
	,'@ACTIVE_POLICIES'=@ACTIVE_POLICIES
	,'@CPICOVERAGE'=@CPICOVERAGE
	,'@CPIINPLACE'=@CPIINPLACE
	,'@EXTRNEW'=@EXTRNEW
	,'@EXTRNUC'=@EXTRNUC
	,'@EXTRXCPT'=@EXTRXCPT
	,'@EXTRXCPTNAME'=@EXTRXCPTNAME
	,'@EXTRXCPTOTER'=@EXTRXCPTOTER
	,'@GOODLOANS'=@GOODLOANS
	,'@LOANPAYOFFDATEISNOTNULL'=@LOANPAYOFFDATEISNOTNULL
	,'@NOCOSIGNER'=@NOCOSIGNER
	,'@NOTREPOSSESSION'=@NOTREPOSSESSION
	,'@NOTUNMATCHED'=@NOTUNMATCHED
	,'@PROPEXCEP'=@PROPEXCEP
	,'@REPOSSESSION'=@REPOSSESSION
	,'@SHOW_WORK_ITEM_ID'=@SHOW_WORK_ITEM_ID
End

DECLARE @WorkItemID bigint = 0
IF @SHOW_WORK_ITEM_ID = 'Y'
BEGIN
	SELECT @WorkItemID = MAX(WI.ID) FROM WORK_ITEM WI WITH(NOLOCK)
	WHERE  WI.RELATE_ID IN (SELECT MESSAGE_ID FROM [DOCUMENT] WITH(NOLOCK) where ID = @DocumentID)
		AND WI.RELATE_TYPE_CD = 'LDHLib.Message' AND WI.PURGE_DT IS NULL
END


--Loans
SELECT
	LoanNumber_TX AS LoanNumber,
	ContractStatus_TX AS ContractStatus,
	BranchName_TX AS BranchName,
	BranchCode_TX AS BranchCode,
	DivisionName_TX AS DivisionName,
	DivisionID_TX AS DivisionID,
	DivisionCode_TX AS DivisionCode,
	LoanEffectiveDate_DT AS LoanEffectiveDate,
	LoanExpirationDate_DT AS LoanExpirationDate,
	LoanTerm_TX AS LoanTerm,
	LoanType_TX AS LoanType,
	APR_TX AS APR,
	InterestRate_TX AS InterestRate,
	Margin_TX AS Margin,
	LoanIndex_TX AS LoanIndex,
	NextRateChangeDate_DT AS NextRateChangeDate,
	Balloon_IN,'N' AS Balloon,
	PaymentFrequency_TX AS PaymentFrequency,
	DropZeroBalanceID_TX AS DropZeroBalanceID,
	DropZeroBalance_TX AS DropZeroBalance,
	LoanOfficerName_TX AS LoanOfficerName,
	LoanOfficerTitle_TX AS LoanOfficerTitle,
	LoanOfficerPhone_TX AS LoanOfficerPhone,
	LoanOfficerFax_TX AS LoanOfficerFax,
	LoanOfficerEmail_TX AS LoanOfficerEmail,
	LoanOfficerNumber_TX AS LoanOfficerNumber,
	LoanDealerName_TX AS LoanDealerName,
	LoanDealerTitle_TX AS LoanDealerTitle,
	LoanDealerPhone_TX AS LoanDealerPhone,
	LoanDealerFax_TX AS LoanDealerFax,
	LoanDealerEmail_TX AS LoanDealerEmail,
	LoanDealerNumber_TX AS LoanDealerNumber,
	CASE WHEN ISNULL(Escrow_IN,'N') = 'Y' THEN 1 ELSE 0 END AS Escrow,
	LoanBalance_TX AS LoanBalance,
	OriginalBalance_TX AS OriginalBalance,
	CreditLineAmount_TX AS CreditLineAmount,
	CASE WHEN ISNULL(CreditLine_IN,'N') = 'Y' THEN 1 ELSE 0 END  CreditLine,
	LoanCreditScore_TX AS LoanCreditScore,
	RepaymentMethod_TX AS RepaymentMethod,
	CurrentPaymentAmount_TX AS CurrentPaymentAmount,
	PaymentFrequencyCode_TX AS PaymentFrequencyCode,
	OriginalPaymentAmount_TX AS OriginalPaymentAmount,
	PaymentEffectiveDate_DT AS PaymentEffectiveDate,
	NextScheduledPaymentDate_DT AS NextScheduledPaymentDate,
	LastPaymentReceivedDate_DT AS LastPaymentReceivedDate,
	DueNotPaidAmount_TX AS DueNotPaidAmount,
	LoanPayoffDate_DT AS LoanPayoffDate,
	NonAccrualDate_DT As NonAccrualDate,
	LTV_TX AS LTV,
	L.ExtractUnmatchCount_NO AS ExtractUnmatchCount,
	RecordTypeCode_TX AS RecordTypeCode,
	PartialPayBalance_TX AS PartialPayBalance,
	Misc1_Tx AS Misc1,
	Misc2_TX AS Misc2,
	Misc3_TX AS Misc3,
	Misc4_TX As Misc4,
--LoanMatchResult
	LM_MatchLoanId_TX AS LM_MatchLoanId,
	LM_MatchStatus_TX AS LM_MatchStatus,
	LM_ExtractUnmatchCount_NO AS LM_ExtractUnmatchCount,
	CASE WHEN ISNULL(LM_APRChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END  AS LM_APRChanged,
	LM_APR_NO AS LM_APR,
	CASE WHEN ISNULL(LM_IsDropZeroBalance_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_IsDropZeroBalance,
	CASE WHEN ISNULL(LM_DealerChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_DealerChanged,
	LM_Dealer_TX AS LM_Dealer,
	CASE WHEN ISNULL(LM_EffectiveDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_EffectiveDateChanged,
	LM_EffectiveDate_DT AS LM_EffectiveDate,
	CASE WHEN ISNULL(LM_ExpirationDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_ExpirationDateChanged,
	LM_ExpirationDate_DT AS LM_ExpirationDate,
	CASE WHEN ISNULL(LM_OfficerChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_OfficerChanged,
	LM_Officer_TX AS LM_Officer,
	CASE WHEN ISNULL(LM_PayoffDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_PayoffDateChanged,
	LM_PayoffDate_DT AS LM_PayoffDate,
	CASE WHEN ISNULL(LM_ReOccurance_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_ReOccurance,
	CASE WHEN ISNULL(LM_BalanceIncrease_IN,'N') = 'Y' THEN 1 ELSE 0 END LM_BalanceIncrease,
	CASE WHEN ISNULL(LM_BalanceDecrease_IN,'N') = 'Y' THEN 1 ELSE 0 END LM_BalanceDecrease,
	CASE WHEN ISNULL(LM_CPIInplace_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_CPIInplace,
	CASE WHEN ISNULL(LM_BalanceChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_BalanceChanged,
	LM_LoanChanged_IN AS LM_LoanChanged,
	CASE WHEN ISNULL(LM_CreditLineChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_CreditLineChanged,
	LM_CreditLine_TX AS LM_CreditLine,
	CASE WHEN ISNULL(LM_CreditLineAmountChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_CreditLineAmountChanged,
	LM_CreditLineAmount_TX AS LM_CreditLineAmount,
	CASE WHEN ISNULL(LM_CurrentPaymentAmountChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_CurrentPaymentAmountChanged,
	LM_CurrentPaymentAmount_TX AS LM_CurrentPaymentAmount,
	CASE WHEN ISNULL(LM_EscrowChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_EscrowChanged,
	CASE WHEN ISNULL(LM_Misc1Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Misc1Changed,
	CASE WHEN ISNULL(LM_Misc2Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Misc2Changed,
	CASE WHEN ISNULL(LM_Misc3Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Misc3Changed,
	CASE WHEN ISNULL(LM_Misc4Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Misc4Changed,
	CASE WHEN ISNULL(LM_NextScheduledPaymentDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_NextScheduledPaymentDateChanged,
	LM_NextScheduledPaymentDate_DT AS LM_NextScheduledPaymentDate,
	CASE WHEN ISNULL(LM_OriginalBalanceChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_OriginalBalanceChanged,
	LM_OriginalBalance_TX AS LM_OriginalBalance,
	CASE WHEN ISNULL(LM_OriginalPaymentAmountChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_OriginalPaymentAmountChanged,
	LM_OriginalPaymentAmount_TX AS LM_OriginalPaymentAmount,
	CASE WHEN ISNULL(LM_PaymentEffectiveDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_PaymentEffectiveDateChanged,
	LM_PaymentEffectiveDate_DT AS LM_PaymentEffectiveDate,
	CASE WHEN ISNULL(LM_PaymentFrequencyChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_PaymentFrequencyChanged,
	LM_PaymentFrequency_TX AS LM_PaymentFrequency,
	CASE WHEN ISNULL(LM_PartialPayBalanceChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END As LM_PartialPayBalanceChanged,
	CASE WHEN ISNULL(LM_Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Changed,
	LM_Balance_TX AS LM_Balance_TX,
	C.LenderCollateralCode_TX AS C_LenderCollateralCode,
	C.CollateralCode_TX AS C_CollateralCode,
	C.CollateralType_TX AS C_CollateralType,
	CASE
		WHEN Cast(C.CollateralNumber_TX As Int) NOT BETWEEN 1 AND CollCount.value
			THEN CollCount.value
		WHEN 1 <> IsNumeric(IsNull(RTrim(C.CollateralNumber_TX), ''))
			THEN CollCount.value
		WHEN LM_MatchStatus_TX = 'Match' and CM_MatchStatus_TX = 'New'
			THEN CollCount.value -- (Select COUNT(*) from COLLATERAL where EXTRACT_UNMATCH_COUNT_NO = 0 and STATUS_CD <> 'U' and PURGE_DT IS NULL and LOAN_ID = LM_MatchLoanId_TX)
		WHEN Cast(C.CollateralNumber_TX As Int) BETWEEN 1 AND CollCount.value
			THEN Cast(C.CollateralNumber_TX As Int)
		ELSE Cast(C.CollateralNumber_TX As Int)
	END AS C_CollateralNumber,
	C_CollateralNumberFix = Cast(C.CollateralNumber_TX As Int),
	CASE WHEN ISNULL(C.BadData_IN,'N') = 'Y' THEN 1 ELSE 0 END AS C_BadData,
	CASE WHEN ISNULL(C.MultiCollateral_IN,'N') = 'Y' THEN 1 ELSE 0 END AS C_MultiCollateral,
--CollateralMatchResult
	C.CM_MatchCollateralId_TX AS CM_MatchCollateralId,
	C.CM_MatchPropertyId_TX AS CM_MatchPropertyId,
	C.CM_MatchStatus_TX AS CM_MatchStatus,
	CASE WHEN ISNULL(C.CM_CPIInplace_IN,'N') = 'Y' THEN 1 ELSE 0 END AS CM_CPIInplace,
	CASE WHEN ISNULL(C.CM_PayoffRelease_IN,'N') = 'Y' THEN 1 ELSE 0 END AS CM_PayoffRelease,
	CASE WHEN ISNULL(C.CM_DescriptionChanged_IN ,'N') = 'Y' AND COALESCE(C.CM_Description_TX, '') <> '' THEN 1 ELSE 0 END AS CM_DescriptionChanged,
	C.EquipmentDescription_TX AS CM_Description,
	--Vehicle
	C.VehicleVIN_TX AS CV_VIN,				
	C.VehicleYear_TX AS CV_Year,
	C.VehicleMake_TX AS CV_Make,			
	C.VehicleModel_TX AS CV_Model,			
	--RealEstateProperty
	C.RealEstateLine1_TX + ' ' + C.RealEstateLine2_TX + ' ' + C.RealEstateCity_TX + ' ' + C.RealEstateState_TX + ' ' + C.RealEstateZip_TX AS CA_CollateralAddress,
	C.RealEstateLine1_TX AS CA_CollateralAddressLine1,
	C.RealEstateLine2_TX AS CA_CollateralAddressLine2,
	C.RealEstateCity_TX AS CA_CollateralAddressCity,
	C.RealEstateState_TX AS CA_CollateralAddressState,
	C.RealEstateZip_TX AS CA_CollateralAddressZip,
	CASE WHEN C.EquipmentRequiredCoverageAmt_TX IS NULL THEN 0 ELSE convert(decimal(19,2),C.EquipmentRequiredCoverageAmt_TX) END AS CE_EQRequiredCoverageAmt,
	--Equipment
	C.BorrInsCompanyName_TX AS C_BorrowerInsCompanyName,
	C.BorrInsPolicyNumber_TX AS C_BorrowerInsPolicyNumber,
	C.CM_ExtractUnmatchCount_NO AS CM_ExtractUnmatchCount,
	CASE WHEN ISNULL(C.Retain_IN ,'N') = 'Y' THEN 1 ELSE 0 END AS C_RetainIndicator

INTO 
	#Loans
FROM
	[LOAN_EXTRACT_TRANSACTION_DETAIL] L WITH(NOLOCK)
	JOIN [COLLATERAL_EXTRACT_TRANSACTION_DETAIL] C WITH(NOLOCK) ON C.TRANSACTION_ID = L.TRANSACTION_ID 
													  AND C.SEQUENCE_ID = L.SEQUENCE_ID 
													  AND C.PURGE_DT IS NULL
	CROSS APPLY (Select value=COUNT(*) from COLLATERAL As c2 with(nolock) where c2.EXTRACT_UNMATCH_COUNT_NO = 0 and c2.STATUS_CD <> 'U' and c2.PURGE_DT IS NULL and c2.LOAN_ID = LM_MatchLoanId_TX) As CollCount
WHERE 
	L.TRANSACTION_ID = @TransactionID	
	and NOT(LM_MatchStatus_TX = 'New' and LM_IsDropZeroBalance_IN = 'Y')		
	AND L.PURGE_DT IS NULL	
--OPTION(RECOMPILE)

/* fix CollateralNumber: */
;WITH CollNum AS
(Select LM_MatchLoanId,CM_MatchCollateralId,ROWNUMBER=ROW_NUMBER() OVER (PARTITION BY LM_MatchLoanId ORDER BY CM_MatchCollateralId) From #Loans)
UPDATE Loans
SET C_CollateralNumberFix =
	Case
		--When CM_MatchStatus = 'Unmatch'
		--	Then 0
		WHEN col.STATUS_CD = 'I' OR col.PURGE_DT IS NOT NULL
			THEN 0
		WHEN Loans.LM_MatchLoanId = 0
			THEN 1
		WHEN Loans.CM_MatchCollateralId = 0
			THEN 1
		WHEN 1 <> IsNumeric(IsNull(RTrim(Loans.C_CollateralNumber), ''))
			THEN CollNum.ROWNUMBER
		WHEN Cast(Loans.C_CollateralNumber As Int) NOT BETWEEN 1 AND CollCount.value
			THEN CollNum.ROWNUMBER
		WHEN Exists(Select 1 From #Loans As Loans2 With(NoLock) Where Loans2.LM_MatchLoanId = Loans.LM_MatchLoanId And Loans2.CM_MatchCollateralId <> Loans.CM_MatchCollateralId And Loans2.C_CollateralNumber = CollCount.value)
			THEN CollNum.ROWNUMBER
		WHEN LM_MatchStatus = 'Match' and CM_MatchStatus = 'New'
			THEN CollCount.value
		WHEN Exists(Select 1 From #Loans As Loans2 With(NoLock) Where Loans2.LM_MatchLoanId = Loans.LM_MatchLoanId And Loans2.CM_MatchCollateralId <> Loans.CM_MatchCollateralId And Loans2.C_CollateralNumber = Loans.C_CollateralNumber)
			THEN CollNum.ROWNUMBER
		WHEN Cast(C_CollateralNumber As Int) BETWEEN 1 AND CollCount.value
			THEN Cast(C_CollateralNumber As Int)
		Else Coalesce(CollNum.ROWNUMBER, Loans.C_CollateralNumber, CollCount.value, 0)
	End
FROM (Select Top 100 Percent * From #Loans As Loans Order By Loans.LM_MatchLoanId,Case Loans.CM_MatchStatus When 'Unmatch'  Then 3 When 'New' Then 2 When 'Match' Then 1 Else 0 End,Loans.C_CollateralNumber,Loans.CM_MatchCollateralId) As Loans
CROSS APPLY (Select value=COUNT(*) from COLLATERAL As c2 WITH(NOLOCK) LEFT JOIN PROPERTY As p2 WITH(NOLOCK) ON p2.ID = c2.PROPERTY_ID where c2.LOAN_ID = LM_MatchLoanId And /*c2.EXTRACT_UNMATCH_COUNT_NO = 0 and c2.STATUS_CD <> 'U' and*/ c2.STATUS_CD <> 'I' And p2.RECORD_TYPE_CD <> 'D' And p2.PURGE_DT IS NULL And c2.PURGE_DT IS NULL) As CollCount
LEFT JOIN COLLATERAL As col With(NoLock) On col.LOAN_ID = LM_MatchLoanId And col.ID = CM_MatchCollateralId
LEFT JOIN CollNum WITH(NOLOCK) On CollNum.LM_MatchLoanId = Loans.LM_MatchLoanId And CollNum.CM_MatchCollateralId = Loans.CM_MatchCollateralId
--WHERE Exists(Select 1 From #Loans As Loans2 Where Loans2.LM_MatchLoanId = Loans.LM_MatchLoanId
--And (Loans.C_CollateralNumber > CollCount.value OR (Loans2.C_CollateralNumber = Loans.C_CollateralNumber And Loans2.CM_MatchCollateralId <> Loans.CM_MatchCollateralId) OR CollStat.C_STATUS_CD <> 'A')
--)

/* now update CollateralNumber with CollateralNumberFix: */
Begin
	UPDATE Loans
	SET C_CollateralNumber = C_CollateralNumberFix
	FROM #Loans As Loans
	WHERE Loans.C_CollateralNumber <> Loans.C_CollateralNumberFix

	Declare @rcFixed As Decimal = @@ROWCOUNT
	Declare @rcTotal As Decimal
		Select @rcTotal = Count(*) From #Loans
	If @Debug > 1 Select 'Debug'='@@ROWCOUNT fixed:','@rcFixed'=@rcFixed,'Count(*)'=@rcTotal,'Percent'=@rcFixed / IsNull(NullIf(@rcTotal, 0), 1) * 100
End

SELECT
	L.LoanNumber_TX AS LoanNumber,
	O.LastName_TX AS O_LastName,
	O.FirstName_TX AS O_FirstName,
	O.MiddleInitial_TX AS O_MiddleInitial,
	--CustAddress
	O.Line1_TX AS OA_Line1,
	O.City_TX AS OA_City,
	O.State_TX AS OA_State,
	O.Zip_TX AS OA_Zip,
	--CustomerMatchResult
	O.CM_MatchOwnerId_TX AS OM_OwnerId,
	CASE WHEN ISNULL(O.CM_NameChanged_IN ,'N') = 'Y' THEN 1 ELSE 0 END AS OM_NameChanged,
	CASE WHEN ISNULL(O.CM_AddressChanged_IN ,'N') = 'Y' THEN 1 ELSE 0 END AS OM_AddressChanged
--CustomerMatchResult
INTO 
	#Customers
FROM 
	[LOAN_EXTRACT_TRANSACTION_DETAIL] L WITH(NOLOCK)
	JOIN [OWNER_EXTRACT_TRANSACTION_DETAIL] O WITH(NOLOCK) ON O.TRANSACTION_ID = L.TRANSACTION_ID 
												 AND O.SEQUENCE_ID = L.SEQUENCE_ID 
												 AND O.PURGE_DT IS NULL
												 AND O.TYPE_TX = 'Borrower'
WHERE 
	L.TRANSACTION_ID = @TransactionID
	AND L.PURGE_DT IS NULL

If @Debug > 1
Begin
	Select 'Debug'='#Customers:',* From #Customers
End

SELECT 
		X.LoanNumber,
		X.DivisionID,
		X.LoanType,
		O_LastName,
		O_FirstName,
		O_MiddleInitial,
		OA_Line1,
		OA_City,
		OA_State,
		OA_Zip,
		CV_Year,
		CV_Make,
		CV_Model,
		CV_VIN,
		CA_CollateralAddress,
		CA_CollateralAddressLine1,
		CA_CollateralAddressLine2,
		CA_CollateralAddressCity,
		CA_CollateralAddressState,
		CA_CollateralAddressZip,
		CM_Description,
		X.LM_MatchStatus,
		X.CM_MatchStatus,
		CU.OM_NameChanged,
		CU.OM_AddressChanged,
		X.CM_DescriptionChanged,
		X.LM_EffectiveDateChanged,
		X.OriginalBalance,
		X.LoanBalance,
		X.LM_BalanceIncrease,
		X.LM_IsDropZeroBalance,
		X.LM_ReOccurance,
		X.C_BadData,
		X.LM_CPIInplace,
		X.CM_CPIInplace,
		X.CM_PayoffRelease,
		X.LoanEffectiveDate,
		CASE
			WHEN (LO.CODE_TX = '3' OR LO.CODE_TX = '8') AND ISNULL(CV_Year,'') <> '' THEN CV_Year + ' ' + CV_Make + '/' + CV_Model
			ELSE ''
		END AS PropertyDescriotion,
		CreditLine,
		CreditLineAmount,
		LoanCreditScore,
		X.C_LenderCollateralCode,
		LM_Officer,
		LM_ExtractUnmatchCount,
		CM_ExtractUnmatchCount,
		X.C_RetainIndicator,
		LM_MatchLoanId,
		CM_MatchCollateralId,
		CM_MatchPropertyId,
		C_MultiCollateral,
		LoanOfficerNumber,
		CU.OM_OwnerId,
		LO.CODE_TX as DivisionCode,
		X.BranchCode,
		X.LoanPayoffDate,
		X.C_CollateralCode,
		X.C_CollateralType,
		X.CE_EQRequiredCoverageAmt,
		X.C_CollateralNumber,								
		X.C_BorrowerInsCompanyName,
		X.C_BorrowerInsPolicyNumber,									
		X.LM_Balance_TX,
		X.LM_EffectiveDate												
INTO #EX
FROM #Loans X WITH(NOLOCK)
LEFT JOIN #Customers CU ON X.LoanNumber = CU.LoanNumber --AND CU.O_CustomerType = 'Borrower'
--LEFT JOIN #Collaterals CO ON X.LoanNumber = CO.LoanNumber AND (CM_MatchCollateralId > 0 OR ISNULL(CM_MatchStatus,'') = 'New')
left join LENDER_ORGANIZATION LO WITH(NOLOCK) on LO.ID = X.DivisionID and X.DivisionCode is not null

If @Debug > 1
Begin
	Select 'Debug'='#EX:',* From #EX
End

--Truncate most of the values of the #EX for the 'EXTRNEW-01'
IF @ReportConfig = 'EXTRNEW-01'
BEGIN
	DECLARE @columnNames as nvarchar(max)

	SELECT @columnNames =  coalesce(@columnNames, 'SET ') + '[' + name + ']=NULL,'
	FROM tempdb.sys.columns
	WHERE object_id = object_id('tempdb..#EX') 
	AND name not in
		('LM_MatchLoanId',
		'OM_OwnerId',
		'CM_MatchCollateralId',
		'CM_MatchPropertyId',
		'DivisionCode',
		'LM_MatchStatus',
		'CM_MatchStatus',
		'OM_NameChanged',
		'OM_AddressChanged',
		'CM_DescriptionChanged',
		'LM_EffectiveDateChanged',
		'LM_BalanceIncrease',
		'LM_IsDropZeroBalance',
		'LM_ReOccurance',
		'C_BadData',
		'C_MultiCollateral',
		'LM_CPIInplace',
		'CreditLine') 
	--need these fields to meet the filter for EXTRNEW-01; all other fields should be blank

	SET @sqlstring = N'UPDATE #EX ' +stuff(@columnNames, len(@columnNames),1,'')

	EXECUTE sp_executesql @sqlstring
END



INSERT INTO [#tmpTable]
([ReportLoanUnMatch]
,[ReportCollateralUnMatch]
,[ReportNewLoan]
,[ReportNewCollateral]
,[ReportNameChange]
,[ReportAddressChange]
,[ReportCollDescriptionChange]
,[ReportEffDateChange]
,[ReportBalanceIncrease]
,[ReportIsDropZeroBalance]
,[ReportLoanReOccurance]
,[ReportBadData]
,[ReportUTLCollateral]
,[ReportCPIInPlace]
,[ReportPayOffRelease]
,[ReportDeleteCount]
,[ReportINSPolicyExist]
,[ReportINSUTL]
,[ReportINSUTLCollateral]
,[ReportINSUTLCoverage]
,[ReportCollRetainIndicator]
,[LOAN_OFFICER_CODE_TX]
,[LOAN_BRANCHCODE_TX]
,[LOAN_DIVISIONCODE_TX]
,[LOAN_TYPE_TX]
,[REQUIREDCOVERAGE_CODE_TX]
,[REQUIREDCOVERAGE_TYPE_TX]
,[LOAN_NUMBER_TX]
,[LOAN_NUMBERSORT_TX]
,[LOAN_EFFECTIVE_DT]
,[LOAN_EFFECTIVE_DT_BEFORE_CHANGE_DT]	
,[LOAN_BALANCE_NO]
,[LOAN_BALANCESORT_TX]
,[LOAN_BALANCE_BEFORE_CHANGE_NO]		
,[CREDIT_LINE]
,[CREDIT_LINE_AMOUNT_NO]
,[PAYOFF_DT]
,[LOAN_CREDITSCORECODE_TX]
,[FILE_LOAN_CREDITSCORECODE_TX]
,[LENDER_CODE_TX]
,[LENDER_NAME_TX]
,[COLLATERAL_NUMBER_NO]
,[COLLATERAL_CODE_TX]
,[LENDER_COLLATERAL_CODE_TX]
,[FILE_LENDER_COLLATERAL_CODE_TX]
,[LOAN_STATUSCODE]
,[COLLATERAL_STATUSCODE]
,[OWNER_LASTNAME_TX]
,[OWNER_FIRSTNAME_TX]
,[OWNER_MIDDLEINITIAL_TX]
,[OWNER_NAME_TX]
,[OWNER_COSIGN_TX]
,[OWNER_LINE1_TX]
,[OWNER_LINE2_TX]
,[OWNER_STATE_TX]
,[OWNER_CITY_TX]
,[OWNER_ZIP_TX]
,[PROPERTY_TYPE_CD]
,[PROPERTY_DESCRIPTION]
,[PROPERTY_DESCRIPTION_FILE]
,[COLLATERAL_VIN_TX]
,[COLLATERAL_VIN_FILE_TX]
,[COLLATERAL_STATE_TX]
,[LENDER_STATE_TX]
,[REQUIREDCOVERAGE_REQUIREDAMOUNT_NO]
,[COVERAGE_STATUS_TX]
,[COVERAGEWAIVE_MEANING_TX]
,[REQUIREDCOVERAGE_STATUSCODE]
,[COVERAGE_SUMMARY_SUB_STATUS_CD]
,[CPI_ACTIVE_TX]
,[INSCOMPANY_NAME_TX]
,[INSCOMPANY_POLICY_NO]
,[CPI_PREMIUM_AMOUNT_NO]
,[PC_PREMIUM_AMOUNT_NO]
,[BORRINSCOMPANY_EFF_DT]
,[BORRINSCOMPANY_EXP_DT]
,[BORRINSCOMPANY_CAN_DT]
,[INSAGENCY_NAME_TX]
,[INSAGENCY_PHONE_TX]
,[INSAGENCY_EMAIL_TX]
,[INSAGENCY_FAX_TX]
,[LOAN_ID]
,[COLLATERAL_ID]
,[PROPERTY_ID]
,[REQUIREDCOVERAGE_ID]
,[LOAN_RECORDTYPE_TX]
,[RC_RECORDTYPE_TX]
,[P_RECORDTYPE_TX]
,[EXTR_COVERAGE_STATUS_TX]
,[EXTR_EXCEPTION]
,[EXTR_RUN_DT]
,[WORK_ITEM_ID]					
,[LoanUpdatesOnlyOnLoan]
,[CPI_QUOTE_ID]
)

(
SELECT
CASE WHEN #EX.LM_MatchStatus = 'Unmatch' OR (L.EXTRACT_UNMATCH_COUNT_NO > 0 AND #EX.LM_IsDropZeroBalance = 1) THEN 1 ELSE 0 END AS [ReportLoanUnMatch],
CASE WHEN #EX.CM_MatchStatus = 'Unmatch' THEN 1 ELSE 0 END AS [ReportCollateralUnMatch],
CASE WHEN #EX.LM_MatchStatus  = 'New' THEN 1 ELSE 0 END AS [ReportNewLoan],
CASE WHEN #EX.CM_MatchStatus = 'New' THEN 1 ELSE 0 END AS [ReportNewCollateral],
CASE WHEN #EX.OM_NameChanged = 1 THEN 1 ELSE 0 END AS [ReportNameChange],
CASE WHEN #EX.OM_AddressChanged = 1 THEN 1 ELSE 0 END AS [ReportAddressChange],
CASE WHEN #EX.CM_DescriptionChanged = 1 THEN 1 ELSE 0 END AS [ReportCollDescriptionChange],
CASE WHEN #EX.LM_EffectiveDateChanged = 1 THEN 1 ELSE 0 END AS [ReportEffDateChange],
CASE WHEN #EX.LM_BalanceIncrease = 1 THEN 1 ELSE 0 END AS [ReportBalanceIncrease],
CASE WHEN #EX.LM_IsDropZeroBalance = 1 THEN 1 ELSE 0 END AS [ReportIsDropZeroBalance],
ISNULL(LM_ReOccurance, 0) AS [ReportLoanReOccurance],
CASE WHEN (C_BadData = 1) THEN 1 ELSE 0 END AS [ReportBadData],
0 AS [ReportUTLCollateral],		--(Mayank) ReportUTLCollateral is MultiCollateral under Collateral  //if multiple match, picks the best match. So no UTL coll.
ISNULL(LM_CPIInplace, 0) AS [ReportCPIInPlace],
ISNULL(CM_PayoffRelease,0) AS [ReportPayOffRelease],
0 AS [ReportDeleteCount],
0 AS [ReportINSPolicyExist],
0 AS [ReportINSUTL],
0 AS [ReportINSUTLCollateral],
0 AS [ReportINSUTLCoverage],
#EX.C_RetainIndicator AS [ReportCollRetainIndicator],
ISNULL(ISNULL(L.OFFICER_CODE_TX,#EX.LoanOfficerNumber),'') AS [LOAN_OFFICER_CODE_TX],	
ISNULL(L.BRANCH_CODE_TX,#EX.BranchCode) AS [LOAN_BRANCHCODE_TX],
COALESCE(L.DIVISION_CODE_TX,#EX.DivisionCode, '') AS [LOAN_DIVISIONCODE_TX],	
ISNULL(RCDiv.MEANING_TX,RC_SC.DESCRIPTION_TX) AS [LOAN_TYPE_TX],
RC.TYPE_CD AS [REQUIREDCOVERAGE_CODE_TX],
RC_COVERAGETYPE.MEANING_TX as [REQUIREDCOVERAGE_TYPE_TX],
ISNULL(ISNULL(L.NUMBER_TX,#EX.LoanNumber),'') AS [LOAN_NUMBER_TX],
CASE WHEN ISNULL(ISNULL(L.NUMBER_TX,#EX.LoanNumber),'') = '' 
	THEN '' 
	ELSE SUBSTRING(@FillerZero, 1, 22 - len(ISNULL(ISNULL(L.NUMBER_TX,#EX.LoanNumber),''))) 
		+ CAST(ISNULL(ISNULL(L.NUMBER_TX,#EX.LoanNumber),'') AS nvarchar(22)) END AS [LOAN_NUMBERSORT_TX],
CASE WHEN #EX.LM_EffectiveDateChanged = 1 
	THEN #EX.LoanEffectiveDate 
	ELSE ISNULL(CAST(L.EFFECTIVE_DT AS datetime2(7)),#EX.LoanEffectiveDate) END AS [LOAN_EFFECTIVE_DT],
#EX.LM_EffectiveDate AS [LOAN_EFFECTIVE_DT_BEFORE_CHANGE_DT],								
ISNULL(#EX.LoanBalance, L.BALANCE_AMOUNT_NO) AS [LOAN_BALANCE_NO],
SUBSTRING(@FillerZero, 1, 22 - len(ISNULL(L.BALANCE_AMOUNT_NO,#EX.LoanBalance))) + CAST(ISNULL(L.BALANCE_AMOUNT_NO,#EX.LoanBalance) AS nvarchar(22)) AS [LOAN_BALANCESORT_TX],
#EX.LM_Balance_TX As [LOAN_BALANCE_BEFORE_CHANGE_NO],			
CASE WHEN (L.TYPE_CD = 'CL') THEN 1 ELSE #EX.CreditLine END AS [CREDIT_LINE],
ISNULL(L.CREDIT_LINE_AMOUNT_NO,#EX.CreditLineAmount) AS [CREDIT_LINE_AMOUNT_NO],
ISNULL(CAST(L.PAYOFF_DT AS datetime2(7)),#EX.LoanPayoffDate) AS [PAYOFF_DT],
ISNULL(L.CREDIT_SCORE_CD,#EX.LoanCreditScore) AS [LOAN_CREDITSCORECODE_TX],
ISNULL(#EX.LoanCreditScore,'') AS [FILE_LOAN_CREDITSCORECODE_TX],
LND.CODE_TX AS [LENDER_CODE_TX],
LND.NAME_TX AS [LENDER_NAME_TX],
ISNULL(C.COLLATERAL_NUMBER_NO, #EX.C_CollateralNumber) AS [COLLATERAL_NUMBER_NO],
ISNULL(CC.CODE_TX,#EX.C_CollateralCode) AS [COLLATERAL_CODE_TX],
ISNULL(C.LENDER_COLLATERAL_CODE_TX,#EX.C_LenderCollateralCode) AS [LENDER_COLLATERAL_CODE_TX],
ISNULL(#EX.C_LenderCollateralCode,'') AS [FILE_LENDER_COLLATERAL_CODE_TX],
L.STATUS_CD AS [LOAN_STATUSCODE],
C.STATUS_CD AS [COLLATERAL_STATUSCODE],
ISNULL(ISNULL(O.LAST_NAME_TX,#EX.O_LastName),'') AS [OWNER_LASTNAME_TX],
ISNULL(ISNULL(O.FIRST_NAME_TX,#EX.O_FirstName),'') AS [OWNER_FIRSTNAME_TX],
ISNULL(ISNULL(O.MIDDLE_INITIAL_TX,#EX.O_MiddleInitial),'') AS [OWNER_MIDDLEINITIAL_TX],
RTRIM(ISNULL(ISNULL(O.LAST_NAME_TX,#EX.O_LastName),'') + ', ' 
	+ ISNULL(ISNULL(O.FIRST_NAME_TX,#EX.O_FirstName),'') + ' ' 
	+ ISNULL(ISNULL(O.MIDDLE_INITIAL_TX,#EX.O_MiddleInitial),'')) AS [OWNER_NAME_TX],
'' AS [COSIGN_TX],
ISNULL(ISNULL(AO.LINE_1_TX,#EX.OA_Line1),'') AS [OWNER_LINE1_TX],
ISNULL(AO.LINE_2_TX,'') AS [OWNER_LINE2_TX],
ISNULL(ISNULL(AO.STATE_PROV_TX,#EX.OA_State),'') AS [OWNER_STATE_TX],
ISNULL(ISNULL(AO.CITY_TX,#EX.OA_City),'') AS [OWNER_CITY_TX],
ISNULL(ISNULL(AO.POSTAL_CODE_TX,#EX.OA_Zip),'') AS [OWNER_ZIP_TX],
ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) AS [PROPERTY_TYPE_CD],
NULL AS [PROPERTY_DESCRIPTION],--dbo.fn_GetPropertyDescriptionForReports(C.ID) AS [PROPERTY_DESCRIPTION],
CASE
	WHEN ISNULL(ISNULL(L.DIVISION_CODE_TX,#EX.DivisionCode),'0') in ('3','8') OR ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) in ('VEH','BOAT')
		THEN ISNULL(#EX.CV_Year,'') + ' ' + ISNULL(#EX.CV_Make,'') + '/' + ISNULL(#EX.CV_Model,'')
	WHEN ISNULL(ISNULL(L.DIVISION_CODE_TX,#EX.DivisionCode),'0') in ('7','9') OR ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) in ('EQ')
		THEN ISNULL(#EX.CM_Description,'')
	WHEN ISNULL(ISNULL(L.DIVISION_CODE_TX,#EX.DivisionCode),'0') in ('4','10') OR ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) not in ('','VEH','BOAT','EQ','MH')
		THEN ISNULL(#EX.CA_CollateralAddressLine1, '') + CHAR(13) + CHAR(10) + ISNULL(#EX.CA_CollateralAddressLine2 + CHAR(13) + CHAR(10),'') + COALESCE(#EX.CA_CollateralAddressCity + ', ', '') 
				+ ISNULL(#EX.CA_CollateralAddressState, '') + ' ' + ISNULL(#EX.CA_CollateralAddressZip, '')		
	WHEN ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) = 'MH'
		THEN CASE WHEN CC.VEHICLE_LOOKUP_IN = 'Y'
					THEN ISNULL(#EX.CV_Year,'') + ' ' + ISNULL(#EX.CV_Make,'') + '/' + ISNULL(#EX.CV_Model,'')
				 ELSE  ISNULL(#EX.CA_CollateralAddressLine1, '') + CHAR(13) + CHAR(10) + ISNULL(#EX.CA_CollateralAddressLine2 + CHAR(13) + CHAR(10),'') + COALESCE(#EX.CA_CollateralAddressCity + ', ', '')  
						+ ISNULL(#EX.CA_CollateralAddressState, '') + ' ' + ISNULL(#EX.CA_CollateralAddressZip, '')
				END
	ELSE ''
END AS [PROPERTY_DESCRIPTION_FILE],

ISNULL(P.VIN_TX,'') AS [COLLATERAL_VIN_TX],
ISNULL(#EX.CV_VIN,'') AS [COLLATERAL_VIN_FILE_TX],
AM.STATE_PROV_TX AS [COLLATERAL_STATE_TX],
AL.STATE_PROV_TX AS [LENDER_STATE_TX],
ISNULL(RC.REQUIRED_AMOUNT_NO, #EX.CE_EQRequiredCoverageAmt) AS [REQUIREDCOVERAGE_REQUIREDAMOUNT_NO],
CASE
	WHEN RC.NOTICE_DT is not null and RC.NOTICE_SEQ_NO > 0
		THEN cast(RC.NOTICE_SEQ_NO as char(1)) +  ' ' + NRef.MEANING_TX + ' ' + CONVERT(nvarchar(10), RC.NOTICE_DT, 101)
	ELSE CASE
	WHEN L.STATUS_CD in ('N','O','P') THEN LSRef.MEANING_TX
	WHEN C.STATUS_CD in ('R','S','X') THEN CSRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD not in ('A','D','T')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN CSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN CSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD not in ('A','D','T')
			THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD not in ('A','D','T')
			THEN RCSRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD not in ('A','D','T')
			THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
   END
END AS [COVERAGE_STATUS_TX],
'' AS [COVERAGEWAIVE_MEANING_TX],
RC.STATUS_CD AS [REQUIREDCOVERAGE_STATUSCODE],
RC.SUMMARY_SUB_STATUS_CD AS [COVERAGE_SUMMARY_SUB_STATUS_CD],
FPC.ACTIVE_IN AS [CPI_ACTIVE_TX],
CASE
	WHEN #EX.C_BorrowerInsCompanyName IS NOT NULL THEN #EX.C_BorrowerInsCompanyName
	WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' THEN CR.NAME_TX
	WHEN RC.SUMMARY_SUB_STATUS_CD = 'P' THEN PCP.INSURANCE_COMPANY_NAME_TX
	ELSE NULL--OP.BIC_NAME_TX
END AS [INSCOMPANY_NAME_TX],
CASE
	WHEN #EX.C_BorrowerInsPolicyNumber IS NOT NULL THEN #EX.C_BorrowerInsPolicyNumber
	WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' THEN FPC.NUMBER_TX
	WHEN RC.SUMMARY_SUB_STATUS_CD = 'P' THEN PCP.POLICY_NUMBER_TX
	ELSE NULL--OP.POLICY_NUMBER_TX
END AS [INSCOMPANY_POLICY_NO],
NULL AS [CPI_PREMIUM_AMOUNT_NO], --CASE WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' THEN ISNULL(CDPRM.AMOUNT_NO,0) ELSE NULL END AS [CPI_PREMIUM_AMOUNT_NO],
NULL AS [PC_PREMIUM_AMOUNT_NO], --CASE WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' THEN ISNULL(CDPRM.AMOUNT_NO,0) ELSE NULL END AS [PC_PREMIUM_AMOUNT_NO],

NULL,--OP.EFFECTIVE_DT AS [BORRINSCOMPANY_EFF_DT],
NULL,--CASE WHEN YEAR(OP.EXPIRATION_DT) = '9999' THEN NULL ELSE OP.EXPIRATION_DT END AS [BORRINSCOMPANY_EXP_DT],
NULL,--OP.CANCELLATION_DT AS [BORRINSCOMPANY_CAN_DT],
NULL,--OP.BIC_NAME_TX AS [INSAGENCY_NAME_TX],
NULL,--BIA.PHONE_EXT_TX AS [INSAGENCY_PHONE_TX],
NULL,--BIA.EMAIL_TX AS [INSAGENCY_EMAIL_TX],
NULL,--BIA.FAX_EXT_TX AS [INSAGENCY_FAX_TX],
L.ID AS [LOAN_ID],
C.ID AS [COLLATERAL_ID],
P.ID AS [PROPERTY_ID],
RC.ID AS [REQUIREDCOVERAGE_ID],
L.RECORD_TYPE_CD AS [LOAN_RECORDTYPE_TX],
RC.RECORD_TYPE_CD AS [RC_RECORDTYPE_TX],
P.RECORD_TYPE_CD AS [P_RECORDTYPE_TX],
CASE
	WHEN @ReportConfig = 'EXTRNEW-01' THEN
		CASE WHEN DATEDIFF(D, L.CREATE_DT, C.CREATE_DT) = 0 AND L.SOURCE_CD = 'E' AND P.SOURCE_CD= 'EX' THEN 'New Loan'
			WHEN DATEDIFF(d, L.CREATE_DT, C.CREATE_DT) <> 0 AND L.SOURCE_CD = 'E' AND P.SOURCE_CD= 'EX' THEN 'New Collateral'
			ELSE 'New Loan'
		END
	WHEN #EX.LM_MatchStatus = 'New' and DATEDIFF(d, GETDATE(), COALESCE(L.EFFECTIVE_DT,#EX.LoanEffectiveDate)) > 90 THEN 'Audit Loan'
	WHEN #EX.LM_MatchStatus = 'New' and (DATEDIFF(d, GETDATE(), COALESCE(L.EFFECTIVE_DT,#EX.LoanEffectiveDate)) <= 90 OR L.EFFECTIVE_DT IS NULL) THEN 'New Loan'
	WHEN #EX.CM_MatchStatus = 'New' and #EX.LM_IsDropZeroBalance = 0 THEN 'New Collateral'
	WHEN #EX.LM_IsDropZeroBalance = 1 AND L.EXTRACT_UNMATCH_COUNT_NO > 0 AND L.RECORD_TYPE_CD != 'D' 
		THEN CAST(L.EXTRACT_UNMATCH_COUNT_NO AS nvarchar(20)) 
		 + (CASE L.EXTRACT_UNMATCH_COUNT_NO WHEN 1 THEN 'st' WHEN 2 THEN 'nd' when 3 then 'rd' when 4 then 'th' ELSE '' END) + ' Unmatch Loan'
	WHEN L.RECORD_TYPE_CD IN ('D') THEN  'Loan Deleted'
	WHEN #EX.LM_ExtractUnmatchCount > 0 AND #EX.LM_ExtractUnmatchCount < 4 
		THEN CAST(#EX.LM_ExtractUnmatchCount AS nvarchar(20)) 
			+ (CASE #EX.LM_ExtractUnmatchCount WHEN 1 THEN 'st' WHEN 2 THEN 'nd' when 3 then 'rd' ELSE '' END) + ' Unmatch Loan'
	WHEN #EX.LM_ExtractUnmatchCount = 0 AND #EX.LM_MatchStatus = 'Unmatch' THEN 'Unmatch Loan'
	WHEN #EX.LM_ExtractUnmatchCount > 3 THEN  'Loan Deleted'
	WHEN #EX.CM_ExtractUnmatchCount > 0 AND #EX.CM_ExtractUnmatchCount < 4 
		THEN CAST(#EX.CM_ExtractUnmatchCount AS nvarchar(20)) 
			+ (CASE #EX.CM_ExtractUnmatchCount WHEN  1 THEN 'st' WHEN 2 THEN 'nd' when 3 then 'rd' ELSE '' END) + ' Unmatch Collateral'
	WHEN #EX.CM_ExtractUnmatchCount = 0 AND #EX.CM_MatchStatus = 'Unmatch' THEN 'Unmatch Collateral'
	WHEN #EX.CM_ExtractUnmatchCount > 3 THEN  'Collateral Deleted'
	ELSE ''
END AS [EXTR_COVERAGE_STATUS_TX],
--needs to be multiline
	CASE
		WHEN (FPC.STATUS_CD = 'F')
			THEN '-CPI InForce (currently)' + CHAR(13) + CHAR(10)
		WHEN (CM_CPIInplace = 1 OR LM_CPIInplace = 1)
			THEN '-CPI InForce (when the import was taken)' + CHAR(13) + CHAR(10)
		ELSE '' END +
	CASE WHEN OM_NameChanged = 1 THEN '-Name Change' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN OM_AddressChanged = 1 THEN '-Address Changed' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN (CM_DescriptionChanged = 1 AND ISNULL(P.VIN_TX,'') <> ISNULL(#EX.CV_VIN,'')) 
		THEN '-Collateral Description Changed(Old VIN: ' + ISNULL(#EX.CV_VIN,'MISSING') + ')' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN (CM_DescriptionChanged = 1 AND ISNULL(P.VIN_TX,'') = ISNULL(#EX.CV_VIN,'')) 
		THEN '-Collateral Description Changed' + CHAR(13) + CHAR(10) ELSE '' END + 
	CASE WHEN LM_ReOccurance = 1 THEN '-Loan Reoccurence' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN LM_EffectiveDateChanged = 1 
		THEN '-Effective Date Change(Old: ' + isnull(CONVERT(nvarchar(10),LM_EffectiveDate,101),'MISSING') + ')' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN #EX.LM_BalanceIncrease = 1 
		THEN '-Balance Increase(Old: ' + CONVERT(nvarchar(max), CONVERT(money,ISNULL(#EX.LM_Balance_TX,0)),1) + ')' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN (C_BadData = 1) THEN '-Bad Data' + CHAR(13) + CHAR(10) ELSE '' END +
	--CASE WHEN C_MultiCollateral = 1 THEN '-Unable to Locate Collateral(s)' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN #EX.CM_PayoffRelease = 1 THEN '-Paid off or Released' + CHAR(13) + CHAR(10) ELSE '' END + ''
 AS [EXTR_EXCEPTION],
 @RunDate as [EXTR_RUN_DT],
 @WorkItemID as [WORK_ITEM_ID],
 CASE WHEN L.EXTRACT_LOAN_UPDATE_ONLY_IN = 'Y' THEN 1 ELSE 0 END AS [LoanUpdatesOnlyOnLoan],
 FPC.CPI_QUOTE_ID

FROM #EX WITH(NOLOCK)
JOIN LENDER LND WITH(NOLOCK) on (/*@LenderID Is Null Or*/ LND.ID = @LenderID) and LND.PURGE_DT IS NULL
LEFT JOIN LOAN L WITH(NOLOCK) ON L.ID = #EX.LM_MatchLoanId and L.PURGE_DT IS NULL
LEFT JOIN OWNER_LOAN_RELATE OL WITH(NOLOCK) ON OL.LOAN_ID = L.ID AND OL.PRIMARY_IN = 'Y' AND OL.PURGE_DT IS NULL
LEFT JOIN [OWNER] O WITH(NOLOCK) ON O.ID = ISNULL(OL.OWNER_ID,#EX.OM_OwnerId) AND O.PURGE_DT IS NULL
OUTER APPLY
(select * from COLLATERAL C WITH(NOLOCK) where (    (#EX.CM_MatchCollateralId > 0 and C.ID = #EX.CM_MatchCollateralId) 
                                    or (C.LOAN_ID IS NULL)
								  )  
								  AND C.PURGE_DT IS NULL) C
LEFT JOIN PROPERTY P WITH(NOLOCK) ON P.ID = ISNULL(C.PROPERTY_ID,#EX.CM_MatchPropertyId) AND P.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AM WITH(NOLOCK) ON AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AO WITH(NOLOCK) ON AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
LEFT JOIN [ADDRESS] AL WITH(NOLOCK) ON AL.ID = LND.PHYSICAL_ADDRESS_ID AND AL.PURGE_DT IS NULL
LEFT JOIN REQUIRED_COVERAGE RC WITH(NOLOCK) ON RC.PROPERTY_ID = P.ID AND RC.PURGE_DT IS NULL
--OUTER APPLY
--(SELECT TOP 1 * FROM dbo.GetCurrentCoverage(P.ID, RC.ID, RC.TYPE_CD)
--ORDER BY ISNULL(UNIT_OWNERS_IN, 'N') DESC
--) OP
--LEFT JOIN BORROWER_INSURANCE_AGENCY BIA WITH(NOLOCK) ON BIA.ID = OP.BIA_ID AND BIA.PURGE_DT IS NULL
LEFT JOIN PRIOR_CARRIER_POLICY PCP WITH(NOLOCK) ON PCP.REQUIRED_COVERAGE_ID = RC.ID and RC.SUMMARY_SUB_STATUS_CD = 'P' AND PCP.PURGE_DT IS NULL
OUTER APPLY
(SELECT FPC.* FROM FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR WITH(NOLOCK) JOIN FORCE_PLACED_CERTIFICATE FPC WITH(NOLOCK) ON FPCR.FPC_ID = FPC.ID AND fpcr.REQUIRED_COVERAGE_ID = rc.ID AND FPC.ACTIVE_IN = 'Y' AND (FPC.LOAN_ID = L.ID OR FPC.LOAN_ID IS NULL) AND FPC.PURGE_DT IS NULL
WHERE FPCR.PURGE_DT IS NULL) FPC
LEFT JOIN CARRIER CR WITH(NOLOCK) on CR.ID = FPC.CARRIER_ID AND RC.SUMMARY_SUB_STATUS_CD = 'C' AND CR.PURGE_DT IS NULL
--LEFT JOIN CPI_QUOTE CPQ WITH(NOLOCK) ON CPQ.ID = FPC.CPI_QUOTE_ID and RC.SUMMARY_SUB_STATUS_CD = 'C' AND CPQ.PURGE_DT IS NULL
--LEFT JOIN CPI_ACTIVITY CPA WITH(NOLOCK) ON CPA.CPI_QUOTE_ID = CPQ.ID AND CPA.TYPE_CD = 'I'	and RC.SUMMARY_SUB_STATUS_CD = 'C' AND CPA.PURGE_DT IS NULL
--LEFT JOIN CERTIFICATE_DETAIL CDPRM WITH(NOLOCK) ON CDPRM.CPI_ACTIVITY_ID = CPA.ID AND CDPRM.TYPE_CD = 'PRM' AND RC.SUMMARY_SUB_STATUS_CD = 'C' AND CDPRM.PURGE_DT IS NULL
LEFT JOIN REF_CODE RC_COVERAGETYPE WITH(NOLOCK) ON RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
LEFT JOIN COLLATERAL_CODE CC WITH(NOLOCK) ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
LEFT JOIN REF_CODE NRef WITH(NOLOCK) ON NRef.DOMAIN_CD = 'NoticeType' AND NRef.CODE_CD = RC.NOTICE_TYPE_CD
LEFT JOIN REF_CODE LSRef WITH(NOLOCK) ON LSRef.DOMAIN_CD = 'LoanStatus' AND LSRef.CODE_CD = L.STATUS_CD
LEFT JOIN REF_CODE CSRef WITH(NOLOCK) ON CSRef.DOMAIN_CD = 'CollateralStatus' AND CSRef.CODE_CD = C.STATUS_CD
LEFT JOIN REF_CODE RCSRef WITH(NOLOCK) ON RCSRef.DOMAIN_CD = 'RequiredCoverageStatus' AND RCSRef.CODE_CD = RC.STATUS_CD
LEFT JOIN REF_CODE RCISRef WITH(NOLOCK) ON RCISRef.DOMAIN_CD = 'RequiredCoverageInsStatus' AND RCISRef.CODE_CD = RC.SUMMARY_STATUS_CD
LEFT JOIN REF_CODE RCISSRef WITH(NOLOCK) ON RCISSRef.DOMAIN_CD = 'RequiredCoverageInsSubStatus' AND RCISSRef.CODE_CD = RC.SUMMARY_SUB_STATUS_CD
LEFT JOIN REF_CODE RCCCDIV WITH(NOLOCK) ON RCCCDIV.DOMAIN_CD = 'ContractType' AND RCCCDIV.CODE_CD = CC.CONTRACT_TYPE_CD AND RCCCDIV.PURGE_DT IS NULL	
LEFT JOIN REF_CODE RCDiv WITH(NOLOCK) ON RCDiv.DOMAIN_CD = 'ContractType' AND RCDiv.CODE_CD = ISNULL(L.DIVISION_CODE_TX,#EX.DivisionCode)		
left Join REF_CODE RC_SC WITH(NOLOCK) on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP WITH(NOLOCK) on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
)


SELECT * INTO #T2 FROM #tmpTable OUTER APPLY dbo.fn_FilterCollateralByDivisionCd(COLLATERAL_ID, @Division) fn_FCBD WHERE
([LOAN_BRANCHCODE_TX] IN (SELECT STRVALUE FROM @BranchTable) or @Branch = '1' or @Branch = '' or @Branch is NULL)
AND ( (fn_FCBD.loanType IS NOT NULL) 
	or ((fn_FCBD.loanType IS NULL) and ((LOAN_DIVISIONCODE_TX = @Division) or (@Division = '1'))) )
AND
(([CPI_ACTIVE_TX] IS NOT NULL AND [CPI_ACTIVE_TX] = 'Y') OR [CPI_ACTIVE_TX] IS NULL)
AND ((@ReportType = 'EXTRXCPT' AND (ReportLoanUnMatch = 0 OR (ReportLoanUnMatch = 1 AND [LOAN_RECORDTYPE_TX] IN ('A','D'))) AND [ReportIsDropZeroBalance] =0)
	OR
	(@ReportType <> 'EXTRXCPT' AND ((([LOAN_RECORDTYPE_TX] IS NOT NULL AND [LOAN_RECORDTYPE_TX] = 'G') OR [LOAN_RECORDTYPE_TX] IS NULL  or ReportNewLoan = 1) AND
									(([RC_RECORDTYPE_TX] IS NOT NULL AND [RC_RECORDTYPE_TX] = 'G') OR [RC_RECORDTYPE_TX] IS NULL  or ReportNewLoan = 1) AND
									(([P_RECORDTYPE_TX] IS NOT NULL AND [P_RECORDTYPE_TX] = 'G') OR [P_RECORDTYPE_TX] IS NULL  or ReportNewLoan = 1))
	)
)

AND (@EXTRNUC = 'N' OR (@EXTRNUC = 'Y' AND [EXTR_COVERAGE_STATUS_TX] <> 'Loan Deleted' AND
	([ReportLoanUnMatch] = 1 OR ([ReportCollateralUnMatch] = 1 AND [ReportCollRetainIndicator] = 0) OR
	(@LoanUpdatesOnlyOnWI = 0 AND [LoanUpdatesOnlyOnLoan] = 0 AND ([ReportNewLoan] = 1 OR [ReportNewCollateral] = 1) AND [ReportIsDropZeroBalance] = 0)




	OR
	((@LoanUpdatesOnlyOnWI = 1 OR [LoanUpdatesOnlyOnLoan] = 1) AND ([ReportNewLoan] = 1 AND [ReportNewCollateral] = 1) AND [ReportIsDropZeroBalance] = 0)
	)
	
	AND NOT ([ReportNameChange]=1 OR [ReportAddressChange] = 1 OR [ReportCollDescriptionChange] = 1 OR [ReportEffDateChange] = 1 OR
	[ReportBalanceIncrease] = 1 OR [ReportLoanReOccurance] = 1 OR [ReportBadData] = 1 OR [ReportUTLCollateral] = 1 OR [ReportCPIInPlace] = 1)))
AND (@EXTRNEW = 'N' OR (@EXTRNEW = 'Y' AND ((@LoanUpdatesOnlyOnWI = 0 AND [LoanUpdatesOnlyOnLoan] = 0 AND ([ReportNewLoan] = 1 OR [ReportNewCollateral] = 1) AND [ReportIsDropZeroBalance] = 0)
	OR
	((@LoanUpdatesOnlyOnWI = 1 OR [LoanUpdatesOnlyOnLoan] = 1) AND ([ReportNewLoan] = 1 AND [ReportNewCollateral] = 1) AND [ReportIsDropZeroBalance] = 0))
	AND NOT ([ReportNameChange]=1 OR [ReportAddressChange] = 1 OR [ReportCollDescriptionChange] = 1 OR [ReportEffDateChange] = 1 OR
	[ReportBalanceIncrease] = 1 OR [ReportLoanReOccurance] = 1 OR [ReportBadData] = 1 OR [ReportUTLCollateral] = 1 OR [ReportCPIInPlace] = 1)))
AND (@CPIINPLACE = 'N' OR (@CPIINPLACE = 'Y' AND [ReportCPIInPlace] = 1))
AND (@NOTREPOSSESSION = 'N' OR (@NOTREPOSSESSION = 'Y' AND [COLLATERAL_STATUSCODE] <> 'Z'))
AND (@REPOSSESSION = 'N' OR (@REPOSSESSION = 'Y' AND [COLLATERAL_STATUSCODE] = 'Z'))
AND (@LOANPAYOFFDATEISNOTNULL = 'N' OR (@LOANPAYOFFDATEISNOTNULL = 'Y' and [PAYOFF_DT] <> '0001-01-01'))
AND (@NOTUNMATCHED = 'N' OR (@NOTUNMATCHED = 'Y' AND [ReportLoanUnMatch] = 0 AND [ReportCollateralUnMatch] = 0))
AND (@CPICOVERAGE = 'N' OR (@CPICOVERAGE = 'Y' AND [COVERAGE_SUMMARY_SUB_STATUS_CD] = 'C'))
AND (@EXTRXCPT = 'N' OR (@EXTRXCPT = 'Y' AND (ReportNameChange = 1 OR ReportAddressChange = 1 OR ReportCollDescriptionChange = 1 OR ReportEffDateChange = 1 OR ReportBalanceIncrease = 1  OR ReportBadData = 1 OR ReportPayOffRelease = 1
		OR (@LoanUpdatesOnlyOnWI = 0 AND [LoanUpdatesOnlyOnLoan] = 0 AND (ReportCollDescriptionChange = 1 OR ReportUTLCollateral = 1))
    )
	OR
	(ReportLoanReOccurance = 1 AND (ReportNewCollateral = 1 OR ReportCollateralUnMatch = 0))
	)
)
AND (@EXTRXCPTNAME = 'N' OR (@EXTRXCPTNAME = 'Y' AND ((ReportNameChange = 1 Or ReportAddressChange = 1) AND
	ReportEffDateChange = 0 and ReportBalanceIncrease = 0 and ReportLoanReOccurance = 0 and ReportBadData = 0 and
	ReportPayOffRelease = 0 
	and ((@LoanUpdatesOnlyOnWI = 1 or [LoanUpdatesOnlyOnLoan] = 1) or (@LoanUpdatesOnlyOnWI = 0 AND [LoanUpdatesOnlyOnLoan] = 0 AND ReportCollDescriptionChange = 0 AND ReportUTLCollateral = 0 and ReportNewCollateral = 0))
	)))
AND (@EXTRXCPTOTER = 'N' OR (@EXTRXCPTOTER = 'Y' AND  ReportNewLoan = 0  AND (
ReportEffDateChange = 1 Or ReportBalanceIncrease = 1 Or ReportBadData = 1 or ReportPayOffRelease = 1 OR
(@LoanUpdatesOnlyOnWI = 0 AND [LoanUpdatesOnlyOnLoan] = 0 AND (ReportCollDescriptionChange = 1 Or ReportUTLCollateral = 1))
Or ((ReportNameChange = 1 Or ReportAddressChange = 1 ) and ReportNewCollateral = 1)
Or (ReportLoanReOccurance = 1)
	))
	)
AND (@PROPEXCEP = 'N' OR (@PROPEXCEP = 'Y' 
	AND ([LOAN_DIVISIONCODE_TX] IN ('4', '10') OR [PROPERTY_TYPE_CD] not in ('VEH','BOAT','EQ'))
	AND [LENDER_STATE_TX] <> [COLLATERAL_STATE_TX]))
AND (@ReportType <> 'EXTRTIERTRK' OR (@ReportType = 'EXTRTIERTRK' AND [REQUIREDCOVERAGE_STATUSCODE] != 'W' and 
	(([FILE_LENDER_COLLATERAL_CODE_TX] like '%-OT' and [COLLATERAL_CODE_TX] not like '%-OT') 
	or ([FILE_LENDER_COLLATERAL_CODE_TX] like '%-A' and [COLLATERAL_CODE_TX] not like '%-A')
	or ([FILE_LENDER_COLLATERAL_CODE_TX] like '%-A+' and [COLLATERAL_CODE_TX] not like '%-A+')
	or ([FILE_LENDER_COLLATERAL_CODE_TX] like '%-B' and [COLLATERAL_CODE_TX] not like '%-B')
	or ([FILE_LENDER_COLLATERAL_CODE_TX] like '%-C' and [COLLATERAL_CODE_TX] not like '%-C')
	or ([FILE_LENDER_COLLATERAL_CODE_TX] like '%-D' and [COLLATERAL_CODE_TX] not like '%-D')
	or ([FILE_LENDER_COLLATERAL_CODE_TX] like '%-E' and [COLLATERAL_CODE_TX] not like '%-E')
	or ([FILE_LENDER_COLLATERAL_CODE_TX] like '%-%B/O' and [COLLATERAL_CODE_TX] not like '%-%B/O')
	or ([FILE_LENDER_COLLATERAL_CODE_TX] like '%-%C/D' and [COLLATERAL_CODE_TX] not like '%-%C/D'))))
AND (@ReportType <> 'EXTRCREDITTRK' OR (@ReportType = 'EXTRCREDITTRK' AND [REQUIREDCOVERAGE_STATUSCODE] != 'W' and 
	(([FILE_LOAN_CREDITSCORECODE_TX] = 'OT' and [LOAN_CREDITSCORECODE_TX] <> 'OT') 
	or ([FILE_LOAN_CREDITSCORECODE_TX] = 'A' and [LOAN_CREDITSCORECODE_TX] <> 'A')
	or ([FILE_LOAN_CREDITSCORECODE_TX] = 'AP' and [LOAN_CREDITSCORECODE_TX] <> 'AP')
	or ([FILE_LOAN_CREDITSCORECODE_TX] = 'B' and [LOAN_CREDITSCORECODE_TX] <> 'B')
	or ([FILE_LOAN_CREDITSCORECODE_TX] = 'C' and [LOAN_CREDITSCORECODE_TX] <> 'C')
	or ([FILE_LOAN_CREDITSCORECODE_TX] = 'D' and [LOAN_CREDITSCORECODE_TX] <> 'D'))))

select @RecordCount = @@ROWCOUNT

--Uodate the final result set with CPI and PC premiums
UPDATE T
SET CPI_PREMIUM_AMOUNT_NO = ISNULL(CDPRM.AMOUNT_NO,0),
PC_PREMIUM_AMOUNT_NO = ISNULL(CDPRM.AMOUNT_NO,0)
FROM #T2 T
JOIN CPI_QUOTE CPQ ON CPQ.ID = T.CPI_QUOTE_ID AND CPQ.PURGE_DT IS NULL
JOIN CPI_ACTIVITY CPA ON CPA.CPI_QUOTE_ID = CPQ.ID AND CPA.TYPE_CD = 'I' AND CPA.PURGE_DT IS NULL
JOIN CERTIFICATE_DETAIL CDPRM ON CDPRM.CPI_ACTIVITY_ID = CPA.ID AND CDPRM.TYPE_CD = 'PRM' AND CDPRM.PURGE_DT IS NULL
WHERE T.COVERAGE_SUMMARY_SUB_STATUS_CD = 'C'


--Update the final result set with the property description
UPDATE T
SET PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescription(T.COLLATERAL_ID , 'N')
FROM #T2 T

--Update the final result set with the BIC and Agency information
DECLARE @bic_propertyid	BIGINT = NULL,
@bic_rcid	BIGINT = NULL,
@bic_rctype	NVARCHAR(20)

DECLARE bic CURSOR FOR SELECT T.PROPERTY_ID, T.REQUIREDCOVERAGE_ID, T.REQUIREDCOVERAGE_CODE_TX FROM #T2 T;
OPEN bic;

FETCH NEXT
FROM bic
INTO @bic_propertyid, @bic_rcid, @bic_rctype

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SELECT TOP 1 * 
	INTO #work_list
	FROM dbo.GetCurrentCoverage(@bic_propertyid, @bic_rcid, @bic_rctype)
	ORDER BY ISNULL(UNIT_OWNERS_IN, 'N') DESC

	UPDATE T
	SET INSCOMPANY_NAME_TX = (CASE WHEN T.INSCOMPANY_NAME_TX IS NULL THEN w.BIC_NAME_TX ELSE T.INSCOMPANY_NAME_TX END),
	INSCOMPANY_POLICY_NO = (CASE WHEN T.INSCOMPANY_POLICY_NO IS NULL THEN w.POLICY_NUMBER_TX ELSE T.INSCOMPANY_POLICY_NO END),
	BORRINSCOMPANY_EFF_DT = w.EFFECTIVE_DT,
	BORRINSCOMPANY_EXP_DT = (CASE WHEN YEAR(w.EXPIRATION_DT) = '9999' THEN NULL ELSE w.EXPIRATION_DT END),
	BORRINSCOMPANY_CAN_DT = w.CANCELLATION_DT,
	INSAGENCY_NAME_TX = w.BIC_NAME_TX,
	INSAGENCY_PHONE_TX = BIA.PHONE_EXT_TX,
	[INSAGENCY_EMAIL_TX] = BIA.EMAIL_TX ,
	[INSAGENCY_FAX_TX] = BIA.FAX_EXT_TX
	FROM #T2 T
	JOIN #work_list w on T.PROPERTY_ID = w.PROPERTY_ID AND T.REQUIREDCOVERAGE_CODE_TX = w.RC_TYPE
	LEFT OUTER JOIN BORROWER_INSURANCE_AGENCY BIA WITH(NOLOCK) ON BIA.ID = w.BIA_ID AND BIA.PURGE_DT IS NULL AND w.BIA_ID IS NOT NULL

	DROP TABLE #work_list;

	FETCH NEXT
	FROM bic
	INTO @bic_propertyid, @bic_rcid, @bic_rctype

END

-- Close and deallocate the cursor.
CLOSE bic;
DEALLOCATE bic;


IF @DEBUGGING = 'T'
BEGIN
	SELECT COUNT(*) AS POSTX_CNT FROM #T2
END

IF @DEBUGGING = 'T'
BEGIN
	SELECT @SortByCode AS SBC, @SortBySQL AS SBS
END


declare @setstring nvarchar(4000) = ''
set @setstring = CASE when ISNULL(@GroupBySQL,'') <> ''
                      then '[REPORT_GROUPBY_TX] = ' + @GroupBySQL
                      else '' end
set @setstring = @setstring + CASE When ISNULL(@SortBySQL,'') <> ''
                      then case when @setstring <> '' then ',' else '' end
                          + '[REPORT_SORTBY_TX] = ' + @SortBySQL
                      else '' end
set @setstring = @setstring + CASE When ISNULL(@HeaderTx,'') <> ''
                      then case when @setstring <> '' then ',' else '' end
                          + '[REPORT_HEADER_TX] = ' + @HeaderTx
                      else '' end
set @setstring = @setstring+ CASE When ISNULL(@FooterTx,'') <> ''
                      then case when @setstring <> '' then ',' else '' end
                          + '[REPORT_FOOTER_TX] = ' + @FooterTx
                      else '' end
if @setstring <> ''
begin
	set @sqlstring = N'Update #T2 set ' + @setstring
	EXECUTE sp_executesql @sqlstring
end

IF @Report_History_ID IS NOT NULL
BEGIN

-- get an accurate row count of distinct for bug 33088
if @ReportConfig =  'EXTRXCPTOTHER'
	begin			
			select @RecordCount = count(*)  
			from (select distinct ReportLoanUnMatch,ReportCollateralUnMatch,ReportNewLoan,ReportNewCollateral,ReportNameChange,ReportAddressChange,ReportCollDescriptionChange,ReportEffDateChange,ReportBalanceIncrease,ReportIsDropZeroBalance,ReportLoanReOccurance,ReportBadData,ReportUTLCollateral,ReportCPIInPlace,ReportPayOffRelease,ReportDeleteCount,ReportINSPolicyExist,ReportINSUTL,ReportINSUTLCollateral,ReportINSUTLCoverage,ReportCollRetainIndicator,LOAN_OFFICER_CODE_TX,LOAN_BRANCHCODE_TX,LOAN_DIVISIONCODE_TX,LOAN_TYPE_TX,LOAN_NUMBER_TX,LOAN_NUMBERSORT_TX,LOAN_EFFECTIVE_DT,LOAN_EFFECTIVE_DT_BEFORE_CHANGE_DT,LOAN_BALANCE_NO,LOAN_BALANCESORT_TX,LOAN_BALANCE_BEFORE_CHANGE_NO,CREDIT_LINE,CREDIT_LINE_AMOUNT_NO,PAYOFF_DT,LOAN_CREDITSCORECODE_TX,FILE_LOAN_CREDITSCORECODE_TX,LENDER_CODE_TX,LENDER_NAME_TX,COLLATERAL_NUMBER_NO,COLLATERAL_CODE_TX,LENDER_COLLATERAL_CODE_TX,LOAN_STATUSCODE,COLLATERAL_STATUSCODE,OWNER_LASTNAME_TX,OWNER_FIRSTNAME_TX,OWNER_MIDDLEINITIAL_TX,OWNER_NAME_TX,OWNER_COSIGN_TX,OWNER_LINE1_TX,OWNER_LINE2_TX,OWNER_STATE_TX,OWNER_CITY_TX,OWNER_ZIP_TX,PROPERTY_TYPE_CD,PROPERTY_DESCRIPTION,PROPERTY_DESCRIPTION_FILE,COLLATERAL_VIN_TX,COLLATERAL_VIN_FILE_TX,COLLATERAL_STATE_TX,LENDER_STATE_TX,LOAN_ID,COLLATERAL_ID,PROPERTY_ID,LOAN_RECORDTYPE_TX,P_RECORDTYPE_TX,EXTR_COVERAGE_STATUS_TX,EXTR_EXCEPTION,EXTR_RUN_DT,WORK_ITEM_ID,LoanUpdatesOnlyOnLoan,REPORT_GROUPBY_TX,REPORT_SORTBY_TX,REPORT_HEADER_TX,REPORT_FOOTER_TX
			from #T2) OtherCount
			
			
	end


  Update [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML
  Set RECORD_COUNT_NO = @RecordCount, UPDATE_DT = GETDATE()
  where ID = @Report_History_ID

END

IF NOT @DEBUGGING = 'T'
BEGIN
	if @ReportConfig =  'EXTRXCPTOTHER'
		begin 
			-- Added distinct and removed required coverage fields from the select which caused duplicates bug 33088
			select distinct ReportLoanUnMatch,ReportCollateralUnMatch,ReportNewLoan,ReportNewCollateral,ReportNameChange,ReportAddressChange,ReportCollDescriptionChange,ReportEffDateChange,ReportBalanceIncrease,ReportIsDropZeroBalance,ReportLoanReOccurance,ReportBadData,ReportUTLCollateral,ReportCPIInPlace,ReportPayOffRelease,ReportDeleteCount,ReportINSPolicyExist,ReportINSUTL,ReportINSUTLCollateral,ReportINSUTLCoverage,ReportCollRetainIndicator,LOAN_OFFICER_CODE_TX,LOAN_BRANCHCODE_TX,LOAN_DIVISIONCODE_TX,LOAN_TYPE_TX,LOAN_NUMBER_TX,LOAN_NUMBERSORT_TX,LOAN_EFFECTIVE_DT,LOAN_EFFECTIVE_DT_BEFORE_CHANGE_DT,LOAN_BALANCE_NO,LOAN_BALANCESORT_TX,LOAN_BALANCE_BEFORE_CHANGE_NO,CREDIT_LINE,CREDIT_LINE_AMOUNT_NO,PAYOFF_DT,LOAN_CREDITSCORECODE_TX,FILE_LOAN_CREDITSCORECODE_TX,LENDER_CODE_TX,LENDER_NAME_TX,COLLATERAL_NUMBER_NO,COLLATERAL_CODE_TX,LENDER_COLLATERAL_CODE_TX,LOAN_STATUSCODE,COLLATERAL_STATUSCODE,OWNER_LASTNAME_TX,OWNER_FIRSTNAME_TX,OWNER_MIDDLEINITIAL_TX,OWNER_NAME_TX,OWNER_COSIGN_TX,OWNER_LINE1_TX,OWNER_LINE2_TX,OWNER_STATE_TX,OWNER_CITY_TX,OWNER_ZIP_TX,PROPERTY_TYPE_CD,PROPERTY_DESCRIPTION,PROPERTY_DESCRIPTION_FILE,COLLATERAL_VIN_TX,COLLATERAL_VIN_FILE_TX,COLLATERAL_STATE_TX,LENDER_STATE_TX,LOAN_ID,COLLATERAL_ID,PROPERTY_ID,LOAN_RECORDTYPE_TX,P_RECORDTYPE_TX,EXTR_COVERAGE_STATUS_TX,EXTR_EXCEPTION,EXTR_RUN_DT,WORK_ITEM_ID,LoanUpdatesOnlyOnLoan,REPORT_GROUPBY_TX,REPORT_SORTBY_TX,REPORT_HEADER_TX,REPORT_FOOTER_TX
			from #T2
			
		END
	else 
		begin 
			Select 
			[ReportLoanUnMatch]
			,[ReportCollateralUnMatch]
			,[ReportNewLoan]
			,[ReportNewCollateral]
			,[ReportNameChange]
			,[ReportAddressChange]
			,[ReportCollDescriptionChange]
			,[ReportEffDateChange]
			,[ReportBalanceIncrease]
			,[ReportIsDropZeroBalance]
			,[ReportLoanReOccurance]
			,[ReportBadData]
			,[ReportUTLCollateral]
			,[ReportCPIInPlace]
			,[ReportPayOffRelease]
			,[ReportDeleteCount]
			,[ReportINSPolicyExist]
			,[ReportINSUTL]
			,[ReportINSUTLCollateral]
			,[ReportINSUTLCoverage]
			,[ReportCollRetainIndicator]
			,[LOAN_OFFICER_CODE_TX]
			,[LOAN_BRANCHCODE_TX]
			,[LOAN_DIVISIONCODE_TX]
			,[LOAN_TYPE_TX]
			,[REQUIREDCOVERAGE_CODE_TX]
			,[REQUIREDCOVERAGE_TYPE_TX]
			,[LOAN_NUMBER_TX]
			,[LOAN_NUMBERSORT_TX]
			,[LOAN_EFFECTIVE_DT]
			,[LOAN_EFFECTIVE_DT_BEFORE_CHANGE_DT]	
			,[LOAN_BALANCE_NO]
			,[LOAN_BALANCESORT_TX]
			,[LOAN_BALANCE_BEFORE_CHANGE_NO]		
			,[CREDIT_LINE]
			,[CREDIT_LINE_AMOUNT_NO]
			,[PAYOFF_DT]
			,[LOAN_CREDITSCORECODE_TX]
			,[FILE_LOAN_CREDITSCORECODE_TX]
			,[LENDER_CODE_TX]
			,[LENDER_NAME_TX]
			,[COLLATERAL_NUMBER_NO]
			,[COLLATERAL_CODE_TX]
			,[LENDER_COLLATERAL_CODE_TX]
			,[FILE_LENDER_COLLATERAL_CODE_TX]
			,[LOAN_STATUSCODE]
			,[COLLATERAL_STATUSCODE]
			,[OWNER_LASTNAME_TX]
			,[OWNER_FIRSTNAME_TX]
			,[OWNER_MIDDLEINITIAL_TX]
			,[OWNER_NAME_TX]
			,[OWNER_COSIGN_TX]
			,[OWNER_LINE1_TX]
			,[OWNER_LINE2_TX]
			,[OWNER_STATE_TX]
			,[OWNER_CITY_TX]
			,[OWNER_ZIP_TX]
			,[PROPERTY_TYPE_CD]
			,[PROPERTY_DESCRIPTION]
			,[PROPERTY_DESCRIPTION_FILE]
			,[COLLATERAL_VIN_TX]
			,[COLLATERAL_VIN_FILE_TX]
			,[COLLATERAL_STATE_TX]
			,[LENDER_STATE_TX]
			,[REQUIREDCOVERAGE_REQUIREDAMOUNT_NO]
			,[COVERAGE_STATUS_TX]
			,[COVERAGEWAIVE_MEANING_TX]
			,[REQUIREDCOVERAGE_STATUSCODE]
			,[COVERAGE_SUMMARY_SUB_STATUS_CD]
			,[CPI_ACTIVE_TX]
			,[INSCOMPANY_NAME_TX]
			,[INSCOMPANY_POLICY_NO]
			,[CPI_PREMIUM_AMOUNT_NO]
			,[PC_PREMIUM_AMOUNT_NO]
			,[BORRINSCOMPANY_EFF_DT]
			,[BORRINSCOMPANY_EXP_DT]
			,[BORRINSCOMPANY_CAN_DT]
			,[INSAGENCY_NAME_TX]
			,[INSAGENCY_PHONE_TX]
			,[INSAGENCY_EMAIL_TX]
			,[INSAGENCY_FAX_TX]
			,[LOAN_ID]
			,[COLLATERAL_ID]
			,[PROPERTY_ID]
			,[REQUIREDCOVERAGE_ID]
			,[LOAN_RECORDTYPE_TX]
			,[RC_RECORDTYPE_TX]
			,[P_RECORDTYPE_TX]
			,[EXTR_COVERAGE_STATUS_TX]
			,[EXTR_EXCEPTION]
			,[EXTR_RUN_DT]
			,[WORK_ITEM_ID]					
			,[LoanUpdatesOnlyOnLoan]
			,[REPORT_GROUPBY_TX]
			,[REPORT_SORTBY_TX]
			,[REPORT_HEADER_TX]
			[REPORT_FOOTER_TX]			
			 from #T2 
		END
END

END





GO

