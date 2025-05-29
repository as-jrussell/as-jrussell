USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Report_EscrowNewCarrier]    Script Date: 8/30/2018 11:49:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_EscrowNewCarrier] 
--declare
  @LenderCode as nvarchar(10)=NULL,
 @Branch as nvarchar(max)=NULL,
 @Division as nvarchar(10)=NULL,
 @Coverage as nvarchar(100)=NULL,
 @ReportType as nvarchar(50)='NEWCARRIER',
 @GroupByCode as nvarchar(50)=NULL,
 @SortByCode as nvarchar(50)=NULL,
 @FilterByCode as nvarchar(50)=NULL,
 @ReportConfig as varchar(50)='0000',
 @ReportDomainName as varchar(30)='Report_EscrowNewCarrier',
 @Report_History_ID as bigint=NULL

 /* Escrow ChangeType; 1, 2, or 4 means to include Escrow data (0 means to EXCLUDE Escrow data) */
 /* Owner ChangeType; 1, 2, or 4 means to include Owner Policy data (0 means to EXCLUDE Owner Policy data) */
 ,@ChangeType_E As Int=4 --default to 4 means to require BOTH ESCROW_ID AND ESCROW_ID_PREV
 ,@ChangeType_O As Int=4 --default to 4 means to require BOTH OWNER_POL_ID AND OWNER_POL_ID_PREV

 /* Debug: 0 turns off debug-mode (the default); between 1 and 9999 means @LenderCode; >9999 means @Report_History_ID */
 ,@Debug As BigInt=0
as
BEGIN

	/* override @Debug (this is for debugging only...make sure that this is commented-out before checking-in): */
	--Set @Debug=7545 --Elmira
	--Set @Debug=3200 --TruStone
	--Set @Debug=2771 --PenFed
	--Set @Debug=8776263 --PenFed Report_History_ID
	--Set @Debug=8497300 --PenFed Report_History_ID
	--Set @Debug=2982 --Wintrust

  Select @Report_History_ID=CASE
	when @Report_History_ID is not null then @Report_History_ID
	when @debug>9999 then isnull(@Report_History_ID,@debug)
	else @Report_History_ID
   end

DECLARE @StartDate As datetime2 (7)
DECLARE @EndDate AS datetime2 (7)
Declare @LenderID as bigint
Declare @ProcessLogID as bigint=0

 /* reset defaults If @Debug: */
If @Debug>0
Begin
  Select
   @ReportType=N'NEWCARRIER'
--,@ReportConfig=N'0000'

--,@Branch=N''
--,@Coverage=N'HAZARD'
--,@Division=N'4'

  ,@FilterByCode='PolicyNumChgd'
--,@FilterBySQL='IsNull([STRIPPED_BORRINSCOMPANY_POLICY_NO], '''') <> IsNull([STRIPPEDPREV_BORRINSCOMPANY_POLICY_NO], '''')'
--,@GroupByCode=N'L/B/C-Esc'
  ,@SortByCode=N'BorrowerName'

--,@ChangeType_E=0
--,@ChangeType_O=0
  Where @Debug>0
End

if @Report_History_ID is not NULL
Begin
 SELECT @StartDate=REPORT_DATA_XML.value('(/ReportData[1]/Report[1]/StartDate/@value)[1]', 'Datetime2'),
   @EndDate=REPORT_DATA_XML.value('(/ReportData[1]/Report[1]/EndDate/@value)[1]', 'Datetime2'),
   @ProcessLogID=REPORT_DATA_XML.value('(/ReportData[1]/Report[1]/ProcessLogID/@value)[1]', 'bigint')
,@LenderCode=isnull(@LenderCode,REPORT_DATA_XML.value('(/ReportData/Report/Lender)[1]/@value', 'nvarchar(max)'))
,@Division=isnull(@Division,REPORT_DATA_XML.value('(/ReportData/Report/Division)[1]/@value', 'nvarchar(max)'))
,@ReportConfig=coalesce(@ReportConfig,REPORT_DATA_XML.value('(/ReportData/Report/ReportConfig)[1]/@value', 'varchar(50)'),'0000')
,@ChangeType_E=coalesce(@ChangeType_E,REPORT_DATA_XML.value('(/ReportData/Report/ChangeType_E)[1]/@value', 'int'),4)
,@ChangeType_O=coalesce(@ChangeType_O,REPORT_DATA_XML.value('(/ReportData/Report/ChangeType_O)[1]/@value', 'int'),4)
,@Debug=coalesce(@Debug,REPORT_DATA_XML.value('(/ReportData/Report/Debug)[1]/@value', 'bigint'),0)
 FROM REPORT_HISTORY WHERE ID = @Report_History_ID

 SET @StartDate = DATEADD(HH,0,@StartDate)   
 SET @EndDate = DATEADD(HH,0,@EndDate)    
End

Select @LenderCode=CASE
	WHEN @Debug between 1000 and 9999 THEN IsNull(@LenderCode,Cast(@Debug As NVarChar(10)))

	ELSE @LenderCode
END

	Set NoCount On
	Set Transaction Isolation Level Read Committed

If @Debug>1
Begin
	Set NoCount Off
	Set Transaction Isolation Level Read UnCommitted
End

SET @LenderCode = NullIf(@LenderCode, '')
SET @Branch = NullIf(NullIf(NullIf(@Branch, ''), '1'), 'ALL')
SET @Division = NullIf(NullIf(@Division, ''), '1')
SET @Coverage = NullIf(NullIf(@Coverage, ''), '1')
--DECLARE
-- @IsFiltered_Lender As Bit = CASE WHEN @LenderCode IS NOT NULL THEN 1 ELSE 0 END
--,@IsFiltered_Branch As Bit = CASE WHEN @Branch IS NOT NULL And @Branch <> '1' AND @Branch <> '' And @Branch <> 'ALL' THEN 1 ELSE 0 END
--,@IsFiltered_Division As Bit = CASE WHEN @Division IS NOT NULL And @Division <> '1' And @Division <> '' THEN 1 ELSE 0 END
--,@IsFiltered_Coverage As Bit = CASE WHEN @Coverage IS NOT NULL And @Coverage <> '1' THEN 1 ELSE 0 END

DECLARE @BranchTable AS TABLE(ID int, STRVALUE nvarchar(30))
IF @Branch Is NOT Null
BEGIN
   INSERT INTO @BranchTable SELECT * FROM SplitFunction(@Branch, ',') 
END

DECLARE @Rep_EscNewCar TABLE(
 [POP_MOST_RECENT_TXN_TYPE_CD] [nvarchar](4) NULL,
 [OP_MOST_RECENT_TXN_TYPE_CD] [nvarchar](4) NULL,
 [LOAN_BRANCHCODE_TX] [nvarchar](20) NULL,
 [LOAN_DIVISIONCODE_TX] [nvarchar](20) NULL,
 [LOAN_TYPE_TX] [nvarchar](1000) NULL,
 [REQUIREDCOVERAGE_CODE_TX] [nvarchar](30) NULL,
 [REQUIREDCOVERAGE_TYPE_TX] [nvarchar](1000) NULL,
 [CHANGE_TYPE_TX] [char] (1) NULL,
--LOAN
 [LOAN_NUMBER_TX] [nvarchar](18) NOT NULL,
 [LOAN_NUMBERSORT_TX] [nvarchar](36) NULL,
--LENDER
 [LENDER_CODE_TX] [nvarchar](10) NULL, 
 [LENDER_NAME_TX] [nvarchar](100) NULL, 
--OWNER
 [OWNER_LASTNAME_TX] [nvarchar](30) NULL,
 [OWNER_FIRSTNAME_TX] [nvarchar](30) NULL,
 [OWNER_MIDDLEINITIAL_TX] [char](1) NULL,
 [OWNER_NAME_TX] [nvarchar](100) NULL,
 [OWNER_LINE1_TX] [nvarchar](100) NULL,
 [OWNER_LINE2_TX] [nvarchar](100) NULL,
 [OWNER_CITY_TX] [nvarchar](40) NULL,
 [OWNER_STATE_TX] [nvarchar](30) NULL,
 [OWNER_ZIP_TX] [nvarchar](30) NULL,
--PROPERTY
 [COLLATERAL_LINE1_TX] [nvarchar](100) NULL,
 [COLLATERAL_LINE2_TX] [nvarchar](100) NULL,
 [COLLATERAL_CITY_TX] [nvarchar](40) NULL,
 [COLLATERAL_STATE_TX] [nvarchar](30) NULL,
 [COLLATERAL_ZIP_TX] [nvarchar](30) NULL,
--COVERAGE
 [COVERAGE_STATUS_TX] [nvarchar](1000) NULL,
--BORROWER INSURANCE
 [BORRINSCOMPANY_NAME_TX] [nvarchar](100) NULL,
 [STRIPPED_BORRINSCOMPANY_NAME_TX] [nvarchar](100) NULL,
 [BORRINSCOMPANY_POLICY_NO] [nvarchar](30) NULL,
 [STRIPPED_BORRINSCOMPANY_POLICY_NO] [nvarchar](30) NULL,
 [BORRINSCOMPANY_CREATE_DT] [datetime2] null,
 [BORRINSCOMPANY_EFF_DT] [datetime2](7) NULL,
 [BORRINSCOMPANY_EXP_DT] [datetime2](7) NULL,
--ESCROW
 [ESCROW_DUE_DT] [datetime2](7) NULL,
 [ESCROW_END_DT] [datetime2](7) NULL,
 [ESCROW_TOTAL_NO] [decimal](18, 2) NULL,
--IDs, STATUS
 [LOAN_ID] [bigint] NOT NULL,
 [COLLATERAL_ID] [bigint] NULL,
 [PROPERTY_ID] [bigint] NULL,
 [REQUIREDCOVERAGE_ID] [bigint] NULL,
 [LOAN_STATUSCODE] [nvarchar] (2) NULL,
 [LOAN_STATUSMEANING_TX] [nvarchar](1000) NULL,
 [COLLATERAL_STATUSCODE] [nvarchar] (2) NULL,
 [COLLATERAL_STATUSMEANING_TX] [nvarchar](1000) NULL,
 [REQUIREDCOVERAGE_STATUSCODE] [nvarchar] (2) NULL,
 [REQUIREDCOVERAGE_STATUSMEANING_TX] [nvarchar](1000) NULL,
 [REQUIREDCOVERAGE_SUBSTATUSCODE] [nvarchar] (2) NULL,
 [REQUIREDCOVERAGE_INSSTATUSCODE] [nvarchar] (4) NULL,
 [REQUIREDCOVERAGE_INSSTATUSMEANING_TX] [nvarchar](1000) NULL,
 [REQUIREDCOVERAGE_INSSUBSTATUSCODE] [nvarchar] (4) NULL,
 [REQUIREDCOVERAGE_INSSUBSTATUSMEANING_TX] [nvarchar](1000) NULL,
--PREVIOUS BORROWER INSURANCE
 [PREV_BORRINSCOMPANY_NAME_TX] [nvarchar](100) NULL,
 [STRIPPEDPREV_BORRINSCOMPANY_NAME_TX] [nvarchar](100) NULL,
 [PREV_BORRINSCOMPANY_POLICY_NO] [nvarchar](30) NULL,
 [STRIPPEDPREV_BORRINSCOMPANY_POLICY_NO] [nvarchar](30) NULL,
 [PREV_BORRINSCOMPANY_CREATE_DT] [datetime2](7) NULL,
 [PREV_BORRINSCOMPANY_EFF_DT] [datetime2](7) NULL,
 [PREV_BORRINSCOMPANY_EXP_DT] [datetime2](7) NULL,
 [PREV_ESCROW_TOTAL_NO] [decimal](18, 2) NULL,
-- PARAMETERS
 [REPORT_GROUPBY_TX] [nvarchar](1000) NULL,
 [REPORT_SORTBY_TX] [nvarchar](1000) NULL,
 [POL_CREATED_SORT_TX] [nvarchar](8) NULL,
 [REPORT_HEADER_TX] [nvarchar](1000) NULL,
 [REPORT_FOOTER_TX] [nvarchar](1000) NULL

--Additional ID:
 ,[ESCROW_ID] [bigint] NULL
 ,[ESCROW_ID_PREV] [bigint] NULL
 ,[OWNER_POL_ID] [bigint] NULL
 ,[OWNER_POL_ID_PREV] [bigint] NULL
 ,[OWNER_ID] [bigint] NULL
 ,[REQ_COV_ID] [bigint] NULL
 ,[REQ_COV_ID_PREV] [bigint] NULL
 ,[PLI_ID] [bigint] NULL --ProcessLogItem
 ,[PL_ID] [bigint] NULL --ProcessLog
 ,[PD_ID] [bigint] NULL --ProcessDefinition
)

Select @LenderID=IsNull(@LenderID,ID) from LENDER where CODE_TX = @LenderCode and PURGE_DT is null

If @debug>1
Begin
 Print '@LenderCode'
 Print @LenderCode
 Print '@LenderID'
 Print @LenderID
 Print '@Report_History_ID'
 Print @Report_History_ID
 Print '@ChangeType_E'
 Print @ChangeType_E
 Print '@ChangeType_O'
 Print @ChangeType_O
