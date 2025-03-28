USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_PostingStatements]    Script Date: 6/17/2016 2:12:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_PostingStatements] 
	(@LenderCode as nvarchar(10) = NULL,
	@CarrierCode as nvarchar(20) = NULL, 
	@AccountingPeriod as nvarchar(15)=NULL,
	@DateRange as int=NULL,
	@DateRangeStart as datetime2(7)=NULL,
	@DateRangeEnd as datetime2(7)=NULL,
	@User as nvarchar(20),
	@SortByCode as nvarchar(50)=NULL,
	@FilterByCode as nvarchar(50)=NULL)	
	
AS
BEGIN
SET NOCOUNT ON
--Get rid of residual #temp tables
IF OBJECT_ID(N'tempdb..#tmptable',N'U') IS NOT NULL
  DROP TABLE #tmptable
IF OBJECT_ID(N'tempdb..#t1',N'U') IS NOT NULL
  DROP TABLE #t1

DECLARE @DEBUGGING AS VARCHAR(1) = 'F'
Declare @LenderID as bigint

DECLARE @StartDate as datetime2(7) 
DECLARE @EndDate as datetime2 (7)

DECLARE @ReportConfig as nvarchar (15) = null
Declare @SortBySQL as varchar(1000)
Declare @FilterBySQL as varchar(1000)
Declare @FillerZero as varchar(18)

SET @ReportConfig = 'POSTSTMT'
Set @FillerZero = '000000000000000000'
--Gets the start/end date of the account period
SET @StartDate = @DateRangeStart
SET @EndDate = DATEADD(D, 1, DATEDIFF(D, 0, @DateRangeEnd)) 	

Select @FilterBySQL=DESCRIPTION_TX from REF_CODE where DOMAIN_CD = 'Report_FilterBy' and CODE_CD = @FilterByCode    

Select @SortBySQL=DESCRIPTION_TX from REF_CODE where DOMAIN_CD = 'Report_SortBy' and CODE_CD = @SortByCode
 

 
CREATE TABLE [dbo].[#tmptable](
--LOAN
	[LOAN_NUMBER_TX] [nvarchar](18) NOT NULL,
	[LOAN_NUMBERSORT_TX] [nvarchar](18) NULL,
--LENDER
	[LENDER_CODE_TX] [nvarchar](10) NULL,	
	[LENDER_NAME_TX] [nvarchar](40) NULL,
--OWNER
	[OWNER_LASTNAME_TX] [nvarchar](30) NULL,
	[OWNER_FIRSTNAME_TX] [nvarchar](30) NULL,
	[OWNER_MIDDLEINITIAL_TX] [char](1) NULL,
	[OWNER_LINE1_TX] [nvarchar](100) NULL,
	[OWNER_LINE2_TX] [nvarchar](100) NULL,
	[OWNER_STATE_TX] [nvarchar](30) NULL,
	[OWNER_CITY_TX] [nvarchar](40) NULL,
	[OWNER_ZIP_TX] [nvarchar](30) NULL,
--COLLATERAL
	[COLLATERAL_NUMBER_NO] [int] NULL,
--CPI
	[INSCOMPANY_POLICY_NO] [nvarchar](30) NULL,
	[INSCOMPANY_EFF_DT] [datetime2](7) NULL,
	[INSCOMPANY_EFFDTSORT_TX] [nvarchar](8) NULL,
	[INSCOMPANY_EXP_DT] [datetime2](7) NULL,
	[INSCOMPANY_CAN_DT] [datetime2](7) NULL,
	[INSCOMPANY_EXPCXL_DT] [datetime2](7) NULL,
	[PAID_DT] [datetime2](7) NULL,
	[TRANS_DESC_TX] [nvarchar](30) NULL, 
	[CPI_ISSUEDPREMIUM_AMOUNT_NO] [decimal](18, 2) NULL,
	[CPI_CANCELLEDPREMIUM_AMOUNT_NO] [decimal](18, 2) NULL,
	[NET_VALUE_NO] [decimal](18, 2) NULL,
	[USER_TX] [nvarchar](50) NULL, 
	[CARRIER_CODE_TX] [nvarchar](20) NULL,
	[CARRIER_NAME_TX] [nvarchar](100) NULL,
	[VUT_POLICY_TYPE_TX] [nvarchar] (100) NULL,
	[COVERAGE_TYPE_TX] [nvarchar](100) NULL,
	[REQUIREDCOVERAGE_GROUP_TX] [nvarchar](30) NULL,
-- PARAMETERS
	[REPORT_SORTBY_TX] [nvarchar](1000) NULL
)

