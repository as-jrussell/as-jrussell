USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_ExtractNewCollContract]    Script Date: 9/12/2016 7:35:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Report_ExtractNewCollContract] 
(	@ReportType as nvarchar(50)=NULL,
	@ReportConfig as varchar(50)=NULL,
	@Branch as nvarchar(max)=NULL,
	@Division as nvarchar(10)=NULL,
	@GroupByCode as nvarchar(50)=NULL,
	@SortByCode as nvarchar(50)=NULL,
	@Report_History_ID as bigint=NULL)	
AS
BEGIN
IF OBJECT_ID(N'tempdb..#tmpTable',N'U') IS NOT NULL
  DROP TABLE #tmpTable
IF OBJECT_ID(N'tempdb..#tmpfilter',N'U') IS NOT NULL
  DROP TABLE #tmpfilter

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
Declare @FilterByCode as nvarchar(100)
Declare @RecordCount as bigint
Declare @sqlstring as nvarchar(3000)
DECLARE @DEBUGGING as char(1) = 'F' 

IF @DEBUGGING = 'T'
BEGIN
	SET @DocumentID =  4096854 
	SET @ReportConfigID = 724
END
ELSE
BEGIN
	IF @Report_History_ID is not NULL
		Begin
			SELECT @DocumentID=REPORT_DATA_XML.value('(//ReportData/Report/DocumentID/@value)[1]', 'bigint'),
			@ReportConfigID = REPORT_DATA_XML.value('(//ReportData/Report/ReportConfigID/@value)[1]', 'bigint')
			FROM REPORT_HISTORY WHERE ID = @Report_History_ID
		End
END

--get the actual date the file posted to UniTrac
SELECT @RunDate = MAX(WIA.UPDATE_DT) FROM WORK_ITEM WI JOIN WORK_ITEM_ACTION WIA ON WI.ID =WIA.WORK_ITEM_ID
WHERE WI.RELATE_ID IN (SELECT MESSAGE_ID FROM [DOCUMENT] where ID = @DocumentID) AND  WIA.ACTION_CD = 'Import Completed'

DECLARE @TransactionID bigint = 0						
DECLARE @LoanUpdatesOnlyOnWI AS bit = NULL
SELECT @TransactionID = [TRANSACTION].ID,
	@LenderID = T2.Loc.value('(./LenderID)[1]','decimal'),
	@LoanUpdatesOnlyOnWI = ISNULL(T2.Loc.value('(./OptionLenderSummaryMatchResult/LoanUpdatesOnly)[1]', 'bit'), 0)
FROM [TRANSACTION] CROSS APPLY DATA.nodes('/Lender/Lender') As T2(Loc) WHERE DOCUMENT_ID = @DocumentID AND PURGE_DT IS NULL and isnull(RELATE_TYPE_CD,'') != 'INFA'


DECLARE @WorkItemID bigint = 0
	SELECT @WorkItemID = MAX(WI.ID) FROM WORK_ITEM WI
	WHERE  WI.RELATE_ID IN (SELECT MESSAGE_ID FROM [DOCUMENT] where ID = @DocumentID)
		AND WI.RELATE_TYPE_CD = 'LDHLib.Message' AND WI.PURGE_DT IS NULL