End

Declare @FilterBySQL as varchar(1000)

Declare @GroupBySQL as varchar(1000)
Declare @SortBySQL as varchar(1000)
Declare @HeaderTx as varchar(1000)
Declare @FooterTx as varchar(1000)
Declare @FillerZero as varchar(18)
Declare @RecordCount as bigint

Set @FillerZero = '000000000000000000'
Set @RecordCount = 0

SELECT
 @GroupByCode = CASE WHEN @GroupByCode = '' THEN NULL ELSE @GroupByCode END
,@SortByCode = CASE WHEN @SortByCode = '' THEN NULL ELSE @SortByCode END
,@FilterByCode = CASE WHEN @FilterByCode = '' THEN NULL ELSE @FilterByCode END

SELECT
 @GroupBySQL = CASE WHEN @GroupByCode IS NULL THEN GROUP_TX ELSE @GroupBySQL END
,@SortBySQL = CASE WHEN @SortByCode IS NULL THEN SORT_TX ELSE @SortBySQL END
,@FilterBySQL = CASE WHEN @FilterByCode IS NULL THEN FILTER_TX ELSE @FilterBySQL END
,@HeaderTx = HEADER_TX
,@FooterTx = FOOTER_TX
FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig

IF @GroupBySQL IS NULL
 SELECT @GroupBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_GroupBy' AND CODE_CD = @GroupByCode

IF @SortBySQL IS NULL
 SELECT @SortBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_SortBy' AND CODE_CD = @SortByCode

IF @FilterBySQL IS NULL
 SELECT @FilterBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_FilterBy' AND CODE_CD = @FilterByCode

IF @Debug>0 AND NullIf(@SortBySQL, '') IS NULL
BEGIN
 SET @SortBySQL = 'CHANGE_TYPE_TX, OWNER_NAME_TX, LOAN_TYPE_TX, REQUIREDCOVERAGE_CODE_TX, Cast(BORRINSCOMPANY_EFF_DT As Date), Cast(BORRINSCOMPANY_EXP_DT As Date), LENDER_NAME_TX, LOAN_DIVISIONCODE_TX, LOAN_BRANCHCODE_TX, LOAN_NUMBERSORT_TX'

	Print '@SortBySQL'
	Print @SortBySQL
	Print '@FilterBySQL'
	Print @FilterBySQL
END

 /* flags for Eval_Here; 1 means that DynamicSQL will be used (in order to evaluate in SQL): */
 Declare
 /* Eval. flags; whether or not to evaluate these @var here (in SQL): */
  @EvalFilterHere As Bit = 1 -- for @FilterBySQL
 ,@EvalSortHere As Bit = 1 -- for @SortBySQL
 ,@EvalGroupHere As Bit = 1 -- for @GroupBySQL
 ,@EvalHeadHere As Bit = 1 -- for @HeaderTx
 ,@EvalFootHere As Bit = 1 -- for @FooterTx

/* REF_CODE DOMAIN constants: */
Declare @REF_DOM_SECOND_CLASS NVarChar(30) = 'SecondaryClassification'
Declare @REF_DOM_NOTICE_TYPE NVarChar(30) = 'NoticeType'
Declare @REF_DOM_LOAN_STAT NVarChar(30) = 'LoanStatus'
Declare @REF_DOM_COLLAT_STAT NVarChar(30) = 'CollateralStatus'
Declare @REF_DOM_RCOV_STAT NVarChar(30) = 'RequiredCoverageStatus'
Declare @REF_DOM_RCOV_INS_STAT NVarChar(30) = 'RequiredCoverageInsStatus'
Declare @REF_DOM_RCOV_INS_SUB_STAT NVarChar(30) = 'RequiredCoverageInsSubStatus'
Declare @REF_DOM_CONTRACT_TYPE NVarChar(30) = 'ContractType'
Declare @REF_DOM_COV NVarChar(30) = 'Coverage'

/* Escrow:
*/
;WITH
 LENDER_CTE As
(
 Select Ldr.* From dbo.LENDER As Ldr
 Where (Ldr.ID = @LenderID OR @LenderID Is Null)
   And Ldr.PURGE_DT Is Null   
)
,LOAN_CTE As
(
 Select L.* From dbo.LOAN As L
 Where (L.LENDER_ID = @LenderID OR @LenderID Is Null)
   And L.PURGE_DT Is Null
   And L.RECORD_TYPE_CD = 'G'
   And L.STATUS_CD != 'U'
   And L.EXTRACT_UNMATCH_COUNT_NO = 0
 --during testing, filtering on Branch seemed to slow down performance significantly
   --And (@Branch = '1' OR @Branch = '' OR @Branch Is Null OR L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM @BranchTable))
)
,COLLATERAL_CTE As
(
 Select Col.* From dbo.COLLATERAL As Col
 Where Col.PURGE_DT Is Null
   And Col.STATUS_CD != 'U'
   And Col.EXTRACT_UNMATCH_COUNT_NO = 0
   And Col.PRIMARY_LOAN_IN = 'Y'
)
,PROPERTY_CTE As
(
 Select Prop.ID, Prop.LENDER_ID, Prop.RECORD_TYPE_CD, Prop.ADDRESS_ID, Prop.PURGE_DT
 From dbo.PROPERTY As Prop
 Where (Prop.LENDER_ID = @LenderID OR @LenderID Is Null)
   And Prop.PURGE_DT Is Null
   And Prop.RECORD_TYPE_CD = 'G'
)
,REQ_COV_CTE As
(
 Select
  RC.ID
 ,REQ_ESC_ID=RE.ID
 ,RC.PURGE_DT
 ,RC.PROPERTY_ID
 ,RC.RECORD_TYPE_CD
 ,RC.ESCROW_IN
 ,RC.TYPE_CD
 ,RC.NOTICE_TYPE_CD
 ,RC.STATUS_CD
 ,RC.SUB_STATUS_CD
 ,RC.SUMMARY_STATUS_CD
 ,RC.SUMMARY_SUB_STATUS_CD
 ,RC.NOTICE_DT
 ,RC.NOTICE_SEQ_NO
 From dbo.REQUIRED_COVERAGE As RC
 Left Join dbo.REQUIRED_ESCROW RE On RE.REQUIRED_COVERAGE_ID = RC.ID And RE.PURGE_DT IS NULL And RE.ACTIVE_IN = 'Y'
 Where RC.PURGE_DT Is Null And RC.ESCROW_IN = 'Y'
   And RC.RECORD_TYPE_CD = 'G'
   And (RC.TYPE_CD = @Coverage OR @Coverage = '1' OR @Coverage Is Null)
)
,PROP_REQCOV_CTE As
(
 Select P_ID = Prop.ID, Prop.LENDER_ID, Prop.RECORD_TYPE_CD, Prop.ADDRESS_ID, Prop.PURGE_DT
 ,RC_ID = RC.ID
 --,RC.PURGE_DT
 ,RC.PROPERTY_ID
 --,RC.RECORD_TYPE_CD
 ,RC.ESCROW_IN
 ,RC.TYPE_CD
 ,RC.NOTICE_TYPE_CD
 ,RC.STATUS_CD
 ,RC.SUB_STATUS_CD
 ,RC.SUMMARY_STATUS_CD
 ,RC.SUMMARY_SUB_STATUS_CD
 ,RC.NOTICE_DT
 ,RC.NOTICE_SEQ_NO
 ,RC_STATUS_CD = RC.STATUS_CD
 ,RC_SUMMARY_STATUS_CD = RC.SUMMARY_STATUS_CD
 ,RC_SUMMARY_SUB_STATUS_CD = RC.SUMMARY_SUB_STATUS_CD
 From dbo.PROPERTY As Prop
 Join dbo.REQUIRED_COVERAGE As RC
 On RC.PROPERTY_ID = Prop.ID
 Where (Prop.LENDER_ID = @LenderID OR @LenderID Is Null)
   And Prop.PURGE_DT Is Null
   And Prop.RECORD_TYPE_CD = 'G'
   And RC.PURGE_DT Is Null
   And RC.RECORD_TYPE_CD = 'G'
   And (RC.TYPE_CD = @Coverage OR @Coverage = '1' OR @Coverage Is Null)
)
,REF_CODE_CTE As
(
 Select DOMAIN_CD, CODE_CD, MEANING_TX, DESCRIPTION_TX
 From dbo.REF_CODE
 Where (0=1
 OR DOMAIN_CD = (@REF_DOM_SECOND_CLASS)
 OR DOMAIN_CD = (@REF_DOM_NOTICE_TYPE)
 OR DOMAIN_CD = (@REF_DOM_LOAN_STAT)
 OR DOMAIN_CD = (@REF_DOM_COLLAT_STAT)
 OR DOMAIN_CD = (@REF_DOM_RCOV_STAT)
 OR DOMAIN_CD = (@REF_DOM_RCOV_INS_STAT)
 OR DOMAIN_CD = (@REF_DOM_RCOV_INS_SUB_STAT)
 OR DOMAIN_CD = (@REF_DOM_CONTRACT_TYPE)
 OR DOMAIN_CD = (@REF_DOM_COV)
 )
)
/*
--using PROP_COV_ESC_CTE should theoretically speed up performance
--but using it actually slows it down
*/
,PROP_COV_ESC_CTE As
(
 Select Top 100 Percent
  ESC.*
 ,RC_ID = RC.ID
 ,ERCR.REQUIRED_COVERAGE_ID
 ,P_ADDRESS_ID = Prop.ADDRESS_ID
 ,RC_TYPE_CD = RC.TYPE_CD
 ,RC_NOTICE_TYPE_CD = RC.NOTICE_TYPE_CD
 ,RC_STATUS_CD = RC.STATUS_CD
 ,RC_SUB_STATUS_CD = RC.SUB_STATUS_CD
 ,RC_SUMMARY_STATUS_CD = RC.SUMMARY_STATUS_CD
 ,RC_SUMMARY_SUB_STATUS_CD = RC.SUMMARY_SUB_STATUS_CD
 ,RC_NOTICE_DT = RC.NOTICE_DT
 ,RC_NOTICE_SEQ_NO = RC.NOTICE_SEQ_NO
 From PROPERTY_CTE As Prop
 Join REQ_COV_CTE As RC
   On RC.PROPERTY_ID = Prop.ID
  And RC.PURGE_DT Is Null And RC.RECORD_TYPE_CD = 'G'
 Join dbo.ESCROW_REQUIRED_COVERAGE_RELATE As ERCR On ERCR.REQUIRED_COVERAGE_ID = RC.ID
  And ERCR.PURGE_DT Is Null
 Join dbo.ESCROW As ESC On ESC.ID = ERCR.ESCROW_ID
  And ESC.PURGE_DT Is Null
 Where (Prop.LENDER_ID = @LenderID OR @LenderID Is Null)
   And Prop.PURGE_DT Is Null
   And Prop.RECORD_TYPE_CD = 'G'
   And RC.PURGE_DT Is Null
   And RC.RECORD_TYPE_CD = 'G'
   And (RC.TYPE_CD = @Coverage OR @Coverage = '1' OR @Coverage Is Null)
   And ERCR.PURGE_DT Is Null
   And ESC.PURGE_DT Is Null
   --And (@EndDate Is Null OR ESC.ID Is Null OR (ESC.CREATE_DT >= @StartDate And ESC.CREATE_DT < @EndDate))
  Order By
   Prop.ID, RC.ID
  ,ISNULL(ESC.END_DT, DATEADD(month, 12 , ESC.DUE_DT)) Desc
)
,OWNER_LOAN_CTE As
(
 Select OL.OWNER_ID, OL.LOAN_ID
 ,OL.PRIMARY_IN
 ,OL.PURGE_DT
 From dbo.OWNER_LOAN_RELATE As OL WITH(NOLOCK)
 Where OL.PRIMARY_IN = 'Y' AND OL.PURGE_DT IS NULL
)
,MAIN_QUERY As
(
  Select
	POP_MOST_RECENT_TXN_TYPE_CD='',
	OP_MOST_RECENT_TXN_TYPE_CD='',
    CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '' then 'No Branch' else L.BRANCH_CODE_TX END as [LOAN_BRANCHCODE_TX],
    CASE WHEN ISNULL(L.DIVISION_CODE_TX,'') = '' THEN '0' ELSE L.DIVISION_CODE_TX END AS [LOAN_DIVISIONCODE_TX],
     ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) AS [LOAN_TYPE_TX],
     RC.TYPE_CD as [REQUIREDCOVERAGE_CODE_TX], 
     RC_COVERAGETYPE.MEANING_TX as [REQUIREDCOVERAGE_TYPE_TX], 
     'E' as [CHANGE_TYPE_TX],
 --LOAN
     L.NUMBER_TX as [LOAN_NUMBER_TX], 
     SUBSTRING(@FillerZero, 1, 18 - len(L.NUMBER_TX)) + CAST(L.NUMBER_TX AS nvarchar(18)) AS [LOAN_NUMBERSORT_TX],
 --LENDER
     LND.CODE_TX as [LENDER_CODE_TX], 
     LND.NAME_TX as [LENDER_NAME_TX]
 --OWNER
     ,OWNER_LASTNAME_TX = NULL
     ,OWNER_FIRSTNAME_TX = NULL
     ,OWNER_MIDDLEINITIAL_TX = NULL
     ,OWNER_NAME_TX = NULL
     --CASE WHEN O.FIRST_NAME_TX IS NULL THEN O.LAST_NAME_TX ELSE RTRIM(O.LAST_NAME_TX + ', ' + ISNULL(O.FIRST_NAME_TX,'') + ' ' + ISNULL(O.MIDDLE_INITIAL_TX,'')) END
     ,OWNER_LINE1_TX = NULL
     ,OWNER_LINE2_TX = NULL
     ,OWNER_CITY_TX = NULL
     ,OWNER_STATE_TX = NULL
     ,OWNER_ZIP_TX = NULL
 --PROPERTY (AM)
     ,COLLATERAL_LINE1_TX = NULL
     ,COLLATERAL_LINE2_TX = NULL
     ,COLLATERAL_CITY_TX = NULL
     ,COLLATERAL_STATE_TX = NULL
     ,COLLATERAL_ZIP_TX = NULL
     , 
 --COVERAGE
     CASE 
    WHEN RC.NOTICE_DT is not null and RC.NOTICE_SEQ_NO > 0 THEN cast(RC.NOTICE_SEQ_NO as char(1)) +  ' ' + NRef.MEANING_TX + ' ' + CONVERT(nvarchar(10), RC.NOTICE_DT, 101) 
     ELSE CASE 
   WHEN L.STATUS_CD in ('N','O','P') THEN LSRef.MEANING_TX
   WHEN C.STATUS_CD in ('R','S','X') THEN CSRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')  THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N') THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')    THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')   THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD not in ('A','D','T')          THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')        THEN CSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')       THEN CSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')          THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')         THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD not in ('A','D','T')               THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')        THEN RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')       THEN RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')          THEN RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')         THEN RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD not in ('A','D','T')               THEN RCSRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')        THEN LSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')       THEN LSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')          THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')         THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD not in ('A','D','T')               THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
     END
     END as [COVERAGE_STATUS_TX],
 --BORROWER INSURANCE
     [BORRINSCOMPANY_NAME_TX] = BIC.NAME,
     [STRIPPED_BORRINSCOMPANY_NAME_TX] = STRIPPED2_BORRINSCOMPANY.NAME1_TX,
     [BORRINSCOMPANY_POLICY_NO] = ES.POLICY_NUMBER_TX,
     [STRIPPED_BORRINSCOMPANY_POLICY_NO] = STRIPPED_BORRINSCOMPANY.POLICY_NO,
	 ES.CREATE_DT as [BORRINSCOMPANY_CREATE_DT],
	 CONVERT(nvarchar(8), ES.CREATE_DT, 112) as [POL_CREATED_SORT_TX],
     ES.DUE_DT as [BORRINSCOMPANY_EFF_DT],	 
     Case 
    when year(ES.END_DT) = '9999' then NULL
    else ES.END_DT
     End as [BORRINSCOMPANY_EXP_DT],  
 --ESCROW
   ES.DUE_DT as [ESCROW_DUE_DT], 
   ES.END_DT as [ESCROW_END_DT],
   ES.TOTAL_AMOUNT_NO as [ESCROW_TOTAL_NO],
 --IDs, STATUS
     L.ID as [LOAN_ID], 
     C.ID as [COLLATERAL_ID], 
     P.ID as [PROPERTY_ID], 
     RC.ID as [REQUIREDCOVERAGE_ID], 
     L.STATUS_CD as [LOAN_STATUSCODE], 
     LSRef.MEANING_TX as [LOAN_STATUSMEANING_TX], 
     C.STATUS_CD as [COLLATERAL_STATUSCODE], 
     CSRef.MEANING_TX as [COLLATERAL_STATUSMEANING_TX],
     RC.STATUS_CD as [REQUIREDCOVERAGE_STATUSCODE],
     RCSRef.MEANING_TX as [REQUIREDCOVERAGE_STATUSMEANING_TX],
     RC.SUB_STATUS_CD as [REQUIREDCOVERAGE_SUBSTATUSCODE],
     RC.SUMMARY_STATUS_CD as [REQUIREDCOVERAGE_INSSTATUSCODE],
     ISNULL(RCISRef.MEANING_TX, 'NOTAVAIL') as [REQUIREDCOVERAGE_INSSTATUSMEANING_TX],
     RC.SUMMARY_SUB_STATUS_CD as [REQUIREDCOVERAGE_INSSUBSTATUSCODE], 
     RCISSRef.MEANING_TX as [REQUIREDCOVERAGE_INSSUBSTATUSMEANING_TX],
    
 --Previous BORROWER INSURANCE
     [PREV_BORRINSCOMPANY_NAME_TX] = BICP.NAME,
     [STRIPPEDPREV_BORRINSCOMPANY_NAME_TX] = STRIPPEDPREV2_BORRINSCOMPANY.NAME1_TX,
     [PREV_BORRINSCOMPANY_POLICY_NO] = PES.POLICY_NUMBER_TX,
     [STRIPPEDPREV_BORRINSCOMPANY_POLICY_NO] = STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO,
	 PES.CREATE_DT as [PREV_BORRINSCOMPANY_CREATE_DT],
     PES.DUE_DT as [PREV_BORRINSCOMPANY_EFF_DT], 
     Case 
    when year(PES.END_DT) = '9999' then NULL
    else PES.END_DT
     End as [PREV_BORRINSCOMPANY_EXP_DT],
     PES.TOTAL_AMOUNT_NO as [PREV_ESCROW_TOTAL_NO]               

 --Additional ID:
     ,ESCROW_ID = ES.ID
     ,ESCROW_ID_PREV = PES.ID
     ,OWNER_POL_ID = NULL
     ,OWNER_POL_ID_PREV = NULL
     ,OWNER_ID = OL.OWNER_ID
     ,REQ_COV_ID = RC.ID
     ,REQ_COV_ID_PREV = PES.PRIOR_RC_ID
	 ,PLI_ID = PL.PLI_ID
	 ,PL_ID = PL.PL_ID
	 ,PD_ID = PL.PD_ID

