SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Report_PaymentChanges] 
	(@LenderCode AS nvarchar(20)=NULL,
	@Branch as nvarchar(max)=NULL,
	@Division as nvarchar(10)=NULL,
	@Coverage as nvarchar(100)=NULL,
	@ReportType as nvarchar(50)=NULL,
	@GroupByCode as nvarchar(50)=NULL,
	@SortByCode as nvarchar(50)=NULL,
	@FilterByCode as nvarchar(50)=NULL,
	@ReportConfig as varchar(50)=NULL,
	@Report_History_ID as bigint=NULL)
	
AS

BEGIN
SET NOCOUNT ON
--Get rid of residual #temp tables
IF OBJECT_ID(N'tempdb..#tmptable',N'U') IS NOT NULL
  DROP TABLE #tmptable
IF OBJECT_ID(N'tempdb..#tmpfilter',N'U') IS NOT NULL
  DROP TABLE #tmpfilter
IF OBJECT_ID(N'tempdb..#t1',N'U') IS NOT NULL
  DROP TABLE #t1
IF OBJECT_ID(N'tempdb..#t2',N'U') IS NOT NULL
  DROP TABLE #t2
IF OBJECT_ID(N'tempdb..#tmpSpecialFPCs',N'U') IS NOT NULL
  DROP TABLE #tmpSpecialFPCs
IF OBJECT_ID(N'tempdb..#tmpFPCIDs',N'U') IS NOT NULL
  DROP TABLE #tmpFPCIDs

DECLARE @AP_ID AS bigint=NULL
DECLARE @AccountPeriod AS NVARCHAR(20)=NULL


BEGIN

DECLARE @LenderID AS bigint
DECLARE @DEBUG nvarchar(1) = 'F'

DECLARE @RenderType as nvarchar(10) = NULL
DECLARE @GroupBySQL AS varchar(1000)=NULL
DECLARE @SortBySQL AS varchar(1000)=NULL
DECLARE @FilterBySQL AS varchar(1000)=NULL
DECLARE @HeaderTx AS varchar(1000)=NULL
DECLARE @FooterTx AS varchar(1000)=NULL
DECLARE @FillerZero AS varchar(18)
DECLARE @StartDate As datetime2 (7)=NULL
DECLARE @EndDate AS datetime2 (7)=NULL
DECLARE @StartDateSpecial As datetime2 (7)=NULL
DECLARE @EndDateSpecial AS datetime2 (7)=NULL
DECLARE @StartDateSpecialLong As datetime2 (7)=NULL
DECLARE @EndDateSpecialLong AS datetime2 (7)=NULL
DECLARE @AP_START_DT AS datetime2 (7) = NULL
DECLARE @AP_END_DT AS datetime2 (7) = NULL

DECLARE @PER_YEAR AS int=NULL
DECLARE @PER_NO AS int=NULL

DECLARE @ProcessDefinitionID as bigint = 0
DECLARE @CyclePeriod as nvarchar(15) = NULL

IF @Report_History_ID IS NOT NULL
BEGIN
	SELECT @RenderType = R.RENDER_TYPE_CD 
	FROM REPORT_HISTORY RH 
	JOIN REPORT R ON RH.REPORT_ID = R.ID AND R.PURGE_DT IS NULL 
	WHERE RH.ID = @Report_History_ID

	SELECT @StartDate=REPORT_DATA_XML.value('(//ReportData/Report/StartDate/@value)[1]', 'Datetime2'),
			@EndDate=REPORT_DATA_XML.value('(//ReportData/Report/EndDate/@value)[1]', 'Datetime2')
	FROM REPORT_HISTORY WHERE ID = @Report_History_ID
END

--get the parameter values from ReportHistory for SPROC render types
IF @RenderType = 'SPROC'
BEGIN
SELECT @LenderCode=REPORT_DATA_XML.value('(/ReportData/Report/Lender/@value)[1]', 'nvarchar(20)'),
	@Division =REPORT_DATA_XML.value('(/ReportData/Report/Division/@value)[1]', 'nvarchar(10)'),
	@Coverage =REPORT_DATA_XML.value('(/ReportData/Report/Coverage/@value)[1]', 'nvarchar(100)'),
	@ReportType =REPORT_DATA_XML.value('(/ReportData/Report/ReportType/@value)[1]', 'nvarchar(50)'),
	@GroupByCode =REPORT_DATA_XML.value('(/ReportData/Report/GroupByTx/@value)[1]', 'nvarchar(50)'),
	@SortByCode =REPORT_DATA_XML.value('(/ReportData/Report/SortByTx/@value)[1]', 'nvarchar(50)'),
	@FilterByCode =REPORT_DATA_XML.value('(/ReportData/Report/FilterByTx/@value)[1]', 'nvarchar(50)'),
	@ReportConfig =REPORT_DATA_XML.value('(/ReportData/Report/ReportConfig/@value)[1]', 'nvarchar(50)')	
  FROM REPORT_HISTORY WHERE ID = @Report_History_ID
END

DECLARE @BranchTable AS TABLE(ID int, STRVALUE nvarchar(30))
			INSERT INTO @BranchTable SELECT * FROM SplitFunction(@Branch, ',')  


Select @LenderID=ID from LENDER where CODE_TX = @LenderCode and PURGE_DT is null

IF @StartDate IS NULL
BEGIN
	SET @StartDate = '01/01/2013'
	SET @EndDate = GETDATE()
END

IF @StartDate = '0001-01-01' or @StartDate IS NULL
BEGIN
  SELECT @ProcessDefinitionID =  REPORT_DATA_XML.value('(/ReportData/Report/ProcessDefinitionID/@value)[1]', 'bigint')  FROM REPORT_HISTORY WHERE ID = @Report_History_ID
  SELECT @CyclePeriod = EXECUTION_FREQ_CD FROM PROCESS_DEFINITION WHERE ID = @ProcessDefinitionID
  select @StartDate = 
	CASE @CyclePeriod 
		WHEN 'ANNUAL' THEN DATEADD(YEAR, -1, @EndDate)
		WHEN 'QUARTERLY' THEN DATEADD(QUARTER, -1, @EndDate)
		WHEN 'MONTHLY' THEN DATEADD(MONTH, -1, @EndDate)
		WHEN 'SEMIMONTH' THEN DATEADD(WEEK, -2, @EndDate)
		WHEN 'BIWEEK' THEN DATEADD(WEEK, -2, @EndDate)
		WHEN '14DAYS' THEN DATEADD(d, -14, @EndDate)
		WHEN 'WEEK' THEN DATEADD(WEEK, -1, @EndDate)
		WHEN 'DAY' THEN DATEADD(d, -1, @EndDate)
		WHEN 'HOUR' THEN DATEADD(HOUR, -1, @EndDate)	
		ELSE DATEADD(DAY, -2, @EndDate)	
	 end	 
END

SET @StartDate = DATEADD(HH,0,@StartDate)			
SET @EndDate = DATEADD(HH,0,@EndDate)		
SET @StartDateSpecial = DATEADD(D, 1, DATEDIFF(D, 0, @StartDate))			
SET @EndDateSpecial = DATEADD(D, 1, DATEDIFF(D, 0, @EndDate)) 			
SET @StartDateSpecialLong = DATEADD(D, -100, @StartDateSpecial)
SET @EndDateSpecialLong = DATEADD(D, 100, @EndDateSpecial)
SET @PER_YEAR = CAST(SUBSTRING(@AccountPeriod,1,4) AS INTEGER)
SET @PER_NO = CAST(SUBSTRING(@AccountPeriod,6,2) AS INTEGER)

DECLARE @FIL_HAS_TAX AS varchar(1)='F'
DECLARE @FIL_HAS_OTHER AS varchar(1)='F'
DECLARE @FIL_HAS_FEE AS varchar(1)='F'
DECLARE @FIL_ASSMI AS varchar(1)='F'
DECLARE @FIL_AGENT_CODE AS varchar(20)='NONE'
DECLARE @FIL_DATERANGE AS varchar(1) = 'F'
DECLARE @FIL_DATERANGE_SPECIAL AS varchar(1) = 'F'
DECLARE @FIL_PI_DELAY AS varchar(1) = 'T'

