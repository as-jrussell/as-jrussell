USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_LoanStatus]    Script Date: 10/27/2017 8:24:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Report_LoanStatus] 
--declare
	@LenderCode as nvarchar(10)=NULL,
	@Branch AS nvarchar(max)=NULL,
	@Division as nvarchar(10)=NULL,
	@Coverage as nvarchar(100)=NULL,
	@ReportType as nvarchar(50)=NULL,
	@GroupByCode as nvarchar(50)=NULL,
	@SortByCode as nvarchar(50)=NULL,
	@FilterByCode as nvarchar(50)=NULL,
	@SpecificReport as varchar(50)='0000',
	@ReportDomainName as nvarchar(50)='Report_LoanStatus',
	@Report_History_ID as bigint=NULL,
	@optimize_for_unknown as bit=1,
	@debug as bit=0
as

BEGIN
	/* defaults: */
	Declare
	 @excludeUnmatched as bit=1
	,@excludeZeroBal as bit=0

IF OBJECT_ID(N'tempdb..#tmpTable',N'U') IS NOT NULL
  DROP TABLE #tmpTable
IF OBJECT_ID(N'tempdb..#tmpTable1',N'U') IS NOT NULL
  DROP TABLE #tmpTable1
IF OBJECT_ID(N'tempdb..#tmptable_initial',N'U') IS NOT NULL
  DROP TABLE #tmptable_initial
IF OBJECT_ID(N'tempdb..#tmpfilter',N'U') IS NOT NULL
  DROP TABLE #tmpfilter
IF OBJECT_ID(N'tempdb..#tmpimpaired',N'U') IS NOT NULL
  DROP TABLE #tmpimpaired
IF OBJECT_ID(N'tempdb..#t1',N'U') IS NOT NULL
  DROP TABLE #t1
IF OBJECT_ID(N'tempdb..#t3',N'U') IS NOT NULL
  DROP TABLE #t3
IF OBJECT_ID(N'tempdb..#t4',N'U') IS NOT NULL
  DROP TABLE #t4
IF OBJECT_ID(N'tempdb..#t5',N'U') IS NOT NULL
  DROP TABLE #t5
IF OBJECT_ID(N'tempdb..#tMortgage',N'U') IS NOT NULL
  DROP TABLE #tMortgage
IF OBJECT_ID(N'tempdb..#tVehicle',N'U') IS NOT NULL
  DROP TABLE #tVehicle
IF OBJECT_ID(N'tempdb..#tLoan',N'U') IS NOT NULL
  DROP TABLE #tLoan
IF OBJECT_ID(N'tempdb..#tVin',N'U') IS NOT NULL
  DROP TABLE #tVin
IF OBJECT_ID(N'tempdb..#BranchTable',N'U') IS NOT NULL
  DROP TABLE #BranchTable
IF OBJECT_ID(N'tempdb..#finalgroup',N'U') IS NOT NULL
  DROP TABLE #finalgroup
IF OBJECT_ID(N'tempdb..#tmpTableClone',N'U') IS NOT NULL
  DROP TABLE #tmpTableClone

DECLARE @BeginDate As datetime2 (7)
DECLARE @EndDate AS datetime2 (7)
Declare @LenderID as bigint
DECLARE @ProcessDefinitionID as bigint = 0
DECLARE @CyclePeriod as nvarchar(15) = NULL

Declare @RD_MISC1_ID as bigint
Select @RD_MISC1_ID = ID from RELATED_DATA_DEF where NAME_TX = 'Misc1'