From LENDER_CTE LND WITH(NOLOCK)
 Join LOAN_CTE L WITH(NOLOCK) on LND.ID = L.LENDER_ID AND L.PURGE_DT IS NULL
 Join COLLATERAL_CTE C WITH(NOLOCK) on L.ID = C.LOAN_ID AND C.PRIMARY_LOAN_IN = 'Y' AND C.PURGE_DT IS NULL

 LEFT JOIN dbo.COLLATERAL_CODE CC WITH(NOLOCK) ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL

 left Join REF_CODE_CTE RC_SC WITH(NOLOCK) on RC_SC.DOMAIN_CD = (@REF_DOM_SECOND_CLASS) AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
 left Join dbo.REF_CODE_ATTRIBUTE RCA_PROP WITH(NOLOCK) on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
 
 Join PROPERTY_CTE P WITH(NOLOCK) on C.PROPERTY_ID = P.ID AND L.LENDER_ID = P.LENDER_ID
 Join REQ_COV_CTE RC WITH(NOLOCK) ON RC.PROPERTY_ID = P.ID AND RC.PURGE_DT IS NULL and RC.ESCROW_IN = 'Y'
 JOIN dbo.REQUIRED_ESCROW RE WITH(NOLOCK) ON RE.REQUIRED_COVERAGE_ID = RC.ID AND RE.PURGE_DT IS NULL AND RE.ACTIVE_IN = 'Y'

 --CURRENT ESCROW:
 --JOIN ESCROW_REQUIRED_COVERAGE_RELATE ERCR WITH(NOLOCK) ON ERCR.REQUIRED_COVERAGE_ID = RC.ID AND ERCR.PURGE_DT IS NULL
 --LEFT JOIN ESCROW ES WITH(NOLOCK) ON ERCR.ESCROW_ID = ES.ID AND ES.PURGE_DT IS NULL
 CROSS Apply(
  Select
  Top 1 /*00 Percent*/ -- use 100 Percent ONLY if we would want the report to show EVERY HISTORICAL escrow (along with a "CHAIN" of PRIOR escrows [gotten below]) instead of just "THE CURRENT" escrow (along with JUST ITS PRIOR escrow)
   ES.*
  ,ERCR.REQUIRED_COVERAGE_ID
  ,EFFECTIVE_MON = DatePart(Month, ES.EFFECTIVE_DT)
  ,EFFECTIVE_DAY = DatePart(Day, ES.EFFECTIVE_DT)
  ,END_MON = DatePart(Month, ES.END_DT)
  ,END_DAY = DatePart(Day, ES.END_DT)
  From REQ_COV_CTE As CURR_RC
  Join dbo.ESCROW_REQUIRED_COVERAGE_RELATE As ERCR
    On CURR_RC.ID = ERCR.REQUIRED_COVERAGE_ID
  Join dbo.ESCROW As ES
    On ERCR.ESCROW_ID = ES.ID
  Where CURR_RC.PROPERTY_ID = P.ID
    And CURR_RC.PURGE_DT IS NULL
    And ES.PURGE_DT IS NULL
    And ERCR.PURGE_DT IS NULL

----------------------------------------------------------------------------------------------------------
       --And (ES.STATUS_CD <> 'CLSE' OR ES.SUB_STATUS_CD NOT In ('RPTD' , 'LNDRPAID', 'INHSPAID' , 'BWRPAID'))
       And (ES.STATUS_CD <> 'CLSE' OR ES.SUB_STATUS_CD NOT In ('RPTD' , 'LNDRPAID', 'INHSPAID' , 'BWRPAID', 'QCREJ', 'DUPLICATE') /*e.g. 'INWI'*/)
----------------------------------------------------------------------------------------------------------

	And CURR_RC.TYPE_CD = RC.TYPE_CD
  Order By
   Case When CURR_RC.ID = RC.ID Then 1 Else 2 End
  ,IsNull(ES.END_DT, DATEADD(month, 12 , ES.DUE_DT)) Desc
  ,ES.DUE_DT Desc
  ,ES.ID Desc
  ) As ES
 /* the query below is pretty similar to the query above,
 ** except that it uses PROP_COV_ESC_CTE instead of ESCROW Join ESCROW_REQUIRED_COVERAGE_RELATE
 ** although this should NOT really make much difference, it actually SLOWS it down
 */
 --CROSS APPLY
 --(Select Top 1
 -- ES.*
 -- From PROP_COV_ESC_CTE As ES WITH(NOLOCK)
 -- Where ES.PROPERTY_ID = C.PROPERTY_ID And ES.RC_ID = RC.ID
 --   And (ES.STATUS_CD <> 'CLSE' OR ES.SUB_STATUS_CD NOT In ('RPTD' , 'LNDRPAID', 'INHSPAID' , 'BWRPAID'))
 --) As ES

 --PRIOR ESCROW
 --CROSS APPLY
 --(select Top 1  esc.ID as ID , esc.END_DT , esc.DUE_DT , esc.TOTAL_AMOUNT_NO , esc.BIC_ID, ESC.REMITTANCE_ADDR_ID, ESC.POLICY_NUMBER_TX
 --    from REQUIRED_COVERAGE rc1 WITH(NOLOCK) join ESCROW_REQUIRED_COVERAGE_RELATE escrel WITH(NOLOCK)
 --    on escrel.REQUIRED_COVERAGE_ID = RC.ID 
 --    join ESCROW esc WITH(NOLOCK) on esc.ID = escrel.ESCROW_ID 
 --    where (rc1.ID = rc.ID)
 --    and esc.PURGE_DT is null and escrel.PURGE_DT is null
 --    and (esc.STATUS_CD = 'CLSE' and esc.SUB_STATUS_CD in ('RPTD' , 'LNDRPAID', 'INHSPAID' , 'BWRPAID' ))
 --    and (es.ID Is Null OR (
 --    esc.TYPE_CD = ES.TYPE_CD and
 --    esc.SUB_TYPE_CD = ES.SUB_TYPE_CD and esc.EXCESS_IN = ES.EXCESS_IN and
 --    ISNULL(esc.END_DT, DATEADD(month, 12 , esc.DUE_DT)) < ES.END_DT
 --    ))
 --    order by Case when rc1.TYPE_CD = 'HAZARD' Then 0 else 1 end asc ,
 --   ISNULL(esc.END_DT, DATEADD(month, 12 , esc.DUE_DT)) desc 
 --) AS PES
 /* the query below is essentially similar to the query above,
 ** except that RC1 is called PRIOR_RC; it also returns some PRIOR_RC fields
 ** and they way that PRIOR_RC is used is a little different
 */
 CROSS Apply(
 Select Top 1
  ESP.ID, ESP.CREATE_DT, ESP.EFFECTIVE_DT, ESP.END_DT, ESP.DUE_DT, ESP.TOTAL_AMOUNT_NO, ESP.BIC_ID, ESP.REMITTANCE_ADDR_ID, ESP.POLICY_NUMBER_TX
 ,PRIOR_RC_ID = PRIOR_RC.ID
 ,PRIOR_RC.NOTICE_TYPE_CD
 ,PRIOR_RC.SUMMARY_STATUS_CD
 ,PRIOR_RC.SUMMARY_SUB_STATUS_CD
 ,EFFECTIVE_MON = DatePart(Month, ESP.EFFECTIVE_DT)
 ,EFFECTIVE_DAY = DatePart(Day, ESP.EFFECTIVE_DT)
 ,END_MON = DatePart(Month, ESP.END_DT)
 ,END_DAY = DatePart(Day, ESP.END_DT)
  From REQ_COV_CTE As PRIOR_RC
  Join dbo.ESCROW_REQUIRED_COVERAGE_RELATE As ERCR
    On PRIOR_RC.ID = ERCR.REQUIRED_COVERAGE_ID
  Join dbo.ESCROW As ESP
    On ERCR.ESCROW_ID = ESP.ID
  Where PRIOR_RC.PROPERTY_ID = P.ID
    And PRIOR_RC.PURGE_DT IS NULL
    And ESP.PURGE_DT IS NULL
    And ERCR.PURGE_DT IS NULL
       And (ESP.STATUS_CD = 'CLSE' AND ESP.SUB_STATUS_CD In ('RPTD' , 'LNDRPAID', 'INHSPAID' , 'BWRPAID'))
    And (ES.ID Is Null OR (
         ESP.TYPE_CD = ES.TYPE_CD AND
         ESP.SUB_TYPE_CD = ES.SUB_TYPE_CD AND
   ESP.EXCESS_IN = ES.EXCESS_IN AND
         ((/*ESP.END_DT Is NOT Null And*/ ESP.END_DT < ES.END_DT) OR (/*ESP.DUE_DT Is NOT Null And*/ ESP.DUE_DT < ES.DUE_DT))
        ))
	And PRIOR_RC.TYPE_CD = RC.TYPE_CD
  Order By
   Case When PRIOR_RC.ID = RC.ID Then 1 Else 2 End
  ,ISNULL(ESP.END_DT, DATEADD(month, 12 , ESP.DUE_DT)) Desc
  ,ESP.DUE_DT Desc
  ,ESP.ID Desc
  ) As PES
 /* the query below is similar to the query above,
 ** except that it uses PROP_COV_ESC_CTE instead of ESCROW Join ESCROW_REQUIRED_COVERAGE_RELATE
 ** although this should NOT really make much difference, it actually SLOWS it down
 */
 --CROSS APPLY
 --(Select Top 1
 -- ESP.ID, ESP.END_DT, ESP.DUE_DT, ESP.TOTAL_AMOUNT_NO, ESP.BIC_ID, ESP.REMITTANCE_ADDR_ID, ESP.POLICY_NUMBER_TX
 -- From PROP_COV_ESC_CTE As ESP WITH(NOLOCK)
    -- Where ES.PROPERTY_ID = C.PROPERTY_ID And ES.RC_ID = RC.ID And (ESP.STATUS_CD = 'CLSE' AND ESP.SUB_STATUS_CD In ('RPTD' , 'LNDRPAID', 'INHSPAID' , 'BWRPAID'))
 --   And (ES.ID Is Null OR (
 --        ESP.TYPE_CD = ES.TYPE_CD AND
 --        ESP.SUB_TYPE_CD = ES.SUB_TYPE_CD AND
 --    ESP.EXCESS_IN = ES.EXCESS_IN AND
 --        ISNULL(ESP.END_DT, DATEADD(month, 12 , ESP.DUE_DT)) < ISNULL(ES.END_DT, DATEADD(month, 12 , ES.DUE_DT))
 --       ))
 -- Order By
 --  Case When RC.TYPE_CD = 'HAZARD' Then 0 Else 1 End
 -- ,ISNULL(ES.END_DT, DATEADD(month, 12 , ES.DUE_DT)) Desc) As PES
  
 /*
 --the purpose of this, combined with its relevant part of the WHERE clause below, is to
 --filter out any ClosedEsc that are dated MORE RECENTLY than ES
 */
 OUTER Apply(
 Select Top 1 
 ES.*
,ERCR.REQUIRED_COVERAGE_ID
From REQ_COV_CTE As CURR_RC
Join dbo.ESCROW_REQUIRED_COVERAGE_RELATE As ERCR
  On CURR_RC.ID = ERCR.REQUIRED_COVERAGE_ID
Join dbo.ESCROW As ES
  On ERCR.ESCROW_ID = ES.ID
Where CURR_RC.PROPERTY_ID = P.ID
  And CURR_RC.PURGE_DT IS NULL
  And ES.PURGE_DT IS NULL
  And ERCR.PURGE_DT IS NULL
     And (ES.STATUS_CD = 'CLSE' AND ES.SUB_STATUS_CD  In ('RPTD' , 'LNDRPAID', 'INHSPAID' , 'BWRPAID'))
    And CURR_RC.TYPE_CD = RC.TYPE_CD
    AND ES.TYPE_CD = ES.TYPE_CD 
  AND ES.SUB_TYPE_CD = ES.SUB_TYPE_CD 
    AND   ES.EXCESS_IN = ES.EXCESS_IN
Order By
 Case When CURR_RC.ID = RC.ID Then 1 Else 2 End
,IsNull(ES.END_DT, DATEADD(month, 12 , ES.DUE_DT)) Desc) As CLOSEDESC

 left Join dbo.BORROWER_INSURANCE_COMPANY BIC WITH(NOLOCK) on BIC.ID = ES.BIC_ID AND BIC.PURGE_DT IS NULL And BIC.ACTIVE_IN = 'Y'
 left Join dbo.BORROWER_INSURANCE_COMPANY BICP WITH(NOLOCK) on BICP.ID = PES.BIC_ID --AND BICP.PURGE_DT IS NULL

 CROSS APPLY (SELECT
	 POLICY_NO = Substring(IsNull(
		 --CASE When @Debug>0 THEN
		  --ES.POLICY_NUMBER_TX Else
		  dbo.fn_NormalizePolicyNumber(ES.POLICY_NUMBER_TX,'Y')
		 --END
		 , ''), 1, 6)
	,NAME_TX = UPPER(RTrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Lower(BIC.NAME),'-',''),'.',''),' ins ',' '),'insurance',''),' comp ',' '),' co ',' '),'company','')))
	 ) AS [STRIPPED_BORRINSCOMPANY]
 CROSS APPLY (SELECT
	 POLICY_NO = Substring(IsNull(
		 --CASE When @Debug>0 THEN
		  --PES.POLICY_NUMBER_TX Else
		  dbo.fn_NormalizePolicyNumber(PES.POLICY_NUMBER_TX,'Y')
		 --END
		 , ''), 1, 6)
	,NAME_TX = UPPER(RTrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Lower(BICP.NAME),'-',''),'.',''),' ins ',' '),'insurance',''),' comp ',' '),' co ',' '),'company','')))
	 ) AS [STRIPPEDPREV_BORRINSCOMPANY]
