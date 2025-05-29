USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Report_VerifyDataLender]    Script Date: 7/29/2016 9:02:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_VerifyDataLender]		
--declare
	@LenderCode as nvarchar(10)=NULL,
	@Branch as nvarchar(max)=NULL,
	@Division as nvarchar(10)=NULL,
	@Coverage as nvarchar(100)=NULL,
	@ReportType as nvarchar(50)='VRFYDATA',
	@SortByCode as nvarchar(50)=NULL,
	@FilterByCode as nvarchar(50)=NULL,
	@Report_History_ID as bigint=NULL,
	@GroupByCode nvarchar(max)=NULL
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


SELECT 
		wi.ID AS workitem_id, 
		l.ID as loan_id, 
		l.NUMBER_TX, 
		T2.Loc.value('(@RelateId)[1]', 'bigint') AS RelateId, 
		T2.Loc.value('(@RelateClassName)[1]', 'nvarchar(50)') AS RelateType, 
		--T2.Loc.value('(@Checked)[1]', 'nvarchar(5)') AS Checked ,
		T2.Loc.value('(@FieldDisplayName)[1]', 'nvarchar(100)') AS FieldDisplayName,
		T2.Loc.value('(@UTValue)[1]', 'nvarchar(100)') AS UTValue,
		ldr.CODE_TX as LENDER_CODE_TX,
		ldr.NAME_TX as LENDER_NAME_TX,
		WI.CONTENT_XML.value('(//Content/Owner/Name)[1]', 'varchar(100)') as BorrowerName,
		l.BRANCH_CODE_TX AS LOAN_BRANCHCODE_TX,
		l.DIVISION_CODE_TX as LOAN_DIVISIONCODE_TX,
		SUBSTRING(@FillerZero, 1, 18 - len(L.NUMBER_TX)) + CAST(L.NUMBER_TX AS nvarchar(18)) AS [LOAN_NUMBERSORT_TX],
		CONVERT(nvarchar(8), WI.CREATE_DT, 112) + '/' + CAST(WI.ID AS nvarchar(20)) AS DEFAULT_SORTBY_TX,
		l.BALANCE_AMOUNT_NO as LOAN_BALANCE_NO,
		WI.CONTENT_XML.value('(//Content/Property/AddressLine1)[1]', 'varchar(100)') as TempCOLLATERAL_LINE1_TX,
		WI.CONTENT_XML.value('(//Content/Property/AddressLine2)[1]', 'varchar(100)') as TempCOLLATERAL_LINE2_TX,
		WI.CONTENT_XML.value('(//Content/Property/City)[1]', 'varchar(40)') as TempCOLLATERAL_CITY_TX,
		WI.CONTENT_XML.value('(//Content/Property/State)[1]', 'varchar(30)')as TempCOLLATERAL_STATE_TX,
		WI.CONTENT_XML.value('(//Content/Property/PostalCode)[1]', 'varchar(30)') as TempCOLLATERAL_ZIP_TX,
		WI.CONTENT_XML.value('(//Content/Property/Year)[1]', 'varchar(4)') as TempCOLLATERAL_YEAR_TX,
		WI.CONTENT_XML.value('(//Content/Property/Make)[1]', 'varchar(30)') as TempCOLLATERAL_MAKE_TX,
		WI.CONTENT_XML.value('(//Content/Property/Model)[1]', 'varchar(30)') as TempCOLLATERAL_MODEL_TX,
		WI.CONTENT_XML.value('(//Content/Property/VIN)[1]', 'varchar(18)') as TempCOLLATERAL_VIN_TX,
		WI.CONTENT_XML.value('(//Content/Collateral/Type)[1]', 'varchar(20)') as TempPropertyType,
		WI.CONTENT_XML.value('(//Content/Collateral/Type)[1]', 'varchar(20)') AS TempPROPERTY_TYPE_CD,
     	WI.CONTENT_XML.value('(//Content/Coverage/Type)[1]', 'varchar(30)') as TempREQUIREDCOVERAGE_TYPE_TX,
		WI.CONTENT_XML.value('(//Content/Coverage/InsuranceStatus)[1]', 'varchar(30)') as TempREQUIREDCOVERAGE_STATUSMEANING_TX,
		L.STATUS_CD as LOAN_STATUSCODE,
		'Verify ' + T2.Loc.value('@FieldDisplayName[1]','nvarchar(500)') as ActionNeeded,
		T2.Loc.value('@UTValue[1]','nvarchar(500)') as CurrentValue,
		WI.CONTENT_XML.value('(//Content/Property/Id)[1]', 'bigint') AS TempPROPERTY_ID,
		WI.CONTENT_XML.value('(//Content/Coverage/Id)[1]', 'bigint')  AS TempRC_ID

