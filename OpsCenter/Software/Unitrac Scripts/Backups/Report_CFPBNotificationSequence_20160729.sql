USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_CFPBNotificationSequence]    Script Date: 7/29/2016 3:08:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_CFPBNotificationSequence] 
	(@LenderCode as nvarchar(10)=NULL,
	@Branch AS nvarchar(max)=NULL,
	@Division as nvarchar(10)=NULL,
	@Coverage as nvarchar(100)=NULL,
	@ReportType as nvarchar(50)=NULL,
	@ReportConfig as varchar(50)=NULL,
	@GroupByCode as nvarchar(50)=NULL,
	@SortByCode as nvarchar(50)=NULL,
	@FilterByCode as nvarchar(50)=NULL,
	@FromDate as datetime2(7) = NULL,
	@ToDate as datetime2(7) = NULL,
	@Report_History_ID as bigint=NULL,
	@ProcessLogID as bigint=0)
		
AS

BEGIN
SET NOCOUNT ON
	
--Get rid of residual #temp tables
IF OBJECT_ID(N'tempdb..#tmpfilter',N'U') IS NOT NULL
  DROP TABLE #tmpfilter
IF OBJECT_ID(N'tempdb..#tmptable',N'U') IS NOT NULL
  DROP TABLE #tmptable


DECLARE @DEBUGGING AS VARCHAR(1) = 'F'
Declare @LenderID as bigint
Declare @DateInput as bit = 'false'


DECLARE @BranchTable AS TABLE(ID int, STRVALUE nvarchar(30))
		INSERT INTO @BranchTable SELECT * FROM SplitFunction(@Branch, ',')  

IF @FromDate IS NOT NULL OR @ToDate IS NOT NULL 
BEGIN
	IF @FromDate IS NULL
	SET @FromDate = GetDate() - 1

	IF @ToDate IS NULL
	Set @ToDate = GetDate()

	SET @DateInput = 1
END

CREATE TABLE [dbo].[#tmptable](
	[LOAN_BRANCHCODE_TX] [nvarchar](20) NULL,	
	[LOAN_DIVISIONCODE_TX] [nvarchar](20) NULL,
	[LOAN_TYPE_TX] [nvarchar] (1000) NULL,
--LOAN
	[LOAN_NUMBER_TX] [nvarchar](18) NOT NULL,
	[LOAN_NUMBERSORT_TX] [nvarchar](18) NULL,
--COVERAGE
	[REQUIREDCOVERAGE_CODE_TX] [nvarchar](30) NULL,
	[REQUIREDCOVERAGE_TYPE_TX] [nvarchar](1000) NULL,
--LENDER
	[LOAN_LENDERCODE_TX] [nvarchar](10) NULL,	
	[LENDER_NAME_TX] [nvarchar](40) NULL,	
--OWNER
	[OWNER_LASTNAME_TX] [nvarchar](30) NULL,
	[OWNER_FIRSTNAME_TX] [nvarchar](30) NULL,
	[OWNER_MIDDLEINITIAL_TX] [char](1) NULL,
	[OWNER_NAME_TX] [nvarchar](50) NULL,
	[OWNER_LINE1_TX] [nvarchar](100) NULL,
	[OWNER_LINE2_TX] [nvarchar](100) NULL,
	[OWNER_CITY_TX] [nvarchar](40) NULL,
	[OWNER_STATE_TX] [nvarchar](30) NULL,
	[OWNER_ZIP_TX] [nvarchar](30) NULL,
--PROPERTY
	[COLLATERAL_YEAR_TX] [nvarchar](4) NULL,
	[COLLATERAL_MAKE_TX] [nvarchar](30) NULL,
	[COLLATERAL_MODEL_TX] [nvarchar](30) NULL,
	[COLLATERAL_VIN_TX] [nvarchar](18) NULL,
	[COLLATERAL_EQUIP_TX] [nvarchar](100) NULL,
	[PROPERTY_FLOODZONE_TX] [nvarchar](10) NULL,
	[FLOOD_VALUE_TX] [nvarchar](1) NULL,
	[PROPERTY_ACV_NO] [decimal](19, 2) NULL,
	[PROPERTY_TITLE_CD] [char](3) NULL,
	[PROPERTY_TYPE_CD] [nvarchar](30) NULL,
	[COLLATERAL_LINE1_TX] [nvarchar](100) NULL,
	[COLLATERAL_LINE2_TX] [nvarchar](100) NULL,
	[COLLATERAL_CITY_TX] [nvarchar](40) NULL,
	[COLLATERAL_STATE_TX] [nvarchar](30) NULL,
	[COLLATERAL_ZIP_TX] [nvarchar](30) NULL,
	[COLLATERAL_MORTGAGE_TX] [nvarchar](300) NULL,
   [PROPERTY_DESCRIPTION] [nvarchar](800) NULL,
--CPI
	[CPI_NUMBER_TX] [nvarchar](18) NULL,
	[CPI_EFF_DT] [datetime2](7) NULL,
	[CPI_ISSUE_DT] [datetime2](7) NULL,
	[CPI_REASON_TX] [nvarchar](400) NULL,
	[CPI_QUICK_ISSUE_IN][char](1) NULL,
--IDs, STATUS
	[LOAN_ID] [bigint] NULL,
	[COLLATERAL_ID] [bigint] NULL,
	[PROPERTY_ID] [bigint] NULL,
	[REQUIREDCOVERAGE_ID] [bigint] NULL,
--STD
	[REPORT_GROUPBY_CD] [nvarchar](50) NULL,
	[REPORT_GROUPBY_TX] [nvarchar](1000) NULL,
	[REPORT_SORTBY_TX] [nvarchar](1000) NULL,
	[REPORT_HEADER_TX] [nvarchar](1000) NULL,
	[REPORT_FOOTER_TX] [nvarchar](1000) NULL
) ON [PRIMARY]