--
--take just the 1st "word" (that EndsWith a NON-letter):
 CROSS APPLY (SELECT
	 NAME1_TX = Substring([STRIPPED_BORRINSCOMPANY].NAME_TX, 1, IsNull(NullIf(PatIndex('%[^A-Z]%', [STRIPPED_BORRINSCOMPANY].NAME_TX), 0), Len([STRIPPED_BORRINSCOMPANY].NAME_TX) + 1) - 1)
	 ) AS [STRIPPED2_BORRINSCOMPANY]
--take just the 1st "word" (that EndsWith a NON-letter):
 CROSS APPLY (SELECT
	 NAME1_TX = Substring([STRIPPEDPREV_BORRINSCOMPANY].NAME_TX, 1, IsNull(NullIf(PatIndex('%[^A-Z]%', [STRIPPEDPREV_BORRINSCOMPANY].NAME_TX), 0), Len([STRIPPEDPREV_BORRINSCOMPANY].NAME_TX) + 1) - 1)
	 ) AS [STRIPPEDPREV2_BORRINSCOMPANY]
--
--determine if the names are the same (similar):
 CROSS APPLY (SELECT
	 Compare = Case
	  When STRIPPED2_BORRINSCOMPANY.NAME1_TX = STRIPPEDPREV2_BORRINSCOMPANY.NAME1_TX Then 1
	  When STRIPPED_BORRINSCOMPANY.NAME_TX Like '%' + STRIPPEDPREV2_BORRINSCOMPANY.NAME1_TX + '%' AND Len(STRIPPEDPREV2_BORRINSCOMPANY.NAME1_TX) > 3 Then 1
	  When STRIPPEDPREV_BORRINSCOMPANY.NAME_TX Like '%' + STRIPPED2_BORRINSCOMPANY.NAME1_TX + '%' AND Len(STRIPPED2_BORRINSCOMPANY.NAME1_TX) > 3 Then 1
	  Else 0 End
	) AS BIC_NAMES_MATCH