INTO #tmp

FROM WORK_ITEM wi
JOIN LOAN l ON l.id = wi.RELATE_ID and wi.RELATE_TYPE_CD = 'Allied.UniTrac.Loan' AND l.PURGE_DT is NULL AND wi.PURGE_DT is null
JOIN lender ldr ON ldr.ID = l.LENDER_ID and ldr.CODE_TX = @LenderCode
	CROSS APPLY CONTENT_XML.nodes('/Content/VerifyData/Detail') as T2(Loc) 

WHERE wi.WORKFLOW_DEFINITION_ID = 8
	and L.RECORD_TYPE_CD = 'G' 
		AND WI.STATUS_CD NOT IN ('Complete', 'Withdrawn', 'Error')
		AND WI.USER_ROLE_CD = 'Lender'
		AND WI.PURGE_DT IS NULL
		AND WI.DELAY_UNTIL_DT IS NULL
		and T2.Loc.value('@Checked[1]','nvarchar(10)') = 'true'
		

SELECT * 
INTO #tmpHalfWay
FROM (

SELECT t.*, p.ID as P_DETAIL_ID, null as C_DETAIL_ID, null as C_DETAIL_PROP_ID, '' AS C_DETAIL_STATUS_CD, null as RC_DETAIL_ID, null as RC_PROP_ID, '' as RC_TYPE_CD, '' AS RC_SUMMARY_STATUS_CD, '' AS RC_STATUS_CD, '' RC_SUMMARY_SUB_STATUS_CD 
FROM #tmp t
JOIN PROPERTY p ON p.ID = t.RelateId AND t.RelateType = 'Allied.UniTrac.Property' AND p.PURGE_DT is NULL
AND ( @Coverage = '1' OR @Coverage  = '' OR @Coverage is NULL)

UNION 

SELECT t.*, null as P_DETAIL_ID, c.id as C_DETAIL_ID, c.PROPERTY_ID as C_DETAIL_PROP_ID, C.STATUS_CD AS C_DETAIL_STATUS_CD, null as RC_DETAIL_ID, null as RC_PROP_ID, '' as RC_TYPE_CD, '' as RC_SUMMARY_STATUS_CD, '' as RC_STATUS_CD, '' RC_SUMMARY_SUB_STATUS_CD 
FROM #tmp t
JOIN COLLATERAL c on c.LOAN_ID = t.loan_id and c.PURGE_DT IS NULL AND t.RelateId = c.ID AND t.RelateType = 'Allied.UniTrac.Collateral' 
AND ( @Coverage = '1' OR @Coverage  = '' OR @Coverage is NULL)

UNION 

SELECT t.*, null as P_DETAIL_ID, null as C_DETAIL_ID, '' as C_DETAIL_PROP_ID, '' AS C_DETAIL_STATUS_CD, rc.ID as RC_DETAIL_ID, rc.PROPERTY_ID as RC_PROP_ID, rc.TYPE_CD as RC_TYPE_CD, rc.SUMMARY_STATUS_CD AS RC_SUMMARY_STATUS_CD, rc.STATUS_CD AS RC_STATUS_CD, ISNULL(rc.SUMMARY_SUB_STATUS_CD,'') as  RC_SUMMARY_SUB_STATUS_CD 
FROM #tmp t
JOIN REQUIRED_COVERAGE rc ON rc.ID = t.RelateId AND t.RelateType = 'Allied.UniTrac.RequiredCoverage' AND rc.PURGE_DT is NULL
WHERE RC.TYPE_CD = @Coverage OR @Coverage = '1' OR @Coverage  = '' OR @Coverage is NULL

UNION 

SELECT t.*, null as P_DETAIL_ID, null as C_DETAIL_ID, null as C_DETAIL_PROP_ID,'' AS C_DETAIL_STATUS_CD, null as RC_DETAIL_ID, null as RC_PROP_ID, '' as RC_TYPE_CD, '' as RC_SUMMARY_STATUS_CD, '' as RC_STATUS_CD, NULL RC_SUMMARY_SUB_STATUS_CD 
FROM #tmp t
where t.RelateType in ('Allied.UniTrac.Loan' , 'Allied.UniTrac.Owner')
AND ( @Coverage = '1' OR @Coverage  = '' OR @Coverage is NULL)

) t