CREATE TABLE [dbo].[#tmpfilter](
	[ATTRIBUTE_CD] [nvarchar](50) NULL,
	[VALUE_TX] [nvarchar](50) NULL
) ON [PRIMARY]

Select @LenderID=ID from LENDER where CODE_TX = @LenderCode and PURGE_DT is null

Declare @LoanStatus as varchar(5)
Declare @CollateralStatus as varchar(5)
Declare @RequiredCoverageStatus as varchar(5)
Declare @RequiredCoverageSubStatus as varchar(5)
Declare @SummaryStatus as varchar(5)
Declare @SummarySubStatus as varchar(5)
Declare @GroupBySQL as varchar(1000)
Declare @SortBySQL as varchar(1000)
Declare @FilterBySQL as varchar(1000)
Declare @HeaderTx as varchar(1000)
Declare @FooterTx as varchar(1000)
Declare @FillerZero as varchar(18)
Declare @RecordCount as bigint

Set @LoanStatus = NULL
Set @CollateralStatus = NULL
Set @RequiredCoverageStatus = NULL
Set @RequiredCoverageSubStatus = NULL
Set @SummaryStatus = NULL
Set @SummarySubStatus = NULL
Set @FillerZero = '000000000000000000'
Set @RecordCount = 0

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
 on  Custom.CODE_TX = @ReportConfig and Custom.REPORT_DOMAIN_CD = RAD.DOMAIN_CD and Custom.REPORT_REF_ATTRIBUTE_CD = RAD.ATTRIBUTE_CD and Custom.REPORT_CD = @ReportType
where RC.DOMAIN_CD = 'Report_CFPBNotification' and RC.CODE_CD = @ReportType

IF (@ReportConfig is NULL or @ReportConfig = '' or @ReportConfig = '0000')
	SET @ReportConfig = @ReportType --reassign the value of @ReportConfig		
		 
IF @GroupByCode IS NULL OR @GroupByCode = ''
	BEGIN
		SELECT @GroupBySQL=GROUP_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig
	END
ELSE
	BEGIN
		SELECT @GroupBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_GroupBy' AND CODE_CD = @GroupByCode
	END

IF @SortByCode IS NULL OR @SortByCode = ''
	SELECT @SortBySQL=SORT_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig
ELSE
	SELECT @SortBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_SortBy' AND CODE_CD = @SortByCode

IF @FilterByCode IS NULL OR @FilterByCode = ''
	SELECT @FilterBySQL=FILTER_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig
Else
	SELECT @FilterBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_FilterBy' AND CODE_CD = @FilterByCode

Select @HeaderTx=HEADER_TX from REPORT_CONFIG where CODE_TX = @ReportConfig
Select @FooterTx=FOOTER_TX from REPORT_CONFIG where CODE_TX = @ReportConfig 
    