--determine if the companies are the same or have the same parent company
 CROSS APPLY (SELECT
	Compare = Case 
	 When BIC.PARENT_ID = BICP.PARENT_ID Then 1
	 When BIC.ID = BICP.PARENT_ID Then 1
	 When BIC.PARENT_ID = BICP.ID Then 1
	 Else 0 End
 ) AS BIC_PARENTS_MATCH

 Join OWNER_LOAN_CTE OL WITH(NOLOCK) on OL.LOAN_ID = L.ID AND OL.PRIMARY_IN = 'Y' AND OL.PURGE_DT IS NULL
 --LEFT Join dbo.[OWNER] O WITH(NOLOCK) on O.ID = OL.OWNER_ID AND O.PURGE_DT IS NULL
 --left Join dbo.OWNER_ADDRESS AO WITH(NOLOCK) on AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
 --left Join dbo.OWNER_ADDRESS AM WITH(NOLOCK) on AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
 
 --LEFT JOIN dbo.PROCESS_LOG_ITEM PLI WITH(NOLOCK) ON PLI.RELATE_ID = ES.ID and PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Escrow' AND PLI.PURGE_DT IS NULL
 OUTER Apply(Select Top 1 PLI_ID=PLI.ID,PL_ID=PLI.PROCESS_LOG_ID,PD_ID=PL.PROCESS_DEFINITION_ID From dbo.PROCESS_LOG_ITEM PLI (NoLock) Join dbo.PROCESS_LOG PL (NoLock) On PL.ID=PLI.PROCESS_LOG_ID Where PLI.RELATE_ID = ES.ID and PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Escrow' AND PLI.PURGE_DT IS NULL Order By PLI.PROCESS_LOG_ID Desc) As PL

 Left Join REF_CODE_CTE NRef WITH(NOLOCK) on NRef.DOMAIN_CD = (@REF_DOM_NOTICE_TYPE) and NRef.CODE_CD = RC.NOTICE_TYPE_CD
 left Join REF_CODE_CTE LSRef WITH(NOLOCK) on LSRef.DOMAIN_CD = (@REF_DOM_LOAN_STAT) and LSRef.CODE_CD = L.STATUS_CD
 left Join REF_CODE_CTE CSRef WITH(NOLOCK) on CSRef.DOMAIN_CD = (@REF_DOM_COLLAT_STAT) and CSRef.CODE_CD = C.STATUS_CD

 Left Join REF_CODE_CTE RCSRef WITH(NOLOCK) on RCSRef.DOMAIN_CD = (@REF_DOM_RCOV_STAT) and RCSRef.CODE_CD = RC.STATUS_CD
 Left Join REF_CODE_CTE RCISRef WITH(NOLOCK) on RCISRef.DOMAIN_CD = (@REF_DOM_RCOV_INS_STAT) and RCISRef.CODE_CD = RC.SUMMARY_STATUS_CD
 Left Join REF_CODE_CTE RCISSRef WITH(NOLOCK) on RCISSRef.DOMAIN_CD = (@REF_DOM_RCOV_INS_SUB_STAT) and RCISSRef.CODE_CD = RC.SUMMARY_SUB_STATUS_CD

 left Join REF_CODE_CTE RC_DIVISION WITH(NOLOCK) on RC_DIVISION.DOMAIN_CD = (@REF_DOM_CONTRACT_TYPE) and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
 left Join REF_CODE_CTE RC_COVERAGETYPE WITH(NOLOCK) on RC_COVERAGETYPE.DOMAIN_CD = (@REF_DOM_COV) and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
 CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
 where
  @ChangeType_E > 0

 AND (LND.ID = @LenderID OR @LenderID IS NULL) AND LND.PURGE_DT IS NULL
 AND (P.LENDER_ID = @LenderID OR @LenderID IS NULL) AND P.PURGE_DT IS NULL

 AND L.RECORD_TYPE_CD = 'G' and P.RECORD_TYPE_CD = 'G' and RC.RECORD_TYPE_CD = 'G' and (ES.RECORD_TYPE_CD = 'G' Or ES.ID Is Null)

 AND L.EXTRACT_UNMATCH_COUNT_NO = 0 AND C.EXTRACT_UNMATCH_COUNT_NO = 0
 AND L.STATUS_CD != 'U' AND C.STATUS_CD != 'U'

 --during testing, filtering on Branch seemed to slow down performance significantly
 --AND (@Branch = '1' OR @Branch = '' OR @Branch is NULL OR L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM @BranchTable))

 AND fn_FCBD.loanType IS NOT NULL

 AND (RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage is NULL)

 --AND (@EndDate IS NULL OR ES.ID IS NULL OR (ES.CREATE_DT >= @StartDate and ES.CREATE_DT < @EndDate))

 --AND (@ProcessLogID IS NULL OR PLI.ID IS NULL OR PLI.PROCESS_LOG_ID = @ProcessLogID)

 --filter out any ClosedEsc that are dated MORE RECENTLY than ES
 AND (IsNull(CLOSEDESC.END_DT, DATEADD(month, 12 , CLOSEDESC.DUE_DT)) <  IsNull(ES.END_DT, DATEADD(month, 12 , ES.DUE_DT)) OR @ChangeType_E<2)

 AND 1 = (CASE 
 /*
 */
 --exclude homestreet polices whose companies match (TFS 44160)
 WHEN LND.CODE_TX = '3551'
	and (BIC_NAMES_MATCH.Compare > 0 Or BIC_PARENTS_MATCH.Compare > 0)
 THEN 0

 --exclude policies whose companies AND effective dates are the same (disregarding years):
  WHEN BIC_NAMES_MATCH.Compare > 0
   AND ES.EFFECTIVE_MON = PES.EFFECTIVE_MON
   AND ES.EFFECTIVE_DAY = PES.EFFECTIVE_DAY
  THEN 0
  --
 --exclude policies whose companies AND EXPIRATION dates are the same (disregarding years):
  WHEN BIC_NAMES_MATCH.Compare > 0
   AND ES.END_MON = PES.END_MON
   AND ES.END_DAY = PES.END_DAY
  THEN 0
  --
 --exclude policies whose companies are the same and whose CURR EFFECTIVE equals PREV EXPIRATION dates:
  WHEN BIC_NAMES_MATCH.Compare > 0
   AND IsNull(ES.EFFECTIVE_DT,'12/31/9999') = IsNull(PES.END_DT,'12/31/9999')
  THEN 0
--
--EXCLUDE the following, as per TFS#40896:
  WHEN RTrim(PES.POLICY_NUMBER_TX) In ('BINDER','PENDING','APPLICATION','UNKNOWN','NA')
    OR RTrim(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO) Like '%TBD'
    OR (PES.POLICY_NUMBER_TX) Like '% %'
    OR RTrim(PES.POLICY_NUMBER_TX) In ('BINDER','PENDING','APPLICATION','UNKNOWN','NA') 
    OR RTrim(STRIPPED_BORRINSCOMPANY.POLICY_NO) Like '%TBD'
    OR (ES.POLICY_NUMBER_TX) Like '% %'
  THEN 0

/* exclude same borrowers whose policies 1st 6 digits are the same */
  WHEN RTrim(UPPER(STRIPPED_BORRINSCOMPANY.POLICY_NO)) = RTrim(UPPER(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO)) THEN 0
--
/* exclude same borrowers whose policies go from Binder to policy number */
  WHEN (STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO LIKE '%BIND%' And STRIPPED_BORRINSCOMPANY.POLICY_NO NOT LIKE '%BIND%') THEN 0
  WHEN ((PES.SUMMARY_STATUS_CD In ('B', 'BH', 'U', 'UH') OR PES.SUMMARY_SUB_STATUS_CD = 'B') And RC.SUMMARY_STATUS_CD NOT In ('B', 'BH', 'U', 'UH') And RC.SUMMARY_SUB_STATUS_CD <> 'B') THEN 0
  WHEN RTrim(ISNULL(STRIPPED_BORRINSCOMPANY.NAME_TX,'')) <> '' AND
       RTrim(UPPER(ISNULL(STRIPPED_BORRINSCOMPANY.NAME_TX,''))) = RTrim(UPPER(ISNULL(STRIPPEDPREV_BORRINSCOMPANY.NAME_TX,''))) AND
       dbo.fn_ComparePolicyNumber ( RTrim(UPPER(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO)) , RTrim(UPPER(STRIPPED_BORRINSCOMPANY.POLICY_NO)) , 6 , 3 ) = 'Y' THEN 0
  
  --WHEN (Coalesce(NullIf(BIC.NAME, ''), NullIf(BICP.NAME, '')) IS NOT NULL AND RTrim(UPPER(STRIPPED_BORRINSCOMPANY.NAME_TX)) != RTrim(UPPER(STRIPPEDPREV_BORRINSCOMPANY.NAME_TX))) THEN 1

/*
*/
--EXCLUDE those borrowers whose prev/curr Companies the same and prev/curr Policies different:
--(but INCLUDE them if their prev/curr Effective dates different)
  WHEN BIC_NAMES_MATCH.Compare > 0
   AND 'N' = dbo.fn_ComparePolicyNumber ( RTrim(UPPER(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO)) , RTrim(UPPER(STRIPPED_BORRINSCOMPANY.POLICY_NO)) , 6 , 3 )
  THEN CASE WHEN IsNull(PES.EFFECTIVE_DT,'') != IsNull(ES.EFFECTIVE_DT,'') THEN 1 ELSE 0 END
--
/*
--EXCLUDE prev/curr Company name "variations":
  WHEN BIC_NAMES_MATCH.Compare > 0
   AND Coalesce(NullIf(BIC.NAME, ''), NullIf(BICP.NAME, '')) IS NOT NULL
  THEN 0
*/

  ELSE 1 END)

  /* OPTIMIZATION for @FilterBySQL: */
 AND 1 = (CASE
  WHEN UPPER(@FilterBySQL) = 'ISNULL([STRIPPED_BORRINSCOMPANY_POLICY_NO], '''') <> ISNULL([STRIPPEDPREV_BORRINSCOMPANY_POLICY_NO], '''')' AND IsNull(STRIPPED_BORRINSCOMPANY.POLICY_NO, '') = IsNull(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO, '') THEN 0
 ELSE 1 END)

/* Owner Policy:
*/
 UNION ALL

 Select
	POP_MOST_RECENT_TXN_TYPE_CD=POP.MOST_RECENT_TXN_TYPE_CD,
	OP_MOST_RECENT_TXN_TYPE_CD=OP.MOST_RECENT_TXN_TYPE_CD,
	CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '' then 'No Branch' else L.BRANCH_CODE_TX END as [LOAN_BRANCHCODE_TX],
    CASE WHEN ISNULL(L.DIVISION_CODE_TX,'') = '' THEN '0' ELSE L.DIVISION_CODE_TX END AS [LOAN_DIVISIONCODE_TX],
     ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) AS [LOAN_TYPE_TX],
     RC.TYPE_CD as [REQUIREDCOVERAGE_CODE_TX], 
     RC_COVERAGETYPE.MEANING_TX as [REQUIREDCOVERAGE_TYPE_TX], 
     'O' as [CHANGE_TYPE_TX],
 --LOAN
     L.NUMBER_TX as [LOAN_NUMBER_TX], 
     SUBSTRING(@FillerZero, 1, 18 - len(L.NUMBER_TX)) + CAST(L.NUMBER_TX AS nvarchar(18)) AS [LOAN_NUMBERSORT_TX],
 --LENDER
     LND.CODE_TX as [LENDER_CODE_TX], 
     LND.NAME_TX as [LENDER_NAME_TX]
 --OWNER
     ,OWNER_LASTNAME_TX = NULL
     ,OWNER_FIRSTNAME_TX = NULL
     ,OWNER_MIDDLEINITIAL_TX = NULL
     ,OWNER_NAME_TX = NULL
     --CASE WHEN O.FIRST_NAME_TX IS NULL THEN O.LAST_NAME_TX ELSE RTRIM(O.LAST_NAME_TX + ', ' + ISNULL(O.FIRST_NAME_TX,'') + ' ' + ISNULL(O.MIDDLE_INITIAL_TX,'')) END
     ,OWNER_LINE1_TX = NULL
     ,OWNER_LINE2_TX = NULL
     ,OWNER_CITY_TX = NULL
     ,OWNER_STATE_TX = NULL
     ,OWNER_ZIP_TX = NULL
 --PROPERTY (AM)
     ,COLLATERAL_LINE1_TX = NULL
     ,COLLATERAL_LINE2_TX = NULL
     ,COLLATERAL_CITY_TX = NULL
     ,COLLATERAL_STATE_TX = NULL
     ,COLLATERAL_ZIP_TX = NULL
     ,
 --COVERAGE
     CASE 
    WHEN RC.NOTICE_DT is not null and RC.NOTICE_SEQ_NO > 0 THEN cast(RC.NOTICE_SEQ_NO as char(1)) +  ' ' + NRef.MEANING_TX + ' ' + CONVERT(nvarchar(10), RC.NOTICE_DT, 101) 
     ELSE CASE 
   WHEN L.STATUS_CD in ('N','O','P') THEN LSRef.MEANING_TX
   WHEN C.STATUS_CD in ('R','S','X') THEN CSRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')  THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N') THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')    THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')   THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD not in ('A','D','T')          THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')        THEN CSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')       THEN CSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')          THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')         THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD not in ('A','D','T')               THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')        THEN RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')       THEN RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')          THEN RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')         THEN RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'A' and RC.STATUS_CD not in ('A','D','T')               THEN RCSRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')        THEN LSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')       THEN LSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')          THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')         THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
   WHEN L.STATUS_CD = 'B' and RC.STATUS_CD not in ('A','D','T')               THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
     END
     END as [COVERAGE_STATUS_TX],
 --BORROWER INSURANCE
     [BORRINSCOMPANY_NAME_TX] = OP.BIC_NAME_TX,
     [STRIPPED_BORRINSCOMPANY_NAME_TX] = STRIPPED2_BORRINSCOMPANY.NAME1_TX,
     [BORRINSCOMPANY_POLICY_NO] = OP.POLICY_NUMBER_TX,
     [STRIPPED_BORRINSCOMPANY_POLICY_NO] = STRIPPED_BORRINSCOMPANY.POLICY_NO,
	 OP.CREATE_DT as [BORRINSCOMPANY_CREATE_DT],
	 CONVERT(nvarchar(8), OP.CREATE_DT, 112) as [POL_CREATED_SORT_TX],
     OP.EFFECTIVE_DT as [BORRINSCOMPANY_EFF_DT], 
     Case 
    when year(OP.EXPIRATION_DT) = '9999' then NULL
    else OP.EXPIRATION_DT
     End as [BORRINSCOMPANY_EXP_DT],  
 --ESCROW
     ESCROW_DUE_DT = NULL,ESCROW_END_DT = NULL,ESCROW_TOTAL_NO = NULL,  
 --IDs, STATUS
     L.ID as [LOAN_ID], 
     C.ID as [COLLATERAL_ID], 
     P.ID as [PROPERTY_ID], 
     RC.ID as [REQUIREDCOVERAGE_ID], 
     L.STATUS_CD as [LOAN_STATUSCODE], 
     LSRef.MEANING_TX as [LOAN_STATUSMEANING_TX], 
     C.STATUS_CD as [COLLATERAL_STATUSCODE], 
     CSRef.MEANING_TX as [COLLATERAL_STATUSMEANING_TX],
     RC.STATUS_CD as [REQUIREDCOVERAGE_STATUSCODE],
     RCSRef.MEANING_TX as [REQUIREDCOVERAGE_STATUSMEANING_TX],
     RC.SUB_STATUS_CD as [REQUIREDCOVERAGE_SUBSTATUSCODE],
     RC.SUMMARY_STATUS_CD as [REQUIREDCOVERAGE_INSSTATUSCODE],
     ISNULL(RCISRef.MEANING_TX, 'NOTAVAIL') as [REQUIREDCOVERAGE_INSSTATUSMEANING_TX],
     RC.SUMMARY_SUB_STATUS_CD as [REQUIREDCOVERAGE_INSSUBSTATUSCODE], 
     RCISSRef.MEANING_TX as [REQUIREDCOVERAGE_INSSUBSTATUSMEANING_TX],
    
 --Previous BORROWER INSURANCE
     [PREV_BORRINSCOMPANY_NAME_TX] = POP.BIC_NAME_TX,
     [STRIPPEDPREV_BORRINSCOMPANY_NAME_TX] = STRIPPEDPREV2_BORRINSCOMPANY.NAME1_TX,
     [PREV_BORRINSCOMPANY_POLICY_NO] = POP.POLICY_NUMBER_TX,
     [STRIPPEDPREV_BORRINSCOMPANY_POLICY_NO] = STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO,
	 POP.CREATE_DT as [PREV_BORRINSCOMPANY_CREATE_DT],
     POP.EFFECTIVE_DT as [PREV_BORRINSCOMPANY_EFF_DT], 
     Case 
    when year(POP.EXPIRATION_DT) = '9999' then NULL
    else POP.EXPIRATION_DT
     End as [PREV_BORRINSCOMPANY_EXP_DT]
 ,PREV_ESCROW_TOTAL_NO = NULL

 --Additional ID:
     ,ESCROW_ID = NULL
     ,ESCROW_ID_PREV = NULL
     ,OWNER_POL_ID = OP.ID
     ,OWNER_POL_ID_PREV = POP.ID
     ,OWNER_ID = OL.OWNER_ID
     ,REQ_COV_ID = NULL
     ,REQ_COV_ID_PREV = NULL
	 ,PLI_ID = NULL
	 ,PL_ID = NULL
	 ,PD_ID = NULL