CREATE TABLE [dbo].[#tmpTable](
	[LOAN_BRANCHCODE_TX] [nvarchar](20) NULL,
	[LOAN_DIVISIONCODE_TX] [nvarchar](20) NULL,
	[LOAN_TYPE_TX] [nvarchar](1000) NULL,
	[REQUIREDCOVERAGE_CODE_TX] [nvarchar](30) NULL,
	[REQUIREDCOVERAGE_TYPE_TX] [nvarchar](1000) NULL,
--LOAN
	[LOAN_NUMBER_TX] [nvarchar](20) NOT NULL,
	[LOAN_NUMBERSORT_TX] [nvarchar](18) NULL,
	[LOAN_EFFECTIVE_DT] [datetime2] NULL,
	[LOAN_BALANCE_NO] [decimal](19, 2) NULL,					
	[LOAN_BALANCESORT_TX] [nvarchar](15) NULL,			
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
	[PROPERTY_DESCRIPTION_TX] [nvarchar](400) NULL,
	[COLLATERAL_VIN_TX] [nvarchar](18) NULL,					
	[EXTR_PROPERTY_DESCRIPTION_TX] [nvarchar](400) NULL,				
	[EXTR_COLLATERAL_VIN_TX] [nvarchar](18) NULL,					
--COVERAGE
	[COVERAGE_STATUS_TX] [nvarchar](1000) NULL,					
	[REQUIREDCOVERAGE_STATUSCODE] [nvarchar](4) NULL,
--IDs, STATUS
	[LOAN_ID] [bigint] NULL,
	[COLLATERAL_ID] [bigint] NULL,
	[PROPERTY_ID] [bigint] NULL,
	[REQUIREDCOVERAGE_ID] [bigint] NULL,	
	[CETD_ID] [bigint] NULL,
--LENDER FILE
	[EXTR_COVERAGE_STATUS_TX] [nvarchar](1000) NULL,			
	[EXTR_EXCEPTION] [nvarchar](1000) NULL,						
	[EXTR_RUN_DT] [datetime2](7) NULL,
	[WORK_ITEM_ID] [bigint] NULL,							
--PARAMETERS
	[REPORT_GROUPBY_TX] [nvarchar](1000) NULL,
	[REPORT_SORTBY_TX] [nvarchar](1000) NULL,
	[REPORT_HEADER_TX] [nvarchar](1000) NULL,
	[REPORT_FOOTER_TX] [nvarchar](1000) NULL

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
from REF_CODE RC
Join REF_CODE_ATTRIBUTE RAD on RAD.DOMAIN_CD = RC.DOMAIN_CD and RAD.REF_CD = 'DEFAULT' and RAD.ATTRIBUTE_CD like 'FIL%'
left Join REF_CODE_ATTRIBUTE RA on RA.DOMAIN_CD = RC.DOMAIN_CD and RA.REF_CD = RC.CODE_CD and RA.ATTRIBUTE_CD = RAD.ATTRIBUTE_CD
left Join
  (
  Select CODE_TX,REPORT_CD,REPORT_DOMAIN_CD,REPORT_REF_ATTRIBUTE_CD,VALUE_TX from REPORT_CONFIG RC
  Join REPORT_CONFIG_ATTRIBUTE RCA on RCA.REPORT_CONFIG_ID = RC.ID
  ) Custom
   on Custom.CODE_TX = @ReportConfig and Custom.REPORT_DOMAIN_CD = RAD.DOMAIN_CD and Custom.REPORT_REF_ATTRIBUTE_CD = RAD.ATTRIBUTE_CD --and Custom.REPORT_CD = @ReportConfig
where RC.DOMAIN_CD = 'Report_Extract' and RC.CODE_CD = @ReportType


if @ReportConfig is NULL or @ReportConfig = '' or @ReportConfig = '0000'
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
		SELECT @GroupBySQL=GROUP_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportConfig
	ELSE
		SELECT @GroupBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_GroupBy' AND CODE_CD = @GroupByCode
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
  End


INSERT INTO [#tmpTable](
[LOAN_BRANCHCODE_TX]
,[LOAN_DIVISIONCODE_TX]
,[LOAN_TYPE_TX]
--LOAN
,[LOAN_NUMBER_TX]
,[LOAN_NUMBERSORT_TX]
,[LOAN_EFFECTIVE_DT]
,[LOAN_BALANCE_NO]
,[LOAN_BALANCESORT_TX]
--LENDER
,[LENDER_CODE_TX]
,[LENDER_NAME_TX]
--COLLATERAL
,[COLLATERAL_NUMBER_NO]
,[COLLATERAL_CODE_TX]
,[LENDER_COLLATERAL_CODE_TX]
,[FILE_LENDER_COLLATERAL_CODE_TX]
,[LOAN_STATUSCODE]
,[COLLATERAL_STATUSCODE]
--OWNER
,[OWNER_LASTNAME_TX]
,[OWNER_FIRSTNAME_TX]
,[OWNER_MIDDLEINITIAL_TX]
,[OWNER_NAME_TX]
,[OWNER_LINE1_TX]
,[OWNER_LINE2_TX]
,[OWNER_STATE_TX]
,[OWNER_CITY_TX]
,[OWNER_ZIP_TX]
--PROPERTY
,[PROPERTY_TYPE_CD]
,[PROPERTY_DESCRIPTION_TX]
,[COLLATERAL_VIN_TX]
,[EXTR_PROPERTY_DESCRIPTION_TX]
,[EXTR_COLLATERAL_VIN_TX]
--COVERAGE
,[COVERAGE_STATUS_TX]
--IDs, STATUS
,[LOAN_ID]
,[COLLATERAL_ID]
,[PROPERTY_ID]
,[CETD_ID]
--LENDER FILE
,[EXTR_COVERAGE_STATUS_TX]
,[EXTR_EXCEPTION]
,[EXTR_RUN_DT]
,[WORK_ITEM_ID]				
)
SELECT 
L.BRANCH_CODE_TX AS [LOAN_BRANCHCODE_TX],
COALESCE(L.DIVISION_CODE_TX, '') AS [LOAN_DIVISIONCODE_TX],	
ISNULL(RCDiv.MEANING_TX,RC_SC.DESCRIPTION_TX) AS [LOAN_TYPE_TX],
--LOAN
ISNULL(L.NUMBER_TX,'') AS [LOAN_NUMBER_TX],
CASE WHEN ISNULL(L.NUMBER_TX,'') = '' 
	THEN '' 
	ELSE SUBSTRING(@FillerZero, 1, 18 - len(ISNULL(L.NUMBER_TX,''))) 
		+ CAST(ISNULL(L.NUMBER_TX,'') AS nvarchar(18)) END AS [LOAN_NUMBERSORT_TX],
CAST(L.EFFECTIVE_DT AS datetime2(7)) AS [LOAN_EFFECTIVE_DT],
ISNULL(LETD.LoanBalance_TX, L.BALANCE_AMOUNT_NO) AS [LOAN_BALANCE_NO],
SUBSTRING(@FillerZero, 1, 15 - len(L.BALANCE_AMOUNT_NO)) + CAST(L.BALANCE_AMOUNT_NO AS nvarchar(15)) AS [LOAN_BALANCESORT_TX],
--LENDER
LND.CODE_TX AS [LENDER_CODE_TX],
LND.NAME_TX AS [LENDER_NAME_TX],	
--COLLATERAL
C.COLLATERAL_NUMBER_NO AS [COLLATERAL_NUMBER_NO],
ISNULL(CC.CODE_TX,CETD.CollateralCode_TX) AS [COLLATERAL_CODE_TX],
ISNULL(C.LENDER_COLLATERAL_CODE_TX,CETD.LenderCollateralCode_TX) AS [LENDER_COLLATERAL_CODE_TX],
ISNULL(CETD.LenderCollateralCode_TX,'') AS [FILE_LENDER_COLLATERAL_CODE_TX],
L.STATUS_CD AS [LOAN_STATUSCODE],
C.STATUS_CD AS [COLLATERAL_STATUSCODE],
--OWNER	
O.LAST_NAME_TX AS [OWNER_LASTNAME_TX],
O.FIRST_NAME_TX AS [OWNER_FIRSTNAME_TX],
ISNULL(O.MIDDLE_INITIAL_TX,'') AS [OWNER_MIDDLEINITIAL_TX],
RTRIM(ISNULL(O.LAST_NAME_TX,'') + ', ' 
	+ ISNULL(O.FIRST_NAME_TX,'') + ' ' 
	+ ISNULL(O.MIDDLE_INITIAL_TX,'')) AS [OWNER_NAME_TX],
ISNULL(AO.LINE_1_TX,'') AS [OWNER_LINE1_TX],
ISNULL(AO.LINE_2_TX,'') AS [OWNER_LINE2_TX],
ISNULL(AO.STATE_PROV_TX,'') AS [OWNER_STATE_TX],
ISNULL(AO.CITY_TX,'') AS [OWNER_CITY_TX],
ISNULL(AO.POSTAL_CODE_TX,'') AS [OWNER_ZIP_TX],
--PROPERTY
RCA_PROP.VALUE_TX AS [PROPERTY_TYPE_CD],
dbo.fn_GetPropertyDescription (C.ID, 'N') AS [PROPERTY_DESCRIPTION_TX],
p.VIN_TX as [COLLATERAL_VIN_TX],
CASE
	WHEN ISNULL(LETD.DivisionCode_TX,'0') in ('3','8') OR CETD.CollateralType_TX in ('VEH','BOAT')
		THEN COALESCE(CETD.VehicleYear_TX,'') + ' ' + COALESCE(CETD.VehicleMake_TX,'') + '/' + COALESCE(CETD.VehicleModel_TX,'')
	WHEN ISNULL(LETD.DivisionCode_TX,'0') in ('7','9') OR CETD.CollateralType_TX in ('EQ')
		THEN CETD.EquipmentDescription_TX
	WHEN ISNULL(LETD.DivisionCode_TX,'0') in ('4','10') OR CETD.CollateralType_TX not in ('','VEH','BOAT','EQ')
			THEN ISNULL(CETD.RealEstateLine1_TX, '') + CHAR(13) + CHAR(10) + ISNULL(CETD.RealEstateLine2_TX + CHAR(13) + CHAR(10), '') + ISNULL(CETD.RealEstateCity_TX, '') + ', ' 
				+ ISNULL(CETD.RealEstateState_TX, '') + ' ' + ISNULL(CETD.RealEstateZip_TX, '')
	ELSE ''
END AS [EXTR_PROPERTY_DESCRIPTION],
cetd.VehicleVIN_TX as [EXTR_COLLATERAL_VIN_TX],
--COVERAGE
NULL AS [COVERAGE_STATUS],
--IDs,STATUS
L.ID AS [LOAN_ID],
C.ID AS [COLLATERAL_ID],
P.ID AS [PROPERTY_ID],
CETD.ID AS [CETD_ID],
--LENDER FILE
'New Collateral' as [EXTR_COVERAGE_STATUS_TX],
--needs to be multiline
	CASE WHEN (ISNULL(CETD.CM_CPIInplace_IN,'N') = 'Y' OR ISNULL(LETD.LM_CPIInplace_IN,'N') = 'Y') THEN '-CPI InForce' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN (ISNULL(CETD.CM_DescriptionChanged_IN ,'N') = 'Y' AND ISNULL(P.VIN_TX,'') <> ISNULL(CETD.VehicleVIN_TX,'')) 
		THEN '-Collateral Description Changed(Old VIN: ' + ISNULL(CETD.VehicleVIN_TX,'MISSING') + ')' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN (ISNULL(CETD.CM_DescriptionChanged_IN ,'N') = 'Y' AND ISNULL(P.VIN_TX,'') = ISNULL(CETD.VehicleVIN_TX,'')) 
		THEN '-Collateral Description Changed' + CHAR(13) + CHAR(10) ELSE '' END + 
	CASE WHEN ISNULL(LM_ReOccurance_IN,'N') = 'Y' THEN '-Loan Reoccurence' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN ISNULL(LM_EffectiveDateChanged_IN,'N') = 'Y'  
		THEN '-Effective Date Change(Old: ' + isnull(CONVERT(nvarchar(10),LM_EffectiveDate_DT,101),'MISSING') + ')' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN ISNULL(LM_BalanceIncrease_IN,'N') = 'Y'
		THEN '-Balance Increase(Old: ' + CONVERT(nvarchar(max), CONVERT(money,ISNULL(LETD.LM_Balance_TX,0)),1) + ')' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN (ISNULL(CETD.BadData_IN, 'N') = 'Y') THEN '-Bad Data' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN ISNULL(CETD.MultiCollateral_IN,'N') = 'Y' THEN '-Unable to Locate Collateral(s)' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN ISNULL(CETD.CM_PayoffRelease_IN,'N') = 'Y' THEN '-Paid off or Released' + CHAR(13) + CHAR(10) ELSE '' END + ''
 AS [EXTR_EXCEPTION],
 @RunDate as [EXTR_RUN_DT],
 @WorkItemID as [WORK_ITEM_ID]
from LOAN_EXTRACT_TRANSACTION_DETAIL LETD
JOIN LOAN L ON LETD.LM_MatchLoanId_TX = L.ID AND L.PURGE_DT IS NULL
JOIN LENDER LND on LND.ID = L.LENDER_ID and LND.PURGE_DT IS NULL
JOIN [COLLATERAL_EXTRACT_TRANSACTION_DETAIL] CETD ON CETD.TRANSACTION_ID = LETD.TRANSACTION_ID 
													  AND CETD.SEQUENCE_ID = LETD.SEQUENCE_ID 
													  AND CETD.PURGE_DT IS NULL 
LEFT JOIN COLLATERAL C ON L.ID = C.LOAN_ID AND C.PURGE_DT IS NULL
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
LEFT JOIN PROPERTY P ON C.PROPERTY_ID = P.ID AND P.PURGE_DT IS NULL
LEFT JOIN OWNER_LOAN_RELATE OL ON OL.LOAN_ID = L.ID AND OL.PRIMARY_IN = 'Y' AND OL.PURGE_DT IS NULL
LEFT JOIN [OWNER] O ON O.ID = OL.OWNER_ID AND O.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AO ON AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AM ON AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
LEFT JOIN REF_CODE RCDiv ON RCDiv.DOMAIN_CD = 'ContractType' AND RCDiv.CODE_CD = L.DIVISION_CODE_TX		
LEFT JOIN REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
LEFT JOIN REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
where LETD.TRANSACTION_ID= @TransactionID
and LM_MatchStatus_TX = 'Match'
and CETD.CM_MatchStatus_TX = 'New'
and (@LoanUpdatesOnlyOnWI = 1 OR L.EXTRACT_LOAN_UPDATE_ONLY_IN = 'Y') AND ISNULL(LM_IsDropZeroBalance_IN,'N') = 'N' 
and L.RECORD_TYPE_CD = 'G' and p.RECORD_TYPE_CD = 'G' 
ORDER BY L.ID, C.COLLATERAL_NUMBER_NO


IF ISNULL(@GroupBySQL,'') <> ''
BEGIN
Set @sqlstring = N'Update #tmpTable Set [REPORT_GROUPBY_TX] = ' + @GroupBySQL
EXECUTE sp_executesql @sqlstring
END

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
--print @RecordCount



IF @Report_History_ID IS NOT NULL
BEGIN
  Update [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML
  Set RECORD_COUNT_NO = @RecordCount
  where ID = @Report_History_ID
END

Select * from #tmptable

END


GO