Insert into #tmptable (
LOAN_BRANCHCODE_TX, LOAN_DIVISIONCODE_TX, LOAN_TYPE_TX, LOAN_NUMBER_TX, LOAN_NUMBERSORT_TX,
REQUIREDCOVERAGE_CODE_TX,REQUIREDCOVERAGE_TYPE_TX,
--LENDER
LOAN_LENDERCODE_TX, LENDER_NAME_TX,
--OWNER
OWNER_LASTNAME_TX, OWNER_FIRSTNAME_TX, OWNER_MIDDLEINITIAL_TX, OWNER_NAME_TX,
OWNER_LINE1_TX, OWNER_LINE2_TX, OWNER_CITY_TX, OWNER_STATE_TX, OWNER_ZIP_TX,
--PROPERTY
COLLATERAL_YEAR_TX, COLLATERAL_MAKE_TX, COLLATERAL_MODEL_TX, COLLATERAL_VIN_TX, COLLATERAL_EQUIP_TX, 
PROPERTY_FLOODZONE_TX, FLOOD_VALUE_TX, PROPERTY_ACV_NO, PROPERTY_TITLE_CD, PROPERTY_TYPE_CD,
COLLATERAL_LINE1_TX, COLLATERAL_LINE2_TX, COLLATERAL_CITY_TX, COLLATERAL_STATE_TX, COLLATERAL_ZIP_TX, COLLATERAL_MORTGAGE_TX, PROPERTY_DESCRIPTION,
--CPI
CPI_NUMBER_TX,CPI_EFF_DT,CPI_ISSUE_DT,CPI_REASON_TX,CPI_QUICK_ISSUE_IN,
LOAN_ID, COLLATERAL_ID, PROPERTY_ID, REQUIREDCOVERAGE_ID
)				

SELECT (CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '' then 'No Branch' else L.BRANCH_CODE_TX END) as [LOAN_BRANCHCODE_TX],
	   CASE WHEN ISNULL(L.DIVISION_CODE_TX,'') = ''
			THEN '0'
			ELSE L.DIVISION_CODE_TX
	   END AS [LOAN_DIVISIONCODE_TX],
	   ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) AS [LOAN_TYPE_TX],
--LOAN
	   L.NUMBER_TX as [LOAN_NUMBER_TX], 
	   SUBSTRING(@FillerZero, 1, 18 - len(L.NUMBER_TX)) + CAST(L.NUMBER_TX AS nvarchar(18)) AS [LOAN_NUMBERSORT_TX],
--COVERAGE
       RC.TYPE_CD as [REQUIREDCOVERAGE_CODE_TX],
	   RC_COVERAGETYPE.MEANING_TX as [REQUIREDCOVERAGE_TYPE_TX],
--LENDER
	   LND.CODE_TX as [LOAN_LENDERCODE_TX], 
	   LND.NAME_TX as [LENDER_NAME_TX],
--OWNER
       O.LAST_NAME_TX as [OWNER_LASTNAME_TX], 
	   O.FIRST_NAME_TX as [OWNER_FIRSTNAME_TX], 
	   O.MIDDLE_INITIAL_TX as [OWNER_MIDDLEINITIAL_TX],
       CASE WHEN ISNULL(ODBA.NAME_TX,'') = '' THEN ODBA.LAST_NAME_TX ELSE ODBA.NAME_TX END AS [OWNER_NAME_TX],
       AO.LINE_1_TX as [OWNER_LINE1_TX], 
	   AO.LINE_2_TX as [OWNER_LINE2_TX],
	   AO.CITY_TX as [OWNER_CITY_TX], 
       AO.STATE_PROV_TX as [OWNER_STATE_TX], 
	   AO.POSTAL_CODE_TX as [OWNER_ZIP_TX],	      
--PROPERTY
       P.YEAR_TX as [COLLATERAL_YEAR_TX], 
	   P.MAKE_TX as [COLLATERAL_MAKE_TX], 
	   P.MODEL_TX as [COLLATERAL_MODEL_TX], 
	   P.VIN_TX as [COLLATERAL_VIN_TX], 
	   P.DESCRIPTION_TX as [COLLATERAL_EQUIP_TX], 
	   P.FLOOD_ZONE_TX as [PROPERTY_FLOODZONE_TX], 
	   left(isnull(P.FLOOD_ZONE_TX,' '),1) as [FLOOD_VALUE_TX],
	   P.ACV_NO as [PROPERTY_ACV_NO],
       (CASE when P.TITLE_CD = 'Y' then 'Yes' else 'No' END) as [PROPERTY_TITLE_CD],
	   RCA_PROP.VALUE_TX AS [PROPERTY_TYPE_CD],
       AM.LINE_1_TX as [COLLATERAL_LINE1_TX], 
	   AM.LINE_2_TX as [COLLATERAL_LINE2_TX],
	   AM.CITY_TX as [COLLATERAL_CITY_TX], 
       AM.STATE_PROV_TX as [COLLATERAL_STATE_TX], 
	   AM.POSTAL_CODE_TX as [COLLATERAL_ZIP_TX], 
       isnull(AM.LINE_1_TX,'') + ' ' + isnull(AM.LINE_2_TX,'') + ' ' + isnull(AM.CITY_TX,'') + ' ' + 
			isnull(AM.STATE_PROV_TX,'') + ' ' + isnull(AM.POSTAL_CODE_TX,'') as [COLLATERAL_MORTGAGE_TX],
       dbo.fn_GetPropertyDescriptionForReports(C.ID) as PROPERTY_DESCRIPTION, 