From LENDER_CTE LND WITH(NOLOCK)
 Join LOAN_CTE L WITH(NOLOCK) on LND.ID = L.LENDER_ID AND L.PURGE_DT IS NULL

 Join COLLATERAL_CTE C WITH(NOLOCK) on L.ID = C.LOAN_ID AND C.PRIMARY_LOAN_IN = 'Y' AND C.PURGE_DT IS NULL

 LEFT JOIN dbo.COLLATERAL_CODE CC WITH(NOLOCK) ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL

 left Join REF_CODE_CTE RC_SC WITH(NOLOCK) on RC_SC.DOMAIN_CD = (@REF_DOM_SECOND_CLASS) AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
 left Join dbo.REF_CODE_ATTRIBUTE RCA_PROP WITH(NOLOCK) on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'

 Join PROPERTY_CTE P WITH(NOLOCK) on C.PROPERTY_ID = P.ID AND L.LENDER_ID = P.LENDER_ID
 JOIN REQ_COV_CTE RC WITH(NOLOCK) ON RC.PROPERTY_ID = P.ID AND RC.PURGE_DT IS NULL and RC.ESCROW_IN = 'Y'
 JOIN dbo.REQUIRED_ESCROW RE WITH(NOLOCK) ON RE.REQUIRED_COVERAGE_ID = RC.ID AND RE.PURGE_DT IS NULL AND RE.ACTIVE_IN = 'Y'

 CROSS APPLY
 (select ID, PROPERTY_ID, RC_TYPE, BIC_NAME_TX, POLICY_NUMBER_TX, EFFECTIVE_DT, EXPIRATION_DT, CREATE_DT, UNIT_OWNERS_IN, MOST_RECENT_TXN_TYPE_CD
  ,EFFECTIVE_MON = DatePart(Month, XP.EFFECTIVE_DT)
  ,EFFECTIVE_DAY = DatePart(Day, XP.EFFECTIVE_DT)
  ,EXPIRATION_MON = DatePart(Month, XP.EXPIRATION_DT)
  ,EXPIRATION_DAY = DatePart(Day, XP.EXPIRATION_DT)
  ,BIC_ID
  from (select TOP 1 ownpol.ID, popr.PROPERTY_ID, pcov.TYPE_CD as RC_TYPE, MOST_RECENT_TXN_TYPE_CD,
     ownpol.BIC_NAME_TX,ownpol.BIC_ID, ownpol.POLICY_NUMBER_TX, 
     ownpol.EFFECTIVE_DT, ownpol.EXPIRATION_DT,
     isnull(ownpol.UNIT_OWNERS_IN, 'N') as UNIT_OWNERS_IN, ownpol.CREATE_DT,
     row_number() over(partition by isnull(ownpol.UNIT_OWNERS_IN, 'N'), isnull(ownpol.EXCESS_IN, 'N')
           order by pcov.END_DT desc, ownpol.MOST_RECENT_MAIL_DT desc, ownpol.ID desc) as ROWNUM
     from dbo.OWNER_POLICY ownpol
     INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE popr WITH(NOLOCK) ON ownpol.ID = popr.OWNER_POLICY_ID and popr.PURGE_DT IS NULL and popr.PROPERTY_ID = P.ID
	 INNER JOIN dbo.POLICY_COVERAGE pcov on ownpol.ID = pcov.OWNER_POLICY_ID and pcov.PURGE_DT IS NULL and pcov.TYPE_CD = RC.TYPE_CD     
     where ownpol.PURGE_DT IS NULL 
	 AND         
       ((ISNULL(ownpol.UNIT_OWNERS_IN, 'N') = 'N' AND CC.SECONDARY_CLASS_CD NOT IN ('COCOND' , 'COND')) OR
       (ISNULL(ownpol.UNIT_OWNERS_IN, 'N') = 'Y' AND CC.SECONDARY_CLASS_CD IN ('COCOND' , 'COND')))  	 
	 ) XP
  where XP.ROWNUM = 1
 ) OP

 CROSS APPLY
 (select ID, PROPERTY_ID, RC_TYPE, BIC_NAME_TX, POLICY_NUMBER_TX, EFFECTIVE_DT, EXPIRATION_DT, CREATE_DT, UNIT_OWNERS_IN, MOST_RECENT_TXN_TYPE_CD
  ,EFFECTIVE_MON = DatePart(Month, XP.EFFECTIVE_DT)
  ,EFFECTIVE_DAY = DatePart(Day, XP.EFFECTIVE_DT)
  ,EXPIRATION_MON = DatePart(Month, XP.EXPIRATION_DT)
  ,EXPIRATION_DAY = DatePart(Day, XP.EXPIRATION_DT)
  ,BIC_ID
  from (select TOP 2 ownpol.ID, popr.PROPERTY_ID, pcov.TYPE_CD as RC_TYPE, MOST_RECENT_TXN_TYPE_CD,
     ownpol.BIC_NAME_TX, ownpol.BIC_ID, ownpol.POLICY_NUMBER_TX, 
     ownpol.EFFECTIVE_DT, ownpol.EXPIRATION_DT,
     isnull(ownpol.UNIT_OWNERS_IN, 'N') as UNIT_OWNERS_IN, ownpol.CREATE_DT,
     row_number() over(partition by isnull(ownpol.UNIT_OWNERS_IN, 'N'), isnull(ownpol.EXCESS_IN, 'N')
           order by pcov.END_DT desc, ownpol.MOST_RECENT_MAIL_DT desc, ownpol.ID desc) as ROWNUM
     from dbo.OWNER_POLICY ownpol
     INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE popr WITH(NOLOCK) ON ownpol.ID = popr.OWNER_POLICY_ID and popr.PURGE_DT IS NULL and popr.PROPERTY_ID = P.ID
	 INNER JOIN dbo.POLICY_COVERAGE pcov on ownpol.ID = pcov.OWNER_POLICY_ID and pcov.PURGE_DT IS NULL and pcov.TYPE_CD = RC.TYPE_CD    
     where ownpol.PURGE_DT IS NULL 
	 AND         
       ((ISNULL(ownpol.UNIT_OWNERS_IN, 'N') = 'N' AND CC.SECONDARY_CLASS_CD NOT IN ('COCOND' , 'COND')) OR
       (ISNULL(ownpol.UNIT_OWNERS_IN, 'N') = 'Y' AND CC.SECONDARY_CLASS_CD IN ('COCOND' , 'COND')))  
	 ) XP
  where XP.ROWNUM = 2
 ) POP
 left Join dbo.BORROWER_INSURANCE_COMPANY BIC WITH(NOLOCK) on BIC.ID = OP.BIC_ID AND BIC.PURGE_DT IS NULL And BIC.ACTIVE_IN = 'Y'
 left Join dbo.BORROWER_INSURANCE_COMPANY BICP WITH(NOLOCK) on BICP.ID = POP.BIC_ID --AND BICP.PURGE_DT IS NULL

 CROSS APPLY (SELECT
	 POLICY_NO = Substring(IsNull(
		 --CASE When @Debug>0 THEN
		  --OP.POLICY_NUMBER_TX Else
		  dbo.fn_NormalizePolicyNumber(OP.POLICY_NUMBER_TX,'Y')
		 --END
		 , ''), 1, 6)
	,NAME_TX = UPPER(RTrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Lower(OP.BIC_NAME_TX),'-',' '),'.',''),' ins ',' '),'insurance',''),' comp ',' '),' co ',' '),'company','')))
 ) AS [STRIPPED_BORRINSCOMPANY]
 CROSS APPLY (SELECT
	 POLICY_NO = Substring(IsNull(
		 --CASE When @Debug>0 THEN
		  --POP.POLICY_NUMBER_TX Else
		  dbo.fn_NormalizePolicyNumber(POP.POLICY_NUMBER_TX,'Y')
		 --END
		 , ''), 1, 6)
	,NAME_TX = UPPER(RTrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Lower(POP.BIC_NAME_TX),'-',' '),'.',''),' ins ',' '),'insurance',''),' comp ',' '),' co ',' '),'company','')))
 ) AS [STRIPPEDPREV_BORRINSCOMPANY]
--
--take just the 1st "word" (that EndsWith a NON-letter):
 CROSS APPLY (SELECT
	 NAME1_TX = Substring([STRIPPED_BORRINSCOMPANY].NAME_TX, 1, IsNull(NullIf(PatIndex('%[^A-Z]%', [STRIPPED_BORRINSCOMPANY].NAME_TX), 0), Len([STRIPPED_BORRINSCOMPANY].NAME_TX) + 1) - 1)
	 ) AS [STRIPPED2_BORRINSCOMPANY]
--take just the 1st "word" (that EndsWith a NON-letter):
 CROSS APPLY (SELECT
	 NAME1_TX = Substring([STRIPPEDPREV_BORRINSCOMPANY].NAME_TX, 1, IsNull(NullIf(PatIndex('%[^A-Z]%', [STRIPPEDPREV_BORRINSCOMPANY].NAME_TX), 0), Len([STRIPPEDPREV_BORRINSCOMPANY].NAME_TX) + 1) - 1)
	 ) AS [STRIPPEDPREV2_BORRINSCOMPANY]
--
--determine if the names are the same (similar):
 CROSS APPLY (SELECT
	 Compare = Case
	  When STRIPPED2_BORRINSCOMPANY.NAME1_TX = STRIPPEDPREV2_BORRINSCOMPANY.NAME1_TX Then 1
	  When STRIPPED_BORRINSCOMPANY.NAME_TX Like '%' + STRIPPEDPREV2_BORRINSCOMPANY.NAME1_TX + '%' AND Len(STRIPPEDPREV2_BORRINSCOMPANY.NAME1_TX) > 3 Then 1
	  When STRIPPEDPREV_BORRINSCOMPANY.NAME_TX Like '%' + STRIPPED2_BORRINSCOMPANY.NAME1_TX + '%' AND Len(STRIPPED2_BORRINSCOMPANY.NAME1_TX) > 3 Then 1
	  Else 0 End
	) AS BIC_NAMES_MATCH