SELECT  t.*, CL.*, P.ID as FinalPropId, P.ADDRESS_ID,  P.YEAR_TX , p.MAKE_TX , p.MODEL_TX , P.VIN_TX

INTO #tmpAllProp
FROM 
#tmpHalfWay t
 OUTER APPLY
      (
         SELECT TOP 1 COLL.ID AS CL_COLL_ID , COLL.PROPERTY_ID AS CL_PROPERTY_ID
         FROM COLLATERAL COLL 
		 JOIN PROPERTY PR ON PR.ID = COLL.PROPERTY_ID
         WHERE COLL.LOAN_ID = t.loan_id AND COLL.PURGE_DT IS NULL AND PR.PURGE_DT IS NULL 
         ORDER BY CASE PR.RECORD_TYPE_CD WHEN 'G' THEN 1 WHEN 'A' THEN 2 ELSE 3 END ASC,
                  CASE WHEN COLL.STATUS_CD = 'U' OR COLL.EXTRACT_UNMATCH_COUNT_NO > 0 THEN 3							    
							  WHEN COLL.STATUS_CD = 'A' THEN 1	ELSE 2 END ASC,	
                       COLL.LOAN_BALANCE_NO DESC, COLL.CREATE_DT ASC
      ) AS CL
	  
	JOIN PROPERTY P ON P.ID = COALESCE(t.P_DETAIL_ID, t.C_DETAIL_PROP_ID,t.RC_PROP_ID, CL_PROPERTY_ID) AND P.PURGE_DT IS NULL


	SELECT * 
	INTO #tmpAllCol
	FROM (

	SELECT t.*, c.COLLATERAL_CODE_ID, c.ID AS FinalCollID, C.LENDER_COLLATERAL_CODE_TX, C.LEGAL_STATUS_CODE_TX,  C.PURPOSE_CODE_TX,CC.SECONDARY_CLASS_CD, CC.CODE_TX as COLLATERAL_CODE_TX
	FROM #tmpAllProp t
	JOIN COLLATERAL c ON c.ID = t.C_DETAIL_ID AND C.PURGE_DT IS NULL
	JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL

	UNION

	SELECT t.*, c.COLLATERAL_CODE_ID, c.ID AS FinalCollID, C.LENDER_COLLATERAL_CODE_TX, C.LEGAL_STATUS_CODE_TX,  C.PURPOSE_CODE_TX,CC.SECONDARY_CLASS_CD, CC.CODE_TX as COLLATERAL_CODE_TX
	FROM #tmpAllProp t
	JOIN COLLATERAL c ON C.PROPERTY_ID = t.P_DETAIL_ID AND C.PURGE_DT IS NULL
	JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL

	UNION

	SELECT t.*, c.COLLATERAL_CODE_ID, c.ID AS FinalCollID, C.LENDER_COLLATERAL_CODE_TX, C.LEGAL_STATUS_CODE_TX,  C.PURPOSE_CODE_TX,CC.SECONDARY_CLASS_CD, CC.CODE_TX as COLLATERAL_CODE_TX
	FROM #tmpAllProp t
	JOIN COLLATERAL c ON C.PROPERTY_ID = t.RC_PROP_ID AND C.PURGE_DT IS NULL
	JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL

	UNION

	SELECT t.*, c.COLLATERAL_CODE_ID, c.ID AS FinalCollID, C.LENDER_COLLATERAL_CODE_TX, C.LEGAL_STATUS_CODE_TX,  C.PURPOSE_CODE_TX,CC.SECONDARY_CLASS_CD, CC.CODE_TX as COLLATERAL_CODE_TX
	FROM #tmpAllProp t
	JOIN COLLATERAL c ON  C.ID = t.CL_COLL_ID  AND t.C_DETAIL_ID IS NULL AND t.P_DETAIL_ID IS NULL AND t.RC_PROP_ID IS NULL AND C.PURGE_DT IS NULL
	JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL

	) tmpunion



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
	
	t.workitem_id, 
	@GroupByCode AS REPORT_GROUPBY_TX,
	t.DEFAULT_SORTBY_TX,
	t.LENDER_CODE_TX,
	t.LENDER_NAME_TX,
	t.BorrowerName,