DECLARE @HASFEE AS varchar(1)=NULL
DECLARE @CUR_PERIOD As varchar(1)=NULL
DECLARE @RealReportConfig as varchar(50)=NULL

SET @FillerZero = '000000000000000000'
	
DECLARE @RecordCount bigint = 0
DECLARE @sqlstring AS nvarchar(4000)

END;

CREATE TABLE [dbo].[#tmptable](
	[LOAN_BRANCHCODE_TX] [nvarchar](20) NULL,
	[LOAN_DIVISIONCODE_TX] [nvarchar](20) NULL,
	[LOAN_TYPE_TX] [nvarchar](1000) NULL,
	[LOAN_TERM_NO] [int] NULL,
	[REQUIREDCOVERAGE_TYPE_TX] [nvarchar](1000) NULL,
	[REQUIREDCOVERAGE_CODE_TX] [nvarchar](30) NULL,
	[LOAN_NUMBER_TX] [nvarchar](18) NOT NULL,
	[LOAN_NUMBERSORT_TX] [nvarchar](36) NULL,
	[OWNER_LASTNAME_TX] [nvarchar](30) NOT NULL,
	[OWNER_FIRSTNAME_TX] [nvarchar](30) NOT NULL,
	[OWNER_MIDDLE_INITIAL_TX] [char](1) NOT NULL,
	[OWNER_NAME] [nvarchar](64) NULL,
	[OWNER_LINE1_TX] [nvarchar](100) NOT NULL,
	[OWNER_LINE2_TX] [nvarchar](100) NOT NULL,
	[OWNER_STATE_TX] [nvarchar](30) NOT NULL,
	[OWNER_CITY_TX] [nvarchar](40) NOT NULL,
	[OWNER_ZIP_TX] [nvarchar](30) NOT NULL,
	[OWNER_TYPE_CD] [nvarchar](4) NULL,
	[INS_EXPIRE_DT] [datetime] NULL,
	[INS_EXPCXL_DT] [datetime] NULL,
	[INS_CANCEL_DT] [datetime] NULL,
	[INS_EFFECTIVE_DT] [datetime] NULL,
	[INS_PAYMENT_REPORT_DT] [datetime2] NULL,
	[INS_PAYMENT_REPORT_CD] [nvarchar] (1) NULL,
	[LOAN_BALANCE_NO] [decimal](19, 2) NULL,
	[COLLATERAL_CODE_TX] [nvarchar](30) NULL,
	[COLLATERAL_NUMBER_NO] [int] NULL,
	[COLLATERAL_YEAR_TX] [nvarchar](4) NULL,
	[COLLATERAL_MAKE_TX] [nvarchar](30) NULL,
	[COLLATERAL_MODEL_TX] [nvarchar](30) NULL,
	[COLLATERAL_VIN_TX] [nvarchar](18) NULL,
	[COLLATERAL_EQUIP_TX] [nvarchar](100) NULL,
	[COLLATERAL_LINE1_TX] [nvarchar](100) NULL,
	[COLLATERAL_LINE2_TX] [nvarchar](100) NULL,
	[COLLATERAL_STATE_TX] [nvarchar](30) NULL,
	[COLLATERAL_CITY_TX] [nvarchar](40) NULL,
	[COLLATERAL_ZIP_TX] [nvarchar](30) NULL,
	[PROPERTY_TYPE_CD] [nvarchar](30) NULL,
	[LENDER_COLLATERAL_CODE_TX] [nvarchar](10) NULL,
	[LOAN_OFFICERCODE_TX] [nvarchar](20) NULL,			
	[LOAN_CREDITSCORECODE_TX] [nvarchar](20) NULL,
	[LOAN_LENDERCODE_TX] [nvarchar](10) NULL,
	[LOAN_LENDERNAME_TX] [nvarchar](40) NOT NULL,
	[INSCOMPANY_NAME_TX] [nvarchar](100) NOT NULL,		
	[INSCOMPANY_POLICY_NO] [nvarchar](30) NOT NULL,
	[INSCOMPANY_ISSUE_DT] [datetime2] (7) NULL,
	[LOAN_CONTRACTTYPECODE] [nvarchar](30) NULL,
	[LOAN_STATUSCODE] [varchar](1) NOT NULL,
	[COLLATERAL_STATUSCODE] [varchar](2) NOT NULL,
	[REQUIREDCOVERAGE_STATUSCODE] [varchar](2) NULL,
	[REQUIREDCOVERAGE_SUBSTATUSCODE] [varchar](2) NULL,
	[REQUIREDCOVERAGE_INSSTATUSCODE] [varchar](2) NULL,
	[REQUIREDCOVERAGE_INSSUBSTATUSCODE] [varchar](2) NULL,
	[REQUIREDCOVERAGE_TYPE_CD] [nvarchar] (30) NULL,
	[AP_START_DT] [datetime2] (7) NULL,
	[AP_END_DT] [datetime2] (7) NULL,
	[CARRIER_ID] [bigint] NULL,
	[PROPERTY_DESCRIPTION] [nvarchar](100) NULL,
	[CPI_NETPREMIUM_AMOUNT_NO] [decimal](18, 2) NULL,
	[CPI_ISSUEDPREMIUM_AMOUNT_NO] [decimal](18, 2) NULL,
	[CPI_CANCELLEDPREMIUM_AMOUNT_NO] [decimal](18, 2) NULL,
	[NEW_PAYMENT_AMOUNT_NO] [decimal] (10,2) NULL,
	[CURRENT_PAYMENT_AMOUNT_NO] [decimal] (10,2) NULL,
	[ORIGINAL_PAYMENT_AMOUNT_NO] [decimal] (10,2) NULL,
	[CALCPMTINCR_NO] [decimal] (10,2) NULL,
	[PMTINCR_NO] [decimal] (10,2) NULL,
	[PmtOptPmtMethodValue] [decimal] (10,2) NULL,
	[CALC_CURRENT_PAYMENT_AMOUNT_NO] [decimal] (10,2) NULL,
	[ORIG_CALC_CURRENT_PAYMENT_AMOUNT_NO] [decimal] (10,2) NULL,
	[CALC_CURRENT_PAYMENT_AMOUNT_REF_NO] [decimal] (10,2) NULL,
	[CALC_CURRENT_PAYMENT_AMOUNT_REF6497_NO] [decimal] (10,2) NULL,
	[CALC_NEW_PAYMENT_AMOUNT_NO] [decimal] (10,2) NULL,
	[ORIG_CALC_NEW_PAYMENT_AMOUNT_NO] [decimal] (10,2) NULL,
	[CALC_INCREASED_BY_AMOUNT_NO] [decimal] (10,2) NULL,
	[CALC_INCREASED_BY_AMOUNT1_NO] [decimal] (10,2) NULL,
	[LENDER_OPTION_DELAYED_PI_NO] bigint NULL,
	[PAYMENT_INCREASE_METHOD_CD] [nvarchar] (20) NULL,
	[RENEW_TX] nvarchar(20) NULL,
	[ISS_REASON_TX] [nvarchar](10) NOT NULL,
	[EARNED_PREMIUM_AMOUNT_NO] [decimal] (10,2) NULL,
	[MONTHLY_BILLING_IN] [nvarchar](1) NULL,
	[PAYMENT_FREQUENCY_CD] [varchar](1) NULL,
	[QUICK_ISSUE_IN] [varchar] (1) NULL,
	[HOLD_IN] [varchar] (1) NULL,
	[EARNED_PAYMENT_NO] [int] NULL,	
	[ISMULTI] [int] NOT NULL DEFAULT 0,
	[FPC_ID] [bigint] NULL,
	[LOAN_ID] [bigint] NULL,		
	[REPORT_SORTBY_TX] [nvarchar](2114) NULL,
	[REPORT_GROUPBY_TX] [nvarchar](2012) NULL,
	[REPORT_FOOTER_TX] [varchar](2012) NULL
) ON [PRIMARY]