--determine if the companies are the same or have the same parent company
 CROSS APPLY (SELECT
	Compare = Case 
	 When BIC.PARENT_ID = BICP.PARENT_ID Then 1
	 When BIC.ID = BICP.PARENT_ID Then 1
	 When BIC.PARENT_ID = BICP.ID Then 1
	 Else 0 End
 ) AS BIC_PARENTS_MATCH
 OUTER APPLY
 (
	 SELECT COUNT(*) AS ESCROW_CNT
	 FROM REQ_COV_CTE As CURR_RC JOIN dbo.ESCROW_REQUIRED_COVERAGE_RELATE ERCR 
	 ON CURR_RC.ID = ERCR.REQUIRED_COVERAGE_ID JOIN ESCROW ES ON ERCR.ESCROW_ID = ES.ID
     WHERE CURR_RC.PROPERTY_ID = P.ID AND CURR_RC.TYPE_CD = RC.TYPE_CD
     AND CURR_RC.PURGE_DT IS NULL AND ES.PURGE_DT IS NULL AND ERCR.PURGE_DT IS NULL
	 AND 
	 ( 	   
	   STRIPPED_BORRINSCOMPANY.POLICY_NO =  SUBSTRING(ISNULL(dbo.fn_NormalizePolicyNumber(ES.POLICY_NUMBER_TX,'Y'), ''), 1, 6)
	 )
 ) ESCR

 Join OWNER_LOAN_CTE OL WITH(NOLOCK) on OL.LOAN_ID = L.ID AND OL.PRIMARY_IN = 'Y' AND OL.PURGE_DT IS NULL

 left Join REF_CODE_CTE NRef WITH(NOLOCK) on NRef.DOMAIN_CD = (@REF_DOM_NOTICE_TYPE) and NRef.CODE_CD = RC.NOTICE_TYPE_CD
 left Join REF_CODE_CTE LSRef WITH(NOLOCK) on LSRef.DOMAIN_CD = (@REF_DOM_LOAN_STAT) and LSRef.CODE_CD = L.STATUS_CD
 left Join REF_CODE_CTE CSRef WITH(NOLOCK) on CSRef.DOMAIN_CD = (@REF_DOM_COLLAT_STAT) and CSRef.CODE_CD = C.STATUS_CD

 left Join REF_CODE_CTE RCSRef WITH(NOLOCK) on RCSRef.DOMAIN_CD = (@REF_DOM_RCOV_STAT) and RCSRef.CODE_CD = RC.STATUS_CD
 left Join REF_CODE_CTE RCISRef WITH(NOLOCK) on RCISRef.DOMAIN_CD = (@REF_DOM_RCOV_INS_STAT) and RCISRef.CODE_CD = RC.SUMMARY_STATUS_CD
 left Join REF_CODE_CTE RCISSRef WITH(NOLOCK) on RCISSRef.DOMAIN_CD = (@REF_DOM_RCOV_INS_SUB_STAT) and RCISSRef.CODE_CD = RC.SUMMARY_SUB_STATUS_CD

 left Join REF_CODE_CTE RC_DIVISION WITH(NOLOCK) on RC_DIVISION.DOMAIN_CD = (@REF_DOM_CONTRACT_TYPE) and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
 left Join REF_CODE_CTE RC_COVERAGETYPE WITH(NOLOCK) on RC_COVERAGETYPE.DOMAIN_CD = (@REF_DOM_COV) and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
 CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
 where 
 @ChangeType_O > 0

 AND (LND.ID = @LenderID OR @LenderID IS NULL) AND LND.PURGE_DT IS NULL
 AND (P.LENDER_ID = @LenderID OR @LenderID IS NULL) AND P.PURGE_DT IS NULL
 
 AND L.RECORD_TYPE_CD = 'G' and P.RECORD_TYPE_CD = 'G' and RC.RECORD_TYPE_CD = 'G' -- and ES.RECORD_TYPE_CD = 'G'

 AND L.EXTRACT_UNMATCH_COUNT_NO = 0 and C.EXTRACT_UNMATCH_COUNT_NO = 0
 AND L.STATUS_CD NOT IN  ('U','F') and C.STATUS_CD NOT IN ('U','F')

 --during testing, filtering on Branch seemed to slow down performance significantly
 --AND (@Branch = '1' OR @Branch = '' OR @Branch is NULL OR L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM @BranchTable))

 and fn_FCBD.loanType IS NOT NULL
 and
 (RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage is NULL)
 
 AND ISNULL(ESCR.ESCROW_CNT,0) = 0

 AND 1 = (CASE 
 /*
 */
--exclude homestreet policies where companies are the same
 WHEN LND.CODE_TX = '3551'
	and (BIC_NAMES_MATCH.Compare > 0 OR BIC_PARENTS_MATCH.Compare > 0)
 THEN 0
--exclude policies whose companies AND effective dates are the same (disregarding years):
  WHEN BIC_NAMES_MATCH.Compare > 0
   AND OP.EFFECTIVE_MON = POP.EFFECTIVE_MON
   AND OP.EFFECTIVE_DAY = POP.EFFECTIVE_DAY
  THEN 0
  --
 --exclude policies whose companies AND EXPIRATION dates are the same (disregarding years):
  WHEN BIC_NAMES_MATCH.Compare > 0
   AND OP.EXPIRATION_MON = POP.EXPIRATION_MON
   AND OP.EXPIRATION_DAY = POP.EXPIRATION_DAY
  THEN 0
  --
 --exclude policies whose companies are the same and whose CURR EFFECTIVE equals PREV EXPIRATION dates:
  WHEN BIC_NAMES_MATCH.Compare > 0
   AND IsNull(OP.EFFECTIVE_DT,'12/31/9999') = IsNull(POP.EXPIRATION_DT,'12/31/9999') THEN 0
--
--EXCLUDE the following, as per TFS#40896:
  WHEN RTrim(POP.POLICY_NUMBER_TX) In ('BINDER','PENDING','APPLICATION','UNKNOWN','NA')
    OR RTrim(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO) Like '%TBD'
    OR (POP.POLICY_NUMBER_TX) Like '% %'
    OR RTrim(OP.POLICY_NUMBER_TX) In ('BINDER','PENDING','APPLICATION','UNKNOWN','NA') 
    OR RTrim(STRIPPED_BORRINSCOMPANY.POLICY_NO) Like '%TBD'
    OR (OP.POLICY_NUMBER_TX) Like '% %'
  THEN 0

 /* exclude same borrowers whose policies 1st 6 digits are the same */
  WHEN RTrim(UPPER(STRIPPED_BORRINSCOMPANY.POLICY_NO)) = RTrim(UPPER(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO)) THEN 0
--
/* exclude same borrowers whose policies go from Binder to policy number */
  WHEN (STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO LIKE '%BIND%' And STRIPPED_BORRINSCOMPANY.POLICY_NO NOT LIKE '%BIND%') THEN 0 
--
/* exclude when summary status is CPI In-force */
  WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' AND RC.SUMMARY_STATUS_CD IN ('F' , 'FH') THEN 0
  
  WHEN RTrim(ISNULL(STRIPPED_BORRINSCOMPANY.NAME_TX,'')) <> '' AND
       RTrim(UPPER(ISNULL(STRIPPED_BORRINSCOMPANY.NAME_TX,''))) = RTrim(UPPER(ISNULL(STRIPPEDPREV_BORRINSCOMPANY.NAME_TX,''))) AND
       dbo.fn_ComparePolicyNumber (RTrim(UPPER(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO)) , RTrim(UPPER(STRIPPED_BORRINSCOMPANY.POLICY_NO)) , 6 , 3 ) = 'Y' THEN 0

--WHEN Coalesce(NullIf(OP.BIC_NAME_TX, ''), NullIf(POP.BIC_NAME_TX, '')) IS NOT NULL AND RTrim(UPPER(STRIPPED_BORRINSCOMPANY.NAME_TX)) != RTrim(UPPER(STRIPPEDPREV_BORRINSCOMPANY.NAME_TX)) THEN 1

/*--this Rule was removed on 5/18 because the Requirements changed
--EXCLUDE "renewal" transactions:
  WHEN (OP.MOST_RECENT_TXN_TYPE_CD='RWL' OR POP.MOST_RECENT_TXN_TYPE_CD='RWL')
--60 below means the function figures there's only a 60% chance that the policies are the same
--3 below means that the difference between the lengths of the policies cannot be more than 3 (to even be considered possibly the same)
--4 below means the length of their prefix/suffix
   AND dbo.fn_ComparePolicyNumbers_Prefix_Suffix ( RTrim(UPPER(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO)) , RTrim(UPPER(STRIPPED_BORRINSCOMPANY.POLICY_NO)) , 3 , 4 , 4 ) > 60
  THEN 0
*/
--
--EXCLUDE those borrowers whose prev/curr Companies the same and prev/curr Policies different:
--(but INCLUDE them if their prev/curr Effective dates different)
  WHEN RTrim(IsNull(STRIPPEDPREV_BORRINSCOMPANY.NAME_TX,'')) = RTrim(IsNull(STRIPPED_BORRINSCOMPANY.NAME_TX,''))
--60 below means the function figures there's only a 60% chance that the policies are the same
--3 below means that the difference between the lengths of the policies cannot be more than 3 (to even be considered possibly the same)
--4 below means the length of their prefix/suffix
-- AND dbo.fn_ComparePolicyNumbers_Prefix_Suffix ( RTrim(UPPER(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO)) , RTrim(UPPER(STRIPPED_BORRINSCOMPANY.POLICY_NO)) , 3 , 4 , 4 ) <= 60
  THEN CASE WHEN IsNull(POP.EFFECTIVE_DT,'12/31/9999') != IsNull(OP.EFFECTIVE_DT,'12/31/9999') THEN 1 ELSE 0 END
--
--EXCLUDE prev/curr Company name "variations" (using STRIPPED...):
  WHEN RTrim(IsNull(STRIPPEDPREV_BORRINSCOMPANY.NAME_TX,'')) = RTrim(IsNull(STRIPPED_BORRINSCOMPANY.NAME_TX,''))
   AND Coalesce(NullIf(OP.BIC_NAME_TX, ''), NullIf(POP.BIC_NAME_TX, '')) IS NOT NULL
  THEN 0

  ELSE 1 END)

  /* OPTIMIZATION for @FilterBySQL: */
 AND 1 = (CASE
  WHEN UPPER(@FilterBySQL) = 'ISNULL([STRIPPED_BORRINSCOMPANY_POLICY_NO], '''') <> ISNULL([STRIPPEDPREV_BORRINSCOMPANY_POLICY_NO], '''')' AND IsNull(STRIPPED_BORRINSCOMPANY.POLICY_NO, '') = IsNull(STRIPPEDPREV_BORRINSCOMPANY.POLICY_NO, '') THEN 0
 ELSE 1 END)
)
/*
*/
 Insert into @Rep_EscNewCar (
 POP_MOST_RECENT_TXN_TYPE_CD,
 OP_MOST_RECENT_TXN_TYPE_CD,
 LOAN_BRANCHCODE_TX, LOAN_DIVISIONCODE_TX, LOAN_TYPE_TX, REQUIREDCOVERAGE_CODE_TX, REQUIREDCOVERAGE_TYPE_TX, CHANGE_TYPE_TX,
 --LOAN
 LOAN_NUMBER_TX, LOAN_NUMBERSORT_TX,
 --LENDER
 LENDER_CODE_TX, LENDER_NAME_TX,
 --OWNER
 OWNER_LASTNAME_TX, OWNER_FIRSTNAME_TX, OWNER_MIDDLEINITIAL_TX, OWNER_NAME_TX,
 OWNER_LINE1_TX, OWNER_LINE2_TX, OWNER_CITY_TX, OWNER_STATE_TX, OWNER_ZIP_TX,
 --PROPERTY
 COLLATERAL_LINE1_TX, COLLATERAL_LINE2_TX, COLLATERAL_CITY_TX, COLLATERAL_STATE_TX, COLLATERAL_ZIP_TX, 
 --COVERAGE
 COVERAGE_STATUS_TX, 
 --BORROWER INSURANCE
 BORRINSCOMPANY_NAME_TX, STRIPPED_BORRINSCOMPANY_NAME_TX, BORRINSCOMPANY_POLICY_NO, STRIPPED_BORRINSCOMPANY_POLICY_NO, 
 BORRINSCOMPANY_CREATE_DT,POL_CREATED_SORT_TX, BORRINSCOMPANY_EFF_DT, BORRINSCOMPANY_EXP_DT, 
 --ESCROW
 ESCROW_DUE_DT,ESCROW_END_DT,ESCROW_TOTAL_NO,  
 --IDs, STATUS
 LOAN_ID, COLLATERAL_ID, PROPERTY_ID, REQUIREDCOVERAGE_ID, 
 LOAN_STATUSCODE, LOAN_STATUSMEANING_TX, COLLATERAL_STATUSCODE, COLLATERAL_STATUSMEANING_TX,
 REQUIREDCOVERAGE_STATUSCODE, REQUIREDCOVERAGE_STATUSMEANING_TX, REQUIREDCOVERAGE_SUBSTATUSCODE,
 REQUIREDCOVERAGE_INSSTATUSCODE, REQUIREDCOVERAGE_INSSTATUSMEANING_TX,
 REQUIREDCOVERAGE_INSSUBSTATUSCODE, REQUIREDCOVERAGE_INSSUBSTATUSMEANING_TX,
 PREV_BORRINSCOMPANY_NAME_TX,
 STRIPPEDPREV_BORRINSCOMPANY_NAME_TX,
 PREV_BORRINSCOMPANY_POLICY_NO,
 STRIPPEDPREV_BORRINSCOMPANY_POLICY_NO,
 PREV_BORRINSCOMPANY_CREATE_DT,
 PREV_BORRINSCOMPANY_EFF_DT,
 PREV_BORRINSCOMPANY_EXP_DT,
 PREV_ESCROW_TOTAL_NO
 --Additional ID:
 ,ESCROW_ID
 ,ESCROW_ID_PREV
 ,OWNER_POL_ID
 ,OWNER_POL_ID_PREV
 ,OWNER_ID
 ,REQ_COV_ID
 ,REQ_COV_ID_PREV
 ,PLI_ID
 ,PL_ID
 ,PD_ID
 )
SELECT MQ.* FROM MAIN_QUERY MQ
WHERE (@Branch = '1' OR @Branch = '' OR @Branch Is Null OR LOAN_BRANCHCODE_TX = 'No Branch' OR LOAN_BRANCHCODE_TX IN (SELECT STRVALUE FROM @BranchTable))
-- require ESCROW_ID if @ChangeType_E >= 2
-- require ESCROW_ID_PREV if @ChangeType_E >= 4
And 1=(Case When CHANGE_TYPE_TX='O' OR @ChangeType_E < 2 OR ESCROW_ID Is NOT Null Then 1 Else 0 End)
And 1=(Case When CHANGE_TYPE_TX='O' OR @ChangeType_E < 4 OR ESCROW_ID_PREV Is NOT Null Then 1 Else 0 End)
-- require OWNER_POL_ID if @ChangeType_O >= 2
-- require OWNER_POL_ID_PREV if @ChangeType_O >= 4
And 1=(Case When CHANGE_TYPE_TX='E' OR @ChangeType_O < 2 OR OWNER_POL_ID Is NOT Null Then 1 Else 0 End)
And 1=(Case When CHANGE_TYPE_TX='E' OR @ChangeType_O < 4 OR OWNER_POL_ID_PREV Is NOT Null Then 1 Else 0 End)

--exclude Maintenance data:
And MQ.REQUIREDCOVERAGE_STATUSCODE<>'M'