DECLARE @Query nvarchar(MAX)

SELECT @Query = 'Insert into #tmptable (
LOAN_NUMBER_TX, 
LOAN_NUMBERSORT_TX,
LENDER_CODE_TX,	
LENDER_NAME_TX,
--OWNER
OWNER_LASTNAME_TX, OWNER_FIRSTNAME_TX, OWNER_MIDDLEINITIAL_TX, 
OWNER_LINE1_TX, OWNER_LINE2_TX, OWNER_STATE_TX, OWNER_CITY_TX, OWNER_ZIP_TX,
COLLATERAL_NUMBER_NO,
INSCOMPANY_POLICY_NO,
INSCOMPANY_EFF_DT,
INSCOMPANY_EFFDTSORT_TX,
INSCOMPANY_EXP_DT,
PAID_DT,
TRANS_DESC_TX,
CPI_ISSUEDPREMIUM_AMOUNT_NO,
CPI_CANCELLEDPREMIUM_AMOUNT_NO,
NET_VALUE_NO,
USER_TX,
CARRIER_CODE_TX,
CARRIER_NAME_TX,
VUT_POLICY_TYPE_TX,
COVERAGE_TYPE_TX,
REQUIREDCOVERAGE_GROUP_TX
--REPORT_GROUPBY_TX
)
SELECT DISTINCT
	   fpc.LOAN_NUMBER_TX AS LOAN_NUMBER_TX, 
	   SUBSTRING(@FillerZero, 1, 18 - len(fpc.LOAN_NUMBER_TX)) + CAST(fpc.LOAN_NUMBER_TX AS nvarchar(18)) AS LoanNumberSort,
	   LND.CODE_TX AS LOAN_LENDERCODE_TX, 
	   LND.NAME_TX AS LENDER_NAME_TX,
	   
	   --OWNER
       fpc.LAST_NAME_TX, fpc.FIRST_NAME_TX, fpc.MIDDLE_INITIAL_TX,
       fpc.OWNER_LINE_1_TX as OwnerLine1, fpc.OWNER_LINE_2_TX as OwnerLine2,
       fpc.OWNER_STATE_TX as OwnerState, fpc.OWNER_CITY_TX as OwnerCity, fpc.OWNER_POSTAL_CODE_TX as OwnerZIP,

	   --COLLATERAL
	   fpc.COLLATERAL_NUMBER_NO AS COLLATERAL_NUMBER_NO,
	   --CPI
       fpc.FPC_NUMBER_TX as INSCOMPANY_POLICY_NO,                            --CPIPolicyNum, 
       fpc.FPC_EFF_DT as INSCOMPANY_EFF_DT,									 --CPIPolicyEff, 
       CONVERT(nvarchar(8), fpc.FPC_EFF_DT, 112) as INSCOMPANY_EFFDTSORT_TX, --CPIPolicyEffSort,
       fpc.FPC_EX_DT as INSCOMPANY_EXP_DT,									 --CPIPolicyExp, 
       FTX.TXN_DT AS PAID_DT,
       CASE WHEN FTX.TXN_TYPE_CD = ''P'' THEN ''Issue Posted'' 
			ELSE ''Cancel Posted'' END as TRANS_DESC_TX,
       NET_TOTALS.CPI_ISSUEDPREMIUM_AMOUNT_NO,
       NET_TOTALS.CPI_CANCELLEDPREMIUM_AMOUNT_NO,
       -NET_TOTALS.NET_VALUE_NO as NET_VALUE_NO,
       COALESCE(LFT.UPDATE_USER_TX, FTX.UPDATE_USER_TX) as USER_TX,
       CR.CODE_TX AS CARRIER_CODE_TX,
       CR.NAME_TX AS CARRIER_NAME_TX,
       '''' AS VUT_POLICY_TYPE_TX,
	   fpc.RC_TYPE_TX as COVERAGE_TYPE_TX,
	   RCA_COV.VALUE_TX AS [REQUIREDCOVERAGE_GROUP_TX]
	   --LND.CODE_TX AS REPORT_GROUPBY_TX
FROM FINANCIAL_TXN ftx
  join ForcePlacedCertificateView fpc on fpc.FPC_ID = ftx.FPC_ID
  join LENDER lnd on fpc.LENDER_ID = lnd.ID and lnd.PURGE_DT IS NULL
  left join LENDER_FINANCIAL_TXN lft ON lft.ID = ftx.LFT_ID AND lft.PURGE_DT IS NULL
  left Join CARRIER cr on fpc.CARRIER_ID = cr.ID and cr.PURGE_DT IS NULL
  left Join REF_CODE_ATTRIBUTE RCA_COV on RCA_COV.ATTRIBUTE_CD = ''CoverageReportGroup'' AND RCA_COV.DOMAIN_CD = ''Coverage'' AND RCA_COV.REF_CD = fpc.RC_CODE_TX AND RCA_COV.PURGE_DT IS NULL

  OUTER APPLY (
      SELECT ABS(SUM(AMOUNT_NO))AS NET_VALUE_NO,
             ABS(SUM(CASE WHEN FTX.TXN_TYPE_CD = ''P'' THEN AMOUNT_NO ELSE 0 END)) AS CPI_ISSUEDPREMIUM_AMOUNT_NO,
             ABS(SUM(CASE WHEN FTX.TXN_TYPE_CD = ''CP'' THEN AMOUNT_NO ELSE 0 END)) AS CPI_CANCELLEDPREMIUM_AMOUNT_NO
      FROM  FINANCIAL_TXN FTX 
      WHERE FTX.FPC_ID = FPC.FPC_ID
            AND FTX.TXN_TYPE_CD IN (''P'', ''CP'')
            AND FTX.PURGE_DT IS NULL
  ) NET_TOTALS

WHERE
  FTX.TXN_DT BETWEEN @StartDate AND @EndDate and ftx.TXN_TYPE_CD IN (''P'', ''CP'') and ftx.PURGE_DT IS NULL
'
+ CASE WHEN ISNULL(@LenderCode, '<All>') <> '<All>' THEN ' AND LND.CODE_TX = @LenderCode' ELSE '' END
+ CASE when ISNULL(@CarrierCode, '<All>') <> '<All>' THEN ' AND CR.CODE_TX = @CarrierCode' ELSE '' END
+ CASE WHEN ISNULL(@User, '<All>') <> '<All>' THEN ' AND COALESCE(LFT.UPDATE_USER_TX, FTX.UPDATE_USER_TX) = @User' ELSE '' END

EXEC sp_executesql @Query, 
				N'@StartDate datetime2(7), @EndDate datetime2(7) , @LenderCode nvarchar(10), @CarrierCode nvarchar(20),  @User nvarchar(20), @FillerZero varchar(18)', 
				@StartDate, @EndDate, @LenderCode, @CarrierCode, @User, @FillerZero

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


IF ISNULL(@SortBySQL,'') <> ''
BEGIN
Set @sqlstring = N'Update #tmpTable Set [REPORT_SORTBY_TX] = ' + @SortBySQL
EXECUTE sp_executesql @sqlstring
END

	Select * from #tmptable 

END

GO