CREATE TABLE #tmpSpecialFPCs ( 
	ID bigint,
	QUICK_ISSUE_IN varchar(1) NULL,
	ISSUE_DT DATETIME2(7) NULL,
	NEW_ISSUE_DT DATETIME2(7) NULL
) ON [PRIMARY]

CREATE TABLE #tmpFPCIDs ( 
	ID bigint PRIMARY KEY
) ON [PRIMARY]

CREATE TABLE [dbo].[#tmpfilter](
	[ATTRIBUTE_CD] [nvarchar](50) NULL,
	[VALUE_TX] [nvarchar](50) NULL
) ON [PRIMARY]

INSERT INTO #tmpfilter 
	([ATTRIBUTE_CD]
	,[VALUE_TX])


SELECT
	RAD.ATTRIBUTE_CD,
	CASE 
		WHEN Custom.VALUE_TX IS NOT NULL then Custom.VALUE_TX
		WHEN RA.VALUE_TX IS NOT NULL then RA.VALUE_TX
		ELSE RAD.VALUE_TX
	END AS VALUE_TX
FROM REF_CODE RC
JOIN REF_CODE_ATTRIBUTE RAD ON RAD.DOMAIN_CD = RC.DOMAIN_CD AND RAD.REF_CD = 'DEFAULT' AND RAD.ATTRIBUTE_CD like 'FIL%'
LEFT JOIN REF_CODE_ATTRIBUTE RA ON RA.DOMAIN_CD = RC.DOMAIN_CD AND RA.REF_CD = RC.CODE_CD AND RA.ATTRIBUTE_CD = RAD.ATTRIBUTE_CD
LEFT JOIN 
	(SELECT CODE_TX,REPORT_CD,REPORT_DOMAIN_CD,REPORT_REF_ATTRIBUTE_CD,VALUE_TX FROM REPORT_CONFIG RC
	JOIN REPORT_CONFIG_ATTRIBUTE RCA ON RCA.REPORT_CONFIG_ID = RC.ID) CUSTOM
	ON CUSTOM.CODE_TX = @ReportConfig AND CUSTOM.REPORT_DOMAIN_CD = RAD.DOMAIN_CD AND CUSTOM.REPORT_REF_ATTRIBUTE_CD = RAD.ATTRIBUTE_CD AND CUSTOM.REPORT_CD = @ReportType
WHERE RC.DOMAIN_CD = 'Report_PaymentChanges' AND RC.CODE_CD = @ReportType