--CPI
	   FPC.NUMBER_TX as [CPI_NUMBER_TX],
	   FPC.EFFECTIVE_DT AS [CPI_EFF_DT],
	   FPC.ISSUE_DT AS [CPI_ISSUE_DT],
	   RC_IssueReason.MEANING_TX AS [CPI_REASON_TX],
	   FPC.QUICK_ISSUE_IN AS [CPI_QUICK_ISSUE_IN],
--IDs, STATUS
       L.ID as [LOAN_ID], 
	   C.ID as [COLLATERAL_ID], 
	   P.ID as [PROPERTY_ID], 
	   RC.ID as [REQUIREDCOVERAGE_ID]
FROM FORCE_PLACED_CERTIFICATE FPC 
JOIN CPI_ACTIVITY CPI ON FPC.CPI_QUOTE_ID = CPI.CPI_QUOTE_ID AND CPI.TYPE_CD = 'I'
JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPC.ID = FPCRCR.FPC_ID AND FPCRCR.PURGE_DT IS NULL
JOIN REQUIRED_COVERAGE RC ON FPCRCR.REQUIRED_COVERAGE_ID = RC.ID AND RC.PURGE_DT IS NULL 
JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID AND P.PURGE_DT IS NULL
JOIN COLLATERAL C on P.ID = C.PROPERTY_ID AND C.PURGE_DT IS NULL
JOIN LOAN L ON C.LOAN_ID = L.ID AND L.PURGE_DT IS NULL
JOIN LENDER LND on LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
JOIN OWNER_LOAN_RELATE OL on OL.LOAN_ID = L.ID and OL.PRIMARY_IN = 'Y' AND OL.PURGE_DT IS NULL
JOIN [OWNER] O on O.ID = OL.OWNER_ID AND O.PURGE_DT IS NULL
LEFT JOIN OWNER_LOAN_RELATE OLDBA ON OLDBA.LOAN_ID = L.ID AND OLDBA.OWNER_TYPE_CD = 'DBA' AND OLDBA.PURGE_DT IS NULL
LEFT JOIN [OWNER] ODBA on ODBA.ID = OLDBA.OWNER_ID AND ODBA.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AO on AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AM on AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
LEFT JOIN REF_CODE RC_IssueReason on RC_IssueReason.DOMAIN_CD = 'CPIActivityIssueReason' and RC_IssueReason.CODE_CD = CPI.REASON_CD 
left Join REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
LEFT JOIN REF_CODE RC_COVERAGETYPE on RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
LEFT JOIN PROCESS_LOG_ITEM PLI ON PLI.RELATE_ID = FPC.ID and PLI.RELATE_TYPE_CD like '%ForcePlacedCertificate%' AND PLI.PURGE_DT IS NULL and @DateInput = 0
LEFT JOIN EVALUATION_EVENT EE ON EE.ID = PLI.EVALUATION_EVENT_ID and @DateInput = 0
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
WHERE 1=1
AND L.LENDER_ID = @LenderID
AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM @BranchTable) OR @Branch IS NULL OR @Branch = '' OR @Branch = 'All')
AND (RC.TYPE_CD = @Coverage OR @Coverage = '1' OR @Coverage IS NULL OR @Coverage = 'All')
AND (@DateInput = 0 or (@DateInput = 1 and FPC.ISSUE_DT BETWEEN @FromDate AND @ToDate))
AND (@DateInput = 1 or (@DateInput = 0 and PLI.PROCESS_LOG_ID = @ProcessLogID AND EE.TYPE_CD = 'ISCT'))
AND fn_FCBD.loanType IS NOT NULL


Declare @sqlstring as nvarchar(1000)
If isnull(@FilterBySQL,'') <> '' 
Begin
  Select * into #t1 from #tmptable 
  truncate table #tmptable

  Set @sqlstring = N'Insert into #tmpTable
                     Select * from dbo.#t1 where ' + @FilterBySQL
  --print @sqlstring
  EXECUTE sp_executesql @sqlstring
End

IF ISNULL(@GroupBySQL,'') <> ''
BEGIN
Set @sqlstring = N'Update #tmpTable Set [REPORT_GROUPBY_TX] = ' + @GroupBySQL
EXECUTE sp_executesql @sqlstring
END

IF ISNULL(@SortBySQL,'') <> ''
BEGIN
Set @sqlstring = N'Update #tmpTable Set [REPORT_SORTBY_TX] = ' + @SortBySQL
EXECUTE sp_executesql @sqlstring
END

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


SELECT @RecordCount = COUNT(*) from #tmptable
IF @Report_History_ID IS NOT NULL
BEGIN
 Update [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML
Set RECORD_COUNT_NO = @RecordCount
where ID = @Report_History_ID    
END

Select * from #tmptable 

END

GO