CASE WHEN ISNULL(ODBA.NAME_TX,'') = '' THEN ODBA.LAST_NAME_TX ELSE ODBA.NAME_TX END AS OWNER_NAME_TX,
	t.LOAN_ID,
	t.NUMBER_TX as LOAN_NUMBER_TX,
	t.LOAN_NUMBERSORT_TX,
	t.LOAN_BRANCHCODE_TX,
	t.LOAN_DIVISIONCODE_TX,
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as LOAN_TYPE_TX,
	t.LOAN_BALANCE_NO,
	t.COLLATERAL_CODE_TX,
	t.LENDER_COLLATERAL_CODE_TX,
	t.LEGAL_STATUS_CODE_TX,
	t.PURPOSE_CODE_TX,
CASE WHEN ISNULL(t.ADDRESS_ID,'') <> ''
			THEN AM.LINE_1_TX
			ELSE t.TempCOLLATERAL_LINE1_TX
	END as COLLATERAL_LINE1_TX,
		CASE WHEN ISNULL(t.ADDRESS_ID,'') <> ''
			THEN AM.LINE_2_TX
			ELSE t.TempCOLLATERAL_LINE2_TX
		END as COLLATERAL_LINE2_TX,
		CASE WHEN ISNULL(t.ADDRESS_ID,'') <> ''
			THEN AM.CITY_TX
			ELSE t.TempCOLLATERAL_CITY_TX
		END as COLLATERAL_CITY_TX,
		CASE WHEN ISNULL(t.ADDRESS_ID,'') <> ''
			THEN AM.STATE_PROV_TX
			ELSE t.TempCOLLATERAL_STATE_TX
		END as COLLATERAL_STATE_TX,
		CASE WHEN ISNULL(t.ADDRESS_ID,'') <> ''
			THEN AM.POSTAL_CODE_TX
			ELSE t.TempCOLLATERAL_ZIP_TX
		END as COLLATERAL_ZIP_TX,
		t.YEAR_TX as COLLATERAL_YEAR_TX,
		t.MAKE_TX as COLLATERAL_MAKE_TX,
		t.MODEL_TX as COLLATERAL_MODEL_TX,
		t.VIN_TX as COLLATERAL_VIN_TX,
		'' as COLLATERAL_EQUIP_TX,
  dbo.fn_GetPropertyDescriptionForReports(t.FinalCollID) PROPERTY_DESCRIPTION,
t.TempPropertyType,
ISNULL(RCA_PROP.VALUE_TX,TempPROPERTY_TYPE_CD) AS [PROPERTY_TYPE_CD],
ISNULL(RC_COVERAGETYPE.MEANING_TX, TempREQUIREDCOVERAGE_TYPE_TX) as REQUIREDCOVERAGE_TYPE_TX,
LOAN_STATUSCODE,
  t.C_DETAIL_STATUS_CD as COLLATERAL_STATUSCODE, 
		 t.RC_STATUS_CD as REQUIREDCOVERAGE_STATUSCODE, 
ISNULL(RC_INSTAT.MEANING_TX, TempREQUIREDCOVERAGE_STATUSMEANING_TX) as REQUIREDCOVERAGE_STATUSMEANING_TX,
		t.RC_SUMMARY_STATUS_CD  as REQUIREDCOVERAGE_INSSTATUSCODE, 
	ISNULL(t.RC_SUMMARY_SUB_STATUS_CD,'') as REQUIREDCOVERAGE_INSSUBSTATUSCODE,