--Report specific. As a selection criteria, the report can either have as a regular date range (FIL_DATERANGE) or the special date range (FIL_DATERANGE_SPECIAL)
SELECT @FIL_DATERANGE =  CASE WHEN @FilterByCode = 'SpecialDate' THEN 'F' --if SpecialDate filter used, set the value to 'F'
						 ELSE 
							CASE WHEN (SELECT COUNT(1) FROM #tmpfilter WHERE ATTRIBUTE_CD = 'FIL_DATERANGE') = 0 THEN 'T'	--if not defined, set to 'T'
								ELSE (SELECT VALUE_TX FROM #tmpfilter WHERE ATTRIBUTE_CD = 'FIL_DATERANGE')					-- if defined, set to the value configured
							END 
						 END
Select @FIL_DATERANGE_SPECIAL = CASE WHEN @FilterByCode = 'SpecialDate' THEN 'T' ELSE 'F' END  
Select @FIL_PI_DELAY = ISNULL(Value_TX,'F') from #tmpfilter WHERE ATTRIBUTE_CD = 'FIL_PI_DELAY'


BEGIN --Set Filters, Groups, and Sorts
IF @GroupByCode IS NULL OR @GroupByCode = ''
	SELECT @GroupBySQL=GROUP_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig
ELSE
	SELECT @GroupBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_GroupBy' AND CODE_CD = @GroupByCode

IF @SortByCode IS NULL OR @SortByCode = ''
	SELECT @SortBySQL=SORT_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig
ELSE
	SELECT @SortBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_SortBy' AND CODE_CD = @SortByCode

IF @FilterByCode IS NULL OR @FilterByCode = '' or @FilterByCode = 'SpecialDate' --SpecialDate code is used to control on the lender level the report version to use
	SELECT @FilterBySQL=FILTER_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig
Else
	SELECT @FilterBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_FilterBy' AND CODE_CD = @FilterByCode

SELECT @HeaderTx=HEADER_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig
SELECT @FooterTx=FOOTER_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig
END;

--Creating temp table with FPC IDs for the Special Date logic
IF @FIL_DATERANGE_SPECIAL = 'T'
BEGIN
	INSERT INTO #tmpSpecialFPCs (ID, QUICK_ISSUE_IN, ISSUE_DT, NEW_ISSUE_DT)
		SELECT FPC.ID, FPC.QUICK_ISSUE_IN, FPC.ISSUE_DT,
		DATEADD(DAY, CASE WHEN FPC.QUICK_ISSUE_IN = 'Y' THEN 0 
			ELSE ISNULL(RC.PmtOptIncrDelayedBilling,0) 
			END, FPC.ISSUE_DT)
		FROM FORCE_PLACED_CERTIFICATE FPC
		JOIN LOAN L ON FPC.LOAN_ID = L.ID AND L.PURGE_DT IS NULL
		JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = FPC.ID AND FPCRCR.PURGE_DT IS NULL
		JOIN REQUIRED_COVERAGE RC ON FPCRCR.REQUIRED_COVERAGE_ID = RC.ID AND RC.PURGE_DT IS NULL	
		WHERE 1=1
		AND FPC.PURGE_DT IS NULL
		AND L.LENDER_ID = @LenderID
		AND FPC.ISSUE_DT between @StartDateSpecialLong and @EndDateSpecialLong --widens the start and end date by 100 days to only pull a subset of FPCs

	INSERT INTO #tmpFPCIDs (ID)	
		SELECT SFPC.ID 
		FROM #tmpSpecialFPCs SFPC
		WHERE SFPC.NEW_ISSUE_DT BETWEEN @StartDateSpecial AND @EndDateSpecial --only pulls the FPC IDs that fall between the Start/End date and have the special logic
		GROUP BY SFPC.ID
END

--Creating temp table with FPC IDs for the Payment Report Date logic
IF @FIL_DATERANGE = 'T'
BEGIN
	INSERT INTO #tmpFPCIDs (ID)
		SELECT FPC.ID
		FROM FORCE_PLACED_CERTIFICATE FPC
		JOIN LOAN L ON FPC.LOAN_ID = L.ID AND L.PURGE_DT IS NULL
		WHERE FPC.PURGE_DT IS NULL
		AND L.LENDER_ID = @LenderID
		AND FPC.PAYMENT_REPORT_DT between @StartDate and @EndDate 
END


INSERT INTO #tmptable (
			[LOAN_BRANCHCODE_TX]
           ,[LOAN_DIVISIONCODE_TX]
		   ,[LOAN_TYPE_TX]
           ,[LOAN_TERM_NO]
           ,[REQUIREDCOVERAGE_TYPE_TX]
           ,[REQUIREDCOVERAGE_CODE_TX]
           ,[LOAN_NUMBER_TX]
           ,[LOAN_NUMBERSORT_TX]
           ,[OWNER_LASTNAME_TX]
           ,[OWNER_FIRSTNAME_TX]
           ,[OWNER_MIDDLE_INITIAL_TX]
           ,[OWNER_NAME]
           ,[OWNER_LINE1_TX]
           ,[OWNER_LINE2_TX]
           ,[OWNER_STATE_TX]
           ,[OWNER_CITY_TX]
           ,[OWNER_ZIP_TX]
           ,[OWNER_TYPE_CD]
           ,[INS_EXPIRE_DT]
           ,[INS_EXPCXL_DT]
           ,[INS_CANCEL_DT]
           ,[INS_EFFECTIVE_DT]
           ,[INS_PAYMENT_REPORT_DT]
           ,[INS_PAYMENT_REPORT_CD]
           ,[LOAN_BALANCE_NO]
           ,[COLLATERAL_CODE_TX]
           ,[COLLATERAL_NUMBER_NO]
		   ,[COLLATERAL_YEAR_TX]
		   ,[COLLATERAL_MAKE_TX]
		   ,[COLLATERAL_MODEL_TX]
		   ,[COLLATERAL_VIN_TX]
		   ,[COLLATERAL_EQUIP_TX]
		   ,[COLLATERAL_LINE1_TX]
		   ,[COLLATERAL_LINE2_TX]
		   ,[COLLATERAL_STATE_TX]
		   ,[COLLATERAL_CITY_TX]
		   ,[COLLATERAL_ZIP_TX]
		   ,[PROPERTY_TYPE_CD]
           ,[LENDER_COLLATERAL_CODE_TX]
           ,[LOAN_OFFICERCODE_TX]
		   ,[LOAN_CREDITSCORECODE_TX]
           ,[LOAN_LENDERCODE_TX]
           ,[LOAN_LENDERNAME_TX]
           ,[INSCOMPANY_NAME_TX]
           ,[INSCOMPANY_POLICY_NO]
           ,[INSCOMPANY_ISSUE_DT]
           ,[LOAN_CONTRACTTYPECODE]
           ,[LOAN_STATUSCODE]
           ,[COLLATERAL_STATUSCODE]
           ,[REQUIREDCOVERAGE_STATUSCODE]
           ,[REQUIREDCOVERAGE_SUBSTATUSCODE]
           ,[REQUIREDCOVERAGE_INSSTATUSCODE]
           ,[REQUIREDCOVERAGE_INSSUBSTATUSCODE]
           ,[REQUIREDCOVERAGE_TYPE_CD]
		   ,[AP_START_DT]
		   ,[AP_END_DT]
		   ,[CARRIER_ID]
           ,[PROPERTY_DESCRIPTION]
           ,[CPI_NETPREMIUM_AMOUNT_NO]
           ,[CPI_ISSUEDPREMIUM_AMOUNT_NO]
           ,[CPI_CANCELLEDPREMIUM_AMOUNT_NO]
           ,[NEW_PAYMENT_AMOUNT_NO]
           ,[CURRENT_PAYMENT_AMOUNT_NO]
           ,[ORIGINAL_PAYMENT_AMOUNT_NO]
           ,[CALCPMTINCR_NO]
           ,[PMTINCR_NO]
           ,[PmtOptPmtMethodValue]
           ,[CALC_CURRENT_PAYMENT_AMOUNT_NO]
           ,[ORIG_CALC_CURRENT_PAYMENT_AMOUNT_NO]
           ,[CALC_CURRENT_PAYMENT_AMOUNT_REF_NO]
           ,[CALC_CURRENT_PAYMENT_AMOUNT_REF6497_NO]
           ,[CALC_NEW_PAYMENT_AMOUNT_NO]
           ,[ORIG_CALC_NEW_PAYMENT_AMOUNT_NO]
           ,[CALC_INCREASED_BY_AMOUNT_NO]
           ,[CALC_INCREASED_BY_AMOUNT1_NO]
           ,[LENDER_OPTION_DELAYED_PI_NO]
           ,[PAYMENT_INCREASE_METHOD_CD]
           ,[RENEW_TX]
           ,[ISS_REASON_TX]
           ,[EARNED_PREMIUM_AMOUNT_NO]
           ,[MONTHLY_BILLING_IN]
           ,[PAYMENT_FREQUENCY_CD]
           ,[QUICK_ISSUE_IN]
           ,[HOLD_IN]
           ,[EARNED_PAYMENT_NO]	
		   ,[ISMULTI]
		   ,[FPC_ID]
		   ,[LOAN_ID]
           ,[REPORT_SORTBY_TX]
           ,[REPORT_GROUPBY_TX]
           ,[REPORT_FOOTER_TX])

SELECT
	(CASE WHEN L.BRANCH_CODE_TX IS NULL OR L.BRANCH_CODE_TX = '' THEN 'NOBRANCH' ELSE L.BRANCH_CODE_TX END) AS	[LOAN_BRANCHCODE_TX]
	,CASE WHEN ISNULL(L.DIVISION_CODE_TX,'') = ''
		THEN '0'
		ELSE L.DIVISION_CODE_TX
	 END AS [LOAN_DIVISIONCODE_TX]
	,ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) AS [LOAN_TYPE_TX]
	,DATEDIFF("m",L.EFFECTIVE_DT,L.MATURITY_DT) AS [LOAN_TERM_NO]
	,ISNULL(RC_COVERAGETYPE.MEANING_TX,'') AS [REQUIREDCOVERAGE_TYPE_TX]
	,RC.TYPE_CD AS [REQUIREDCOVERAGE_CODE_TX]
	,L.NUMBER_TX AS	[LOAN_NUMBER_TX]
	,SUBSTRING(@FillerZero, 1, 18 - LEN(L.NUMBER_TX)) + CAST(L.NUMBER_TX AS nvarchar(18)) AS [LOAN_NUMBERSORT_TX]
	,ISNULL(O.LAST_NAME_TX,'') AS [OWNER_LASTNAME_TX]
	,ISNULL(O.FIRST_NAME_TX,'') AS [OWNER_FIRSTNAME_TX]
	,ISNULL(O.MIDDLE_INITIAL_TX,'') AS [OWNER_MIDDLE_INITIAL_TX]
	,CASE WHEN O.FIRST_NAME_TX IS NULL THEN O.LAST_NAME_TX ELSE RTRIM(O.LAST_NAME_TX + ', ' + ISNULL(O.FIRST_NAME_TX,'') + ' ' + ISNULL(O.MIDDLE_INITIAL_TX,'')) END AS [OWNER_NAME]
	,ISNULL(AO.LINE_1_TX,'') AS	[OWNER_LINE1_TX]
	,ISNULL(AO.LINE_2_TX,'') AS	[OWNER_LINE2_TX]
	,ISNULL(AO.STATE_PROV_TX,'') AS	[OWNER_STATE_TX]
	,ISNULL(AO.CITY_TX,'') AS [OWNER_CITY_TX]
	,ISNULL(AO.POSTAL_CODE_TX,'')  AS [OWNER_ZIP_TX]
	,OLR.OWNER_TYPE_CD AS [OWNER_TYPE_CD]
	,FPC.EXPIRATION_DT AS [INS_EXPIRE_DT]
	,ISNULL(FPC.CANCELLATION_DT,FPC.EXPIRATION_DT) AS [INS_EXPCXL_DT]
	,FPC.CANCELLATION_DT AS [INS_CANCEL_DT]
	,FPC.EFFECTIVE_DT AS [INS_EFFECTIVE_DT]
	,FPC.PAYMENT_REPORT_DT AS [INS_PAYMENT_REPORT_DT]
	,CASE WHEN @FIL_DATERANGE_SPECIAL = 'T' THEN 'I' ELSE FPC.PAYMENT_REPORT_CD END AS [INS_PAYMENT_REPORT_CD]
	,C.LOAN_BALANCE_NO AS [LOAN_BALANCE_NO]
	,CC.CODE_TX AS [COLLATERAL_CODE_TX]
	,C.COLLATERAL_NUMBER_NO AS [COLLATERAL_NUMBER_NO]
    ,P.YEAR_TX AS [COLLATERAL_YEAR_TX]
	,P.MAKE_TX AS [COLLATERAL_MAKE_TX]
	,P.MODEL_TX AS [COLLATERAL_MODEL_TX]
	,P.VIN_TX AS [COLLATERAL_VIN_TX]
	,P.DESCRIPTION_TX AS [COLLATERAL_EQUIP_TX]
	,AM.LINE_1_TX as [COLLATERAL_LINE1_TX]
	,AM.LINE_2_TX as [COLLATERAL_LINE2_TX]
	,AM.STATE_PROV_TX as [COLLATERAL_STATE_TX]
	,AM.CITY_TX as [COLLATERAL_CITY_TX]
	,AM.POSTAL_CODE_TX as [COLLATERAL_ZIP_TX]
	,RCA_PROP.VALUE_TX AS [PROPERTY_TYPE_CD]
	,C.LENDER_COLLATERAL_CODE_TX AS	[LENDER_COLLATERAL_CODE_TX]
	,L.OFFICER_CODE_TX AS [LOAN_OFFICERCODE_TX]
	,L.CREDIT_SCORE_CD as [LOAN_CREDITSCORECODE_TX]
	,LND.CODE_TX AS	[LOAN_LENDERCODE_TX]
	,LND.NAME_TX AS	[LOAN_LENDERNAME_TX]
	,ISNULL(CR.NAME_TX,'') AS [INSCOMPANY_NAME_TX]		
	,FPC.NUMBER_TX AS [INSCOMPANY_POLICY_NO]	
	,FPC.ISSUE_DT AS [INSCOMPANY_ISSUE_DT]	 
	,L.CONTRACT_TYPE_CD AS [LOAN_CONTRACTTYPECODE]
	,L.STATUS_CD AS	[LOAN_STATUSCODE]
	,C.STATUS_CD AS	[COLLATERAL_STATUSCODE]
	,RC.STATUS_CD AS [REQUIREDCOVERAGE_STATUSCODE]
	,RC.SUB_STATUS_CD AS [REQUIREDCOVERAGE_SUBSTATUSCODE]
	,RC.SUMMARY_STATUS_CD AS [REQUIREDCOVERAGE_INSSTATUSCODE]
	,RC.SUMMARY_SUB_STATUS_CD AS [REQUIREDCOVERAGE_INSSUBSTATUSCODE]
	,RC.RECORD_TYPE_CD AS [REQUIREDCOVERAGE_TYPE_CD]
	,@StartDate AS [AP_START_DT]
	,@EndDate AS [AP_END_DT]
	,FPC.CARRIER_ID AS [CARRIER_ID]
	,'' AS PROPERTY_DESCRIPTION
	,CASE WHEN FTX.NET_AMOUNT IS NOT NULL 
		THEN FTX.NET_AMOUNT 
		ELSE ISNULL(CPA_I.TOTAL_PREMIUM_NO,0) - ABS(ISNULL(CPA_C.TOTAL_PREMIUM_NO,0)) 
	END AS [CPI_NETPREMIUM_AMOUNT_NO]
	,ISNULL(CPA_I.TOTAL_PREMIUM_NO,0) AS [CPI_ISSUEDPREMIUM_AMOUNT_NO]
	,ABS(ISNULL(CPA_C.TOTAL_PREMIUM_NO,0)) AS [CPI_CANCELLEDPREMIUM_AMOUNT_NO]
	,L.PAYMENT_AMOUNT_NO AS [NEW_PAYMENT_AMOUNT_NO]	
	,CPI_ALL.MAXDATE_CPICMT_NEW_PAYMENT_AMOUNT_NO AS [CURRENT_PAYMENT_AMOUNT_NO]
	,CPI_ALL.CPII_PRIOR_PAYMENT_AMOUNT_NO AS [ORIGINAL_PAYMENT_AMOUNT_NO]
	,CPI_ALL.CalcPmtIncr AS [CALCPMTINCR_NO]
	,CPA_I.PAYMENT_CHANGE_AMOUNT_NO AS [PMTINCR_NO]
	,ISNULL(RC.PmtOptPmtMethodValue, 0) AS [PmtOptPmtMethodValue]
	,CASE
		WHEN CPQ.PAYMENT_INCREASE_METHOD_CD = 'PR' AND ISNULL(CPA_I.REASON_CD, '') = 'R' THEN CPII_PRIOR_PAYMENT_AMOUNT_NO
		ELSE CPII_PRIOR_PAYMENT_AMOUNT_NO
	 END AS [CALC_CURRENT_PAYMENT_AMOUNT_NO]
	,CASE
		WHEN CPQ.PAYMENT_INCREASE_METHOD_CD = 'PR' AND ISNULL(CPA_I.REASON_CD, '') = 'R' THEN CPII_PRIOR_PAYMENT_AMOUNT_NO
		ELSE CPII_PRIOR_PAYMENT_AMOUNT_NO
	 END AS [ORIG_CALC_CURRENT_PAYMENT_AMOUNT_NO]		
	,MAXDATE_CPICMT_PRIOR_PAYMENT_AMOUNT_NO AS [CALC_CURRENT_PAYMENT_AMOUNT_REF_NO]
	,CASE
		WHEN isnull(DATEDIFF(MONTH,FPC.CANCELLATION_DT,FPC.EXPIRATION_DT),0) = 12 THEN CPI_ALL.CPII_NEW_PAYMENT_AMOUNT_NO
		WHEN isnull(DATEDIFF(MONTH,FPC.CANCELLATION_DT,FPC.EXPIRATION_DT),0) = 0 THEN 0
		ELSE ((ISNULL(CPA_I.TOTAL_PREMIUM_NO,0) - ABS(ISNULL(CPI_ALL.CPICMTR_PRIOR_PAYMENT_AMOUNT_NO,0))) / isnull(DATEDIFF(MONTH,FPC.CANCELLATION_DT,FPC.EXPIRATION_DT),0)) + CPI_ALL.CPII_PRIOR_PAYMENT_AMOUNT_NO
	END AS [CALC_CURRENT_PAYMENT_AMOUNT_REF6497_NO]
	,CASE 
		WHEN CPQ.PAYMENT_INCREASE_METHOD_CD = 'NM' AND FPC.CANCELLATION_DT IS NOT NULL THEN ISNULL(CPI_ALL.CPII_PRIOR_PAYMENT_AMOUNT_NO,0) + ABS(ISNULL(CPI_ALL.MAXDATE_CPICMT_EARNED_PAYMENT_AMOUNT_NO,0))
		ELSE ISNULL(CPII_NEW_PAYMENT_AMOUNT_NO,0) 
		END AS [CALC_NEW_PAYMENT_AMOUNT_NO]
	,CASE 
		WHEN CPQ.PAYMENT_INCREASE_METHOD_CD = 'NM' AND FPC.CANCELLATION_DT IS NOT NULL THEN ISNULL(CPI_ALL.CPII_PRIOR_PAYMENT_AMOUNT_NO,0) + ABS(ISNULL(CPI_ALL.MAXDATE_CPICMT_EARNED_PAYMENT_AMOUNT_NO,0))
		ELSE ISNULL(CPII_NEW_PAYMENT_AMOUNT_NO,0) 
		END AS [ORIG_CALC_NEW_PAYMENT_AMOUNT_NO]
	,CASE 
		WHEN CPQ.PAYMENT_INCREASE_METHOD_CD = 'NM' AND FPC.CANCELLATION_DT IS NOT NULL THEN CPI_ALL.MAXDATE_CPICMT_EARNED_PAYMENT_AMOUNT_NO
	    WHEN CPQ.PAYMENT_INCREASE_METHOD_CD = 'PR' AND ISNULL(CPA_I.REASON_CD, '') = 'R' THEN 0	
	    ELSE CPI_ALL.CPII_PAYMENT_CHANGE_AMOUNT_NO 
	 END AS [CALC_INCREASED_BY_AMOUNT_NO]
	,CASE
			WHEN L.PAYMENT_FREQUENCY_CD IN('B','S') THEN ISNULL(CPISQ.IPRM_AMOUNT_NO,0) / 21.66666
			WHEN L.PAYMENT_FREQUENCY_CD = 'W' THEN ISNULL(CPISQ.IPRM_AMOUNT_NO,0) / 43.33333
			ELSE ISNULL(CPISQ.IPRM_AMOUNT_NO,0) / 10
		END AS [CALC_INCREASED_BY_AMOUNT1_NO]
	,ISNULL(RC.PmtOptIncrDelayedBilling,0)  AS [LENDER_OPTION_DELAYED_PI_NO]
	,CPQ.PAYMENT_INCREASE_METHOD_CD AS [PAYMENT_INCREASE_METHOD_CD]
	,CASE
		WHEN ISNULL(L.DIVISION_CODE_TX,'0') in ('3','8') OR RCA_PROP.VALUE_TX in ('VEH','BOAT') THEN 
			CASE WHEN CPQ.PAYMENT_INCREASE_METHOD_CD = 'PR' AND ISNULL(CPA_I.REASON_CD, '') = 'R' THEN 'RENEW' ELSE '' END
		ELSE
			CASE WHEN CPQ.PAYMENT_INCREASE_METHOD_CD  = 'PR' AND ISNULL(CPA_I.REASON_CD, '') = 'R' AND (FPC.PIR_DT < FPC.ISSUE_DT) THEN 'RENEW' ELSE '' END 
	END AS [RENEW_TX] 
	,ISNULL(CPA_I.REASON_CD, '') AS [ISS_REASON_TX]
		,CASE 
			WHEN CPQ.PAYMENT_INCREASE_METHOD_CD = 'NM' THEN (CPI_ALL.CPII_TOTAL_PREMIUM_AMOUNT_NO - ABS(CPICMTR_TOTAL_PREMIUM_NO))
			ELSE CPI_ALL.CPII_TOTAL_PREMIUM_AMOUNT_NO
		END AS [EARNED_PREMIUM_AMOUNT_NO]
	,FPC.MONTHLY_BILLING_IN AS [MONTHLY_BILLING_IN]	
	,L.PAYMENT_FREQUENCY_CD AS [PAYMENT_FREQUENCY_CD]
	,ISNULL(FPC.QUICK_ISSUE_IN,'N') AS [QUICK_ISSUE_IN]	
	,ISNULL(FPC.HOLD_IN,'N') AS [HOLD_IN]
	,dbo.CalculateEarnedPayment(FPC.ID) AS [EARNED_PAYMENT_NO]
	,0 AS [ISMULTI]
	,FPC.ID AS [FPC_ID]
	,L.ID AS [LOAN_ID]
	,@SortByCode AS [REPORT_SORTBY_TX]
	,@GroupByCode as [REPORT_GROUPBY_TX]
	,REPORT_FOOTER_TX = ''