if @Report_History_ID is not NULL
Begin
	Select @BeginDate=VUT_START_DT, 
		@EndDate=VUT_END_DT From [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML where ID = @Report_History_ID

	 SET @BeginDate = DATEADD(HH,0,@BeginDate)			
	 SET @EndDate = DATEADD(HH,0,@EndDate)		

	Select
	 @LenderCode=isnull(@LenderCode,REPORT_DATA_XML.value('(/ReportData/Report/Lender)[1]/@value', 'nvarchar(max)'))
	,@ReportType=isnull(@ReportType,REPORT_DATA_XML.value('(/ReportData/Report/ReportType)[1]/@value', 'varchar(50)'))
	,@SpecificReport=coalesce(@SpecificReport,NullIf(REPORT_DATA_XML.value('(/ReportData/Report/SpecificReport)[1]/@value', 'varchar(50)'), ''), '0000')
	,@ReportDomainName=coalesce(@ReportDomainName,NullIf(REPORT_DATA_XML.value('(/ReportData/Report/ReportDomainName)[1]/@value', 'varchar(50)'), ''), 'Report_LoanStatus')
	,@Division=isnull(@Division,NullIf(REPORT_DATA_XML.value('(/ReportData/Report/Division)[1]/@value', 'nvarchar(max)'), ''))
	 FROM REPORT_HISTORY WHERE ID = @Report_History_ID
End

CREATE TABLE [dbo].[#BranchTable] (ID int, STRVALUE nvarchar(30))
			INSERT INTO #BranchTable SELECT * FROM SplitFunction(@Branch, ',')  

--BEGIN 02252013 Added check for 0001-01-01 date
IF @BeginDate = '0001-01-01' 
BEGIN
  SELECT @ProcessDefinitionID =  REPORT_DATA_XML.value('(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'bigint')  FROM REPORT_HISTORY WHERE ID = @Report_History_ID
  SELECT @CyclePeriod = EXECUTION_FREQ_CD FROM PROCESS_DEFINITION WHERE ID = @ProcessDefinitionID
  select @BeginDate = 
	CASE @CyclePeriod 
		WHEN 'ANNUAL' THEN DATEADD(YEAR, -1, @EndDate)
		WHEN 'QUARTERLY' THEN DATEADD(QUARTER, -1, @EndDate)
		WHEN 'MONTHLY' THEN DATEADD(MONTH, -1, @EndDate)
		WHEN 'SEMIMONTH' THEN DATEADD(WEEK, -2, @EndDate)
		WHEN 'BIWEEK' THEN DATEADD(WEEK, -2, @EndDate)
		WHEN 'WEEK' THEN DATEADD(WEEK, -1, @EndDate)
		WHEN 'DAY' THEN DATEADD(d, -1, @EndDate)
		WHEN 'HOUR' THEN DATEADD(HOUR, -1, @EndDate)	
		ELSE DATEADD(DAY, -2, @EndDate)	
	 end	 
END
	
IF @BeginDate IS NULL OR @EndDate IS NULL 
BEGIN
     --To get more rows (Year-To-Date)
	SET @BeginDate = CONVERT(varchar(20),GETDATE(),101)
	SET @BeginDate = DATEADD(d,(day(@BeginDate)*-1) + 1,@BeginDate)
	SET @BeginDate = DATEADD(m,(month(@BeginDate)*-1) + 1,@BeginDate)
	SET @BeginDate = DATEADD(yy,-1,@BeginDate)								--Start last year
	SET @EndDate = GETDATE()
END	


CREATE TABLE [dbo].[#tmptable_initial](
	[LOAN_BRANCHCODE_TX] [nvarchar](20) NULL,
	[LOAN_PAGEBREAKTYPE_TX] [nvarchar](20) NULL,
	[LOAN_PAGEBREAK_TX] [nvarchar](1000) NULL,
	[LOAN_DIVISIONCODE_TX] [nvarchar](20) NULL,
	[REQUIREDCOVERAGE_CODE_TX] [nvarchar](30) NULL,
--LOAN:
	[LOAN_NUMBER_TX] [nvarchar](35) NOT NULL,
	[LOAN_NUMBERSORT_TX] [nvarchar](18) NULL,
	[LOAN_EFFECTIVE_DT] [datetime] NULL,
	[LOAN_EFFDTSORT_TX] [nvarchar](8) NULL,
	[LOAN_MATURITY_DT] [datetime] NULL,
	[LOAN_TERM_NO] [int] NULL,
	[LOAN_BALANCE_NO] [decimal](19, 2) NULL,
	[LOAN_BALANCESORT_TX] [nvarchar](15) NULL,
	[LOAN_ORIGINALBALANCE_AMOUNT_NO] [decimal](19, 2) NULL,
	[LOAN_BALANCE_DT] [datetime] NULL,
	[LOAN_BALDTFORMAT_TX] [nvarchar](10) NULL,
	[LOAN_APR_AMOUNT_NO] [decimal](15, 8) NULL,
	[LOAN_PAYMENT_FREQUENCY_CD] [nvarchar](1) NULL,
	[LOAN_NOTE_TX] [nvarchar](max) NULL,
	[LOAN_OFFICERCODE_TX] [nvarchar](20) NULL,
	[LOAN_DEALERCODE_TX] [nvarchar](20) NULL,
	[LOAN_CREDITSCORECODE_TX] [nvarchar](20) NULL,
	[LOAN_BAL_NO] [decimal](19, 2) NULL,
	[LN_LastPmtDt] [datetime] NULL,
	[LN_NextPmtDt] [datetime] NULL,
   [LOAN_LENDER_BRANCH_CODE_TX] [nvarchar](20) NULL,
   LOAN_PREDICTIVE_SCORE_NO int NULL,
   LOAN_PREDICTIVE_DECILE_NO int NULL,
--LENDER:
	[LOAN_LENDERCODE_TX] [nvarchar](10) NULL,
	[LENDER_NAME_TX] [nvarchar](40) NULL,
--COLLATERAL:
	[COLLATERAL_NUMBER_NO] [int] NULL,
	[LENDER_COLLATERAL_CODE_TX] [nvarchar](10) NULL,
	[COLLATERAL_LOAN_PERCENTAGE_NO] [decimal](12, 8) NULL,
	[LENDER_STATUS_OFFICER_TX] [nvarchar](20) NULL,
	[LEGAL_STATUS_CODE_TX] [nvarchar](10) NULL,
	[PURPOSE_CODE_TX] [nvarchar](10) NULL,
--OWNER:
	[OWNER_LASTNAME_TX] [nvarchar](30) NULL,
	[OWNER_FIRSTNAME_TX] [nvarchar](30) NULL,
	[OWNER_MIDDLEINITIAL_TX] [char](1) NULL,
	[OWNER_COSIGN_TX] [nvarchar](1) NULL,
	[OWNER_CREDIT_SCORE_TX] [nvarchar](20) NULL,
--PROPERTY:
	[COLLATERAL_YEAR_TX] [nvarchar](4) NULL,
	[COLLATERAL_MAKE_TX] [nvarchar](30) NULL,
	[COLLATERAL_MODEL_TX] [nvarchar](30) NULL,
	[COLLATERAL_VIN_TX] [nvarchar](18) NULL,
	[COLLATERAL_EQUIP_TX] [nvarchar](100) NULL,
	[PROPERTY_FLOODZONE_TX] [nvarchar](10) NULL,
	[FLOOD_VALUE_TX] [nvarchar](1) NULL,
	[PROPERTY_ACV_NO] [decimal](19, 2) NULL,
	[PROPERTY_TITLE_CD] [char](3) NULL,
--COVERAGE:
	[REQUIREDCOVERAGE_REQUIREDAMOUNT_NO] [decimal](18, 2) NULL,
	[DOCTYPE_CODE_TX] [nvarchar](20) NULL,
	[NOTICE_DT] [datetime2](7) NULL,
	[NOTICE_TYPE_CD] [nvarchar](4) NULL,
	[NOTICE_SEQ_NO] [int] NULL,
	[COVERAGE_EXPOSURE_DT] [datetime2](7) NULL,
--ESCROW:
	[ESCROW_IN_REQ_COV_TX] [char](1) NULL,
--IDs, STATUS:
	[LOAN_ID] [bigint] NULL,
	LENDER_ID bigint NULL,
	[COLLATERAL_ID] [bigint] NULL,
	COLLATERAL_CODE_ID bigint null,
	[PROPERTY_ID] [bigint] NULL,
	[REQUIREDCOVERAGE_ID] [bigint] NULL,
	[LOAN_STATUSCODE] [nvarchar] (2) NULL,
	[LOAN_STATUSMEANING_TX] [nvarchar](1000) NULL,
	[LOAN_UNMATCH_CNT] [int] NULL,
	[COLLATERAL_STATUSCODE] [nvarchar] (2) NULL,
	[COLLATERAL_STATUSMEANING_TX] [nvarchar](1000) NULL,
	[COLLATERAL_UNMATCH_CNT] [int] NULL,
	[REQUIREDCOVERAGE_STATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_STATUSMEANING_TX] [nvarchar](1000) NULL,
	[REQUIREDCOVERAGE_SUBSTATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_INSSTATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_INSSTATUSMEANING_TX] [nvarchar](1000) NULL,
	[REQUIREDCOVERAGE_INSSUBSTATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_INSSUBSTATUSMEANING_TX] [nvarchar](1000) NULL,
	OWNER_ADDRESS_ID bigint null,
	PROPERTY_ADDRESS_ID bigint null,
-- LENDER OPTIONS:
	[OPT_MAX_BALANCE][decimal](18,2) NULL,
	[OPT_MIN_BALANCE][decimal](18,2) NULL,
	[OPT_TITLE_START_DT] [datetime] NULL,
	[OPT_BALANCE_TYPE] [nvarchar] (20) NULL,
	PCP_INSURANCE_COMPANY_NAME_TX nvarchar(100) null,
	PCP_POLICY_NUMBER_TX nvarchar(36) null,
	PCP_EFFECTIVE_DT datetime2 null,
	PCP_EXPIRATION_DT datetime2 null,
	PCP_CANCELLATION_DT datetime2 null,
	PCP_TOTAL_PREMIUM_NO decimal(18,2) null,
	FPC_CARRIER_ID bigint null,
	FPC_CPI_QUOTE_ID bigint null,
	FPC_NUMBER_TX nvarchar(36) null,
	FPC_EFFECTIVE_DT datetime2 null,
	FPC_EXPIRATION_DT datetime2 null,
	FPC_CANCELLATION_DT datetime2 null,

) ON [PRIMARY]


CREATE TABLE [dbo].[#tmptable](
	[LOAN_BRANCHCODE_TX] [nvarchar](20) NULL,
	[LOAN_PAGEBREAKTYPE_TX] [nvarchar](20) NULL,
	[LOAN_PAGEBREAK_TX] [nvarchar](1000) NULL,
	[LOAN_DIVISIONCODE_TX] [nvarchar](20) NULL,
	[LOAN_TYPE_TX] [nvarchar](1000) NULL,
	[REQUIREDCOVERAGE_CODE_TX] [nvarchar](30) NULL,
	[REQUIREDCOVERAGE_TYPE_TX] [nvarchar](1000) NULL,
--LOAN:
	[LOAN_NUMBER_TX] [nvarchar](35) NOT NULL,
	[LOAN_NUMBERSORT_TX] [nvarchar](18) NULL,
	[LOAN_EFFECTIVE_DT] [datetime] NULL,
	[LOAN_EFFDTSORT_TX] [nvarchar](8) NULL,
	[LOAN_MATURITY_DT] [datetime] NULL,
	[LOAN_TERM_NO] [int] NULL,
	[LOAN_BALANCE_NO] [decimal](19, 2) NULL,
	[LOAN_BALANCESORT_TX] [nvarchar](15) NULL,
	[LOAN_ORIGINALBALANCE_AMOUNT_NO] [decimal](19, 2) NULL,
	[LOAN_BALANCE_DT] [datetime] NULL,
	[LOAN_BALDTFORMAT_TX] [nvarchar](10) NULL,
	[LOAN_APR_AMOUNT_NO] [decimal](15, 8) NULL,
	[LOAN_PAYMENT_FREQUENCY_CD] [nvarchar](1) NULL,
	[LOAN_NOTE_TX] [nvarchar](max) NULL,
	[LOAN_OFFICERCODE_TX] [nvarchar](20) NULL,
	[LOAN_DEALERCODE_TX] [nvarchar](20) NULL,
	[LOAN_CREDITSCORECODE_TX] [nvarchar](20) NULL,
	[LOAN_BAL_NO] [decimal](19, 2) NULL,
	[LN_LastPmtDt] [datetime] NULL,
	[LN_NextPmtDt] [datetime] NULL,
   [LOAN_LENDER_BRANCH_CODE_TX] [nvarchar](20) NULL,
   LOAN_PREDICTIVE_SCORE_NO int NULL,
   LOAN_PREDICTIVE_DECILE_NO int NULL,
--LOAN RELATED DATA:
    [MISC1_TX] [nvarchar] (1) NULL,	
--LENDER:
	[LOAN_LENDERCODE_TX] [nvarchar](10) NULL,	
	[LENDER_NAME_TX] [nvarchar](40) NULL,	
--COLLATERAL:
	[COLLATERAL_NUMBER_NO] [int] NULL,
	[COLLATERAL_CODE_TX] [nvarchar](30) NULL,
	[PROPERTY_TYPE_CD] [nvarchar](30) NULL,
	[LENDER_COLLATERAL_CODE_TX] [nvarchar](10) NULL,
	[COLLATERAL_LOAN_PERCENTAGE_NO] [decimal](12, 8) NULL,
	[LENDER_STATUS_OFFICER_TX] [nvarchar](20) NULL,
	[LEGAL_STATUS_CODE_TX] [nvarchar](10) NULL,
	[PURPOSE_CODE_TX] [nvarchar](10) NULL,
--OWNER:
	[OWNER_LASTNAME_TX] [nvarchar](30) NULL,
	[OWNER_FIRSTNAME_TX] [nvarchar](30) NULL,
	[OWNER_MIDDLEINITIAL_TX] [char](1) NULL,
	[OWNER_NAME_TX] [nvarchar](50) NULL,
	[ADDITIONAL_INSURED_NAME_TX] [nvarchar](1000) NULL,
	[ADDITIONAL_INSURED_CNT] [int] NULL,
	[OWNER_COSIGN_TX] [nvarchar](1) NULL,
	[OWNER_LINE1_TX] [nvarchar](100) NULL,
	[OWNER_LINE2_TX] [nvarchar](100) NULL,
	[OWNER_CITY_TX] [nvarchar](40) NULL,
	[OWNER_STATE_TX] [nvarchar](30) NULL,
	[OWNER_ZIP_TX] [nvarchar](30) NULL,
	[OWNER_CREDIT_SCORE_TX] [nvarchar](20) NULL,
--PROPERTY:
	[COLLATERAL_YEAR_TX] [nvarchar](4) NULL,
	[COLLATERAL_MAKE_TX] [nvarchar](30) NULL,
	[COLLATERAL_MODEL_TX] [nvarchar](30) NULL,
	[COLLATERAL_VIN_TX] [nvarchar](18) NULL,
	[COLLATERAL_EQUIP_TX] [nvarchar](100) NULL,
	[PROPERTY_FLOODZONE_TX] [nvarchar](10) NULL,
	[FLOOD_VALUE_TX] [nvarchar](1) NULL,
	[PROPERTY_ACV_NO] [decimal](19, 2) NULL,
	[PROPERTY_TITLE_CD] [char](3) NULL,
	[COLLATERAL_LINE1_TX] [nvarchar](100) NULL,
	[COLLATERAL_LINE2_TX] [nvarchar](100) NULL,
	[COLLATERAL_CITY_TX] [nvarchar](40) NULL,
	[COLLATERAL_STATE_TX] [nvarchar](30) NULL,
	[COLLATERAL_ZIP_TX] [nvarchar](30) NULL,
	[COLLATERAL_MORTGAGE_TX] [nvarchar](300) NULL,
--COVERAGE:
	[REQUIREDCOVERAGE_REQUIREDAMOUNT_NO] [decimal](18, 2) NULL,
	[COVERAGE_BASIS_CD] [nvarchar](4) NULL,
	[OTHER_AMOUNT_NO] [decimal](18, 2) NULL,
	[PHYSICALDAMAGE_AMOUNT_NO] [decimal](18, 2) NULL,
	[BODILYINJURYACCIDENT_AMOUNT_NO] [decimal](18, 2) NULL,
	[BODILYINJURYPERSON_AMOUNT_NO] [decimal](18, 2) NULL,
	[COVERAGE_AMOUNT_NO] [decimal](18, 2) NULL,
	[COVERAGE_CA_AMOUNT_NO] [decimal](18, 2) NULL,
	[OTHER_DEDUCTIBLE_NO] [decimal](18, 2) NULL,
	[COMPREHENSIVE_DEDUCTIBLE_NO] [decimal](18, 2) NULL,
	[COLLISION_DEDUCTIBLE_NO] [decimal](18, 2) NULL,
	[PHYSICALDAMAGE_DEDUCTIBLE_NO] [decimal](18, 2) NULL,
	[COVERAGE_STATUS_TX] [nvarchar](1000) NULL,
	[COVERAGEWAIVE_MEANING_TX] [nvarchar](1000) NULL,
	[IMPAIRMENT_CODE_TX] [nvarchar](40) NULL,
	[IMPAIRMENT_MEANING_TX] [nvarchar](1000) NULL,
	[DOCTYPE_CODE_TX] [nvarchar](20) NULL,
	[CANCEL_MEANING_TX] [nvarchar](1000) NULL,
	[NOTICE_DT] [datetime2](7) NULL,
	[NOTICE_TYPE_CD] [nvarchar](4) NULL,
	[NOTICE_TYPE_TX] [nvarchar](1000) NULL,
	[NOTICE_SEQ_NO] [int] NULL,
	[COVERAGE_EXPOSURE_DT] [datetime2](7) NULL,
	[COVERAGE_WAIVE_STATUS_DT] [datetime2](7) NULL,
	[COVERAGE_WAIVE_EVENT_DT] [datetime2](7) NULL,
	[COVERAGE_WAIVE_OFFICER_TX] [nvarchar](10),
	[COVERAGE_WAIVE_TERM] [nvarchar](10),
	[COVERAGE_WAIVE_REM_TERM] [nvarchar](10),
	[LENDER_REVIEW_EVENT] [nvarchar](1000) NULL,
--INSURANCE:
	[INSCOMPANY_NAME_TX] [nvarchar](100) NULL,
	[INSCOMPANY_POLICY_NO] [nvarchar](30) NULL,
	[INSCOMPANY_EFF_DT] [datetime2](7) NULL,
	[INSCOMPANY_EFFDTSORT_TX] [nvarchar](8) NULL,
	[INSCOMPANY_EXP_DT] [datetime2](7) NULL,
	[INSCOMPANY_EXP_DAYS] [int] NULL,
	[INSCOMPANY_CAN_DT] [datetime2](7) NULL,
	[INSCOMPANY_EXPCXL_DT] [datetime2](7) NULL,
	[INSCOMPANY_EXPCXLDTSORT_TX] [nvarchar](8) NULL,
	[INSCOMPANY_UNINS_DAYS] [int] NULL,
	[INSCOMPANY_UNINSGROUP_TX] [nvarchar](30) NULL,
	[CPI_QUOTE_TERM_NO] [int] NULL,
	[CPI_PREMIUM_AMOUNT_NO] [decimal](18, 2) NULL,
	[PC_PREMIUM_AMOUNT_NO] [decimal](18, 2) NULL,
	
	[INSCOMPANY2_NAME_TX] [nvarchar](100) NULL,
	[INSCOMPANY2_POLICY_NO] [nvarchar](30) NULL,
	[INSCOMPANY2_EFF_DT] [datetime2](7) NULL,
	[INSCOMPANY2_EFFDTSORT_TX] [nvarchar](8) NULL,
	[INSCOMPANY2_EXP_DT] [datetime2](7) NULL,
	[INSCOMPANY2_EXP_DAYS] [int] NULL,
	[INSCOMPANY2_CAN_DT] [datetime2](7) NULL,
	[INSCOMPANY2_EXPCXL_DT] [datetime2](7) NULL,
	[INSCOMPANY2_EXPCXLDTSORT_TX] [nvarchar](8) NULL,
--BORROWER INSURANCE:
	[BORRINSCOMPANY_NAME_TX] [nvarchar](50) NULL,
	[BORRINSCOMPANY_POLICY_NO] [nvarchar](30) NULL,
	[BORRINSCOMPANY_EFF_DT] [datetime2](7) NULL,
	[BORRINSCOMPANY_EXP_DT] [datetime2](7) NULL,
	[BORRINSCOMPANY_EXP_DAYS] [int] NULL,
	[BORRINSCOMPANY_CAN_DT] [datetime2](7) NULL,
	[BORRINSCOMPANY_EXPCXL_DT] [datetime2](7) NULL,
	[BORRINSCOMPANY_EXPCXLDTSORT_TX] [nvarchar](8) NULL,
	[BORRINSCOMPANY_FLOODZONE_TX][nvarchar](10) NULL,	
	[BORRINSCOMPANY2_FLOODZONE_TX][nvarchar](10) NULL,
	[OLDINSURANCE_DT] [datetime2](7) NULL,
	[MAIL_DT] [datetime2](7) NULL,
	[INSAGENCY_NAME_TX] [nvarchar](100) NULL,
	[INSAGENCY_PHONE_TX] [nvarchar](20) NULL,
--ESCROW:
	[ESCROW_IN_REQ_COV_TX] [char](1) NULL, 
	[ESCROW_DUE_DT] [datetime2](7) NULL,
--IDs, STATUS:
	[LOAN_ID] [bigint] NULL,
	[COLLATERAL_ID] [bigint] NULL,
	[PROPERTY_ID] [bigint] NULL,
	[REQUIREDCOVERAGE_ID] [bigint] NULL,
	[LOAN_STATUSCODE] [nvarchar] (2) NULL,
	[LOAN_STATUSMEANING_TX] [nvarchar](1000) NULL,
	[LOAN_UNMATCH_CNT] [int] NULL,	
	[COLLATERAL_STATUSCODE] [nvarchar] (2) NULL,
	[COLLATERAL_STATUSMEANING_TX] [nvarchar](1000) NULL,
	[COLLATERAL_UNMATCH_CNT] [int] NULL,	
	[REQUIREDCOVERAGE_STATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_STATUSMEANING_TX] [nvarchar](1000) NULL,
	[REQUIREDCOVERAGE_SUBSTATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_INSSTATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_INSSTATUSMEANING_TX] [nvarchar](1000) NULL,
	[REQUIREDCOVERAGE_INSSUBSTATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_INSSUBSTATUSMEANING_TX] [nvarchar](1000) NULL,
   [PROPERTY_DESCRIPTION] [nvarchar](1000) NULL,
-- LENDER OPTIONS:
	[OPT_MAX_BALANCE][decimal](18,2) NULL,
	[OPT_MIN_BALANCE][decimal](18,2) NULL,
	[OPT_TITLE_START_DT] [datetime] NULL,
	[OPT_BALANCE_ABOVE_MAX] [nvarchar] (10) NULL,
	[OPT_BALANCE_BELOW_MIN] [nvarchar] (10) NULL,
	[OPT_EFF_DT_GREATER_TITLE_START_DT] [nvarchar] (10) NULL,
	[OPT_BALANCE_TYPE] [nvarchar] (20) NULL,
-- PARAMETERS:
	[REPORT_GROUPBY_TX] [nvarchar](1000) NULL,
	[REPORT_SORTBY_TX] [nvarchar](1000) NULL,
	[REPORT_HEADER_TX] [nvarchar](1000) NULL,
	[REPORT_FOOTER_TX] [nvarchar](1000) NULL,
	[REPORT_GROUPBY_FIELDS_TX] [nvarchar](1000) NULL
	
	,[Crossed] [nvarchar](max) NULL
) ON [PRIMARY]
CREATE TABLE [dbo].[#tmpfilter](
	[ATTRIBUTE_CD] [nvarchar](50) NULL,
	[VALUE_TX] [nvarchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[#tmpimpaired](
	[ATTRIBUTE_CD] [nvarchar](50) NULL,
	[VALUE_TX] [nvarchar](50) NULL
) ON [PRIMARY]

Select @LenderID=ID from LENDER where CODE_TX = @LenderCode AND PURGE_DT IS NULL

Declare @LoanStatus as varchar(5)
Declare @CollateralStatus as varchar(5)
Declare @RequiredCoverageStatus as varchar(5)
--Declare @RequiredCoverageSubStatus as varchar(5)
Declare @SummaryStatus as varchar(5)
Declare @SummarySubStatus as varchar(5)
Declare @GroupBySQL as varchar(1000)
Declare @SortBySQL as varchar(1000)
Declare @FilterBySQL as varchar(1000)
Declare @HeaderTx as varchar(1000)
Declare @FooterTx as varchar(1000)
Declare @FillerZero as varchar(18)
Declare @RecordCount as bigint
Declare @Impaired as char(1)

Set @LoanStatus = NULL
Set @CollateralStatus = NULL
Set @RequiredCoverageStatus = NULL
--Set @RequiredCoverageSubStatus = NULL
Set @SummaryStatus = NULL
Set @SummarySubStatus = NULL
Set @FillerZero = '000000000000000000'
Set @RecordCount = 0
Set @Impaired = NULL

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
from REF_CODE RC
Join REF_CODE_ATTRIBUTE RAD on RAD.DOMAIN_CD = RC.DOMAIN_CD and RAD.REF_CD = 'DEFAULT' and RAD.ATTRIBUTE_CD like 'FIL%'
left Join REF_CODE_ATTRIBUTE RA on RA.DOMAIN_CD = RC.DOMAIN_CD and RA.REF_CD = RC.CODE_CD and RA.ATTRIBUTE_CD = RAD.ATTRIBUTE_CD
left Join
  (
  Select CODE_TX,REPORT_CD,REPORT_DOMAIN_CD,REPORT_REF_ATTRIBUTE_CD,VALUE_TX from REPORT_CONFIG RC
  Join REPORT_CONFIG_ATTRIBUTE RCA on RCA.REPORT_CONFIG_ID = RC.ID
  ) Custom
   on Custom.CODE_TX = @SpecificReport and Custom.REPORT_DOMAIN_CD = RAD.DOMAIN_CD and Custom.REPORT_REF_ATTRIBUTE_CD = RAD.ATTRIBUTE_CD and Custom.REPORT_CD = @ReportType
where RC.DOMAIN_CD = @ReportDomainName and RC.CODE_CD = @ReportType

Select @LoanStatus =  Value_TX from #tmpfilter where ATTRIBUTE_CD = 'FIL_LNStatus'
Select @CollateralStatus = Value_TX from #tmpfilter where ATTRIBUTE_CD = 'FIL_CLStatus'
Select @RequiredCoverageStatus =  Value_TX from #tmpfilter where ATTRIBUTE_CD = 'FIL_RCStatus'
--Select @RequiredCoverageSubStatus =  Value_TX from #tmpfilter where ATTRIBUTE_CD = 'FIL_RCSubStatus'
Select @SummaryStatus =  Value_TX from #tmpfilter where ATTRIBUTE_CD = 'FIL_INSStatus'
Select @SummarySubStatus =  Value_TX from #tmpfilter where ATTRIBUTE_CD = 'FIL_INSSubStatus'

DECLARE @PAGEBREAK AS VARCHAR(1) = 'F'
DECLARE @PAGEBREAK_COLUMN AS VARCHAR(20) = ''
SELECT @PAGEBREAK = ISNULL(VALUE_TX,'F') FROM #tmpfilter WHERE ATTRIBUTE_CD = 'FIL_PAGEBREAK'
SELECT @PAGEBREAK_COLUMN = ISNULL(VALUE_TX,'') FROM #tmpfilter WHERE ATTRIBUTE_CD = 'FIL_PAGEBREAK_COLUMN'

if @SpecificReport is NULL or @SpecificReport = '' or @SpecificReport = '0000'
  Begin
	IF @GroupByCode IS NULL OR @GroupByCode = ''
		SELECT @GroupBySQL=GROUP_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportType
	ELSE
		SELECT @GroupBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_GroupBy' AND CODE_CD = @GroupByCode
	IF @SortByCode IS NULL OR @SortByCode = ''
		SELECT @SortBySQL=SORT_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportType
	ELSE
		SELECT @SortBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_SortBy' AND CODE_CD = @SortByCode
	IF @FilterByCode IS NULL OR @FilterByCode = ''
		SELECT @FilterBySQL=FILTER_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportType
	Else
		SELECT @FilterBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_FilterBy' AND CODE_CD = @FilterByCode

	Select @HeaderTx=HEADER_TX from REPORT_CONFIG where CODE_TX = @ReportType
	Select @FooterTx=FOOTER_TX from REPORT_CONFIG where CODE_TX = @ReportType
  End
else
  Begin
	IF @GroupByCode IS NULL OR @GroupByCode = ''
		SELECT @GroupBySQL=GROUP_TX FROM REPORT_CONFIG WHERE CODE_TX = @SpecificReport
	ELSE
		SELECT @GroupBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_GroupBy' AND CODE_CD = @GroupByCode
	IF @SortByCode IS NULL OR @SortByCode = ''
		SELECT @SortBySQL=SORT_TX FROM REPORT_CONFIG WHERE CODE_TX = @SpecificReport
	ELSE
		SELECT @SortBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_SortBy' AND CODE_CD = @SortByCode
	IF @FilterByCode IS NULL OR @FilterByCode = ''
		SELECT @FilterBySQL=FILTER_TX FROM REPORT_CONFIG WHERE CODE_TX = @SpecificReport
	Else
		SELECT @FilterBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_FilterBy' AND CODE_CD = @FilterByCode

	Select @HeaderTx=HEADER_TX from REPORT_CONFIG where CODE_TX = @SpecificReport
	Select @FooterTx=FOOTER_TX from REPORT_CONFIG where CODE_TX = @SpecificReport
  End


Insert into #tmpimpaired (
	ATTRIBUTE_CD,
	VALUE_TX)

Select
RAD.ATTRIBUTE_CD,
Case
  when Custom.VALUE_TX is not NULL then Custom.VALUE_TX
  when RA.VALUE_TX is not NULL then RA.VALUE_TX
  else RAD.VALUE_TX
End as VALUE_TX
from REF_CODE RC
Join REF_CODE_ATTRIBUTE RAD on RAD.DOMAIN_CD = RC.DOMAIN_CD and RAD.REF_CD = 'DEFAULT' and RAD.ATTRIBUTE_CD like 'IMP%'
left Join REF_CODE_ATTRIBUTE RA on RA.DOMAIN_CD = RC.DOMAIN_CD and RA.REF_CD = RC.CODE_CD and RA.ATTRIBUTE_CD = RAD.ATTRIBUTE_CD
left Join
  (
  Select CODE_TX,REPORT_CD,REPORT_DOMAIN_CD,REPORT_REF_ATTRIBUTE_CD,VALUE_TX from REPORT_CONFIG RC
  Join REPORT_CONFIG_ATTRIBUTE RCA on RCA.REPORT_CONFIG_ID = RC.ID
  ) Custom
   on Custom.CODE_TX = @SpecificReport and Custom.REPORT_DOMAIN_CD = RAD.DOMAIN_CD and Custom.REPORT_REF_ATTRIBUTE_CD = RAD.ATTRIBUTE_CD and Custom.REPORT_CD = @ReportType
where RC.DOMAIN_CD = @ReportDomainName and RC.CODE_CD = @ReportType

Select @Impaired = 'T' from #tmpimpaired where VALUE_TX = 'T'
Select @Impaired = 'T' where @GroupBySQL like '%IMPAIRMENT%'
Select @Impaired = 'T' where @FilterBySQL like '%IMPAIRMENT%'


declare @columns varchar(max)
declare @insert varchar(4000)
declare @joins varchar(max)
declare @conditions varchar(max)

select @insert =
N'Insert into #tmptable_initial (
LOAN_BRANCHCODE_TX,
LOAN_PAGEBREAKTYPE_TX,
LOAN_PAGEBREAK_TX,
LOAN_DIVISIONCODE_TX,
REQUIREDCOVERAGE_CODE_TX,
--LOAN:
LOAN_NUMBER_TX,
LOAN_NUMBERSORT_TX,
LOAN_EFFECTIVE_DT,
LOAN_EFFDTSORT_TX,
LOAN_MATURITY_DT,
LOAN_TERM_NO,
LOAN_BALANCE_NO,
LOAN_BALANCESORT_TX,
LOAN_ORIGINALBALANCE_AMOUNT_NO,
LOAN_BALANCE_DT,
LOAN_BALDTFORMAT_TX,
LOAN_APR_AMOUNT_NO,
LOAN_PAYMENT_FREQUENCY_CD,
LOAN_NOTE_TX,
LOAN_OFFICERCODE_TX,
LOAN_DEALERCODE_TX,
LOAN_CREDITSCORECODE_TX,
LOAN_BAL_NO,
LN_LastPmtDt,
LN_NextPmtDt,
LOAN_LENDER_BRANCH_CODE_TX,
   LOAN_PREDICTIVE_SCORE_NO,
   LOAN_PREDICTIVE_DECILE_NO,
--LENDER:
LOAN_LENDERCODE_TX,
LENDER_NAME_TX,
--COLLATERAL:
COLLATERAL_NUMBER_NO,
LENDER_COLLATERAL_CODE_TX,
COLLATERAL_LOAN_PERCENTAGE_NO,
LENDER_STATUS_OFFICER_TX,
LEGAL_STATUS_CODE_TX,
PURPOSE_CODE_TX,
--OWNER:
OWNER_LASTNAME_TX,
OWNER_FIRSTNAME_TX,
OWNER_MIDDLEINITIAL_TX,
OWNER_COSIGN_TX,
OWNER_CREDIT_SCORE_TX,
--PROPERTY:
COLLATERAL_YEAR_TX,
COLLATERAL_MAKE_TX,
COLLATERAL_MODEL_TX,
COLLATERAL_VIN_TX,
COLLATERAL_EQUIP_TX,
[PROPERTY_FLOODZONE_TX],
FLOOD_VALUE_TX,
PROPERTY_ACV_NO,
PROPERTY_TITLE_CD,
--COVERAGE:
REQUIREDCOVERAGE_REQUIREDAMOUNT_NO,
DOCTYPE_CODE_TX,
NOTICE_DT,
NOTICE_TYPE_CD,
NOTICE_SEQ_NO,
COVERAGE_EXPOSURE_DT,
--ESCROW:
[ESCROW_IN_REQ_COV_TX],
--IDs, STATUS:
LOAN_ID,
LENDER_ID,
COLLATERAL_ID,
COLLATERAL_CODE_ID,
PROPERTY_ID,
REQUIREDCOVERAGE_ID,
LOAN_STATUSCODE,
LOAN_UNMATCH_CNT,
COLLATERAL_STATUSCODE,
COLLATERAL_UNMATCH_CNT,
REQUIREDCOVERAGE_STATUSCODE,
REQUIREDCOVERAGE_SUBSTATUSCODE,
REQUIREDCOVERAGE_INSSTATUSCODE,
REQUIREDCOVERAGE_INSSUBSTATUSCODE,
OWNER_ADDRESS_ID,
PROPERTY_ADDRESS_ID,
OPT_MAX_BALANCE,
OPT_MIN_BALANCE,
OPT_TITLE_START_DT,
OPT_BALANCE_TYPE,
PCP_INSURANCE_COMPANY_NAME_TX,
PCP_POLICY_NUMBER_TX,
PCP_EFFECTIVE_DT,
PCP_EXPIRATION_DT,
PCP_CANCELLATION_DT,
PCP_TOTAL_PREMIUM_NO,
FPC_CARRIER_ID,
FPC_CPI_QUOTE_ID,
FPC_NUMBER_TX,
FPC_EFFECTIVE_DT,
FPC_EXPIRATION_DT,
FPC_CANCELLATION_DT
)
'

select @columns =
N'Select
	  CASE when ISNULL(L.BRANCH_CODE_TX,'''') = ''''
			THEN ''No Branch''
			ELSE L.BRANCH_CODE_TX
	  END as [LOAN_BRANCHCODE_TX],
	  CASE WHEN @PAGEBREAK = ''T''
			THEN @PAGEBREAK_COLUMN
			ELSE ''''
	  END AS [LOAN_PAGEBREAKTYPE_TX],
	  CASE WHEN @PAGEBREAK = ''T''
			THEN (CASE  WHEN @PAGEBREAK_COLUMN = ''Branch''
						THEN (	CASE WHEN ISNULL(L.BRANCH_CODE_TX,'''') = ''''
									 THEN ''No Branch''
									 ELSE L.BRANCH_CODE_TX
								END)
						ELSE ''''
				  END)
			ELSE ''''
	   END AS [LOAN_PAGEBREAK_TX],
	   CASE WHEN ISNULL(L.DIVISION_CODE_TX,'''') = ''''
			THEN ''0''
			ELSE L.DIVISION_CODE_TX
	   END AS [LOAN_DIVISIONCODE_TX],
	   RC.TYPE_CD as [REQUIREDCOVERAGE_CODE_TX],
'
select @columns = @columns +
--LOAN
N'
	   L.NUMBER_TX as [LOAN_NUMBER_TX],
	   SUBSTRING(@FillerZero, 1, 18 - len(L.NUMBER_TX)) + CAST(L.NUMBER_TX AS nvarchar(18)) AS [LOAN_NUMBERSORT_TX],
       L.EFFECTIVE_DT as [LOAN_EFFECTIVE_DT],
	   CONVERT(nvarchar(8), L.EFFECTIVE_DT, 112) as [LOAN_EFFDTSORT_TX],
	   L.MATURITY_DT as [LOAN_MATURITY_DT],
       DateDiff("m",L.EFFECTIVE_DT,L.MATURITY_DT) as [LOAN_TERM_NO],
       C.LOAN_BALANCE_NO as [LOAN_BALANCE_NO],
	   SUBSTRING(@FillerZero, 1, 15 - len(C.LOAN_BALANCE_NO)) + CAST(C.LOAN_BALANCE_NO AS nvarchar(15)) AS [LOAN_BALANCESORT_TX],
       L.ORIGINAL_BALANCE_AMOUNT_NO as [LOAN_ORIGINALBALANCE_AMOUNT_NO],
	   L.BALANCE_LAST_UPDATE_DT as [LOAN_BALANCE_DT],
	   CONVERT(nvarchar(10), L.BALANCE_LAST_UPDATE_DT, 101) as [LOAN_BALDTFORMAT_TX],
	   L.APR_AMOUNT_NO as [LOAN_APR_AMOUNT_NO],
	   L.PAYMENT_FREQUENCY_CD as [LOAN_PAYMENT_FREQUENCY_CD],
	   L.NOTE_TX as [LOAN_NOTE_TX],
	   (CASE when ISNULL(L.OFFICER_CODE_TX,'''') = '''' then ''No Loan Officer'' else L.OFFICER_CODE_TX END) as [LOAN_OFFICERCODE_TX],
	   L.DEALER_CODE_TX as [LOAN_DEALERCODE_TX],
	   L.CREDIT_SCORE_CD as [LOAN_CREDITSCORECODE_TX],
	   L.BALANCE_AMOUNT_NO as [LOAN_BAL_NO],
	   L.LAST_PAYMENT_DT as [LN_LastPmtDt],
	   L.NEXT_SCHEDULED_PAYMENT_DT as [LN_NextPmtDt],
      L.LENDER_BRANCH_CODE_TX as [LOAN_LENDER_BRANCH_CODE_TX],
   L.PREDICTIVE_SCORE_NO,
   L.PREDICTIVE_DECILE_NO,
'
select @columns = @columns +
--LENDER
N'
	   LND.CODE_TX as [LOAN_LENDERCODE_TX],
	   LND.NAME_TX as [LENDER_NAME_TX],
'
select @columns = @columns +
--COLLATERAL
N'
	   C.COLLATERAL_NUMBER_NO as [COLLATERAL_NUMBER_NO],
	   C.LENDER_COLLATERAL_CODE_TX as [LENDER_COLLATERAL_CODE_TX],
	   C.LOAN_PERCENTAGE_NO as [COLLATERAL_LOAN_PERCENTAGE_NO],
	   C.LENDER_STATUS_OFFICER_TX as [LENDER_STATUS_OFFICER_TX],
	   C.LEGAL_STATUS_CODE_TX as [LEGAL_STATUS_CODE_TX],
	   C.PURPOSE_CODE_TX as [PURPOSE_CODE_TX],
'
select @columns = @columns +
--OWNER
N'
       O.LAST_NAME_TX as [OWNER_LASTNAME_TX],
	   O.FIRST_NAME_TX as [OWNER_FIRSTNAME_TX],
	   O.MIDDLE_INITIAL_TX as [OWNER_MIDDLEINITIAL_TX],
	   Case when substring(OL.OWNER_TYPE_CD,1,1) = ''C'' then ''C'' else '''' End as [OWNER_COSIGN_TX],
	   O.CREDIT_SCORE_TX as [OWNER_CREDIT_SCORE_TX],
'
select @columns = @columns +
--PROPERTY
N'
       P.YEAR_TX as [COLLATERAL_YEAR_TX],
	   P.MAKE_TX as [COLLATERAL_MAKE_TX],
	   P.MODEL_TX as [COLLATERAL_MODEL_TX],
	   P.VIN_TX as [COLLATERAL_VIN_TX],
	   P.DESCRIPTION_TX as [COLLATERAL_EQUIP_TX],
	   P.FLOOD_ZONE_TX as [PROPERTY_FLOODZONE_TX],
	   left(isnull(P.FLOOD_ZONE_TX,'' ''),1) as [FLOOD_VALUE_TX],
	   P.ACV_NO as [PROPERTY_ACV_NO],
       (CASE when P.TITLE_CD = ''Y'' then ''Yes'' else ''No'' END) as [PROPERTY_TITLE_CD],
'
select @columns = @columns +
--COVERAGE
N'
       RC.REQUIRED_AMOUNT_NO as [REQUIREDCOVERAGE_REQUIREDAMOUNT_NO],
'
select @columns = @columns + N'
	   RC.MOST_RECENT_ATTACHED_DOC_TYPE_CD as [DOCTYPE_CODE_TX],
	   RC.NOTICE_DT as [NOTICE_DT],
	   RC.NOTICE_TYPE_CD as [NOTICE_TYPE_CD],
	   RC.NOTICE_SEQ_NO as [NOTICE_SEQ_NO],
	   RC.EXPOSURE_DT as [COVERAGE_EXPOSURE_DT],
'
-- ESCROW
select @columns = @columns + N'
		RC.ESCROW_IN AS [ESCROW_IN_REQ_COV_TX],
'
select @columns = @columns +
--IDs, STATUS
N'
       L.ID as [LOAN_ID],
       LND.ID as LENDER_ID,
	   C.ID as [COLLATERAL_ID],
	   C.COLLATERAL_CODE_ID as COLLATERAL_CODE_ID,
	   P.ID as [PROPERTY_ID],
	   RC.ID as [REQUIREDCOVERAGE_ID],
       L.STATUS_CD as [LOAN_STATUSCODE],
	   L.EXTRACT_UNMATCH_COUNT_NO as [LOAN_UNMATCH_CNT],
       C.STATUS_CD as [COLLATERAL_STATUSCODE],
	   C.EXTRACT_UNMATCH_COUNT_NO as [COLLATERAL_UNMATCH_CNT],
       RC.STATUS_CD as [REQUIREDCOVERAGE_STATUSCODE],
       RC.SUB_STATUS_CD as [REQUIREDCOVERAGE_SUBSTATUSCODE],
       RC.SUMMARY_STATUS_CD as [REQUIREDCOVERAGE_INSSTATUSCODE],
       RC.SUMMARY_SUB_STATUS_CD as [REQUIREDCOVERAGE_INSSUBSTATUSCODE],
	   O.ADDRESS_ID as 	OWNER_ADDRESS_ID,
	   P.ADDRESS_ID AS PROPERTY_ADDRESS_ID,
'

if (@ReportType In ('CONTMAXBAL') OR @SpecificReport In ( 'WVEHIBAL'))
	or (@ReportType In ('WAIVE') AND @SpecificReport in ('WAIVE','0000'))
	or @SpecificReport = 'WAIVEHIG'
	or @ReportType In ('TITLE')
BEGIN

	select @columns = @columns +
	   N'CASE WHEN RC.BalanceOptionMaximumBalance is null THEN 0
			ELSE RC.BalanceOptionMaximumBalance END as [OPT_MAX_BALANCE],
	   CASE WHEN  RC.BalanceOptionMinimumBalance is null THEN 0
			ELSE RC.BalanceOptionMinimumBalance END AS [OPT_MIN_BALANCE],
	   RC.VehicleTitleOptionStartDate  AS [OPT_TITLE_START_DT],
	   RC.BalanceOptionBalanceType AS [OPT_BALANCE_TYPE],
'
end
else
	select @columns = @columns +
	   N'0 as [OPT_MAX_BALANCE],
	   0 AS [OPT_MIN_BALANCE],
	   null AS [OPT_TITLE_START_DT],
	   null AS [OPT_BALANCE_TYPE],
'

select @columns = @columns + 
	N'PCP.INSURANCE_COMPANY_NAME_TX,
	PCP.POLICY_NUMBER_TX,
	PCP.EFFECTIVE_DT,
	PCP.EXPIRATION_DT,
	PCP.CANCELLATION_DT,
	PCP.TOTAL_PREMIUM_NO,
	FPC.CARRIER_ID,
	FPC.CPI_QUOTE_ID,
	FPC.NUMBER_TX,
	FPC.EFFECTIVE_DT,
	FPC.EXPIRATION_DT,
	FPC.CANCELLATION_DT
'
select @joins =
N'from PROPERTY P
Join COLLATERAL C
	on C.PROPERTY_ID = P.ID AND C.PURGE_DT IS NULL
Join LOAN L
	on L.ID = C.LOAN_ID and L.LENDER_ID = P.LENDER_ID AND L.PURGE_DT IS NULL
'
--LEFT Join RELATED_DATA RD on RD.RELATE_ID = L.ID and DEF_ID = @RD_MISC1_ID
select @joins = @joins +
N'Join LENDER LND
	on LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL

Join OWNER_LOAN_RELATE OL
	on OL.LOAN_ID = L.ID and '
+ case when @SpecificReport = 'LNSTAT1C' then ' OL.OWNER_TYPE_CD = ''CS'' ' else ' OL.OWNER_TYPE_CD = ''B'' and OL.PRIMARY_IN = ''Y'' ' end
+ ' AND OL.PURGE_DT IS NULL
Join [OWNER] O on O.ID = OL.OWNER_ID AND O.PURGE_DT IS NULL
left Join REQUIRED_COVERAGE RC
	on RC.PROPERTY_ID = P.ID AND RC.PURGE_DT IS NULL
left Join PRIOR_CARRIER_POLICY PCP
	on PCP.REQUIRED_COVERAGE_ID = RC.ID and RC.SUMMARY_SUB_STATUS_CD = ''P'' AND PCP.PURGE_DT IS NULL
'
--LEFT JOIN OWNER_LOAN_RELATE OLDBA ON OLDBA.LOAN_ID = L.ID AND OLDBA.OWNER_TYPE_CD = ''DBA'' AND OLDBA.PURGE_DT IS NULL
select @joins = @joins
-- extract only the newest OWNER_LOAN_RELATE.OWNER_TYPE_CD = DBA re TFS #33688
+ case when  @SpecificReport = 'WAIVECYC'
      then ' Left Join WAIVE_TRACK WT on WT.REQUIRED_COVERAGE_ID = RC.ID and WT.TYPE_CD = ''W'' AND WT.PURGE_DT IS NULL '
      else '' end
+ 'left join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR on FPCR.REQUIRED_COVERAGE_ID = RC.ID and RC.SUMMARY_SUB_STATUS_CD = ''C'' AND FPCR.PURGE_DT IS NULL
left Join FORCE_PLACED_CERTIFICATE FPC on FPC.ID = FPCR.FPC_ID and FPC.ACTIVE_IN = ''Y'' and RC.SUMMARY_SUB_STATUS_CD = ''C'' AND FPC.PURGE_DT IS NULL
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID,  @Division) fn_FCBD 
'
/*
C
L
LND
O
OL
P
PCP
RC
WT
*/

select @conditions =
'where
L.RECORD_TYPE_CD = ''G'' and P.RECORD_TYPE_CD = ''G'' and RC.RECORD_TYPE_CD = ''G'' and '
+ case when @ReportType <> 'DUPCOLL' then
'L.EXTRACT_UNMATCH_COUNT_NO = 0 and C.EXTRACT_UNMATCH_COUNT_NO = 0 and
L.STATUS_CD != ''U'' and C.STATUS_CD != ''U'' and ' else '' end +
'(RC.STATUS_CD IS NULL OR RC.STATUS_CD <> ''I'') and
P.PURGE_DT IS NULL and

(
	((select count(*) from FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE REL where REQUIRED_COVERAGE_ID = RC.ID AND REL.PURGE_DT IS NULL and RC.SUMMARY_SUB_STATUS_CD = ''C'') < 2 ) 
	or
	((select count(*) from FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE REL where REQUIRED_COVERAGE_ID = RC.ID AND REL.PURGE_DT IS NULL and RC.SUMMARY_SUB_STATUS_CD = ''C'') >= 2 and FPC.ID is not null)
)
 and

P.LENDER_ID = @LenderID '
--and (L.BRANCH_CODE_TX = @BranchCode or @BranchCode = '1' or @BranchCode = '' or @BranchCode is NULL)
+ case when @Branch <> '1' and @Branch <> '' and @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end

+ char(10) + ' AND fn_FCBD.loanType IS NOT NULL'

--and (RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage is NULL)
+ case when isnull(@Coverage , '1') <> '1' then char(10) + ' and (RC.TYPE_CD = @Coverage) ' else '' end
--and (L.STATUS_CD = @LoanStatus or @LoanStatus is NULL or @LoanStatus = '')
+ case when isnull(@LoanStatus, '') <> '' then char(10) + ' and (L.STATUS_CD = @LoanStatus) ' else '' end
--and (C.STATUS_CD = @CollateralStatus or @CollateralStatus is NULL or @CollateralStatus = '')
+ case when isnull(@CollateralStatus, '') <> '' then char(10) + ' and (C.STATUS_CD = @CollateralStatus) ' else '' end
--and (RC.STATUS_CD = @RequiredCoverageStatus or @RequiredCoverageStatus is NULL or @RequiredCoverageStatus = '')
+ case when isnull(@RequiredCoverageStatus, '') <> '' then char(10)
     + ' and (RC.STATUS_CD = @RequiredCoverageStatus) ' else '' end
--+ char(10) + ' and ((RC.STATUS_CD = ''W'') or ((@RequiredCoverageSubStatus is NULL or @RequiredCoverageSubStatus = '''') and (RC.SUB_STATUS_CD is NULL or RC.SUB_STATUS_CD = '''')) or
--(@RequiredCoverageSubStatus is not NULL and (RC.SUB_STATUS_CD = @RequiredCoverageSubStatus or RC.SUB_STATUS_CD is NULL or RC.SUB_STATUS_CD = ''''))) '
--+ case when @RequiredCoverageStatus = 'W' then ''
--       when isnull(@RequiredCoverageSubStatus, '') = '' then char(10) + ' and (RC.SUB_STATUS_CD is NULL or RC.SUB_STATUS_CD = '''') '
--       else char(10) + ' and (RC.SUB_STATUS_CD = @RequiredCoverageSubStatus or RC.SUB_STATUS_CD is NULL or RC.SUB_STATUS_CD = '''') '
--	   end
--and (RC.SUMMARY_STATUS_CD = @SummaryStatus or @SummaryStatus is NULL or @SummaryStatus = '')
+ case when isnull(@SummaryStatus, '') <> '' then char(10)
     + ' and (RC.SUMMARY_STATUS_CD = @SummaryStatus) ' else '' end
--and (RC.SUMMARY_SUB_STATUS_CD = @SummarySubStatus or @SummarySubStatus is NULL or @SummarySubStatus = '')
+ case when isnull(@SummarySubStatus, '') <> '' then char(10)
     + ' and (RC.SUMMARY_SUB_STATUS_CD = @SummarySubStatus) ' else '' end

--and ((@SpecificReport = 'WAIVECYC' and WT.START_DT >= @BeginDate and WT.START_DT <= @EndDate) or (@SpecificReport <> 'WAIVECYC'))
--and ((@SpecificReport = 'BANKRUPT2230' and L.STATUS_DT >= @BeginDate and L.STATUS_DT <= @EndDate) or (@SpecificReport <> 'BANKRUPT2230'))
--02252013 next 2 AND statements
--AND ((@SpecificReport = 'PCARACT' and PCP.EFFECTIVE_DT >= @BeginDate and PCP.EFFECTIVE_DT <= @EndDate) or (@SpecificReport <> 'PCARACT'))
--AND ((@SpecificReport = 'PCARACT' AND ((PCP.CANCELLATION_DT Is Null And DateDiff(Day,GetDate(),PCP.EXPIRATION_DT) >= 0) Or (PCP.CANCELLATION_DT Is Not Null And DateDiff(s,PCP.UPDATE_DT,@BeginDate)<= 0))) OR @SpecificReport <> 'PCARACT')

+ case when @SpecificReport = 'WAIVECYC' then char(10)
            + ' and (WT.START_DT >= @BeginDate and WT.START_DT <= @EndDate) '
	   when @SpecificReport = 'BANKRUPT2230' then char(10)
	        + ' and (L.STATUS_DT >= @BeginDate and L.STATUS_DT <= @EndDate) '
	   when @SpecificReport = 'PCARACT' then char(10)
	        + ' and (PCP.EFFECTIVE_DT >= @BeginDate and PCP.EFFECTIVE_DT <= @EndDate) '
	        + ' AND ((PCP.CANCELLATION_DT Is Null And DateDiff(Day,GetDate(),PCP.EXPIRATION_DT) >= 0) Or (PCP.CANCELLATION_DT Is Not Null And DateDiff(s,PCP.UPDATE_DT,@BeginDate)<= 0))'
	   else '' end

declare @initialquery nvarchar(max)
select @initialquery =  @insert + @columns + @joins + isnull(@conditions,'')
if @debug = 1
begin
	select @insert
	select @columns
	select @joins
	select isnull(@conditions,'')
	--select convert(xml, @initialquery)
end

declare @rval INT, @error INT, @rowcount int

exec @rval = sp_executesql @initialquery, 
					N'@PAGEBREAK varchar(1), @PAGEBREAK_COLUMN varchar(20), @FillerZero varchar(18), @Division nvarchar(10), @LenderID bigint, @CollateralStatus varchar(5), @Coverage nvarchar(100), @LoanStatus varchar(5), @RequiredCoverageStatus varchar(5), @SummaryStatus varchar(5), @SummarySubStatus varchar(5), @BeginDate datetime2(7), @EndDate datetime2(7)',
					@PAGEBREAK, @PAGEBREAK_COLUMN, @FillerZero, @Division, @LenderID, @CollateralStatus, @Coverage, @LoanStatus, @RequiredCoverageStatus, @SummaryStatus, @SummarySubStatus, @BeginDate, @EndDate
select @error = @@error, @rowcount = @@rowcount
if @error <> 0 or @rval <> 0
	return

if @debug = 1
begin
	select '#tmptable_initial count' = @rowcount
END


/*********************************************************************************************************
**********************************************************************************************************
**********************************************************************************************************
***** Build Final Query Here *****************************************************************************
**********************************************************************************************************
**********************************************************************************************************
**********************************************************************************************************/

set @insert=''
Set @columns=''
Set @joins=''
Set @conditions=''

select @insert =
N'Insert into #tmptable (
LOAN_BRANCHCODE_TX,
LOAN_PAGEBREAKTYPE_TX,
LOAN_PAGEBREAK_TX,
LOAN_DIVISIONCODE_TX,
LOAN_TYPE_TX,
REQUIREDCOVERAGE_CODE_TX,
REQUIREDCOVERAGE_TYPE_TX,
--LOAN:
LOAN_NUMBER_TX,
LOAN_NUMBERSORT_TX,
LOAN_EFFECTIVE_DT,
LOAN_EFFDTSORT_TX,
LOAN_MATURITY_DT,
LOAN_TERM_NO,
LOAN_BALANCE_NO,
LOAN_BALANCESORT_TX,
LOAN_ORIGINALBALANCE_AMOUNT_NO,
LOAN_BALANCE_DT,
LOAN_BALDTFORMAT_TX,
LOAN_APR_AMOUNT_NO,
LOAN_PAYMENT_FREQUENCY_CD,
LOAN_NOTE_TX,
LOAN_OFFICERCODE_TX,
LOAN_DEALERCODE_TX,
LOAN_CREDITSCORECODE_TX,
LOAN_BAL_NO,
LN_LastPmtDt,
LN_NextPmtDt,
LOAN_LENDER_BRANCH_CODE_TX,
LOAN_PREDICTIVE_SCORE_NO,
LOAN_PREDICTIVE_DECILE_NO,
--LOAN RELATED DATA
[MISC1_TX],
--LENDER:
LOAN_LENDERCODE_TX,
LENDER_NAME_TX,
--COLLATERAL:
COLLATERAL_NUMBER_NO,
COLLATERAL_CODE_TX,
PROPERTY_TYPE_CD,
LENDER_COLLATERAL_CODE_TX,
COLLATERAL_LOAN_PERCENTAGE_NO,
LENDER_STATUS_OFFICER_TX,
LEGAL_STATUS_CODE_TX,
PURPOSE_CODE_TX,
--OWNER:
OWNER_LASTNAME_TX,
OWNER_FIRSTNAME_TX,
OWNER_MIDDLEINITIAL_TX,
OWNER_NAME_TX,
ADDITIONAL_INSURED_NAME_TX,
ADDITIONAL_INSURED_CNT,
OWNER_COSIGN_TX,
OWNER_LINE1_TX,
OWNER_LINE2_TX,
OWNER_CITY_TX,
OWNER_STATE_TX,
OWNER_ZIP_TX,
OWNER_CREDIT_SCORE_TX,
--PROPERTY:
COLLATERAL_YEAR_TX,
COLLATERAL_MAKE_TX,
COLLATERAL_MODEL_TX,
COLLATERAL_VIN_TX,
COLLATERAL_EQUIP_TX,
PROPERTY_FLOODZONE_TX,
FLOOD_VALUE_TX,
PROPERTY_ACV_NO,
PROPERTY_TITLE_CD,
COLLATERAL_LINE1_TX,
COLLATERAL_LINE2_TX,
COLLATERAL_CITY_TX,
COLLATERAL_STATE_TX,
COLLATERAL_ZIP_TX,
COLLATERAL_MORTGAGE_TX,
--COVERAGE:
REQUIREDCOVERAGE_REQUIREDAMOUNT_NO,
COVERAGE_BASIS_CD,
OTHER_AMOUNT_NO,
PHYSICALDAMAGE_AMOUNT_NO,
BODILYINJURYACCIDENT_AMOUNT_NO,
BODILYINJURYPERSON_AMOUNT_NO,
COVERAGE_AMOUNT_NO,
COVERAGE_CA_AMOUNT_NO,
OTHER_DEDUCTIBLE_NO,
COMPREHENSIVE_DEDUCTIBLE_NO,
COLLISION_DEDUCTIBLE_NO,
PHYSICALDAMAGE_DEDUCTIBLE_NO,
COVERAGE_STATUS_TX,
COVERAGEWAIVE_MEANING_TX,
IMPAIRMENT_CODE_TX,
IMPAIRMENT_MEANING_TX,
DOCTYPE_CODE_TX,
CANCEL_MEANING_TX,
NOTICE_DT,
NOTICE_TYPE_CD,
NOTICE_TYPE_TX,
NOTICE_SEQ_NO,
COVERAGE_EXPOSURE_DT,
COVERAGE_WAIVE_STATUS_DT,
COVERAGE_WAIVE_EVENT_DT,
COVERAGE_WAIVE_OFFICER_TX,
COVERAGE_WAIVE_TERM,
COVERAGE_WAIVE_REM_TERM,
LENDER_REVIEW_EVENT,
--INSURANCE:
INSCOMPANY_NAME_TX,
INSCOMPANY_POLICY_NO,
INSCOMPANY_EFF_DT,
INSCOMPANY_EFFDTSORT_TX,
INSCOMPANY_EXP_DT,
INSCOMPANY_EXP_DAYS,
INSCOMPANY_CAN_DT,
INSCOMPANY_EXPCXL_DT,
INSCOMPANY_EXPCXLDTSORT_TX,
INSCOMPANY_UNINS_DAYS,
INSCOMPANY_UNINSGROUP_TX,
CPI_QUOTE_TERM_NO,
CPI_PREMIUM_AMOUNT_NO,
PC_PREMIUM_AMOUNT_NO,

INSCOMPANY2_NAME_TX,
INSCOMPANY2_POLICY_NO,
INSCOMPANY2_EFF_DT,
INSCOMPANY2_EFFDTSORT_TX,
INSCOMPANY2_EXP_DT,
INSCOMPANY2_EXP_DAYS,
INSCOMPANY2_CAN_DT,
INSCOMPANY2_EXPCXL_DT,
INSCOMPANY2_EXPCXLDTSORT_TX,
--BORROWER INSURANCE
BORRINSCOMPANY_NAME_TX,
BORRINSCOMPANY_POLICY_NO,
BORRINSCOMPANY_EFF_DT,
BORRINSCOMPANY_EXP_DT,
BORRINSCOMPANY_EXP_DAYS,
BORRINSCOMPANY_CAN_DT,
BORRINSCOMPANY_EXPCXL_DT,
BORRINSCOMPANY_EXPCXLDTSORT_TX,
BORRINSCOMPANY_FLOODZONE_TX,
BORRINSCOMPANY2_FLOODZONE_TX,
OLDINSURANCE_DT,
MAIL_DT,
INSAGENCY_NAME_TX,INSAGENCY_PHONE_TX,
--ESCROW:
ESCROW_IN_REQ_COV_TX,
ESCROW_DUE_DT,
--IDs, STATUS:
LOAN_ID,
COLLATERAL_ID,
PROPERTY_ID,
REQUIREDCOVERAGE_ID,
LOAN_STATUSCODE,
LOAN_STATUSMEANING_TX,
LOAN_UNMATCH_CNT,
COLLATERAL_STATUSCODE,
COLLATERAL_STATUSMEANING_TX,
COLLATERAL_UNMATCH_CNT,
REQUIREDCOVERAGE_STATUSCODE,
REQUIREDCOVERAGE_STATUSMEANING_TX,
REQUIREDCOVERAGE_SUBSTATUSCODE,
REQUIREDCOVERAGE_INSSTATUSCODE,
REQUIREDCOVERAGE_INSSTATUSMEANING_TX,
REQUIREDCOVERAGE_INSSUBSTATUSCODE,
REQUIREDCOVERAGE_INSSUBSTATUSMEANING_TX,
PROPERTY_DESCRIPTION,
OPT_MAX_BALANCE,
OPT_MIN_BALANCE,
OPT_TITLE_START_DT,
OPT_BALANCE_TYPE)
'

select @columns =
'Select
	  T.[LOAN_BRANCHCODE_TX],
	  T.[LOAN_PAGEBREAKTYPE_TX],
	  T.[LOAN_PAGEBREAK_TX],
	  T.[LOAN_DIVISIONCODE_TX],
	   ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as [LOAN_TYPE_TX],
	  T.[REQUIREDCOVERAGE_CODE_TX],
	   RC_COVERAGETYPE.MEANING_TX as [REQUIREDCOVERAGE_TYPE_TX],
'
select @columns = @columns +
--LOAN
'
	   T.[LOAN_NUMBER_TX],
	   T.[LOAN_NUMBERSORT_TX],
       T.[LOAN_EFFECTIVE_DT],
	   T.[LOAN_EFFDTSORT_TX],
	   T.[LOAN_MATURITY_DT],
       T.[LOAN_TERM_NO],
       T.[LOAN_BALANCE_NO],
	   T.[LOAN_BALANCESORT_TX],
       T.[LOAN_ORIGINALBALANCE_AMOUNT_NO],
	   T.[LOAN_BALANCE_DT],
	   T.[LOAN_BALDTFORMAT_TX],
	   T.[LOAN_APR_AMOUNT_NO],
	   T.[LOAN_PAYMENT_FREQUENCY_CD],
	   T.[LOAN_NOTE_TX],
	   T.[LOAN_OFFICERCODE_TX],
	   T.[LOAN_DEALERCODE_TX],
	   T.[LOAN_CREDITSCORECODE_TX],
	   T.[LOAN_BAL_NO],
	   T.[LN_LastPmtDt],
	   T.[LN_NextPmtDt],
       T.[LOAN_LENDER_BRANCH_CODE_TX],
	  T.LOAN_PREDICTIVE_SCORE_NO,
	  T.LOAN_PREDICTIVE_DECILE_NO,
'
select @columns = @columns +
--LOAN RELATED DATA
'
	   left(isnull(RD.VALUE_TX,'' ''),1) as [MISC1_TX],
'
select @columns = @columns +
--LENDER
'
	   T.[LOAN_LENDERCODE_TX],
	   T.[LENDER_NAME_TX],
'
select @columns = @columns +
--COLLATERAL
'
	   T.[COLLATERAL_NUMBER_NO],
	   CC.CODE_TX as [COLLATERAL_CODE_TX],
	   RCA_PROP.VALUE_TX AS [PROPERTY_TYPE_CD],
	   T.[LENDER_COLLATERAL_CODE_TX],
	   T.[COLLATERAL_LOAN_PERCENTAGE_NO],
	   T.[LENDER_STATUS_OFFICER_TX],
	   T.[LEGAL_STATUS_CODE_TX],
	   T.[PURPOSE_CODE_TX],
'
select @columns = @columns +
--OWNER
'
       T.[OWNER_LASTNAME_TX],
	   T.[OWNER_FIRSTNAME_TX],
	   T.[OWNER_MIDDLEINITIAL_TX],
       CASE WHEN ISNULL(ODBA.NAME_TX,'''') = '''' THEN ODBA.LAST_NAME_TX ELSE ODBA.NAME_TX END AS [OWNER_NAME_TX],
       '''' as [ADDITIONAL_INSURED_NAME_TX],
	   (select COUNT(*) from OWNER_LOAN_RELATE where LOAN_ID = T.LOAN_ID and OWNER_TYPE_CD = ''AI'' and PURGE_DT is null) as [ADDITIONAL_INSURED_CNT],
	   T.[OWNER_COSIGN_TX],
       AO.LINE_1_TX as [OWNER_LINE1_TX],
	   AO.LINE_2_TX as [OWNER_LINE2_TX],
	   AO.CITY_TX as [OWNER_CITY_TX],
       AO.STATE_PROV_TX as [OWNER_STATE_TX],
	   AO.POSTAL_CODE_TX as [OWNER_ZIP_TX],
	   T.[OWNER_CREDIT_SCORE_TX],
'
select @columns = @columns +
--PROPERTY
'
       T.[COLLATERAL_YEAR_TX],
	   T.[COLLATERAL_MAKE_TX],
	   T.[COLLATERAL_MODEL_TX],
	   T.[COLLATERAL_VIN_TX],
	   T.[COLLATERAL_EQUIP_TX],
	   T.[PROPERTY_FLOODZONE_TX],
	   T.[FLOOD_VALUE_TX],
	   T.[PROPERTY_ACV_NO],
       T.[PROPERTY_TITLE_CD],
       AM.LINE_1_TX as [COLLATERAL_LINE1_TX],
	   AM.LINE_2_TX as [COLLATERAL_LINE2_TX],
	   AM.CITY_TX as [COLLATERAL_CITY_TX],
	   AM.STATE_PROV_TX as [COLLATERAL_STATE_TX],
	   AM.POSTAL_CODE_TX as [COLLATERAL_ZIP_TX],
       isnull(AM.LINE_1_TX,'''') + '' '' + isnull(AM.LINE_2_TX,'''') + '' '' + isnull(AM.CITY_TX,'''') + '' '' +
			isnull(AM.STATE_PROV_TX,'''') + '' '' + isnull(AM.POSTAL_CODE_TX,'''') as [COLLATERAL_MORTGAGE_TX],
'
select @columns = @columns +
--COVERAGE
'
       T.[REQUIREDCOVERAGE_REQUIREDAMOUNT_NO],
       PCOTHER.COVERAGE_BASIS_CD as [COVERAGE_BASIS_CD],
	   PCOTHER.AMOUNT_NO as [OTHER_AMOUNT_NO],
	   PCPHYS.AMOUNT_NO as [PHYSICALDAMAGE_AMOUNT_NO],
       PCBIPA.AMOUNT_NO as [BODILYINJURYACCIDENT_AMOUNT_NO],
	   PCBIPP.AMOUNT_NO as [BODILYINJURYPERSON_AMOUNT_NO],
       Case
		  when (T.[LOAN_DIVISIONCODE_TX] in (3,8) OR RCA_PROP.VALUE_TX in (''VEH'',''BOAT'')) and PCPHYS.AMOUNT_NO > 0 then PCPHYS.AMOUNT_NO
		  when (T.[LOAN_DIVISIONCODE_TX] in (4,7,9,10) OR ISNULL(RCA_PROP.VALUE_TX,'''') not in ('''',''VEH'',''BOAT'')) then isnull(PCOTHER.AMOUNT_NO,0)
		  else 0
	   End as [COVERAGE_AMOUNT_NO],
	   isnull(PCOTHER_CA.AMOUNT_NO,0) as [COVERAGE_CA_AMOUNT_NO],
       PCOTHER.DEDUCTIBLE_NO as [OTHER_DEDUCTIBLE_NO],
	   PCCOMP.DEDUCTIBLE_NO as [COMPREHENSIVE_DEDUCTIBLE_NO],
       PCCOLL.DEDUCTIBLE_NO as [COLLISION_DEDUCTIBLE_NO],
	   PCPHYS.DEDUCTIBLE_NO as [PHYSICALDAMAGE_DEDUCTIBLE_NO],
'
select @columns = @columns +
'	   CASE
		 WHEN T.NOTICE_DT is not null and T.NOTICE_SEQ_NO > 0
				THEN cast(T.NOTICE_SEQ_NO as char(1)) +  '' '' + NRef.MEANING_TX + '' '' + CONVERT(nvarchar(10), T.NOTICE_DT, 101)
	   ELSE CASE
		WHEN T.LOAN_STATUSCODE in (''N'',''O'',''P'') THEN LSRef.MEANING_TX
		WHEN T.COLLATERAL_STATUSCODE in (''R'',''S'',''X'') THEN CSRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE in (''A'',''D'') and T.REQUIREDCOVERAGE_INSSTATUSCODE in (''A'',''N'')
				THEN LSRef.MEANING_TX + '' '' + CSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE in (''A'',''D'') and T.REQUIREDCOVERAGE_INSSTATUSCODE not in (''A'',''N'')
				THEN LSRef.MEANING_TX + '' '' + CSRef.MEANING_TX + '' '' + RCISSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE = ''T'' and T.REQUIREDCOVERAGE_INSSTATUSCODE in (''A'',''N'')
				THEN LSRef.MEANING_TX + '' '' + CSRef.MEANING_TX + '' '' + RCSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE = ''T'' and T.REQUIREDCOVERAGE_INSSTATUSCODE not in (''A'',''N'')
				THEN LSRef.MEANING_TX + '' '' + CSRef.MEANING_TX + '' '' + RCSRef.MEANING_TX + '' '' + RCISSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE not in (''A'',''D'',''T'')
				THEN LSRef.MEANING_TX + '' '' + CSRef.MEANING_TX + '' '' + RCSRef.MEANING_TX
		WHEN T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE in (''A'',''D'') and T.REQUIREDCOVERAGE_INSSTATUSCODE in (''A'',''N'')
				THEN CSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE in (''A'',''D'') and T.REQUIREDCOVERAGE_INSSTATUSCODE not in (''A'',''N'')
				THEN CSRef.MEANING_TX + '' '' + RCISSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE = ''T'' and T.REQUIREDCOVERAGE_INSSTATUSCODE in (''A'',''N'')
				THEN CSRef.MEANING_TX + '' '' + RCSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE = ''T'' and T.REQUIREDCOVERAGE_INSSTATUSCODE not in (''A'',''N'')
				THEN CSRef.MEANING_TX + '' '' + RCSRef.MEANING_TX + '' '' + RCISSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.COLLATERAL_STATUSCODE = ''Z'' and T.REQUIREDCOVERAGE_STATUSCODE not in (''A'',''D'',''T'')
				THEN CSRef.MEANING_TX + '' '' + RCSRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''A'' and T.REQUIREDCOVERAGE_STATUSCODE in (''A'',''D'') and T.REQUIREDCOVERAGE_INSSTATUSCODE in (''A'',''N'') 
				THEN RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''A'' and T.REQUIREDCOVERAGE_STATUSCODE in (''A'',''D'') and T.REQUIREDCOVERAGE_INSSTATUSCODE not in (''A'',''N'') 
				THEN RCISSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX 
		WHEN T.LOAN_STATUSCODE = ''A'' and T.REQUIREDCOVERAGE_STATUSCODE = ''T'' and T.REQUIREDCOVERAGE_INSSTATUSCODE in (''A'',''N'')
				THEN RCSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''A'' and T.REQUIREDCOVERAGE_STATUSCODE = ''T'' and T.REQUIREDCOVERAGE_INSSTATUSCODE not in (''A'',''N'')
				THEN RCSRef.MEANING_TX + '' '' + RCISSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''A'' and T.REQUIREDCOVERAGE_STATUSCODE not in (''A'',''D'',''T'')
				THEN RCSRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.REQUIREDCOVERAGE_STATUSCODE in (''A'',''D'') and T.REQUIREDCOVERAGE_INSSTATUSCODE in (''A'',''N'')
				THEN LSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.REQUIREDCOVERAGE_STATUSCODE in (''A'',''D'') and T.REQUIREDCOVERAGE_INSSTATUSCODE not in (''A'',''N'')
				THEN LSRef.MEANING_TX + '' '' + RCISSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.REQUIREDCOVERAGE_STATUSCODE = ''T'' and T.REQUIREDCOVERAGE_INSSTATUSCODE in (''A'',''N'')
				THEN LSRef.MEANING_TX + '' '' + RCSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.REQUIREDCOVERAGE_STATUSCODE = ''T'' and T.REQUIREDCOVERAGE_INSSTATUSCODE not in (''A'',''N'')
				THEN LSRef.MEANING_TX + '' '' + RCSRef.MEANING_TX + '' '' + RCISSRef.MEANING_TX + '' '' + RCISRef.MEANING_TX
		WHEN T.LOAN_STATUSCODE = ''B'' and T.REQUIREDCOVERAGE_STATUSCODE not in (''A'',''D'',''T'')
				THEN LSRef.MEANING_TX + '' '' + RCSRef.MEANING_TX
	   END +	   
		   CASE WHEN ISNULL(NRef.CODE_CD ,'''') = ''AN'' THEN  
			 ''; '' + NRef.CODE_CD + '' notified '' + IsNull(CONVERT(nvarchar(10), T.NOTICE_DT, 101), '''')
		   ELSE '''' END
	   END as [COVERAGE_STATUS_TX],
	   WRRef.MEANING_TX as [COVERAGEWAIVE_MEANING_TX],
'
select @columns = @columns +
case when @Impaired = 'T'
     then '	   CI.CODE_CD as [IMPAIRMENT_CODE_TX],
	   IRRef.MEANING_TX as [IMPAIRMENT_MEANING_TX],
'
	 else '	   NULL as [IMPAIRMENT_CODE_TX],
	   NULL as [IMPAIRMENT_MEANING_TX],'
	 end

select @columns = @columns + '
	   T.[DOCTYPE_CODE_TX],
	   CRRef.MEANING_TX as [CANCEL_MEANING_TX],
	   T.[NOTICE_DT],
	   T.[NOTICE_TYPE_CD],
	   NRef.MEANING_TX as [NOTICE_TYPE_TX],
	   T.[NOTICE_SEQ_NO],
	   T.[COVERAGE_EXPOSURE_DT],
	   CWT.CREATE_DT as [COVERAGE_WAIVE_STATUS_DT],
	   CWT.START_DT as [COVERAGE_WAIVE_EVENT_DT],
	   CWT.AUTHORIZED_BY_TX as [COVERAGE_WAIVE_OFFICER_TX],
	   DateDiff("m",T.LOAN_EFFECTIVE_DT,CWT.CREATE_DT) as [COVERAGE_WAIVE_TERM],
	   DateDiff("m",CWT.CREATE_DT, T.LOAN_MATURITY_DT) as [COVERAGE_WAIVE_REM_TERM],
'

if (@ReportType = 'LNDRREVWEVT')
BEGIN
	select @columns = @columns + '
		   IH.ADDL_COMMENT as [LENDER_REVIEW_EVENT],
'
END
else
BEGIN
	select @columns = @columns + '
		   NULL as [LENDER_REVIEW_EVENT],
'
END

select @columns = @columns +
--INSURANCE
'
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then CR.NAME_TX
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then T.PCP_INSURANCE_COMPANY_NAME_TX
         else OP.BIC_NAME_TX
       End as [INSCOMPANY_NAME_TX],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then T.FPC_NUMBER_TX
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then T.PCP_POLICY_NUMBER_TX
         else OP.POLICY_NUMBER_TX
       End as [INSCOMPANY_POLICY_NO],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then T.FPC_EFFECTIVE_DT
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then T.PCP_EFFECTIVE_DT
         else OP.EFFECTIVE_DT
       End as [INSCOMPANY_EFF_DT],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then CONVERT(nvarchar(8), T.FPC_EFFECTIVE_DT, 112)
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then CONVERT(nvarchar(8), T.PCP_EFFECTIVE_DT, 112)
         else CONVERT(nvarchar(8), OP.EFFECTIVE_DT, 112)
       End as [INSCOMPANY_EFFDTSORT_TX],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then
           Case
             when year(T.FPC_EXPIRATION_DT) = ''9999'' then NULL
             else T.FPC_EXPIRATION_DT
           End
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then
           Case
             when year(T.PCP_EXPIRATION_DT) = ''9999'' then NULL
             else T.PCP_EXPIRATION_DT
           End
         else
           Case
             when year(OP.EXPIRATION_DT) = ''9999'' then NULL
             else OP.EXPIRATION_DT
           End
       End as [INSCOMPANY_EXP_DT],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then DateDiff (day,getDate(),T.FPC_EXPIRATION_DT)
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then DateDiff (day,getDate(),T.PCP_EXPIRATION_DT)
         else DateDiff (day,getDate(),OP.EXPIRATION_DT)
       End as [INSCOMPANY_EXP_DAYS],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then T.FPC_CANCELLATION_DT
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then T.PCP_CANCELLATION_DT
         else OP.CANCELLATION_DT
       End as [INSCOMPANY_CAN_DT],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then
           Case
             when YEAR(ISNULL(T.FPC_CANCELLATION_DT,T.FPC_EXPIRATION_DT)) = ''9999'' then NULL
             else ISNULL(T.FPC_CANCELLATION_DT,T.FPC_EXPIRATION_DT)
           End
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then
           Case
             when YEAR(ISNULL(T.PCP_CANCELLATION_DT,T.PCP_EXPIRATION_DT)) = ''9999'' then NULL
             else isnull(T.PCP_CANCELLATION_DT,T.PCP_EXPIRATION_DT)
           End
         else
           Case
             when YEAR(ISNULL(OP.CANCELLATION_DT,OP.EXPIRATION_DT)) = ''9999'' then NULL
             else ISNULL(OP.CANCELLATION_DT,OP.EXPIRATION_DT)
           End
       End as [INSCOMPANY_EXPCXL_DT],
'
select @columns = @columns +
'       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then isnull(CONVERT(nvarchar(8), T.FPC_CANCELLATION_DT, 112),CONVERT(nvarchar(8), T.FPC_EXPIRATION_DT, 112))
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then isnull(CONVERT(nvarchar(8), T.PCP_CANCELLATION_DT, 112),CONVERT(nvarchar(8), T.PCP_EXPIRATION_DT, 112))
         else isnull(CONVERT(nvarchar(8), OP.CANCELLATION_DT, 112),CONVERT(nvarchar(8), OP.EXPIRATION_DT, 112))
       End as [INSCOMPANY_EXPCXLDTSORT_TX],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then DateDiff (day,isnull(isnull(T.FPC_CANCELLATION_DT,T.FPC_EXPIRATION_DT),T.LOAN_EFFECTIVE_DT),getDate())
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then DateDiff (day,isnull(isnull(T.PCP_CANCELLATION_DT,T.PCP_EXPIRATION_DT),T.LOAN_EFFECTIVE_DT),getDate())
         else DateDiff (day,isnull(isnull(OP.CANCELLATION_DT,OP.EXPIRATION_DT),T.LOAN_EFFECTIVE_DT),getDate())
       End as [INSCOMPANY_UNINS_DAYS],
	   '''' as [INSCOMPANY_UNINSGROUP_TX],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then CPQ.TERM_NO
       End as [CPI_QUOTE_TERM_NO],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' then ISNULL(CDPRM.AMOUNT_NO,0)
       End as [CPI_PREMIUM_AMOUNT_NO],
       Case
         when T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''P'' then ISNULL(T.PCP_TOTAL_PREMIUM_NO,0)
       End as [PC_PREMIUM_AMOUNT_NO],
'

select @columns = @columns +
'      CASE WHEN T.REQUIREDCOVERAGE_INSSUBSTATUSCODE not in (''C'', ''P'') THEN OP2.BIC_NAME_TX ELSE '''' END as [INSCOMPANY2_NAME_TX],
       CASE WHEN T.REQUIREDCOVERAGE_INSSUBSTATUSCODE not in (''C'', ''P'') THEN OP2.POLICY_NUMBER_TX ELSE '''' END as [INSCOMPANY2_POLICY_NO],
       CASE WHEN T.REQUIREDCOVERAGE_INSSUBSTATUSCODE not in (''C'', ''P'') THEN OP2.EFFECTIVE_DT ELSE NULL END as [INSCOMPANY2_EFF_DT],
       CASE WHEN T.REQUIREDCOVERAGE_INSSUBSTATUSCODE not in (''C'', ''P'') THEN CONVERT(nvarchar(8), OP2.EFFECTIVE_DT, 112) ELSE NULL END as [INSCOMPANY2_EFFDTSORT_TX],
       CASE WHEN T.REQUIREDCOVERAGE_INSSUBSTATUSCODE not in (''C'', ''P'') THEN 
		   Case
				 when year(OP2.EXPIRATION_DT) = ''9999'' then NULL
				 else OP2.EXPIRATION_DT
		   End 
       ELSE NULL END as [INSCOMPANY2_EXP_DT],
	   CASE WHEN T.REQUIREDCOVERAGE_INSSUBSTATUSCODE not in (''C'', ''P'') THEN DateDiff (day,getDate(),OP2.EXPIRATION_DT) ELSE NULL END as [INSCOMPANY2_EXP_DAYS],
       CASE WHEN T.REQUIREDCOVERAGE_INSSUBSTATUSCODE not in (''C'', ''P'') THEN OP2.CANCELLATION_DT ELSE NULL END as [INSCOMPANY2_CAN_DT],
       CASE WHEN T.REQUIREDCOVERAGE_INSSUBSTATUSCODE not in (''C'', ''P'') THEN 
			Case
			   when YEAR(ISNULL(OP2.CANCELLATION_DT,OP2.EXPIRATION_DT)) = ''9999'' then NULL
			   else ISNULL(OP2.CANCELLATION_DT,OP2.EXPIRATION_DT)
		   End 
		   ELSE NULL END as [INSCOMPANY2_EXPCXL_DT], 
	   CASE WHEN T.REQUIREDCOVERAGE_INSSUBSTATUSCODE not in (''C'', ''P'') THEN isnull(CONVERT(nvarchar(8), OP2.CANCELLATION_DT, 112),CONVERT(nvarchar(8), OP2.EXPIRATION_DT, 112)) ELSE NULL END as [INSCOMPANY2_EXPCXLDTSORT_TX], 
'
select @columns = @columns +
--BORROWER INSURANCE
'
       OP.BIC_NAME_TX as [BORRINSCOMPANY_NAME_TX],
	   OP.POLICY_NUMBER_TX as [BORRINSCOMPANY_POLICY_NO],
	   OP.EFFECTIVE_DT as [BORRINSCOMPANY_EFF_DT],
	   Case
         when year(OP.EXPIRATION_DT) = ''9999'' then NULL
         else OP.EXPIRATION_DT
       End as [BORRINSCOMPANY_EXP_DT],
	   DateDiff (day,getDate(),OP.EXPIRATION_DT) as [BORRINSCOMPANY_EXP_DAYS],
	   OP.CANCELLATION_DT as [BORRINSCOMPANY_CAN_DT],
       Case
         when YEAR(ISNULL(OP.CANCELLATION_DT,OP.EXPIRATION_DT)) = ''9999'' then NULL
         else ISNULL(OP.CANCELLATION_DT,OP.EXPIRATION_DT)
       End as [BORRINSCOMPANY_EXPCXL_DT],
       ISNULL(CONVERT(nvarchar(8), OP.CANCELLATION_DT, 112),CONVERT(nvarchar(8), OP.EXPIRATION_DT, 112)) as [BORRINSCOMPANY_EXPCXLDTSORT_TX],
	   OP.FLOOD_ZONE_TX AS [BORRINSCOMPANY_FLOODZONE_TX], 
	   OP2.FLOOD_ZONE_TX AS [BORRINSCOMPANY2_FLOODZONE_TX],
	   Case
         when ISNULL(OP.MOST_RECENT_EFFECTIVE_DT,'''') <> '''' then OP.MOST_RECENT_EFFECTIVE_DT
         when ISNULL(OP.MAIL_DT,'''') <> '''' then OP.MAIL_DT
         else OP.EFFECTIVE_DT
       End as [OLDINSURANCE_DT],
	   Case 
		when E_MAIL_DT > OP.MAIL_DT then E_MAIL_DT 
		else OP.MAIL_DT 
	   End as [MAIL_DT],
       BIA.NAME_TX as [INSAGENCY_NAME_TX],
	   BIA.PHONE_TX as [INSAGENCY_PHONE_TX],
'
select @columns = @columns +
--ESCROW
'
		T.[ESCROW_IN_REQ_COV_TX],
		E.END_DT AS [ESCROW_DUE_DT],
'
select @columns = @columns +
--IDs, STATUS
'
       T.[LOAN_ID],
	   T.[COLLATERAL_ID],
	   T.[PROPERTY_ID],
	   T.[REQUIREDCOVERAGE_ID],
       T.[LOAN_STATUSCODE],
	   LSRef.MEANING_TX as [LOAN_STATUSMEANING_TX],
	   T.[LOAN_UNMATCH_CNT],
       T.[COLLATERAL_STATUSCODE],
	   CSRef.MEANING_TX as [COLLATERAL_STATUSMEANING_TX],
	   T.[COLLATERAL_UNMATCH_CNT],
       T.[REQUIREDCOVERAGE_STATUSCODE],
	   RCSRef.MEANING_TX as [REQUIREDCOVERAGE_STATUSMEANING_TX],
       T.[REQUIREDCOVERAGE_SUBSTATUSCODE],
       T.[REQUIREDCOVERAGE_INSSTATUSCODE],
	   ISNULL(RCISRef.MEANING_TX, ''NOTAVAIL'') as [REQUIREDCOVERAGE_INSSTATUSMEANING_TX],
       T.[REQUIREDCOVERAGE_INSSUBSTATUSCODE],
	   RCISSRef.MEANING_TX as [REQUIREDCOVERAGE_INSSUBSTATUSMEANING_TX],
      
	   PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescriptionForReports(t.COLLATERAL_ID), 
	   T.[OPT_MAX_BALANCE],
	   T.[OPT_MIN_BALANCE],
	   T.[OPT_TITLE_START_DT],
	   T.[OPT_BALANCE_TYPE]
'
select @joins =
'from #tmptable_initial t
LEFT Join RELATED_DATA RD on RD.RELATE_ID = T.LOAN_ID and DEF_ID = @RD_MISC1_ID
-- extract only the newest OWNER_LOAN_RELATE.OWNER_TYPE_CD = DBA re TFS #33688
OUTER APPLY
(SELECT TOP 1 * FROM OWNER_LOAN_RELATE olr 
where  
olr.loan_id = T.LOAN_ID 
and olr.OWNER_TYPE_CD = ''DBA'' AND olr.PURGE_DT IS NULL
ORDER BY UPDATE_DT DESC)  OLDBA

LEFT JOIN [OWNER] ODBA on ODBA.ID = OLDBA.OWNER_ID AND ODBA.PURGE_DT IS NULL
left Join [OWNER_ADDRESS] AO on AO.ID = T.OWNER_ADDRESS_ID AND AO.PURGE_DT IS NULL
left Join [OWNER_ADDRESS] AM on AM.ID = T.PROPERTY_ADDRESS_ID AND AM.PURGE_DT IS NULL
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = T.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left Join WAIVE_TRACK CWT on CWT.REQUIRED_COVERAGE_ID = T.REQUIREDCOVERAGE_ID and CWT.START_DT < GETDATE() and CWT.END_DT > GETDATE() and CWT.PURGE_DT IS NULL
and @ReportType in (''WAIVE'',''WVNOPAY'',''WVNOPAYPRM'',''TRACK'')
'
+ case when @Impaired = 'T'
then 
'OUTER APPLY (
	select distinct case when (select COUNT(*) from IMPAIRMENT 
		where REQUIRED_COVERAGE_ID = T.REQUIREDCOVERAGE_ID 
		AND START_DT < GETDATE() AND END_DT > GETDATE() AND PURGE_DT IS NULL and
		(OVERRIDE_TYPE_CD IS null or OVERRIDE_TYPE_CD = '''')) > 1 
		and @ReportType not in (''CLSNIMPD'',''HIGHDED'',''IMPAIRED'',''LIABIMP'',''LIENIMPD'',''INSUFFINS'',''MORTIMPD'',''LCIMPD'')
	then ''MU''  
	else CI1.CODE_CD
	end as CODE_CD
	from IMPAIRMENT CI1
	where CI1.REQUIRED_COVERAGE_ID = T.REQUIREDCOVERAGE_ID 
	AND CI1.START_DT < GETDATE() AND CI1.END_DT > GETDATE() AND CI1.PURGE_DT IS NULL and
	(CI1.OVERRIDE_TYPE_CD IS null or CI1.OVERRIDE_TYPE_CD = '''') 
	group by CI1.CODE_CD
) CI
'
else '' end
+ '
OUTER APPLY
(SELECT TOP 1 * FROM dbo.GetCurrentCoverage(T.PROPERTY_ID, T.REQUIREDCOVERAGE_ID, T.REQUIREDCOVERAGE_CODE_TX)
ORDER BY ISNULL(UNIT_OWNERS_IN, ''N'') DESC
) OP
OUTER APPLY
(SELECT TOP 1 * FROM dbo.GetCurrentCoverage(T.PROPERTY_ID, T.REQUIREDCOVERAGE_ID, T.REQUIREDCOVERAGE_CODE_TX)
WHERE BASE_PROPERTY_TYPE_CD = ''CA'' AND ID != OP.ID
ORDER BY ISNULL(EXCESS_IN, ''N'') 
) OP2

left Join CARRIER CR on CR.ID = T.FPC_CARRIER_ID and T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' AND CR.PURGE_DT IS NULL --and CR.ACTIVE_IN = ''Y''
left Join CPI_QUOTE CPQ ON CPQ.ID = T.FPC_CPI_QUOTE_ID and T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' AND CPQ.PURGE_DT IS NULL
LEFT JOIN CPI_ACTIVITY CPA ON CPA.CPI_QUOTE_ID = CPQ.ID AND CPA.TYPE_CD = ''I''	and T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' and CPA.PURGE_DT IS NULL
LEFT JOIN CERTIFICATE_DETAIL CDPRM ON CDPRM.CPI_ACTIVITY_ID = CPA.ID AND CDPRM.TYPE_CD = ''PRM'' and T.REQUIREDCOVERAGE_INSSUBSTATUSCODE = ''C'' AND CDPRM.PURGE_DT IS NULL
left Join BORROWER_INSURANCE_AGENCY BIA on BIA.ID = OP.BIA_ID AND BIA.PURGE_DT IS NULL
'
+ '
OUTER APPLY (
SELECT TOP 1 PC.TYPE_CD, PC.SUB_TYPE_CD, PC.OWNER_POLICY_ID, PC.DEDUCTIBLE_NO, PC.AMOUNT_NO, PC.ID, PC.COVERAGE_BASIS_CD
FROM POLICY_COVERAGE PC
WHERE 
PC.OWNER_POLICY_ID = OP.ID
AND PC.START_DT <= GETDATE() AND PC.END_DT > GETDATE() AND PC.PURGE_DT IS NULL
AND PC.TYPE_CD NOT IN(''PHYS-DAMAGE'',''AUTO-LIABILITY'')
AND PC.TYPE_CD = T.REQUIREDCOVERAGE_CODE_TX
AND PC.SUB_TYPE_CD = ''CADW''
ORDER BY START_DT DESC
) PCOTHER
OUTER APPLY (
SELECT TOP 1 PC.TYPE_CD, PC.SUB_TYPE_CD, PC.OWNER_POLICY_ID, PC.DEDUCTIBLE_NO, PC.AMOUNT_NO, PC.ID, PC.COVERAGE_BASIS_CD
FROM POLICY_COVERAGE PC
WHERE 
PC.OWNER_POLICY_ID = OP2.ID
AND PC.START_DT <= GETDATE() AND PC.END_DT > GETDATE() AND PC.PURGE_DT IS NULL
AND PC.TYPE_CD NOT IN(''PHYS-DAMAGE'',''AUTO-LIABILITY'')
AND PC.TYPE_CD = T.REQUIREDCOVERAGE_CODE_TX
AND PC.SUB_TYPE_CD = ''CADW''
ORDER BY START_DT DESC
) PCOTHER_CA
OUTER APPLY (
SELECT TOP 1 PC.TYPE_CD, PC.SUB_TYPE_CD, PC.OWNER_POLICY_ID, PC.DEDUCTIBLE_NO, PC.AMOUNT_NO
FROM POLICY_COVERAGE PC
WHERE 
PC.OWNER_POLICY_ID = OP.ID
AND PC.START_DT <= GETDATE() AND PC.END_DT > GETDATE() AND PC.PURGE_DT IS NULL
AND PC.TYPE_CD = ''PHYS-DAMAGE''
AND PC.SUB_TYPE_CD = ''COMP''
ORDER BY START_DT DESC
) PCCOMP
OUTER APPLY (
SELECT TOP 1 PC.TYPE_CD, PC.SUB_TYPE_CD, PC.OWNER_POLICY_ID, PC.DEDUCTIBLE_NO, PC.AMOUNT_NO
FROM POLICY_COVERAGE PC
WHERE 
PC.OWNER_POLICY_ID = OP.ID
AND PC.START_DT <= GETDATE() AND PC.END_DT > GETDATE() AND PC.PURGE_DT IS NULL
AND PC.TYPE_CD = ''PHYS-DAMAGE''
AND PC.SUB_TYPE_CD = ''COLL''
ORDER BY START_DT DESC
) PCCOLL
OUTER APPLY (
SELECT TOP 1 PC.TYPE_CD, PC.SUB_TYPE_CD, PC.OWNER_POLICY_ID, PC.DEDUCTIBLE_NO, PC.AMOUNT_NO
FROM POLICY_COVERAGE PC
WHERE 
PC.OWNER_POLICY_ID = OP.ID
AND PC.START_DT <= GETDATE() AND PC.END_DT > GETDATE() AND PC.PURGE_DT IS NULL
AND PC.TYPE_CD = ''AUTO-LIABILITY''
AND PC.SUB_TYPE_CD = ''PCVH''
ORDER BY START_DT DESC
) PCPHYS
OUTER APPLY (
SELECT TOP 1 PC.TYPE_CD, PC.SUB_TYPE_CD, PC.OWNER_POLICY_ID, PC.DEDUCTIBLE_NO, PC.AMOUNT_NO
FROM POLICY_COVERAGE PC
WHERE 
PC.OWNER_POLICY_ID = OP.ID
AND PC.START_DT <= GETDATE() AND PC.END_DT > GETDATE() AND PC.PURGE_DT IS NULL
AND PC.TYPE_CD = ''AUTO-LIABILITY''
AND PC.SUB_TYPE_CD = ''BIPA''
ORDER BY START_DT DESC
) PCBIPA
OUTER APPLY (
SELECT TOP 1 PC.TYPE_CD, PC.SUB_TYPE_CD, PC.OWNER_POLICY_ID, PC.DEDUCTIBLE_NO, PC.AMOUNT_NO
FROM POLICY_COVERAGE PC
WHERE 
PC.OWNER_POLICY_ID = OP.ID
AND PC.START_DT <= GETDATE() AND PC.END_DT > GETDATE() AND PC.PURGE_DT IS NULL
AND PC.TYPE_CD = ''AUTO-LIABILITY''
AND PC.SUB_TYPE_CD = ''BIPP''
ORDER BY START_DT DESC
) PCBIPP
OUTER APPLY (SELECT TOP 1 E.LOAN_ID, E.PROPERTY_ID, E.END_DT, MAIL_DT AS E_MAIL_DT
FROM ESCROW E
JOIN ESCROW_REQUIRED_COVERAGE_RELATE ERCR
	ON T.REQUIREDCOVERAGE_ID = ERCR.REQUIRED_COVERAGE_ID
	AND ERCR.PURGE_DT IS NULL
WHERE E.LOAN_ID = T.LOAN_ID
  AND E.PROPERTY_ID = T.PROPERTY_ID
  AND E.PURGE_DT IS NULL
  AND E.REPORTED_DT IS NOT NULL
ORDER BY E.END_DT DESC, E.STATUS_CD DESC) E
'
select @joins = @joins 
+ '
left Join REF_CODE NRef on NRef.DOMAIN_CD = ''NoticeType'' and NRef.CODE_CD = T.NOTICE_TYPE_CD
left Join REF_CODE WRRef on WRRef.DOMAIN_CD = ''WaiveTrackReason'' and WRRef.CODE_CD = CWT.REASON_CD
'
+ case when @Impaired = 'T'
       then 'left Join REF_CODE IRRef on IRRef.DOMAIN_CD = ''ImpairmentReason'' and IRRef.CODE_CD = CI.CODE_CD'
       else '' end
+ case when @ReportType = 'LNDRREVWEVT'
		then ' CROSS APPLY 
		(SELECT TOP 1  
			SPECIAL_HANDLING_XML.value(''(/SH/AdditionalComment)[1]'', ''nvarchar(max)'') as ADDL_COMMENT_CD,
			LndrRevRef.MEANING_TX as ADDL_COMMENT
		FROM INTERACTION_HISTORY ih 
		LEFT JOIN REF_CODE LndrRevRef on LndrRevRef.DOMAIN_CD = ''LenderReviewAdditionalComment'' and LndrRevRef.CODE_CD = SPECIAL_HANDLING_XML.value(''(/SH/AdditionalComment)[1]'', ''nvarchar(max)'')
			WHERE ih.PROPERTY_ID = T.PROPERTY_ID AND ih.TYPE_CD = ''LRVWEVNT'' AND ih.PURGE_DT IS NULL
					AND (ih.EFFECTIVE_DT >= '''+ Convert(varchar(30), @BeginDate, 120) + ''' and ih.EFFECTIVE_DT <= ''' + Convert(varchar(30), @EndDate, 120) + ''')
		ORDER BY ih.ISSUE_DT DESC
		) IH '
		else '' end
+ '       
left Join REF_CODE CRRef on CRRef.DOMAIN_CD = ''OwnerPolicyCancelReason'' and CRRef.CODE_CD = OP.CANCEL_REASON_CD
left Join REF_CODE LSRef on LSRef.DOMAIN_CD = ''LoanStatus'' and LSRef.CODE_CD = T.LOAN_STATUSCODE
left Join REF_CODE CSRef on CSRef.DOMAIN_CD = ''CollateralStatus'' and CSRef.CODE_CD = T.COLLATERAL_STATUSCODE
left Join REF_CODE RCSRef on RCSRef.DOMAIN_CD = ''RequiredCoverageStatus'' and RCSRef.CODE_CD = T.REQUIREDCOVERAGE_STATUSCODE
left Join REF_CODE RCISRef on RCISRef.DOMAIN_CD = ''RequiredCoverageInsStatus'' and RCISRef.CODE_CD = T.REQUIREDCOVERAGE_INSSTATUSCODE
left Join REF_CODE RCISSRef on RCISSRef.DOMAIN_CD = ''RequiredCoverageInsSubStatus'' and RCISSRef.CODE_CD = T.REQUIREDCOVERAGE_INSSUBSTATUSCODE
left Join REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = ''ContractType'' and RC_DIVISION.CODE_CD = T.LOAN_DIVISIONCODE_TX
left Join REF_CODE RC_COVERAGETYPE on RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' and RC_COVERAGETYPE.CODE_CD = T.REQUIREDCOVERAGE_CODE_TX
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = ''SecondaryClassification'' and cc.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
  
'



declare @finalquery nvarchar(max)
select @finalquery =  @insert + @columns + @joins + isnull(@conditions, '') + '
 OPTION (QUERYTRACEON 2312)'
-- OPTION (QUERYTRACEON 2312, MAX_GRANT_PERCENT = 5)'
if @debug = 1
begin
	select @insert
	select @columns
	select @joins
	select isnull(@conditions,'')
end

exec sp_executesql @finalquery,
				   N'@RD_MISC1_ID bigint, @ReportType nvarchar(50)',
				   @RD_MISC1_ID, @ReportType

--drop table #tmptable_initial

set @insert=''
Set @columns=''
Set @joins=''
Set @conditions=''
Set @finalquery=''

-- Retrieves the lender option values and creates flags. Used in the report filters.
IF (@ReportType In ('CONTMAXBAL') OR @SpecificReport In ( 'WVEHIBAL'))
BEGIN
	UPDATE #tmptable
	SET  OPT_BALANCE_ABOVE_MAX = CASE
		WHEN #tmptable.OPT_MAX_BALANCE IN (0, NULL) THEN NULL
		WHEN #tmptable.OPT_BALANCE_TYPE  = 'Contract' Then
			Case
				WHEN  #tmptable.LOAN_BAL_NO >= #tmptable.OPT_MAX_BALANCE Then 'True'
				ELSE 'False'
			End
		ELSE
			Case
				WHEN  #tmptable.LOAN_BALANCE_NO >= #tmptable.OPT_MAX_BALANCE Then 'True'
				ELSE 'False'
			END
		END
END
ELSE IF @ReportType In ('WAIVE') AND @SpecificReport in ('WAIVE','0000')
BEGIN
	UPDATE #tmptable
	SET  OPT_BALANCE_BELOW_MIN = CASE
		WHEN #tmptable.OPT_MIN_BALANCE IN (0, NULL) Then NULL
		WHEN #tmptable.LOAN_BALANCE_NO < #tmptable.OPT_MIN_BALANCE Then 'True'
		ELSE 'False'
		END
END
ELSE IF @SpecificReport in ('WAIVEHIG')
BEGIN
	UPDATE #tmptable
	SET  OPT_BALANCE_ABOVE_MAX = Case
		WHEN  #tmptable.LOAN_BALANCE_NO >= #tmptable.OPT_MAX_BALANCE Then 'True'
		ELSE 'False'
		END
END
ELSE IF @ReportType In ('TITLE')
BEGIN
	UPDATE #tmptable
	SET  OPT_EFF_DT_GREATER_TITLE_START_DT = Case
		WHEN  #tmptable.OPT_TITLE_START_DT IS NULL Then 'True'
		WHEN  #tmptable.LOAN_EFFECTIVE_DT >= #tmptable.OPT_TITLE_START_DT  Then 'True'
		ELSE 'False'
		End
END

Declare @sqlstring as nvarchar(max)
If isnull(@FilterBySQL,'') <> ''
Begin
  Select * into #t1 from #tmptable
  truncate table #tmptable

  Set @sqlstring = N'Insert into #tmpTable
                     Select * from dbo.#t1 where ' + @FilterBySQL

  EXECUTE sp_executesql @sqlstring
End

If @SpecificReport = 'INSLNSTA_AI'
BEGIN
	DECLARE @combinedString VARCHAR(MAX)
	declare @loanID bigint

	DECLARE Additional_Insured_Cursor CURSOR FOR
	select [LOAN_ID] from #tmptable where [ADDITIONAL_INSURED_CNT] > 0
	OPEN Additional_Insured_Cursor
	FETCH NEXT FROM Additional_Insured_Cursor into @loanID
	WHILE @@FETCH_STATUS = 0
	   BEGIN
			SET @combinedString=NULL
			select @combinedString = COALESCE(@combinedString, '') + 
				CASE WHEN isnull(O.FIRST_NAME_TX,'') = '' THEN  '' ELSE O.FIRST_NAME_TX + ' ' END +
				CASE WHEN isnull(O.MIDDLE_INITIAL_TX,'') = '' THEN '' ELSE substring(O.MIDDLE_INITIAL_TX,1,1) + ' ' END +
				CASE WHEN isnull(O.LAST_NAME_TX,'')= '' THEN '' ELSE O.LAST_NAME_TX END +
				CHAR(13) + CHAR(10) 
			from OWNER_LOAN_RELATE OLAI
			join [OWNER] O on O.ID = OLAI.OWNER_ID AND O.PURGE_DT is null
			where OLAI.LOAN_ID = @loanID AND OLAI.OWNER_TYPE_CD = 'AI' AND OLAI.PURGE_DT IS NULL
		
			UPDATE #tmptable 
			SET  [ADDITIONAL_INSURED_NAME_TX] = ISNULL(@combinedString,'') WHERE [LOAN_ID] = @loanID
		
			--SELECT @combinedString as StringValue
			FETCH NEXT FROM Additional_Insured_Cursor into @loanID
		END
	CLOSE Additional_Insured_Cursor
	DEALLOCATE Additional_Insured_Cursor
END

If @ReportType = 'DUPCOLL'
Begin
	/* remove unmatched: */
	IF @excludeUnmatched = 1
	BEGIN
		DELETE FROM #tmptable
		 WHERE LOAN_UNMATCH_CNT > 0 OR COLLATERAL_UNMATCH_CNT > 0
		    OR LOAN_STATUSCODE = 'U' OR COLLATERAL_STATUSCODE = 'U'
	END

	/* remove loans that have a zero-balance: */
	IF @excludeZeroBal = 1
	BEGIN
		UPDATE #tmptable
		SET  OPT_BALANCE_BELOW_MIN = CASE
			WHEN #tmptable.LOAN_BALANCE_NO = 0 Then 'True'
			ELSE IsNull(OPT_BALANCE_BELOW_MIN, 'False')
			END
	END

	If @SpecificReport = 'DUPCOLLMTG'
	Begin
		CREATE TABLE [dbo].[#tMortgage](
			[CollCount] [int] NULL,
			[LoanStatus] [nvarchar] (2) NULL,
			[LoanUnmatch] [int] NULL,
			[CollStatus] [nvarchar] (2) NULL,
			[CollUnmatch] [int] NULL,
			[CollMortgage] [nvarchar](300) NULL
			,minLoanID BigInt NOT NULL
			,maxLoanID BigInt NOT NULL
		) ON [PRIMARY]
		Insert into #tMortgage (
			CollCount,
			LoanStatus,
			LoanUnmatch,
			CollStatus,
			CollUnmatch,
			CollMortgage
			,minLoanID
			,maxLoanID
			)
		Select COUNT([COLLATERAL_MORTGAGE_TX]) as CollCount,
				MIN([LOAN_STATUSCODE]) as LoanStatus,
				MAX([LOAN_UNMATCH_CNT]) as LoanUnmatch,
				MIN([COLLATERAL_STATUSCODE]) as CollStatus,
				MAX([COLLATERAL_UNMATCH_CNT]) as CollUnmatch,
				[COLLATERAL_MORTGAGE_TX] as CollMortgage
				,minLoanID = MIN(Loan_ID)
				,maxLoanID = MAX(Loan_ID)
		from #tmptable
		group by [COLLATERAL_MORTGAGE_TX]

		Select * into #t3 from #tmptable
      
		truncate table #tmptable

		Set @sqlstring = N'Insert into #tmpTable
							Select * from #t3 
							where (ISNULL(RTrim([COLLATERAL_MORTGAGE_TX]),'''') <> '''')
							  AND [COLLATERAL_MORTGAGE_TX] in
							(Select [CollMortgage] from #tMortgage
							  where [CollCount] > 1 
							    and [LoanStatus] = ''A'' and [CollStatus] = ''A''
							    and 1 = Case
							            When ' + Cast(@excludeUnmatched As NVarChar(1)) + ' = 0 Then 1
							            When (CollUnmatch > 0 Or LoanUnmatch > 0) Then 0
							            Else 1 End
							    and maxLoanID <> minLoanID
								and COLLATERAL_LINE1_TX is not null
							)
						'
		EXECUTE sp_executesql @sqlstring
	End
	else
	Begin
		CREATE TABLE [dbo].[#tVehicle](
			[CollCount] [int] NULL,
			[LoanStatus] [nvarchar] (2) NULL,
			[LoanUnmatch] [int] NULL,
			[CollStatus] [nvarchar] (2) NULL,
			[CollUnmatch] [int] NULL,
			[CollVIN] [nvarchar](18) NULL
		) ON [PRIMARY]
		Insert into #tVehicle (
			CollCount,
			LoanStatus,
			LoanUnmatch,
			CollStatus,
			CollUnmatch,
			CollVIN)
		Select COUNT([COLLATERAL_VIN_TX]) as CollCount,
				MIN([LOAN_STATUSCODE]) as LoanStatus,
				MAX([LOAN_UNMATCH_CNT]) as LoanUnmatch,
				MIN([COLLATERAL_STATUSCODE]) as CollStatus,
				MAX([COLLATERAL_UNMATCH_CNT]) as CollUnmatch,
				[COLLATERAL_VIN_TX] as CollVIN
		from #tmptable
		group by [COLLATERAL_VIN_TX]

		Select * into #t4 from #tmptable
      
		truncate table #tmptable

		Set @sqlstring = N'Insert into #tmpTable
							Select * from #t4 
							where (ISNULL(RTrim([COLLATERAL_VIN_TX]),'''') <> '''')
							  AND [COLLATERAL_VIN_TX] in
							(Select [CollVIN] from #tVehicle
							  where [CollCount] > 1
							    and [LoanStatus] = ''A'' and [CollStatus] = ''A''
							    and 1 = Case
							            When ' + Cast(@excludeUnmatched As NVarChar(1)) + ' = 0 Then 1
							            When (CollUnmatch > 0 Or LoanUnmatch > 0) Then 0
							            Else 1 End
							)
							'

		EXECUTE sp_executesql @sqlstring

		CREATE TABLE [dbo].[#tLoan](
			[LoanCount] [int] NULL,
			[LoanNumber] [nvarchar](18) NULL
		) ON [PRIMARY]
		Insert into #tLoan (
			LoanCount,
			LoanNumber)
		Select
		 COUNT([LOAN_NUMBER_TX]) as LoanCount,
				[LOAN_NUMBER_TX] as LoanNumber
		from #tmptable
		group by [LOAN_NUMBER_TX]

		CREATE TABLE [dbo].[#tVin](
			[VinCount] [int] NULL,
			[Vin] [nvarchar](18) NULL
		) ON [PRIMARY]
		Insert into #tVin (
			VinCount,
			Vin)
		Select
		 COUNT(COLLATERAL_VIN_TX) as VinCount,
				COLLATERAL_VIN_TX as Vin
		from #tmptable
		group by COLLATERAL_VIN_TX

		Select * into #t5 from #tmptable
      
		truncate table #tmptable

		Set @sqlstring = N'Insert into #tmpTable
							Select * from #t5
							where [LOAN_NUMBER_TX] in (Select [LoanNumber] from #tLoan where [LoanCount] = 1)
							  and [COLLATERAL_VIN_TX] in (Select [Vin] from #tVin where [VinCount] > 1)
							'
		EXECUTE sp_executesql @sqlstring

	End
End


If @ReportType = 'LNSTAT1'
Begin
	If @SpecificReport = 'LNSTAT1_MULTICOLL' or @SpecificReport = 'LNSTAT1_MULTICOLL_NOBRCH'
	Begin
		CREATE TABLE [dbo].[#tAddress1NoBranch](
				[CollCount] [int] NULL,
				[CollMortgage] [nvarchar](300) NULL
			) ON [PRIMARY]
			Insert into #tAddress1NoBranch (
				CollCount,
				CollMortgage)
			Select COUNT([COLLATERAL_MORTGAGE_TX]) as CollCount,
					[COLLATERAL_MORTGAGE_TX] as CollMortgage
			from #tmptable
			group by [COLLATERAL_MORTGAGE_TX]

			Select * into #tAdd1NoBr from #tmptable
			truncate table #tmptable

			Set @sqlstring = N'Insert into #tmpTable
								Select * from #tAdd1NoBr 
								where ISNULL([COLLATERAL_MORTGAGE_TX],'''') <> '''' AND [COLLATERAL_MORTGAGE_TX] in
								(Select [CollMortgage] from #tAddress1NoBranch where [CollCount] > 1)'

			EXECUTE sp_executesql @sqlstring
	end
	else if @SpecificReport = 'MULTLNST'
	Begin
		Select * into #tempA1 from
		(
			select COUNT(COLLATERAL_ID) as LoanCount,loan_id,COLLATERAL_ID from #tmptable
			group by loan_ID,collateral_id

		) grp1

		select * into #tempA2 from
		(
			select COUNT(loan_id) counts,loan_id from #tempA1 group by loan_id having COUNT(loan_ID) >= 2
		) grp2


		Select * into #tLoan1 from #tmptable
		truncate table #tmptable

		Set @sqlstring = N'Insert into #tmpTable
							Select * from #tLoan1 where [LOAN_ID] in
							(Select [LOAN_ID] from #tempA2)'

		EXECUTE sp_executesql @sqlstring
	end
	else if @SpecificReport = 'MULTLNSTDUP'
	Begin
		Select * into #tmptable1 from #tmptable

		Update #tmptable1 set COLLATERAL_VIN_TX = '' where COLLATERAL_VIN_TX is null

		Select * into #finalgroup from
		(
			Select loan_id,COLLATERAL_ID,COLLATERAL_VIN_TX,COUNT(COLLATERAL_VIN_TX) ct from #tmptable1
			group by loan_id,COLLATERAL_ID,COLLATERAL_VIN_TX
		) FG


		Select * into #tmpTableClone from #tmptable
		truncate table #tmptable


		Set @sqlstring =N'Insert into #tmpTable
						  Select * from #tmpTableClone where [LOAN_ID] in
						  (
							Select [LOAN_ID]  from
							(
								select [LOAN_ID],[COLLATERAL_VIN_TX],Count(COLLATERAL_VIN_TX) VIN_COUNT
								from #finalgroup
								Group By Loan_ID, COLLATERAL_VIN_TX Having count(COLLATERAL_VIN_TX) > 1
							) x
						   )'

		EXECUTE sp_executesql @sqlstring
	end
End

/*Handle Muliple Impairments*/
/**/
DECLARE @MultImpair TABLE(REQUIREDCOVERAGE_ID BigInt NOT NULL, IMPAIRMENT_CODE_TX nvarchar(40) NULL, IMPAIRMENT_MEANING_TX nvarchar(1000) NULL)

insert into @MultImpair
	select TT.REQUIREDCOVERAGE_ID
	,IMPAIRMENT_CODE_TX=null
	,IMPAIRMENT_MEANING_TX=null
	from #TmpTable TT
	where @Impaired='T'
	group by TT.REQUIREDCOVERAGE_ID
	having count(TT.IMPAIRMENT_CODE_TX)>1

if exists(
	select REQUIREDCOVERAGE_ID
	from @MultImpair
)
begin
	update TT
	set
	 IMPAIRMENT_CODE_TX =
		case when @Impaired<>'T' then TT.IMPAIRMENT_CODE_TX
		else stuff((select ', ' + isnull(TT2.IMPAIRMENT_CODE_TX,'') from #TmpTable TT2 where TT2.REQUIREDCOVERAGE_ID = TT.REQUIREDCOVERAGE_ID order by TT2.IMPAIRMENT_CODE_TX for XML PATH('')), 1, 2, '')
		end
	,IMPAIRMENT_MEANING_TX =
		case when @Impaired<>'T' then TT.IMPAIRMENT_MEANING_TX
		else stuff((select ', ' + isnull(TT2.IMPAIRMENT_MEANING_TX,'') from #TmpTable TT2 where TT2.REQUIREDCOVERAGE_ID = TT.REQUIREDCOVERAGE_ID order by TT2.IMPAIRMENT_CODE_TX for XML PATH('')), 1, 2, '')
		end
	from #TmpTable TT
	join @MultImpair MI on MI.REQUIREDCOVERAGE_ID = TT.REQUIREDCOVERAGE_ID

	update MI
	set
	 IMPAIRMENT_CODE_TX = TT.IMPAIRMENT_CODE_TX
	,IMPAIRMENT_MEANING_TX = TT.IMPAIRMENT_MEANING_TX
	from #TmpTable TT
	join @MultImpair MI on MI.REQUIREDCOVERAGE_ID = TT.REQUIREDCOVERAGE_ID
end

set @sqlstring = N'Update #tmpTable
	Set [INSCOMPANY_UNINSGROUP_TX] = case when [INSCOMPANY_UNINS_DAYS] >= 0 and [INSCOMPANY_UNINS_DAYS] <= 30 then ''0-30 Uninsured Days''
										  when [INSCOMPANY_UNINS_DAYS] > 30 and [INSCOMPANY_UNINS_DAYS] <= 60 then ''31-60 Uninsured Days''
										  when [INSCOMPANY_UNINS_DAYS] > 60 and [INSCOMPANY_UNINS_DAYS] <= 90 then ''61-90 Uninsured Days''
										  when [INSCOMPANY_UNINS_DAYS] > 90 then ''90> Uninsured Days''
										  else ''''
										  END,
		[REPORT_GROUPBY_TX] = ' + isnull(@GroupBySQL, '') + ',
		[REPORT_GROUPBY_FIELDS_TX] = ' + replace(replace(@GroupBySQL, '[', ''''),']','''') + ',
		[REPORT_SORTBY_TX] = ' + isnull(@SortBySQL, '')
		+ case when isnull(@HeaderTx, '') <> '' then ', [REPORT_HEADER_TX] = ' + @HeaderTx else '' end
		+ case when isnull(@FooterTx, '') <> '' then ', [REPORT_FOOTER_TX] = ' + @FooterTx else '' end
		+ case when @PAGEBREAK = 'T' AND @PAGEBREAK_COLUMN <> 'Branch' then ', [LOAN_PAGEBREAK_TX] = ' + @GroupBySQL else '' end

--select @sqlstring
EXECUTE sp_executesql @sqlstring

SELECT @RecordCount = @@rowcount

--SELECT @RecordCount = COUNT(*) from #tmptable
--print @RecordCount


IF @Report_History_ID IS NOT NULL
BEGIN
  Update [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML
  Set
   RECORD_COUNT_NO = @RecordCount
  ,UPDATE_DT = GETDATE()
  where ID = @Report_History_ID
END

/* For DUPCOL, update #tmptable.COVERAGE_STATUS_TX with Unmatched: */
If @ReportType = 'DUPCOLL'
Or @SpecificReport = 'DUPCOLLMTG'
Begin
	UPDATE #tmptable
	SET
		 COVERAGE_STATUS_TX=IsNull(COVERAGE_STATUS_TX, '') + Case When COLLATERAL_STATUSCODE = 'U' Or COLLATERAL_UNMATCH_CNT > 0 Then ' (Unmatched)' Else '' End
	Where @ReportType = 'DUPCOLL'
	Or @SpecificReport = 'DUPCOLLMTG'

/*
--update tt.REQUIREDCOVERAGE_TYPE_TX, to account for multiple coverages in the DUPCOL report (e.g. we want "distinct" rows like "Flood, Hazard" instead of "Flood" AND "Hazard" among "duplicate" rows)
*/
	update tt
	set
	 REQUIREDCOVERAGE_TYPE_TX = Cover.TYPE_TX
	,COVERAGE_STATUS_TX = Cover.STATUS_TX
	From #tmptable tt
	cross apply(
		select
		 TYPE_TX = stuff(
			(select distinct
			 ', ' + tt2.REQUIREDCOVERAGE_TYPE_TX
			 from #tmptable tt2
			 where tt2.COLLATERAL_ID = tt.COLLATERAL_ID
			 order by
			  ', ' + tt2.REQUIREDCOVERAGE_TYPE_TX
			 for xml path(''))
			, 1, 2, '')
		,STATUS_TX = stuff(
			(select distinct
			 ', ' + tt2.REQUIREDCOVERAGE_CODE_TX + ': ' + tt2.COVERAGE_STATUS_TX
			 from #tmptable tt2
			 where tt2.COLLATERAL_ID = tt.COLLATERAL_ID
			 order by
			  ', ' + tt2.REQUIREDCOVERAGE_CODE_TX + ': ' + tt2.COVERAGE_STATUS_TX
			 for xml path(''))
			, 1, 2, '')
	) as Cover
	Where @ReportType = 'DUPCOLL'
	Or @SpecificReport = 'DUPCOLLMTG'

/*
--now remove the "duplicate" rows
*/
	;with
	 dups as
	(
		select
		 rn = ROW_NUMBER() OVER (Partition By COLLATERAL_ID Order By REQUIREDCOVERAGE_TYPE_TX Desc)
		,COLLATERAL_ID
		from #tmptable
	)
	delete dups
	where rn > 1
End

/* For Expired Loan report, delete #tmptable entries where collateral status and coverage status are not Active  
	and delete enteries that are already expired or expiring later than 30 days */ 
If @ReportType = 'LOANEXP'and (@SpecificReport = 'INSEXP_30')
Begin
	delete #tmptable where COLLATERAL_STATUSCODE <> 'A' and REQUIREDCOVERAGE_STATUSCODE  <> 'A'
	delete #tmptable where ((INSCOMPANY_EXP_DAYS < 0 AND INSCOMPANY2_EXP_DAYS < 0) or (INSCOMPANY_EXP_DAYS > 30 AND INSCOMPANY2_EXP_DAYS > 30))
	delete #tmptable where ((INSCOMPANY_EXP_DAYS < 0 AND INSCOMPANY2_EXP_DAYS > 30) or (INSCOMPANY_EXP_DAYS > 30 AND INSCOMPANY2_EXP_DAYS < 0))
	delete #tmptable where ((INSCOMPANY_EXP_DAYS < 0 AND INSCOMPANY2_EXP_DAYS IS NULL) or (INSCOMPANY_EXP_DAYS > 30 AND INSCOMPANY2_EXP_DAYS IS NULL))
End

/* For Expired Loan report, delete #tmptable entries where collateral status and coverage status are not Active
	and delete enteries that are already expired or expiring later than 60 days */ 
If @ReportType = 'LOANEXP'and (@SpecificReport = 'INSEXP_60')
Begin
	delete #tmptable where COLLATERAL_STATUSCODE <> 'A' and REQUIREDCOVERAGE_STATUSCODE  <> 'A'
	delete #tmptable where ((INSCOMPANY_EXP_DAYS < 0 AND INSCOMPANY2_EXP_DAYS < 0) or (INSCOMPANY_EXP_DAYS > 60 AND INSCOMPANY2_EXP_DAYS > 60))
	delete #tmptable where ((INSCOMPANY_EXP_DAYS < 0 AND INSCOMPANY2_EXP_DAYS > 60) or (INSCOMPANY_EXP_DAYS > 60 AND INSCOMPANY2_EXP_DAYS < 0))
	delete #tmptable where ((INSCOMPANY_EXP_DAYS < 0 AND INSCOMPANY2_EXP_DAYS IS NULL) or (INSCOMPANY_EXP_DAYS > 60 AND INSCOMPANY2_EXP_DAYS IS NULL))
End

/*
--update tt.Crossed
*/
	update tt
	set
	 Crossed = Crossed.WithLoans
	From #tmptable tt
	cross apply(
		select WithLoans = stuff(
			(select ', '
			 + l.number_tx
			 + case when c.STATUS_CD in ('A') then '' else '(' + c.status_cd + ')' end
			 + case when c.primary_loan_in = 'Y' then '*' else '' end
			 from collateral c join loan l on l.id=c.loan_id
			 where c.purge_dt is null and l.PURGE_DT is null and c.property_id=tt.property_id and l.id<>tt.loan_id
			 order by l.number_tx
			 for xml path(''))
			, 1, 2, '')
	) as Crossed

If @Impaired='T'
Begin
	Select Distinct *
	From #tmptable
End
Else
Begin
	Select *
	From #tmptable
End

END


GO