Option(Recompile)
;

/* now update OWNER/ADDRESS
** (this is done outside of MAIN_QUERY in order to speed performance efficiently)
 */
UPDATE Rep_EscNewCar
SET
--OWNER
   OWNER_LASTNAME_TX = O.LAST_NAME_TX
  ,OWNER_FIRSTNAME_TX = O.FIRST_NAME_TX
  ,OWNER_MIDDLEINITIAL_TX = O.MIDDLE_INITIAL_TX
  ,OWNER_NAME_TX = CASE WHEN O.FIRST_NAME_TX IS NULL THEN O.LAST_NAME_TX ELSE RTRIM(O.LAST_NAME_TX + ', ' + ISNULL(O.FIRST_NAME_TX,'') + ' ' + ISNULL(O.MIDDLE_INITIAL_TX,'')) END
  ,OWNER_LINE1_TX = AO.LINE_1_TX
  ,OWNER_LINE2_TX = AO.LINE_2_TX
  ,OWNER_CITY_TX = AO.CITY_TX
  ,OWNER_STATE_TX = AO.STATE_PROV_TX
  ,OWNER_ZIP_TX = AO.POSTAL_CODE_TX
--PROPERTY (AM)
  ,COLLATERAL_LINE1_TX = AM.LINE_1_TX
  ,COLLATERAL_LINE2_TX = AM.LINE_2_TX
  ,COLLATERAL_CITY_TX = AM.CITY_TX
  ,COLLATERAL_STATE_TX = AM.STATE_PROV_TX
  ,COLLATERAL_ZIP_TX = AM.POSTAL_CODE_TX
FROM @Rep_EscNewCar As Rep_EscNewCar
JOIN dbo.PROPERTY As P On P.ID = Rep_EscNewCar.PROPERTY_ID
 left Join dbo.[OWNER] O WITH(NOLOCK) on O.ID = Rep_EscNewCar.OWNER_ID AND O.PURGE_DT IS NULL
 left Join dbo.OWNER_ADDRESS AO WITH(NOLOCK) on AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
 left Join dbo.OWNER_ADDRESS AM WITH(NOLOCK) on AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL

IF @Debug>1
BEGIN
 PRINT '@FilterBySQL:'
 PRINT @FilterBySQL
 PRINT ''
 PRINT '@GroupBySQL:'
 PRINT @GroupBySQL
 PRINT ''
 PRINT '@SortBySQL:'
 PRINT @SortBySQL
 PRINT ''
 PRINT '@HeaderTx:'
 PRINT @HeaderTx
 PRINT ''
 PRINT '@FooterTx:'
 PRINT @FooterTx
END

--Get rid of residual #temp tables
IF OBJECT_ID(N'tempdb..#Rep_EscNewCar',N'U') IS NOT NULL
  DROP TABLE #Rep_EscNewCar

IF OBJECT_ID(N'tempdb..#Swap_EscNewCar',N'U') IS NOT NULL
  DROP TABLE #Swap_EscNewCar

-- create the metadata for #Rep_EscNewCar BUT WITHOUT any data
Select * into #Rep_EscNewCar from @Rep_EscNewCar where 0=1

Declare @sqlstring as nvarchar(1000)
BEGIN
 If (IsNull(@FilterBySQL, '') <> '' And @EvalFilterHere = 1)
 Or (IsNull(@SortBySQL, '') <> '' And @EvalSortHere = 1)
 Begin
   Select @sqlstring = N'Insert into #Rep_EscNewCar
       Select * from dbo.#Swap_EscNewCar'
       + Case When (IsNull(@FilterBySQL, '') <> '' And @EvalFilterHere = 1) Then ' where ' + @FilterBySQL Else '' End
       + Case When (IsNull(@SortBySQL, '') <> '' And @EvalSortHere = 1) Then ' order by ' + @SortBySQL Else '' End

	IF @Debug>1
	BEGIN
		Print @sqlstring
	END

		Insert Into #Rep_EscNewCar Select * From @Rep_EscNewCar
		Select DISTINCT * into #Swap_EscNewCar from #Rep_EscNewCar
		truncate table #Rep_EscNewCar

		EXECUTE sp_executesql @sqlstring
 End  
 Else -- instead transfer the data from @Rep_EscNewCar into #Rep_EscNewCar:
 BEGIN
	INSERT Into #Rep_EscNewCar Select DISTINCT * From @Rep_EscNewCar
 END

 If isnull(@GroupBySQL,'') <> ''
 Begin
  If @EvalGroupHere = 1
  Begin

	IF @Debug>0
	BEGIN
		Set @sqlstring = N'Update #Rep_EscNewCar Set [REPORT_GROUPBY_TX] = ' + @GroupBySQL
		Print @sqlstring
		EXECUTE sp_executesql @sqlstring
	END
	ELSE
	BEGIN TRY
		Set @sqlstring = N'Update #Rep_EscNewCar Set [REPORT_GROUPBY_TX] = ' + @GroupBySQL
		EXECUTE sp_executesql @sqlstring
	END TRY
	BEGIN CATCH
	END CATCH

  End
  Else
  Begin
   UPDATE #Rep_EscNewCar Set [REPORT_GROUPBY_TX] = @GroupBySQL
  End
 End

 If isnull(@SortBySQL,'') <> ''
 Begin
  If @EvalSortHere = 1
  Begin

	IF @Debug>0
	BEGIN
		Set @sqlstring = N'Update #Rep_EscNewCar Set [REPORT_SORTBY_TX] = ' + @SortBySQL
		Print @sqlstring
		EXECUTE sp_executesql @sqlstring
	END
	ELSE
	BEGIN TRY
		Set @sqlstring = N'Update #Rep_EscNewCar Set [REPORT_SORTBY_TX] = ' + @SortBySQL
		EXECUTE sp_executesql @sqlstring
	END TRY
	BEGIN CATCH
	END CATCH

  End
  Else
  Begin
   Update #Rep_EscNewCar Set [REPORT_SORTBY_TX] = @SortBySQL
  End
 End

 If isnull(@HeaderTx,'') <> ''
 Begin
  If @EvalHeadHere = 1
  Begin
   Set @sqlstring = N'Update #Rep_EscNewCar Set [REPORT_HEADER_TX] = ' + @HeaderTx
   EXECUTE sp_executesql @sqlstring
  End
  Else
  Begin
   Update #Rep_EscNewCar Set [REPORT_HEADER_TX] = @HeaderTx
  End
 End

 If isnull(@FooterTx,'') <> ''
 Begin
  If @EvalFootHere = 1
  Begin
   Set @sqlstring = N'Update #Rep_EscNewCar Set [REPORT_FOOTER_TX] = ' + @FooterTx
   EXECUTE sp_executesql @sqlstring
  End
  Else
  Begin
   Update #Rep_EscNewCar Set [REPORT_FOOTER_TX] = @FooterTx
  End
 End
END

SELECT @RecordCount = COUNT(*) from #Rep_EscNewCar
		where isnull(strippedprev_BORRINSCOMPANY_POLICY_NO,'')<>''
		  and isnull(stripped_BORRINSCOMPANY_POLICY_NO,'')<>''

IF @Debug>1
BEGIN
 print 'RecordCount:'
 print @RecordCount
END

IF @Report_History_ID IS NOT NULL
BEGIN

  Update [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML
  Set RECORD_COUNT_NO = @RecordCount
  ,UPDATE_DT = GETDATE()
  where ID = @Report_History_ID
    
END


	If @Debug=0 Or @Debug Is Null
	Begin
		Select
		 *
		from #Rep_EscNewCar order by REPORT_SORTBY_TX
		--where (
		--      isnull(prev_BORRINSCOMPANY_NAME_TX,'')<>''
		--  AND isnull(BORRINSCOMPANY_NAME_TX,'')<>''
		--      )
		--   OR CHANGE_TYPE_TX='O'
	End
	Else
	Begin
		SELECT
		 '@LenderCode'=@LenderCode
		,'@rhID'=@Report_History_ID
        ,ENC.CHANGE_TYPE_TX
		,ENC.REQUIREDCOVERAGE_STATUSCODE
		,ENC.OWNER_NAME_TX
		/*
		,ENC.OWNER_LINE1_TX
		,ENC.OWNER_LINE2_TX
		,ENC.OWNER_CITY_TX
		,ENC.OWNER_STATE_TX
		,ENC.OWNER_ZIP_TX
		*/
		,ENC.LOAN_NUMBER_TX
		,CoverageType=ENC.REQUIREDCOVERAGE_TYPE_TX
		--,ENC.COVERAGE_STATUS_TX
		,ENC.ESCROW_ID
		,ENC.ESCROW_ID_PREV
		,ProcDef=cast(ENC.PD_ID as char(10)) +' : '+ pd.name_tx
		,ProcLog=cast(ENC.PL_ID as char(10))
		,PLItem=cast(ENC.PLI_ID as char(10)) +' : '+ cast(cast(pli.update_dt as date) as char(10))
		,ENC.PREV_BORRINSCOMPANY_NAME_TX as 'Borrower OLD Ins Company'
		,ENC.BORRINSCOMPANY_NAME_TX as 'Borrower NEW Ins Company'
		,ENC.PREV_BORRINSCOMPANY_POLICY_NO as 'Policy OLD Num'
		,ENC.BORRINSCOMPANY_POLICY_NO as 'Policy NEW Num'
		,ENC.STRIPPEDPREV_BORRINSCOMPANY_NAME_TX
		,ENC.STRIPPED_BORRINSCOMPANY_NAME_TX
		,ENC.STRIPPED_BORRINSCOMPANY_POLICY_NO
		,ENC.STRIPPEDPREV_BORRINSCOMPANY_POLICY_NO
		,ENC.PREV_BORRINSCOMPANY_CREATE_DT
		,ENC.PREV_BORRINSCOMPANY_EFF_DT
		,ENC.PREV_BORRINSCOMPANY_EXP_DT
		,ENC.BORRINSCOMPANY_EFF_DT
		,ENC.BORRINSCOMPANY_EXP_DT
		/*
		*/
		--,ENC.ESCROW_DUE_DT
		--,ENC.PREV_ESCROW_DUE_DT
		--,ENC.PREV_BORRINSCOMPANY_EXP_DT
		--,ENC.PREV_ESCROW_TOTAL_NO
		--,ENC.COLLATERAL_LINE1_TX
		--,ENC.COLLATERAL_LINE2_TX
		--,ENC.COLLATERAL_CITY_TX
		--,ENC.COLLATERAL_STATE_TX
		--,ENC.COLLATERAL_ZIP_TX
		--,*
		from #Rep_EscNewCar ENC
		LEFT join process_definition pd (nolock) on pd.id=enc.pd_id
		LEFT join process_log_item pli (nolock) on pli.id=enc.pli_id
		where isnull(strippedprev_BORRINSCOMPANY_POLICY_NO,'')<>isnull(stripped_BORRINSCOMPANY_POLICY_NO,'')
/*
AND (@DEBUG!=2982 OR LOAN_NUMBER_TX IN (
 '1307683-1','1245725-1','1303650-1','1326278-1'
,'1189675-1','1297045-1'
,'9607-1'
,'1269627-1','1304942-1','1269105-1','1326537-1','1318245-1','1279560-1'
,'9607-1'
,'1312091-1','1269105-1','1294532-1','1279560-1','1284201-1'
))
*/
--and (PREV_BORRINSCOMPANY_POLICY_NO in ('application') or PREV_BORRINSCOMPANY_POLICY_NO in ('application'))
		-- and (@LenderCode<>'7545' or LOAN_NUMBER_TX in ('40029237')) --Elmira; example too old now (for the Escrow part)?!
		-- and (@LenderCode<>'3200' or LOAN_NUMBER_TX in ('20000837')) --TruStone; example too old now (for the Escrow part)?!
		-- and (@LenderCode<>'2771' or LOAN_NUMBER_TX in ('130212568', '1993266', '902113420', '1201055877')) --PenFed
		-- and (isnull(@Report_History_ID,0)<>8776263
		 -- or LOAN_NUMBER_TX in ('1103070086', '1601128977', '1601118725', '1306170848', '1303117422', '1072792', '1312059144', '1308198886', '1303117422', '2152365', '1105255595', '1511237961')
		 -- or LOAN_NUMBER_TX in ('2179827', '1310230062', '2231985')
		-- )
		--WHERE Substring(stripped_BORRINSCOMPANY_POLICY_NO,1,6)=Substring(strippedprev_BORRINSCOMPANY_POLICY_NO,1,6)
		--where rtrim(Substring(BORRINSCOMPANY_NAME_TX,1,7))=rtrim(Substring(PREV_BORRINSCOMPANY_NAME_TX,1,7)) and BORRINSCOMPANY_NAME_TX<>PREV_BORRINSCOMPANY_NAME_TX
		--AND (BORRINSCOMPANY_POLICY_NO LIKE '0%' OR prev_BORRINSCOMPANY_POLICY_NO LIKE '0%')
		--ORDER by ENC.loan_number_tx
		--order by borrinscompany_name_tx
	End

END




GO