FROM #tmpFPCIDs tmp
JOIN FORCE_PLACED_CERTIFICATE FPC on tmp.ID = FPC.ID
JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = FPC.ID AND FPCRCR.PURGE_DT IS NULL
JOIN CARRIER CR ON FPC.CARRIER_ID = CR.ID AND CR.PURGE_DT IS NULL	
JOIN REQUIRED_COVERAGE RC ON FPCRCR.REQUIRED_COVERAGE_ID = RC.ID AND RC.PURGE_DT IS NULL					 
JOIN LOAN L ON L.ID = FPC.LOAN_ID AND L.PURGE_DT IS NULL 
JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND OLR.PRIMARY_IN = 'Y' AND OLR.PURGE_DT IS NULL
JOIN [OWNER] O ON O.ID = OLR.OWNER_ID AND O.PURGE_DT IS NULL
JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID AND P.PURGE_DT IS NULL											
JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID AND C.PURGE_DT IS NULL AND C.LOAN_ID = L.ID 									
LEFT JOIN OWNER_ADDRESS AM ON AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
LEFT JOIN OWNER_ADDRESS AO ON AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
LEFT JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD 
LEFT JOIN REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX 
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
LEFT JOIN CPI_QUOTE CPQ ON  CPQ.ID = FPC.CPI_QUOTE_ID AND CPQ.PURGE_DT IS NULL
LEFT JOIN CPI_ACTIVITY CPA_I on CPA_I.CPI_QUOTE_ID = CPQ.ID AND CPA_I.TYPE_CD = 'I'	AND CPA_I.PURGE_DT IS NULL

