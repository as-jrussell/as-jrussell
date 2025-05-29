USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Report_VerifyDataLender]    Script Date: 4/7/2016 10:52:16 AM ******/
DROP PROCEDURE [dbo].[Report_VerifyDataLender]
GO

/****** Object:  StoredProcedure [dbo].[Report_VerifyDataLender]    Script Date: 4/7/2016 10:52:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_VerifyDataLender]		
	(@LenderCode as nvarchar(10)=NULL,
	@Branch as nvarchar(max)=NULL,
	@Division as nvarchar(10)=NULL,
	@Coverage as nvarchar(100)=NULL,
	@ReportType as nvarchar(50)=NULL,
	@SortByCode as nvarchar(50)=NULL,
	@FilterByCode as nvarchar(50)=NULL,
	@Report_History_ID as bigint=NULL,
	@GroupByCode nvarchar(max)=NULL)
AS
BEGIN

--Get rid of residual #temp tables
IF OBJECT_ID(N'tempdb..#tmptable',N'U') IS NOT NULL
  DROP TABLE #tmptable

DECLARE @BranchTable AS TABLE(ID int, STRVALUE nvarchar(30))
			INSERT INTO @BranchTable SELECT * FROM SplitFunction(@Branch, ',')  

Declare @LenderID as bigint
SELECT @LenderID=ID FROM LENDER WHERE CODE_TX = @LenderCode and PURGE_DT is null
Declare @RecordCount as bigint
set @RecordCount = 0

Declare @FillerZero as varchar(18)
Set @FillerZero = '000000000000000000'

Declare @SortBySQL as varchar(1000)
Declare @FilterBySQL as varchar(1000)
Declare @GroupBySQL as varchar(max)

IF @SortByCode IS NULL OR @SortByCode = ''
	SELECT @SortBySQL=SORT_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportType
ELSE
	SELECT @SortBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_SortBy' AND CODE_CD = @SortByCode

IF @FilterByCode IS NULL OR @FilterByCode = ''
	SELECT @FilterBySQL=FILTER_TX FROM REPORT_CONFIG WHERE CODE_TX = @ReportType
Else
	SELECT @FilterBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_FilterBy' AND CODE_CD = @FilterByCode

IF @GroupByCode IS NULL OR @GroupByCode = ''
	SELECT @GroupBySQL = ''
Else
	SELECT @GroupBySQL=DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'Report_GroupBy' AND CODE_CD = @GroupByCode


CREATE TABLE [dbo].[#tmptable](
	[WorkItemID] [bigint] NULL,
	[REPORT_GROUPBY_TX] [nvarchar](1000) NULL,
	[REPORT_SORTBY_TX] [nvarchar](1000) NULL,
	[DEFAULT_SORTBY_TX] [nvarchar](1000) NULL,
	[LENDER_CODE_TX] [nvarchar](10) NULL,	
	[LENDER_NAME_TX] [nvarchar](40) NULL,	
	[BorrowerName] [nvarchar](100) NULL,
	[OWNER_NAME_TX] [nvarchar](50) NULL,
	[LOAN_ID] [bigint] NULL,
	[LOAN_NUMBER_TX] [nvarchar](18) NOT NULL,
	[LOAN_NUMBERSORT_TX] [nvarchar](18) NULL,
	[LOAN_BRANCHCODE_TX] [nvarchar](20) NULL,
	[LOAN_DIVISIONCODE_TX] [nvarchar](20) NULL,
	[LOAN_TYPE_TX] [nvarchar](30) NULL,
	[LOAN_BALANCE_NO] [decimal](19, 2) NULL,
	[COLLATERAL_CODE_TX] [nvarchar](10) NULL,
	[LENDER_COLLATERAL_CODE_TX] [nvarchar](10) NULL,
	[LEGAL_STATUS_CODE_TX] [nvarchar](6) NULL,
	[PURPOSE_CODE_TX] [nvarchar](10) NULL,
	[COLLATERAL_LINE1_TX] [nvarchar](100) NULL,
	[COLLATERAL_LINE2_TX] [nvarchar](100) NULL,
	[COLLATERAL_CITY_TX] [nvarchar](40) NULL,
	[COLLATERAL_STATE_TX] [nvarchar](30) NULL,
	[COLLATERAL_ZIP_TX] [nvarchar](30) NULL,
	[COLLATERAL_YEAR_TX] [nvarchar](4) NULL,
	[COLLATERAL_MAKE_TX] [nvarchar](30) NULL,
	[COLLATERAL_MODEL_TX] [nvarchar](30) NULL,
	[COLLATERAL_VIN_TX] [nvarchar](18) NULL,
	[COLLATERAL_EQUIP_TX] [nvarchar](100) NULL,
   [PROPERTY_DESCRIPTION] [nvarchar] (800) NULL,
	[PropertyType] [nvarchar](20) NULL,
	[PROPERTY_TYPE_CD] [nvarchar](10) NULL,
	[REQUIREDCOVERAGE_TYPE_TX] [nvarchar](1000) NULL,
	[LOAN_STATUSCODE] [nvarchar] (2) NULL,
	[COLLATERAL_STATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_STATUSCODE] [nvarchar] (2) NULL,
	[REQUIREDCOVERAGE_STATUSMEANING_TX] [nvarchar](1000) NULL,
	[REQUIREDCOVERAGE_INSSTATUSCODE] [nvarchar] (4) NULL,
	[REQUIREDCOVERAGE_INSSUBSTATUSCODE] [nvarchar] (4) NULL,
	[ActionNeeded] [nvarchar](500) NULL,
	[CurrentValue] [nvarchar](500) NULL,
	[VerifyDataComment] [nvarchar](MAX) NULL,
	[PROPERTY_ID] [bigint] NULL,
	[COLLATERAL_ID] [bigint] NULL,
	[RC_ID] [bigint] NULL
) ON [PRIMARY]

Insert into #tmptable (WorkItemID, REPORT_GROUPBY_TX, DEFAULT_SORTBY_TX,
						LENDER_CODE_TX, LENDER_NAME_TX, BorrowerName, OWNER_NAME_TX,
						LOAN_ID, LOAN_NUMBER_TX, LOAN_NUMBERSORT_TX, LOAN_BRANCHCODE_TX, LOAN_DIVISIONCODE_TX, LOAN_TYPE_TX,
						LOAN_BALANCE_NO, COLLATERAL_CODE_TX, LENDER_COLLATERAL_CODE_TX, LEGAL_STATUS_CODE_TX, PURPOSE_CODE_TX, 
						COLLATERAL_LINE1_TX, COLLATERAL_LINE2_TX, COLLATERAL_CITY_TX, COLLATERAL_STATE_TX, COLLATERAL_ZIP_TX,
						COLLATERAL_YEAR_TX, COLLATERAL_MAKE_TX, COLLATERAL_MODEL_TX, COLLATERAL_VIN_TX, COLLATERAL_EQUIP_TX, PROPERTY_DESCRIPTION, PropertyType, PROPERTY_TYPE_CD,
						REQUIREDCOVERAGE_TYPE_TX, LOAN_STATUSCODE, COLLATERAL_STATUSCODE, 
						REQUIREDCOVERAGE_STATUSCODE, REQUIREDCOVERAGE_STATUSMEANING_TX, REQUIREDCOVERAGE_INSSTATUSCODE, REQUIREDCOVERAGE_INSSUBSTATUSCODE,
						ActionNeeded, CurrentValue, VerifyDataComment, PROPERTY_ID,COLLATERAL_ID,RC_ID
)

SELECT
		WI.ID as WorkItemID, @GroupByCode AS REPORT_GROUPBY_TX,
		CONVERT(nvarchar(8), WI.CREATE_DT, 112) + '/' + CAST(WI.ID AS nvarchar(20)) AS DEFAULT_SORTBY_TX,
		WI.CONTENT_XML.value('(//Content/Lender/Code)[1]', 'varchar(10)') as LENDER_CODE_TX,
		WI.CONTENT_XML.value('(//Content/Lender/Name)[1]', 'varchar(40)') as LENDER_NAME_TX,
		WI.CONTENT_XML.value('(//Content/Owner/Name)[1]', 'varchar(100)') as BorrowerName,
		CASE WHEN ISNULL(ODBA.NAME_TX,'') = '' THEN ODBA.LAST_NAME_TX ELSE ODBA.NAME_TX END AS OWNER_NAME_TX,
		WI.CONTENT_XML.value('(//Content/Loan/Id)[1]', 'bigint') as LOAN_ID,
		WI.CONTENT_XML.value('(//Content/Loan/Number)[1]', 'varchar(18)') as LOAN_NUMBER_TX,
		SUBSTRING(@FillerZero, 1, 18 - len(L.NUMBER_TX)) + CAST(L.NUMBER_TX AS nvarchar(18)) AS [LOAN_NUMBERSORT_TX],
		WI.CONTENT_XML.value('(//Content/Loan/Branch)[1]', 'varchar(10)') as LOAN_BRANCHCODE_TX,
		CASE WHEN 
			ISNULL(WI.CONTENT_XML.value('(//Content/Loan/Division)[1]', 'varchar(10)'),'') = ''
			THEN '0'
			ELSE WI.CONTENT_XML.value('(//Content/Loan/Division)[1]', 'varchar(10)')
		END	as LOAN_DIVISIONCODE_TX,
		ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as LOAN_TYPE_TX,
		WI.CONTENT_XML.value('(//Content/Loan/Balance)[1]', 'decimal(19, 2)') as LOAN_BALANCE_NO,
		CC.CODE_TX as COLLATERAL_CODE_TX, C.LENDER_COLLATERAL_CODE_TX, C.LEGAL_STATUS_CODE_TX, C.PURPOSE_CODE_TX,
		CASE WHEN ISNULL(P.ID,'') <> ''
			THEN AM.LINE_1_TX
			ELSE WI.CONTENT_XML.value('(//Content/Property/AddressLine1)[1]', 'varchar(100)')
		END as COLLATERAL_LINE1_TX,
		CASE WHEN ISNULL(P.ID,'') <> ''
			THEN AM.LINE_2_TX
			ELSE WI.CONTENT_XML.value('(//Content/Property/AddressLine2)[1]', 'varchar(100)')
		END as COLLATERAL_LINE2_TX,
		CASE WHEN ISNULL(P.ID,'') <> ''
			THEN AM.CITY_TX
			ELSE WI.CONTENT_XML.value('(//Content/Property/City)[1]', 'varchar(40)')
		END as COLLATERAL_CITY_TX,
		CASE WHEN ISNULL(P.ID,'') <> ''
			THEN AM.STATE_PROV_TX
			ELSE WI.CONTENT_XML.value('(//Content/Property/State)[1]', 'varchar(30)')
		END as COLLATERAL_STATE_TX,
		CASE WHEN ISNULL(P.ID,'') <> ''
			THEN AM.POSTAL_CODE_TX
			ELSE WI.CONTENT_XML.value('(//Content/Property/PostalCode)[1]', 'varchar(30)')
		END as COLLATERAL_ZIP_TX,
		CASE WHEN ISNULL(P.ID,'') <> ''
			THEN P.YEAR_TX
			ELSE WI.CONTENT_XML.value('(//Content/Property/Year)[1]', 'varchar(4)')
		END as COLLATERAL_YEAR_TX,
		CASE WHEN ISNULL(P.ID,'') <> ''
			THEN P.MAKE_TX
			ELSE WI.CONTENT_XML.value('(//Content/Property/Make)[1]', 'varchar(30)')
		END as COLLATERAL_MAKE_TX,
		CASE WHEN ISNULL(P.ID,'') <> ''
			THEN P.MODEL_TX
			ELSE WI.CONTENT_XML.value('(//Content/Property/Model)[1]', 'varchar(30)')
		END as COLLATERAL_MODEL_TX,
		CASE WHEN ISNULL(P.ID,'') <> ''
			THEN P.VIN_TX
			ELSE WI.CONTENT_XML.value('(//Content/Property/VIN)[1]', 'varchar(18)')
		END as COLLATERAL_VIN_TX,
		'' as COLLATERAL_EQUIP_TX,
      dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION,
		WI.CONTENT_XML.value('(//Content/Collateral/Type)[1]', 'varchar(20)') as PropertyType,
		ISNULL(RCA_PROP.VALUE_TX,WI.CONTENT_XML.value('(//Content/Collateral/Type)[1]', 'varchar(20)')) AS [PROPERTY_TYPE_CD],
     	ISNULL(RC_COVERAGETYPE.MEANING_TX, WI.CONTENT_XML.value('(//Content/Coverage/Type)[1]', 'varchar(30)')) as REQUIREDCOVERAGE_TYPE_TX,
		L.STATUS_CD as LOAN_STATUSCODE, C.STATUS_CD as COLLATERAL_STATUSCODE, RC.STATUS_CD as REQUIREDCOVERAGE_STATUSCODE, 
		ISNULL(RC_INSTAT.MEANING_TX, WI.CONTENT_XML.value('(//Content/Coverage/InsuranceStatus)[1]', 'varchar(30)')) as REQUIREDCOVERAGE_STATUSMEANING_TX,
		RC.SUMMARY_STATUS_CD as REQUIREDCOVERAGE_INSSTATUSCODE, RC.SUMMARY_SUB_STATUS_CD as REQUIREDCOVERAGE_INSSUBSTATUSCODE,
		'Verify ' + T2.Loc.value('@FieldDisplayName[1]','nvarchar(500)') as ActionNeeded,
		T2.Loc.value('@UTValue[1]','nvarchar(500)') as CurrentValue,
		'' as VerifyDataComment,
		ISNULL(P.ID, WI.CONTENT_XML.value('(//Content/Property/Id)[1]', 'bigint')) AS PROPERTY_ID,
		C.ID AS COLLATERAL_ID,
		ISNULL(RC.ID,WI.CONTENT_XML.value('(//Content/Coverage/Id)[1]', 'bigint'))  AS RC_ID
FROM WORK_ITEM WI 
		CROSS APPLY CONTENT_XML.nodes('/Content/VerifyData/Detail') as T2(Loc) 
		JOIN WORKFLOW_DEFINITION WD on WD.ID = WI.WORKFLOW_DEFINITION_ID and WD.DESCRIPTION_TX like '%verify%' AND WD.PURGE_DT IS NULL
		join LOAN L on WI.CONTENT_XML.value('(//Content/Loan/Id)[1]', 'bigint') = L.ID and L.PURGE_DT IS NULL
		LEFT JOIN PROPERTY P_DETAIL on T2.Loc.value('(.[@RelateClassName="Allied.UniTrac.Property"]/@RelateId)[1]', 'bigint') = P_DETAIL.ID and P_DETAIL.PURGE_DT IS NULL
		LEFT JOIN COLLATERAL C_DETAIL on T2.Loc.value('(.[@RelateClassName="Allied.UniTrac.Collateral"]/@RelateId)[1]', 'bigint') = C_DETAIL.ID and C_DETAIL.PURGE_DT IS NULL
		LEFT JOIN REQUIRED_COVERAGE RC on T2.Loc.value('(.[@RelateClassName="Allied.UniTrac.RequiredCoverage"]/@RelateId)[1]', 'bigint') = RC.ID AND RC.PURGE_DT IS NULL
      OUTER APPLY
      (
         SELECT TOP 1 COLL.ID AS COLL_ID , COLL.PROPERTY_ID AS PROPERTY_ID 
         FROM COLLATERAL COLL JOIN PROPERTY PR ON PR.ID = COLL.PROPERTY_ID
         WHERE COLL.LOAN_ID = L.ID AND COLL.PURGE_DT IS NULL AND PR.PURGE_DT IS NULL 
         ORDER BY CASE PR.RECORD_TYPE_CD WHEN 'G' THEN 1 WHEN 'A' THEN 2 ELSE 3 END ASC,
                  CASE WHEN COLL.STATUS_CD = 'U' OR COLL.EXTRACT_UNMATCH_COUNT_NO > 0 THEN 3							    
							  WHEN COLL.STATUS_CD = 'A' THEN 1	ELSE 2 END ASC,	
                       COLL.LOAN_BALANCE_NO DESC, COLL.CREATE_DT ASC
      ) AS CL
		LEFT JOIN PROPERTY P ON P.ID = COALESCE(P_DETAIL.ID, C_DETAIL.PROPERTY_ID, RC.PROPERTY_ID, CL.PROPERTY_ID) AND P.PURGE_DT IS NULL
		LEFT JOIN COLLATERAL C ON (C.ID = C_DETAIL.ID OR C.PROPERTY_ID = P_DETAIL.ID OR C.PROPERTY_ID = RC.PROPERTY_ID OR 
                 (C.ID = CL.COLL_ID AND C_DETAIL.ID IS NULL AND P_DETAIL.ID IS NULL AND RC.PROPERTY_ID IS NULL)) AND C.PURGE_DT IS NULL
		left Join [OWNER_ADDRESS] AM on AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
		LEFT JOIN OWNER_LOAN_RELATE OLDBA ON OLDBA.LOAN_ID = L.ID AND OLDBA.OWNER_TYPE_CD = 'DBA' AND OLDBA.PURGE_DT IS NULL
		LEFT JOIN [OWNER] ODBA on ODBA.ID = OLDBA.OWNER_ID AND ODBA.PURGE_DT IS NULL
		LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
		LEFT JOIN REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = WI.CONTENT_XML.value('(//Content/Loan/Division)[1]', 'varchar(2)') 
		left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
		left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
		LEFT JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
		LEFT JOIN REF_CODE RC_INSTAT ON RC_INSTAT.DOMAIN_CD = 'RequiredCoverageInsStatus' AND RC_INSTAT.CODE_CD = RC.SUMMARY_STATUS_CD
      CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
WHERE  
		L.RECORD_TYPE_CD = 'G' AND
		(WI.CONTENT_XML.value('(//Content/Lender/Id)[1]', 'int') = @LenderID or @LenderID is NULL)
		AND 
		(WI.CONTENT_XML.value('(//Content/Loan/Branch)[1]', 'varchar(20)') IN (SELECT STRVALUE FROM @BranchTable) or @Branch = '1' or @Branch is NULL)
		AND 
		(RC.TYPE_CD = @Coverage OR @Coverage = '1' OR @Coverage  = '' OR @Coverage is NULL)
		AND WI.STATUS_CD NOT IN ('Complete', 'Withdrawn', 'Error')
		AND WI.USER_ROLE_CD = 'Lender'
		AND WI.PURGE_DT IS NULL
		AND WI.DELAY_UNTIL_DT IS NULL
		and T2.Loc.value('@Checked[1]','nvarchar(10)') = 'true'
      AND fn_FCBD.loanType IS NOT NULL
--select * from #tmptable

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

Set @sqlstring = N'Update #tmpTable Set [REPORT_SORTBY_TX] = ' + @SortBySQL
EXECUTE sp_executesql @sqlstring

if isnull(@GroupBySQL,'') <> ''
BEGIN
Set @sqlstring = N'Update #tmpTable Set [REPORT_GROUPBY_TX] = ' + @GroupBySQL
EXECUTE sp_executesql @sqlstring
END

DECLARE @combinedString VARCHAR(MAX)
declare @workitemID bigint

DECLARE Comment_Cursor CURSOR FOR
select WorkItemID from #tmptable 
OPEN Comment_Cursor
FETCH NEXT FROM Comment_Cursor into @workitemID
WHILE @@FETCH_STATUS = 0
   BEGIN
		SET @combinedString=NULL
		select @combinedString = COALESCE(@combinedString, '') + ACTION_NOTE_TX + CHAR(13) + CHAR(10) 
		FROM WORK_ITEM_ACTION 
		WHERE WORK_ITEM_ID = @workitemID 
		and ACTION_NOTE_TX is not null and ACTION_NOTE_TX != '' and ACTION_NOTE_TX not like '%system%'
		and ACTION_CD like '%note%'    
		
		UPDATE #tmptable 
		SET  VerifyDataComment = ISNULL(@combinedString,'') WHERE WorkItemID = @workitemID
		
		--SELECT @combinedString as StringValue
		FETCH NEXT FROM Comment_Cursor into @workitemID
	END
CLOSE Comment_Cursor
DEALLOCATE Comment_Cursor


SELECT @RecordCount = COUNT(DISTINCT LOAN_ID) from #tmptable 
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