t.ActionNeeded,
t.CurrentValue,
	'' as VerifyDataComment,
		t.FinalPropId AS PROPERTY_ID,
		t.FinalCollID AS COLLATERAL_ID,
		ISNULL(t.RC_DETAIL_ID,TempRC_ID)  AS RC_ID

	FROM #tmpAllCol t
	 CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(t.FinalCollID, @Division) fn_FCBD
	   JOIN REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = t.LOAN_DIVISIONCODE_TX
		 Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND t.SECONDARY_CLASS_CD = RC_SC.CODE_CD
		 LEFT Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
		 LEFT JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD= cast(t.RC_TYPE_CD as nvarchar(max))
		 LEFT JOIN REF_CODE RC_INSTAT ON RC_INSTAT.DOMAIN_CD = 'RequiredCoverageInsStatus' AND RC_INSTAT.CODE_CD = CAST(t.RC_SUMMARY_STATUS_CD AS NVARCHAR(MAX))
		 left Join [OWNER_ADDRESS] AM on AM.ID = t.FinalPropId 
		LEFT JOIN OWNER_LOAN_RELATE OLDBA ON OLDBA.LOAN_ID = t.loan_id AND OLDBA.OWNER_TYPE_CD = 'DBA' 
		LEFT JOIN [OWNER] ODBA on ODBA.ID = OLDBA.OWNER_ID 
		WHERE 
		fn_FCBD.loanType IS NOT NULL
		AND AM.PURGE_DT IS NULL
		AND OLDBA.PURGE_DT IS NULL
		AND ODBA.PURGE_DT IS NULL
		AND RC_COVERAGETYPE.PURGE_DT IS null
		AND RC_DIVISION.PURGE_DT IS NULL
		AND RC_INSTAT.PURGE_DT IS NULL
		AND RC_SC.PURGE_DT IS NULL
		AND RCA_PROP.PURGE_DT IS NULL
		AND (t.LOAN_BRANCHCODE_TX IN (SELECT STRVALUE FROM @BranchTable) or @Branch = '1' or @Branch is NULL)

		--------------------


Declare @sqlstring as nvarchar(1000)
If isnull(@FilterBySQL,'') <> '' 
Begin
  Select * into #t1 from #tmptable 
  truncate table #tmptable

  Set @sqlstring = N'Insert into #tmpTable
                     Select * from dbo.#t1 where ' + @FilterBySQL
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
				
		FETCH NEXT FROM Comment_Cursor into @workitemID
	END
CLOSE Comment_Cursor
DEALLOCATE Comment_Cursor

declare @sqlNewline varchar(2) = char(13) + char(10)


SELECT @RecordCount = COUNT(DISTINCT LOAN_ID) from #tmptable 

IF @Report_History_ID IS NOT NULL
BEGIN

  Update [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML
  Set RECORD_COUNT_NO = @RecordCount
  where ID = @Report_History_ID  
END

Select
 tt.*
,PropertyAddress = [address].collateral
,MailingAddress = [address].borrower
,NamePropertyAddress = BorrowerName + @sqlNewline + [ADDRESS].collateral
,NameMailingAddress = BorrowerName + @sqlNewline + [ADDRESS].borrower
from #tmptable tt
cross apply(
	select top 1
 ADDRESS_LINE1 = oab.line_1_tx
,ADDRESS_LINE2 = oab.line_2_tx
,ADDRESS_CITY = oab.city_tx
,ADDRESS_STATE = oab.state_prov_tx
,ADDRESS_ZIP = oab.postal_code_tx
,NAME = OB.NAME_TX
,FIRST_NAME = OB.FIRST_NAME_TX
,LAST_NAME = OB.LAST_NAME_TX
	from owner_loan_relate olrb (nolock)
	left join [owner] ob (nolock) on ob.id = olrb.owner_id and ob.purge_dt is null
	left join owner_address oab (nolock) on oab.id = ob.address_id and oab.purge_dt is null
	where olrb.loan_id=tt.loan_id and olrb.owner_type_cd = 'B' and olrb.purge_dt is null
	order by
	 case when olrb.primary_in='Y' then 1 else 2 end
	,oab.update_dt desc
) as borrower
cross apply(
	select
	 collateral = IsNull(COLLATERAL_LINE1_TX, '') + IsNull(', ' + NullIf(COLLATERAL_LINE2_TX, ''), '') + @sqlNewline + IsNull(COLLATERAL_CITY_TX, '') + IsNull(', ' + NullIf(COLLATERAL_STATE_TX, ''), '') + IsNull('  ' + COLLATERAL_ZIP_TX, '')
	,borrower = IsNull(BORROWER.ADDRESS_LINE1, '') + IsNull(', ' + NullIf(BORROWER.ADDRESS_LINE2, ''), '') + @sqlNewline + IsNull(BORROWER.ADDRESS_CITY, '') + IsNull(', ' + NullIf(BORROWER.ADDRESS_STATE, ''), '') + IsNull('  ' + BORROWER.ADDRESS_ZIP, '')
) as [address]

END


GO