OUTER APPLY 
(SELECT SUM(TOTAL_PREMIUM_NO) AS TOTAL_PREMIUM_NO, MAX(REASON_CD) AS REASON_CD FROM CPI_ACTIVITY C  
WHERE C.CPI_QUOTE_ID = CPQ.ID AND C.TYPE_CD IN ('C', 'R', 'MT') AND C.PURGE_DT IS NULL
) CPA_C

CROSS APPLY
(
	SELECT 
	-- Note that some of the SUMs use EARNED_PAYMENT_AMOUNT_NO and others use NEW_PAYMENT_AMOUNT_NO or TOTAL_PREMIUM_NO
	-- 04292013 Anu Only use row for EARNED_PAYMENT_AMOUNT (EarnedPremium) for the max ProcessDate
	SUM(CASE WHEN CPI.TYPE_CD  IN('C','MT') AND CPI.PROCESS_DT = CPI_MX.PROCESS_DT THEN CPI.EARNED_PAYMENT_AMOUNT_NO ELSE 0 END) AS EarnedPremium,
	SUM(CASE WHEN CPI.TYPE_CD  IN('C','MT')  AND CPI.PROCESS_DT = CPI_MX.PROCESS_DT THEN CPI.PAYMENT_CHANGE_AMOUNT_NO ELSE 0 END) AS CalcPmtIncr,
	--For Payment decrease ï¿½ we can get the sum of NewPaymentAmount from CPIActivity ï¿½ for Types ï¿½ C, MT, R
	SUM(CASE WHEN CPI.TYPE_CD  IN('C','MT','R') THEN CPI.PAYMENT_CHANGE_AMOUNT_NO ELSE 0 END) AS PmtDecrAmount,
	SUM(CASE WHEN CPI.TYPE_CD  IN('I') THEN CPI.TOTAL_PREMIUM_NO ELSE 0 END) AS CalcIssTtlCharges,
	SUM(CASE WHEN CPI.TYPE_CD  IN('C','MT','R') THEN CPI.TOTAL_PREMIUM_NO ELSE 0 END) AS CalcCanTtlCharges,
	SUM(CASE WHEN CPI.TYPE_CD IN('I') THEN CPI.PRIOR_PAYMENT_AMOUNT_NO ELSE 0 END) AS CPII_PRIOR_PAYMENT_AMOUNT_NO,
	SUM(CASE WHEN CPI.TYPE_CD  IN('C','MT') AND CPI.PROCESS_DT = CPI_MX.PROCESS_DT THEN CPI.EARNED_PAYMENT_AMOUNT_NO ELSE 0 END) AS MAXDATE_CPICMT_EARNED_PAYMENT_AMOUNT_NO,
	SUM(CASE WHEN CPI.TYPE_CD IN('I') THEN CPI.NEW_PAYMENT_AMOUNT_NO ELSE 0 END) AS CPII_NEW_PAYMENT_AMOUNT_NO,
	SUM(CASE WHEN CPI.TYPE_CD  IN('I') THEN CPI.PAYMENT_CHANGE_AMOUNT_NO ELSE 0 END) AS CPII_PAYMENT_CHANGE_AMOUNT_NO,
	SUM(CASE WHEN CPI.TYPE_CD  IN('I') THEN CPI.TOTAL_PREMIUM_NO ELSE 0 END) AS CPII_TOTAL_PREMIUM_AMOUNT_NO,
	SUM(CASE WHEN CPI.TYPE_CD  IN('C','MT','R') THEN CPI.TOTAL_PREMIUM_NO ELSE 0 END) AS CPICMTR_TOTAL_PREMIUM_NO,
	SUM(CASE WHEN CPI.TYPE_CD  IN('C','MT') AND CPI.PROCESS_DT = CPI_MX.PROCESS_DT AND ISNULL(CPI.PRIOR_PAYMENT_AMOUNT_NO,0) <> 0 THEN CPI.PRIOR_PAYMENT_AMOUNT_NO ELSE 0 END) AS MAXDATE_CPICMT_PRIOR_PAYMENT_AMOUNT_NO,		
	SUM(CASE WHEN CPI.TYPE_CD  IN('C','MT') AND CPI.PROCESS_DT = CPI_MX.PROCESS_DT AND ISNULL(CPI.PRIOR_PAYMENT_AMOUNT_NO,0) <> 0 THEN CPI.NEW_PAYMENT_AMOUNT_NO ELSE 0 END) AS MAXDATE_CPICMT_NEW_PAYMENT_AMOUNT_NO,
	SUM(CASE WHEN CPI.TYPE_CD  IN('C','MT','R') THEN CPI.PRIOR_PAYMENT_AMOUNT_NO ELSE 0 END) AS CPICMTR_PRIOR_PAYMENT_AMOUNT_NO
	FROM CPI_ACTIVITY CPI

	CROSS APPLY 
	 (
		SELECT MAX(CPI1.PROCESS_DT) AS PROCESS_DT FROM CPI_ACTIVITY CPI1 
		WHERE CPI1.CPI_QUOTE_ID = CPQ.ID AND CPI1.TYPE_CD  IN('C','MT') AND CPI1.PURGE_DT IS NULL and CPI1.PAYMENT_CHANGE_AMOUNT_NO <> 0
	 ) CPI_MX
 
	WHERE CPI.CPI_QUOTE_ID = CPQ.ID AND CPI.PURGE_DT IS NULL
) CPI_ALL

--ADDED Anu 04/23/2013 to get IPRM_AMOUNT_NO for Increased By Calculation
OUTER APPLY (
	SELECT  
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'PRM' AND CPA_SQ.TYPE_CD = 'I' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS IPRM_AMOUNT_NO,
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'FEE' AND CPA_SQ.TYPE_CD = 'I' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS IFEE_AMOUNT_NO,
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'OTH' AND CPA_SQ.TYPE_CD = 'I' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS IOTH_AMOUNT_NO,
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'TAX1' AND CPA_SQ.TYPE_CD = 'I' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS ITAX1_AMOUNT_NO,
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'TAX2' AND CPA_SQ.TYPE_CD = 'I' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS ITAX2_AMOUNT_NO,
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'PRM' AND CPA_SQ.TYPE_CD = 'C' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS CPRM_AMOUNT_NO,
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'FEE' AND CPA_SQ.TYPE_CD = 'C' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS CFEE_AMOUNT_NO,
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'OTH' AND CPA_SQ.TYPE_CD = 'C' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS COTH_AMOUNT_NO, 
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'TAX1' AND CPA_SQ.TYPE_CD = 'C' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS CTAX1_AMOUNT_NO, 
	SUM(CASE WHEN CD_SQ.TYPE_CD = 'TAX2' AND CPA_SQ.TYPE_CD = 'C' THEN CD_SQ.AMOUNT_NO ELSE 0 END) AS CTAX2_AMOUNT_NO
	FROM CPI_ACTIVITY CPA_SQ 
	JOIN CERTIFICATE_DETAIL CD_SQ ON CD_SQ.CPI_ACTIVITY_ID = CPA_SQ.ID AND CPA_SQ.CPI_QUOTE_ID = CPQ.ID AND CD_SQ.PURGE_DT IS NULL
	WHERE CPA_SQ.CPI_QUOTE_ID = CPQ.ID AND CPA_SQ.PURGE_DT IS NULL
) CPISQ

OUTER APPLY
(SELECT SUM(AMOUNT_NO) as NET_AMOUNT FROM FINANCIAL_TXN FTX WHERE FTX.FPC_ID = FPC.ID AND FTX.PURGE_DT IS NULL
) FTX

WHERE 1=1
AND L.RECORD_TYPE_CD = 'G' AND RC.RECORD_TYPE_CD = 'G' AND P.RECORD_TYPE_CD = 'G'
--AND L.EXTRACT_UNMATCH_COUNT_NO = 0 and C.EXTRACT_UNMATCH_COUNT_NO = 0
AND FPC.PURGE_DT IS NULL
AND (LND.ID = @LenderID OR @LenderID IS NULL)
AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM @BranchTable) or @Branch = '1' or @Branch = '' or @Branch is NULL)
AND (L.DIVISION_CODE_TX = @Division OR @Division = '1' OR @Division  = '' OR @Division is NULL 
	OR ((@Division in ('3','8') and L.DIVISION_CODE_TX not in ('3','8') and RCA_PROP.VALUE_TX in ('VEH','BOAT'))
	OR (@Division in ('7','9') and L.DIVISION_CODE_TX not in ('7','9') and RCA_PROP.VALUE_TX in ('EQ'))
	OR (@Division in ('4','10') and L.DIVISION_CODE_TX not in ('4','10') and RCA_PROP.VALUE_TX not in ('VEH','BOAT','EQ'))))
AND (RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage is NULL)
AND (@FIL_DATERANGE = 'F' OR (@FIL_DATERANGE = 'T' AND FPC.ID in (select ID from #tmpFPCIDs)))
AND (@FIL_DATERANGE_SPECIAL = 'F' OR (@FIL_DATERANGE_SPECIAL = 'T' AND FPC.ID in (select ID from #tmpFPCIDs) 
	AND ISNULL(FPC.HOLD_IN,'N') = 'N' AND FPC.MONTHLY_BILLING_IN = 'N' 
	AND ((FTX.NET_AMOUNT IS NOT NULL AND FTX.NET_AMOUNT > 0) OR (FTX.NET_AMOUNT IS NULL AND ISNULL(CPA_I.TOTAL_PREMIUM_NO,0) - ABS(ISNULL(CPA_C.TOTAL_PREMIUM_NO,0)) > 0))
	))

If isnull(@FilterBySQL,'') <> '' 
Begin
  Select * into #t1 from #tmptable 
  truncate table #tmptable

  Set @sqlstring = N'Insert into #tmpTable
                     Select * from dbo.#t1 where ' + @FilterBySQL
  --print @sqlstring
  EXECUTE sp_executesql @sqlstring
End  

-- Anu Multi-Collateral Logic
IF @ReportType = 'PMTCHG'
BEGIN
	UPDATE #tmptable  SET ISMULTI = 1 WHERE LOAN_ID IN 
	(
		SELECT LOAN_ID FROM #tmptable
		GROUP BY LOAN_ID HAVING COUNT(*) > 1	
	)

		DECLARE @tmpMULTICPI TABLE
	(
		LOAN_ID bigint,		
		FPC_ID bigint,	
		FPC_NUMBER varchar(18), 		
		ISSUE_DT datetime, 		
		FPC_CANCELLATION_DT datetime,
		FPC_EXPIRATION_DT datetime,
		ORIGINAL_PAYMENT_NO decimal(18,5), 
		CURRENT_PAYMENT_NO decimal(18,5), 
		PMT_INCR_NO decimal(18,5),
		CALC_NEW_PAYMENT_AMOUNT_NO decimal(18,5),
		CALC_CURRENT_PAYMENT_AMOUNT_NO decimal(18,5),
		PRIOR_PAYMENT_NO decimal(18,5), 
		NEW_PAYMENT_NO DECIMAL (18, 5),
		EARNED_PAYMENT_NO decimal(18,5)		
	)

	INSERT INTO @tmpMULTICPI
	(
		LOAN_ID, FPC_ID, FPC_NUMBER, ISSUE_DT, FPC_CANCELLATION_DT, FPC_EXPIRATION_DT,
		ORIGINAL_PAYMENT_NO, CURRENT_PAYMENT_NO, PMT_INCR_NO, CALC_NEW_PAYMENT_AMOUNT_NO, CALC_CURRENT_PAYMENT_AMOUNT_NO, 
		PRIOR_PAYMENT_NO, NEW_PAYMENT_NO, EARNED_PAYMENT_NO 
	)
	SELECT DISTINCT
		LOAN.ID, FPC.ID, FPC.NUMBER_TX,
		FPC.ISSUE_DT, FPC.CANCELLATION_DT, FPC.EXPIRATION_DT,
		LOAN.ORIGINAL_PAYMENT_AMOUNT_NO, LOAN.PAYMENT_AMOUNT_NO, ACT.PAYMENT_CHANGE_AMOUNT_NO, 0, 0,
		ACT.PRIOR_PAYMENT_AMOUNT_NO, ACT.NEW_PAYMENT_AMOUNT_NO, CXL.EARNED_PAYMENT_AMOUNT_NO 	
		FROM LOAN 
		JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.LOAN_ID = LOAN.ID AND FPC.PURGE_DT IS NULL	 
		JOIN CPI_ACTIVITY ACT ON ACT.CPI_QUOTE_ID = FPC.CPI_QUOTE_ID
		AND ACT.PURGE_DT IS NULL AND ACT.TYPE_CD = 'I'
		JOIN #tmptable ON #tmptable.FPC_ID = FPC.ID
		OUTER APPLY
		(
		   SELECT TOP 1 EARNED_PAYMENT_AMOUNT_NO FROM CPI_ACTIVITY ACT1
		   WHERE PURGE_DT IS NULL AND ACT1.CPI_QUOTE_ID = FPC.CPI_QUOTE_ID
		   AND TYPE_CD IN ('C' , 'MT' ) 
		   ORDER BY PROCESS_DT DESC
		) AS CXL
		WHERE ISMULTI = 1

	DECLARE @LOAN_ID as bigint
	DECLARE @FPC_ID as bigint
	DECLARE @PREV_LOAN_ID as bigint
	DECLARE @ORIGINAL_PAYMENT_NO as decimal(18, 5)
	DECLARE @CURRENT_PAYMENT_NO as decimal(18, 5)
	DECLARE @PMT_INCR_NO as decimal(18, 5)	
	DECLARE @EARNED_PAYMENT_NO as decimal(18, 5)
	DECLARE @NEW_PMT_INCR as decimal (18, 5)
	DECLARE @FPC_CANCELLATION_DT as datetime
	DECLARE @FPCCNT as int
	set @FPCCNT = 0
	set @PREV_LOAN_ID = 0

	DECLARE PMTCUR SCROLL CURSOR FOR
		SELECT  LOAN_ID, FPC_ID, ORIGINAL_PAYMENT_NO, CURRENT_PAYMENT_NO, 
			PMT_INCR_NO, EARNED_PAYMENT_NO, FPC_CANCELLATION_DT
			FROM @tmpMULTICPI 
			ORDER BY LOAN_ID, ISSUE_DT

	OPEN PMTCUR

	FETCH FROM PMTCUR INTO @LOAN_ID, @FPC_ID, @ORIGINAL_PAYMENT_NO, @CURRENT_PAYMENT_NO, 
			@PMT_INCR_NO, @EARNED_PAYMENT_NO, @FPC_CANCELLATION_DT
		WHILE @@Fetch_Status = 0
		BEGIN
		
		   SET @NEW_PMT_INCR = 0 
		   
		   IF @EARNED_PAYMENT_NO > 0 AND @FPC_CANCELLATION_DT IS NOT NULL
			 SET @NEW_PMT_INCR = @EARNED_PAYMENT_NO
		   ELSE
			 SET @NEW_PMT_INCR = @PMT_INCR_NO
			 
		   IF @PREV_LOAN_ID <> @LOAN_ID
			 BEGIN
			   SET @PREV_LOAN_ID = @LOAN_ID
			   SET @FPCCNT = 1
			 END	
		   ELSE
			 SET @FPCCNT = @FPCCNT + 1
			 
		   IF (@FPCCNT = 1)
			 BEGIN
				UPDATE @tmpMULTICPI 
				SET CALC_NEW_PAYMENT_AMOUNT_NO = ORIGINAL_PAYMENT_NO + @NEW_PMT_INCR, CALC_CURRENT_PAYMENT_AMOUNT_NO = ORIGINAL_PAYMENT_NO
				WHERE LOAN_ID = @LOAN_ID AND FPC_ID = @FPC_ID
			 END
		   ELSE
			 BEGIN		          
				UPDATE TMP 
				SET CALC_NEW_PAYMENT_AMOUNT_NO =  		                      
					CASE WHEN isnull(T1.CALC_NEW_PAYMENT_AMOUNT_NO,0) = 0 
						THEN TMP.ORIGINAL_PAYMENT_NO +  @NEW_PMT_INCR		
						WHEN DATEDIFF (DAY , T1.FPC_EXPIRATION_DT , GETDATE()) > 0 AND T1.FPC_CANCELLATION_DT IS NULL  
						THEN TMP.ORIGINAL_PAYMENT_NO +  @NEW_PMT_INCR										  						  
						ELSE T1.CALC_NEW_PAYMENT_AMOUNT_NO + @NEW_PMT_INCR 
					END,
				CALC_CURRENT_PAYMENT_AMOUNT_NO = 
					CASE WHEN isnull(T1.CALC_NEW_PAYMENT_AMOUNT_NO,0) = 0 
						THEN TMP.ORIGINAL_PAYMENT_NO
						WHEN DATEDIFF (DAY , T1.FPC_EXPIRATION_DT , GETDATE()) > 0 AND T1.FPC_CANCELLATION_DT IS NULL 
						THEN TMP.ORIGINAL_PAYMENT_NO
						ELSE T1.CALC_NEW_PAYMENT_AMOUNT_NO 
					END 
				FROM @tmpMULTICPI TMP JOIN  @tmpMULTICPI T1 ON T1.LOAN_ID = TMP.LOAN_ID
				WHERE TMP.LOAN_ID = @LOAN_ID AND TMP.FPC_ID = @FPC_ID
				AND T1.LOAN_ID = @LOAN_ID AND TMP.FPC_NUMBER <> T1.FPC_NUMBER 
				AND T1.ISSUE_DT <= TMP.ISSUE_DT
			 END
			 
		   FETCH NEXT FROM PMTCUR INTO @LOAN_ID, @FPC_ID, @ORIGINAL_PAYMENT_NO, @CURRENT_PAYMENT_NO, 
				@PMT_INCR_NO, @EARNED_PAYMENT_NO, @FPC_CANCELLATION_DT
		END

	CLOSE PMTCUR
	DEALLOCATE PMTCUR	

	UPDATE #tmptable 
	SET CALC_CURRENT_PAYMENT_AMOUNT_NO = TM.CALC_CURRENT_PAYMENT_AMOUNT_NO, 
		CALC_NEW_PAYMENT_AMOUNT_NO = TM.CALC_NEW_PAYMENT_AMOUNT_NO 
	FROM #tmptable TT 
	JOIN @tmpMULTICPI TM ON TT.FPC_ID = TM.FPC_ID AND TT.LOAN_ID = TM.LOAN_ID
END

Set @sqlstring = N'Update #tmpTable Set [REPORT_GROUPBY_TX] = ' + @GroupBySQL
EXECUTE sp_executesql @sqlstring

Set @sqlstring = N'Update #tmpTable Set [REPORT_SORTBY_TX] = ' + @SortBySQL
EXECUTE sp_executesql @sqlstring

If isnull(@HeaderTx,'') <> '' 
Begin
	Set @sqlstring = N'Update #tmpTable Set [REPORT_HEADER_TX] = ' + @HeaderTx
	EXECUTE sp_executesql @sqlstring
End

If isnull(@FooterTx,'') <> '' 
Begin
	Set @sqlstring = N'Update #tmpTable Set [REPORT_FOOTER_TX] = ' + @FooterTx
	EXECUTE sp_executesql @sqlstring
End

IF @Report_History_ID IS NOT NULL
BEGIN
  SELECT @RecordCount = COUNT(*) from #tmptable
  
  Update [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML
  Set RECORD_COUNT_NO = @RecordCount
  where ID = @Report_History_ID
  
END

IF @RenderType = 'SPROC'
BEGIN
	 DECLARE @count as bigint
	 SELECT @count = COUNT (1) FROM #tmptable
	 IF (@count = 0) 
		BEGIN	
			DECLARE @string nvarchar(max);
			DECLARE @xml as XML;
			
			set @string = '<root><row/></root>';
			set @xml = CAST(@string as XML);
			
			SELECT @xml	
		END
	 ELSE
		SELECT * FROM #tmptable as row FOR XML AUTO, ROOT, ELEMENTS
END
ELSE
	SELECT * FROM #tmptable

END
GO