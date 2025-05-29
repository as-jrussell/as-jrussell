USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_StatusNotProgressing]    Script Date: 3/10/2017 3:57:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Report_StatusNotProgressing] 
--declare
	 @LenderCode as nvarchar(10)=NULL
	,@Branch AS nvarchar(max)=NULL
	,@Division as nvarchar(10)=NULL
	,@Coverage as nvarchar(100)=NULL
	,@ReportType as nvarchar(50)=NULL
	,@GroupByCode as nvarchar(50)=NULL
	,@SortByCode as nvarchar(50)=NULL
	,@FilterByCode as nvarchar(50)=NULL
	,@SpecificReport as varchar(50)='0000'
	,@ReportDomainName as nvarchar(50)='Report_StatNoProgress'
	,@Report_History_ID as bigint=NULL
	--,@LenderAdmin_ID as bigint=NULL			--not CURRENTLY an INPUT paramater...YET
	--,@LenderProdAdmin_ID as bigint=NULL		--not CURRENTLY an INPUT paramater...YET
	,@PreBindDays Int = 60
	,@PreBindDays_Flood Int = 35
AS
BEGIN
	declare @debug bigint=0
/*
**  COMMENT-OUT BEFORE CHECK-IN
***
--Debug:
***
**  COMMENT-OUT BEFORE CHECK-IN
	--select @debug=2032	--Tropical
	--select @debug=6175	--GreaterNevada CU
	--select @debug=7500	--GreaterNevada Mortgage
	--select @debug=2105	--SouthwestFCU
	select @debug=2771		--PenFed
	select
	 @LenderCode=isnull(@LenderCode,cast(@debug as nvarchar(10)))
	,@ReportType='StatNoProg'
	,@SpecificReport='StatNoProg'
	,@PreBindDays=600			--only for debugging
	,@PreBindDays_Flood=350		--only for debugging
	,@Coverage='FLOOD'
	where isnull(@debug,0)<>0
*/

Declare @LenderID as bigint
Select @LenderID=ID from LENDER where CODE_TX = @LenderCode AND PURGE_DT IS NULL



if @Report_History_ID is not NULL
Begin
	

	Select
	 @LenderCode=isnull(nullif(REPORT_DATA_XML.value('(/ReportData/Report/Lender)[1]/@value', 'nvarchar(max)'),''), @LenderCode)
	,@ReportType=isnull(nullif(REPORT_DATA_XML.value('(/ReportData/Report/ReportType)[1]/@value', 'varchar(50)'),''), @ReportType)
	,@SpecificReport=coalesce(NullIf(REPORT_DATA_XML.value('(/ReportData/Report/SpecificReport)[1]/@value', 'varchar(50)'),''), @SpecificReport, '0000')
	,@ReportDomainName=coalesce(NullIf(REPORT_DATA_XML.value('(/ReportData/Report/ReportDomainName)[1]/@value', 'varchar(50)'), ''), @ReportDomainName, 'Report_NotProgressing')
	,@Division=isnull(NullIf(REPORT_DATA_XML.value('(/ReportData/Report/Division)[1]/@value', 'nvarchar(max)'),''), @Division)
	 FROM REPORT_HISTORY WHERE ID = @Report_History_ID
End



IF OBJECT_ID(N'tempdb..#BranchTable',N'U') IS NOT NULL
  DROP TABLE #BranchTable
IF OBJECT_ID(N'tempdb..#tmpfilter',N'U') IS NOT NULL
  DROP TABLE #tmpfilter

IF OBJECT_ID(N'tempdb..#t1',N'U') IS NOT NULL
  DROP TABLE #t1
IF OBJECT_ID(N'tempdb..#tmpTable',N'U') IS NOT NULL
  DROP TABLE #tmpTable

CREATE TABLE [dbo].[#BranchTable] (ID int, STRVALUE nvarchar(30))
			INSERT INTO #BranchTable SELECT * FROM SplitFunction(@Branch, ',')  

Declare @GroupBySQL as varchar(1000)
Declare @SortBySQL as varchar(1000)
Declare @FilterBySQL as varchar(1000)
Declare @HeaderTx as varchar(1000)
Declare @FooterTx as varchar(1000)


IF OBJECT_ID(N'tempdb..#tmpimpaired',N'U') IS NOT NULL
  DROP TABLE #tmpimpaired
--
Declare @Impaired as char(1)
Set @Impaired = NULL
--
CREATE TABLE [dbo].[#tmpimpaired](
	[ATTRIBUTE_CD] [nvarchar](50) NULL,
	[VALUE_TX] [nvarchar](50) NULL
) ON [PRIMARY]
--
Insert into #tmpimpaired (
	ATTRIBUTE_CD,
	VALUE_TX)
--
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
--

Select @Impaired = 'T' from #tmpimpaired where VALUE_TX = 'T'
Select @Impaired = 'T' where @GroupBySQL like '%IMPAIRMENT%'
Select @Impaired = 'T' where @FilterBySQL like '%IMPAIRMENT%'



DECLARE @PAGEBREAK AS VARCHAR(1) = 'F'
DECLARE @PAGEBREAK_COLUMN AS VARCHAR(20) = ''

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

Declare @ReportConfig NVarChar(50) = @SpecificReport

Declare @RecordCount as bigint
Set @RecordCount = 0

	Declare @tmpKeys TABLE(
	 PropID BigInt NOT NULL
	,CollID BigInt NOT NULL
	,ReqCovID BigInt NOT NULL
	,LA_ID BigInt NULL		--LenderAdmin UserID
	,FPC_ID BigInt NULL		--needed?
	,PCP_ID BigInt NULL			--needed?
	,DateSinceNoProgress DateTime2 NULL --date since not progressed to Binder/Cpi
	,INSCOMPANY_EXPCXL_DT DateTime2(7) NULL
	,INSCOMPANY_EXPCXL_DT_Condo DateTime2(7) NULL
	,BORRINSCOMPANY_EXPCXL_DT DateTime2(7) NULL
	,CANCEL_REASON_CD NVarChar(50) NULL
	,IMPAIR_CODES NVarChar(500) NULL
	,TagToDelete Bit NULL
	,
-- PARAMETERS:
	[REPORT_GROUPBY_TX] [nvarchar](1000) NULL,
	[REPORT_SORTBY_TX] [nvarchar](1000) NULL,
	[REPORT_HEADER_TX] [nvarchar](1000) NULL,
	[REPORT_FOOTER_TX] [nvarchar](1000) NULL,
	[REPORT_GROUPBY_FIELDS_TX] [nvarchar](1000) NULL
	)

	;With
	 tmpKeys As(
	Select --distinct
	 PropID = P.ID
	,CollID = C.ID
	,ReqCovID = RC.ID
	,LA_ID = LA.ID
	,DateSinceNoProgress = Exposure.DateSince --RC.EXPOSURE_DT
	,FPC_ID = FPC.ID		--needed?
	,PCP_ID = PCP.ID
	,InsCompany_ExpCxl_Dt = InsCompany_ExpCxl.Dt
    ,INSCOMPANY_EXPCXL_DT_Condo = InsCompany_ExpCxl.Condo_Dt
    ,BorrInsCompany_ExpCxl_Dt = InsCompany_ExpCxl.Borr_Dt
	,CANCEL_REASON_CD = Coalesce(NullIf(OwnPol.CANCEL_REASON_CD,''), NullIf(OwnPol_CA.CANCEL_REASON_CD,''), NullIf(CPA_Cancel.REASON_CD,''), Null)
	,IMPAIR_CODES = IMPAIR.CODES
	From PROPERTY P
	INNER Join COLLATERAL C On C.PROPERTY_ID = P.ID AND C.PURGE_DT Is Null
	INNER Join LOAN L On L.LENDER_ID = P.LENDER_ID AND L.PURGE_DT Is Null AND L.ID = C.LOAN_ID
	INNER Join REQUIRED_COVERAGE RC On RC.PROPERTY_ID = P.ID AND RC.PURGE_DT Is Null
	LEFT Join LENDER_PRODUCT LP On LP.ID = RC.LENDER_PRODUCT_ID AND LP.PURGE_DT Is Null

--LenderAdmin:
	OUTER Apply(
		Select TOP 1 ID = RD.VALUE_TX
		--Select RD.RELATE_ID, RD.VALUE_TX, pLenderId=P.LENDER_ID, RDD.*
		From RELATED_DATA RD
		Join RELATED_DATA_DEF RDD On RDD.ID = RD.DEF_ID
		Where 1=1
		  --AND RDD.DATA_TYPE_CD In ('BOList')
		  AND RDD.ACTIVE_IN='Y'
		  AND (RD.START_DT Is Null OR RD.START_DT <= GetDate())
		  AND (RD.END_DT Is Null OR RD.END_DT >= GetDate())
		  AND RDD.DOMAIN_CD='Osprey.User'
		  AND RDD.DESC_TX like 'User assigned to manage/administ%'
		  AND (RDD.RELATE_CLASS_NM = 'Lender' AND RD.RELATE_ID = P.LENDER_ID)
		  --AND RD.ID = Coalesce(@LenderAdmin_ID, RD.ID)
	) As LA --LenderAdmin


	OUTER Apply(
		SELECT TOP 1 * FROM dbo.GetCurrentCoverage(P.ID, RC.ID, RC.TYPE_CD)
		ORDER BY ISNULL(UNIT_OWNERS_IN, 'N') DESC
	) OwnPol
	OUTER Apply(
		SELECT TOP 1 * FROM dbo.GetCurrentCoverage(P.ID, RC.ID, RC.TYPE_CD)
		--CA Condo Assoc
		WHERE BASE_PROPERTY_TYPE_CD = 'CA' AND ID != OwnPol.ID
		ORDER BY ISNULL(EXCESS_IN, 'N') 
	) OwnPol_CA

	OUTER Apply (Select TOP 1 FPC.* From FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR
				INNER Join FORCE_PLACED_CERTIFICATE FPC on FPC.ID = FPCR.FPC_ID AND FPC.PURGE_DT IS NULL --and FPC.ACTIVE_IN = 'Y' /*and RC.SUMMARY_SUB_STATUS_CD = 'C'*/
				Where FPCR.REQUIRED_COVERAGE_ID = RC.ID AND FPCR.PURGE_DT IS NULL /*and RC.SUMMARY_SUB_STATUS_CD = 'C'*/
				Order By FPC.ID Desc
				) As FPC

	OUTER Apply (Select TOP 1 PCP.* From PRIOR_CARRIER_POLICY PCP Where PCP.REQUIRED_COVERAGE_ID = RC.ID AND PCP.PURGE_DT IS NULL AND RC.SUMMARY_SUB_STATUS_CD = 'P' Order By PCP.ID Desc) As PCP

	LEFT Join CPI_QUOTE CPQ ON CPQ.ID = FPC.CPI_QUOTE_ID AND CPQ.PURGE_DT IS NULL AND RC.SUMMARY_STATUS_CD In ('C')
	
	OUTER APPLY
	(
	Select top 1 REASON_CD From 
		CPI_ACTIVITY  where CPI_QUOTE_ID = CPQ.ID AND PURGE_DT IS NULL --AND RC.SUMMARY_STATUS_CD In ('C') 
		AND TYPE_CD In ('C')
		order by CREATE_DT DESC
	) CPA_Cancel

	CROSS Apply(
		Select
		 LOAN_STATUSCODE = L.STATUS_CD
		,REQCOV_STATUSCODE = RC.STATUS_CD
		,REQCOV_SUMSTATUSCODE = Coalesce(NullIf(RC.SUMMARY_STATUS_CD,''), NullIf(RC.INSURANCE_STATUS_CD,''))
		,REQCOV_SUMSUBSTATUSCODE = Coalesce(NullIf(RC.SUMMARY_SUB_STATUS_CD,''), NullIf(RC.INSURANCE_SUB_STATUS_CD,''))
	) As Aliased

	OUTER Apply(
		Select CODES = (Select DISTINCT ';' + IMP.CODE_CD From IMPAIRMENT IMP
		Where IMP.REQUIRED_COVERAGE_ID = RC.ID AND RC.PURGE_DT IS NULL
		  AND IMP.START_DT < GetDate() AND IMP.END_DT > GetDate()
		  AND IsNull(IMP.OVERRIDE_TYPE_CD,'')=''
		Order By ';' + IMP.CODE_CD
		For XML Path(''))
	) As IMPAIR

	CROSS Apply(
		Select
		 Dt =
		   Case
			 when RC.SUMMARY_SUB_STATUS_CD = 'C' then
			   Case
				 when YEAR(ISNULL(FPC.CANCELLATION_DT,FPC.EXPIRATION_DT)) = '9999' then NULL
				 else ISNULL(FPC.CANCELLATION_DT,FPC.EXPIRATION_DT)
			   End
			 when RC.SUMMARY_SUB_STATUS_CD = 'P' then
			   Case
				 when YEAR(ISNULL(PCP.CANCELLATION_DT,PCP.EXPIRATION_DT)) = '9999' then NULL
				 else isnull(PCP.CANCELLATION_DT,PCP.EXPIRATION_DT)
			   End
			 else
			   Case
				 when YEAR(ISNULL(OwnPol.CANCELLATION_DT,OwnPol.EXPIRATION_DT)) = '9999' then NULL
				 else ISNULL(OwnPol.CANCELLATION_DT,OwnPol.EXPIRATION_DT)
			   End
		   End
		,Condo_Dt = 
			CASE WHEN RC.SUMMARY_SUB_STATUS_CD not in ('C', 'P') THEN 
				Case
				   when YEAR(ISNULL(OwnPol_CA.CANCELLATION_DT,OwnPol_CA.EXPIRATION_DT)) = '9999' then NULL
				   else ISNULL(OwnPol_CA.CANCELLATION_DT,OwnPol_CA.EXPIRATION_DT)
			   End 
			   ELSE NULL
			END
		,Borr_Dt = 
		   Case
			 when YEAR(ISNULL(OwnPol.CANCELLATION_DT,OwnPol.EXPIRATION_DT)) = '9999' then NULL
			 else ISNULL(OwnPol.CANCELLATION_DT,OwnPol.EXPIRATION_DT)
		   End
	) As InsCompany_ExpCxl
	
	CROSS Apply(
		Select
		  DateSince = Coalesce(NullIf(RC.EXPOSURE_DT,'12/31/9999'), NullIf(RC.EXPOSURE_STATUS_DT,'12/31/9999'), InsCompany_ExpCxl.Condo_Dt, InsCompany_ExpCxl.Borr_Dt, InsCompany_ExpCxl.Dt, L.EFFECTIVE_DT, L.UPDATE_DT)
	) As Exposure
--
	CROSS Apply(
		Select
		  DaysSince = DateDiff(day, Exposure.DateSince, GetDate())
	) As NoProgress

	Where P.PURGE_DT Is Null
	  And P.LENDER_ID = IsNull(@LenderID,P.LENDER_ID)
	  And P.RECORD_TYPE_CD = 'G'
	  And IsNull(L.RECORD_TYPE_CD,'G') = 'G'
	  And IsNull(RC.RECORD_TYPE_CD,'G') = 'G'
	  And L.EXTRACT_UNMATCH_COUNT_NO = 0
	  And IsNull(C.EXTRACT_UNMATCH_COUNT_NO,0) = 0
	  And L.STATUS_CD != 'U'
	  And IsNull(C.STATUS_CD,'') != 'U'
	  --And (RC.STATUS_CD <> 'I' OR RC.STATUS_CD IS NULL)

	  --FLTRK = FullTrack; WNTC = WithNotice
	  And LP.END_DT > GetDate() AND LP.BASIC_TYPE_CD In ('FLTRK') AND LP.BASIC_SUB_TYPE_CD = 'WNTC'

	  And(
	     --A Active, B Bankruptcy
	      [LOAN_STATUSCODE] in ('A','B')
		 --A Active, E Waive Expired
	  And [REQCOV_STATUSCODE] in (Null,'A','E')

		  --N New, NC New not previously required, A Audit, E Expired, EH Expired Hold, C Cancel, CH Cancel Hold, R Re-audit
	  And [REQCOV_SUMSTATUSCODE] in (Null,'N','NC','A','E','EH','C','CH','R')
	   	 )
	  
	  And 1=
	      Case
			When IMPAIR.CODES Is Null
			Then 1

	  --IC Inadequate Coverage
			When IMPAIR.CODES Like '%IC%'
			Then 1
	/*
	      --DD High Deductibles, LI Lienholder
	*/
			When IMPAIR.CODES Like '%DD%'
			Then 0
			When IMPAIR.CODES Like '%LI%'
			Then 0

			Else 1
	  End

	  And 1=
		 -- --exclude B Binder, C Cpi
		 -- --UNLESS Expired
	      Case when 1=0 then 0
		 --R Re-audit must be F InForce or E Expired
			When RC.SUMMARY_SUB_STATUS_CD = 'R' And RC.SUMMARY_STATUS_CD In ( 'F', 'E' )
			Then 1
			When RC.SUMMARY_SUB_STATUS_CD = 'R' And RC.SUMMARY_STATUS_CD NOT In ( 'F', 'E' )
			Then 0
		  --B Binder, U Binder/Authorized
			When RC.SUMMARY_STATUS_CD In ('B','U')
			Then 0
		 -- --B Binder, C Cpi, I Impaired, L Layup
		 -- --E Expired, EH Expired Hold
			When RC.SUMMARY_SUB_STATUS_CD In ('B','C','I','L') AND RC.SUMMARY_STATUS_CD NOT In ('E','EH')
			Then 0
			When NoProgress.DaysSince < @PreBindDays_Flood AND RC.TYPE_CD = 'FLOOD'
			Then 0
			When NoProgress.DaysSince < @PreBindDays
			Then 0

			Else 1
		  End
	)
	Insert Into @tmpKeys(
	 PropID
	,CollID
	,ReqCovID
	,LA_ID
	,DateSinceNoProgress
	,FPC_ID
	,PCP_ID
	,InsCompany_ExpCxl_Dt
	,INSCOMPANY_EXPCXL_DT_Condo
	,BorrInsCompany_ExpCxl_Dt
	,CANCEL_REASON_CD
	,IMPAIR_CODES
	)
	Select --DISTINCT
	 PropID
	,CollID
	,ReqCovID
	,LA_ID
	,DateSinceNoProgress
	,FPC_ID
	,PCP_ID
	,InsCompany_ExpCxl_Dt
	,INSCOMPANY_EXPCXL_DT_Condo
	,BorrInsCompany_ExpCxl_Dt
	,CANCEL_REASON_CD
	,IMPAIR_CODES
	From tmpKeys

	CROSS Apply dbo.fn_FilterCollateralByDivisionCd(CollID, @Division) As fn_FCBD
	Where 1=1
	  And fn_FCBD.loanType Is NOT Null

Declare @sqlstring NVarChar(MAX)

Select
 @Coverage = NullIf(NullIf(@Coverage,''),'1')
,@FilterBySQL = NullIf(@FilterBySQL,'')
--
If @Coverage Is NOT Null
OR @FilterBySQL Is NOT Null
Begin
  Select *, TagToRemove=Cast(0 As Bit) into #t1 from @tmpKeys

  Set @sqlstring = N'
Update t1
Set TagToRemove=1
From #t1 t1
LEFT Join REQUIRED_COVERAGE RC On RC.ID=t1.ReqCovID
Where 1=0 '
+ Case When @Coverage Is Null Then N'' Else N' OR NOT(RC.TYPE_CD=''' + @Coverage + N''')' End
+ Case When @FilterBySQL Is Null Then N'' Else N' OR NOT(' + @FilterBySQL + N')' End

If @Debug>0
Begin
	Print '@sqlstring:'
	Print @sqlstring
End

  EXECUTE sp_executesql @sqlstring
--select * from #t1 t1 where tagtoremove=1 and @debug>0
  Update tmpKeys
  Set
   TagToDelete=t1.TagToRemove
  From @tmpKeys tmpKeys
  Join #t1 t1 On t1.ReqCovID=tmpKeys.ReqCovID And t1.PropID=tmpKeys.PropID And t1.CollID=tmpKeys.CollID
--select * from @tmpKeys tmpKeys where tagtodelete=1 and @debug>0
  Delete From @tmpKeys Where TagToDelete=1
End

Declare @FillerZero as varchar(18) = Replicate('0', 18)

	Select --TOP 10 --DISTINCT
	 LOAN_NUMBER_TX = LOAN.NUMBER_TX
	,LOAN_BRANCHCODE_TX = IsNull(NullIf(LOAN.BRANCH_CODE_TX,''),'No Branch')
/* format names as GIVEN_NAME FAMILY_NAME
*/
	,LA_Name = IsNull(LA.GIVEN_NAME_TX + ' ','') + LA.FAMILY_NAME_TX
	,LOAN_LENDERCODE_TX = LEND.CODE_TX
	,LENDER_ID = LEND.ID
	,ESCROW_IN = Coalesce(NullIf(REQCOV.ESCROW_IN,''), NullIf(LOAN.ESCROW_IN,''), '?')
	,PRODUCT_TYPE = LP.BASIC_TYPE_CD
	,PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescriptionForReports(C.ID)
	,REQUIREDCOVERAGE_AMOUNT_NO = REQCOV.REQUIRED_AMOUNT_NO
	,REQUIREDCOVERAGE_TYPE_TX = REQCOV.TYPE_CD --TODO: join with REF_CODE table...
	,CXL_REASON_TX = Coalesce(RC_CANCELREASON.DESCRIPTION_TX,NullIf(tmpKeys.CANCEL_REASON_CD,''),'No Reason')
	,LastNotice_Action_Tx = LastNotice.Action_Tx
	,PreBinder_Reason_Tx = PreBinder.Reason_Tx
	,REJECT_REASON_TX = MaxNtc.REJECT_REASON
	,
-- PARAMETERS:
	[REPORT_GROUPBY_TX] = Cast(IsNull(@GroupBySQL,'') As NVarChar(1000)),
	[REPORT_SORTBY_TX] = Cast(IsNull(@SortBySQL,'') As NVarChar(1000)),
	[REPORT_HEADER_TX] = IsNull(@HeaderTx,''),
	[REPORT_FOOTER_TX] = IsNull(@FooterTx,''),
	[REPORT_GROUPBY_FIELDS_TX] = Replace(Replace(IsNull(@GroupBySQL,''),'[',''),']','')
,
/*
--LoanStatus fields (carryover from the StoredProc "Report_LoanStatus"):
*/
LOAN_PAGEBREAKTYPE_TX =
	  CASE WHEN @PAGEBREAK = 'T' 
			THEN @PAGEBREAK_COLUMN
			ELSE ''
	  END,
LOAN_PAGEBREAK_TX = case when @PAGEBREAK = 'T' AND @PAGEBREAK_COLUMN <> 'Branch' then @GroupBySQL else '' end,
--LOAN:
LOAN_BALANCE_NO = LOAN.BALANCE_AMOUNT_NO,
PREDICTIVE_DECILE_NO = LOAN.PREDICTIVE_DECILE_NO,
--LOAN RELATED DATA
--LENDER:
LOAN_EFFECTIVE_DT = LOAN.EFFECTIVE_DT,
LENDER_NAME_TX = LEND.NAME_TX,
--OWNER:
OWNER_LASTNAME_TX = Cast(Null As NVarChar(30)),
OWNER_FIRSTNAME_TX = Cast(Null As NVarChar(30)),
--PROPERTY:
COLLATERAL_VIN_TX = P.VIN_TX,
--COVERAGE:
COVERAGE_STATUS_TX = [Status].Coverage,
CANCEL_MEANING_TX = Coalesce(CRRef.MEANING_TX, ''),
COVERAGE_EXPOSURE_DT = REQCOV.EXPOSURE_DT,
--BORROWER INSURANCE
BORRINSCOMPANY_EXPCXL_DT = tmpKeys.BORRINSCOMPANY_EXPCXL_DT,
--ESCROW:
ESCROW_IN_REQ_COV_TX = REQCOV.ESCROW_IN,
--STATUS:
LOAN_ID = LOAN.ID,
COLLATERAL_ID = C.ID,
PROPERTY_ID = P.ID,
REQUIREDCOVERAGE_ID = RC.ID
	Into #tmpTable
--
	From @tmpKeys tmpKeys
	INNER Join REQUIRED_COVERAGE RC On RC.ID = ReqCovID
	INNER Join PROPERTY P On P.ID = PropID
	INNER Join COLLATERAL C On C.ID = CollID
	LEFT Join COLLATERAL_CODE CC On CC.ID = C.COLLATERAL_CODE_ID
	INNER Join LOAN On LOAN.ID = C.LOAN_ID
	INNER Join LENDER LEND On LEND.ID = LOAN.LENDER_ID
	LEFT Join PRIOR_CARRIER_POLICY PCP on PCP.REQUIRED_COVERAGE_ID = RC.ID and RC.SUMMARY_SUB_STATUS_CD = 'P' AND PCP.PURGE_DT IS NULL
	LEFT Join FORCE_PLACED_CERTIFICATE FPC On FPC.ID = tmpKeys.FPC_ID
	LEFT Join USERS LA On LA.ID = LA_ID

	/*
	--VerifyData:
	*/
	OUTER Apply( Select TOP 1 WI.* From WORK_ITEM WI Where WI.PURGE_DT Is Null AND WI.RELATE_ID = LOAN.ID AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
	AND WI.WORKFLOW_DEFINITION_ID = 8 --VerifyData
	AND WI.STATUS_CD NOT IN ('Complete', 'Withdrawn', 'Error')
	--AND WI.DELAY_UNTIL_DT IS NULL
	Order By
	 Case
	 When 1=1
		AND WI.WORKFLOW_DEFINITION_ID = 8 --VerifyData
		AND WI.USER_ROLE_CD = 'Lender'
	 Then 1
	 When 1=1
		AND WI.WORKFLOW_DEFINITION_ID = 8 --VerifyData
	 Then 2
	 When 1=1
		AND WI.USER_ROLE_CD = 'Lender'
	 Then 3
	 Else 9
	 End
	,WI.UPDATE_DT Desc, WI.ID Desc
	) As WI
	--cross APPLY WI.CONTENT_XML.nodes('/Content/VerifyData/Detail') as VerifDat(Det) 
	OUTER APPLY (Select Checked = WI.CONTENT_XML.value('(/Content/VerifyData/Detail)[1]/@Checked','nvarchar(10)')) As VerifDat

	INNER Join REQUIRED_COVERAGE REQCOV On REQCOV.ID = ReqCovID
	LEFT Join LENDER_PRODUCT LP On LP.ID = REQCOV.LENDER_PRODUCT_ID
	LEFT Join REF_CODE RC_CANCELREASON On RC_CANCELREASON.DOMAIN_CD = 'OwnerPolicyCancelReason' and RC_CANCELREASON.CODE_CD = tmpKeys.CANCEL_REASON_CD

	CROSS Apply(
		Select
		 DaysSince = DateDiff(day, DateSinceNoProgress, GetDate())
	) As NoProgress

---- GET MAIL DATE
	OUTER APPLY
	(
		SELECT TOP 1
		 DC.PRINT_STATUS_CD
		,PRINT_STATUS_DT = DC.UPDATE_DT
		,PRINT_STATUS_USER_TX = Coalesce(PrintUser.GIVEN_NAME_TX + ' ' + PrintUser.FAMILY_NAME_TX, PrintUser.FAMILY_NAME_TX, DC.UPDATE_USER_TX)
		--,PRINTED_DT = IsNull(DC.PRINTED_DT,DC.UPDATE_DT)
		,PRINTED_DT = DC.PRINTED_DT
		,NTC.SEQUENCE_NO
		,LTR_SEQUENCE = 'Letter' + IsNull(' ' + Cast(NTC.SEQUENCE_NO As VarChar(10)),'')
		,NTC.UPDATE_DT
		,NTC.NOT_MAILED_IN
		,NTC.NOT_MAILED_NOTE_TX
		,NTC.NOT_MAILED_CD
		,NTC.PDF_GENERATE_CD
		,NTC.TYPE_CD
		,PLI.INFO_XML.value('(/INFO_LOG/USER_ACTION/node())[1]','nvarchar(max)') as REJECT_REASON
		FROM NOTICE NTC
		JOIN NOTICE_REQUIRED_COVERAGE_RELATE REL ON REL.NOTICE_ID = NTC.ID AND NTC.PURGE_DT IS NULL AND REL.PURGE_DT IS NULL
		JOIN PROCESS_LOG_ITEM PLI on PLI.RELATE_ID = NTC.ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Notice' AND PLI.PURGE_DT IS NULL
		JOIN DOCUMENT_CONTAINER DC ON DC.RELATE_ID = NTC.ID AND DC.PURGE_DT IS NULL AND DC.RELATE_CLASS_NAME_TX = 'ALLIED.UNITRAC.NOTICE'
		LEFT Join USERS PrintUser On PrintUser.USER_NAME_TX = Coalesce(DC.PRINTED_BY_USER_TX, DC.PRINT_STATUS_ASSIGNED_USER_TX, DC.UPDATE_USER_TX) --AND PrintUser.SYSTEM_IN = 'N'
		WHERE REL.REQUIRED_COVERAGE_ID = REQCOV.ID
		AND (REQCOV.NOTICE_SEQ_NO > 0)
		AND NTC.TYPE_CD = REQCOV.NOTICE_TYPE_CD
		AND DATEDIFF(DAY, NTC.EXPECTED_ISSUE_DT, REQCOV.NOTICE_DT) = 0
		AND NTC.SEQUENCE_NO = REQCOV.NOTICE_SEQ_NO
		ORDER BY NTC.UPDATE_DT DESC, NTC.ID DESC
	) MaxNtc

/*
--Last Notice Action:
*/
	OUTER Apply(
		Select
		 Action_Tx =
			CASE
				WHEN MaxNtc.PDF_GENERATE_CD Like 'ERR%'
				THEN MaxNtc.LTR_SEQUENCE + ' Error ' + IsNull(Convert(VarChar(10), MaxNtc.UPDATE_DT, 101), '')

				WHEN MaxNtc.NOT_MAILED_IN = 'Y'
				THEN MaxNtc.LTR_SEQUENCE + ' NOT Mailed ' + IsNull(Convert(VarChar(10), MaxNtc.UPDATE_DT, 101), '') + ' - ' + Coalesce(NullIf(MaxNtc.NOT_MAILED_CD,''), NullIf(MaxNtc.PDF_GENERATE_CD,''))

				--would Printed be the same as Mailed, or would there be some subtle difference?
				WHEN MaxNtc.NOT_MAILED_IN = 'N'
				THEN MaxNtc.LTR_SEQUENCE + ' Mailed ' + IsNull(Convert(VarChar(10), MaxNtc.PRINTED_DT, 101), '')

				ELSE MaxNtc.LTR_SEQUENCE + ' Printed ' + IsNull(Convert(VarChar(10), MaxNtc.PRINTED_DT, 101), '')
			 END

	) As LastNotice

/*
--Notice Cap:
*/
	OUTER Apply(
		Select TOP 1
		 Seq.*
		From EVENT_SEQ_CONTAINER As Container
		Join EVENT_SEQUENCE As Seq On Seq.EVENT_SEQ_CONTAINER_ID=Container.ID AND Seq.EVENT_TYPE_CD='NTC' AND Seq.NOTICE_TYPE_CD = MaxNtc.TYPE_CD
		AND Seq.PURGE_DT Is Null
		Where Container.LENDER_ID = @LenderID
		  AND Container.PURGE_DT Is Null
		  AND Container.START_DT <= GetDate()
		  AND Container.END_DT >= GetDate()
	) As NtcSeqCap

	CROSS Apply(
		Select
		 Reason_Tx =
			Case
				When MaxNtc.PRINT_STATUS_CD NOT In ('PRINTED') OR MaxNtc.PRINT_STATUS_CD Is Null OR MaxNtc.PRINTED_DT Is Null
				Then 'Notice Pull' + IsNull(IsNull(' / ' + MaxNtc.PRINT_STATUS_CD,'') + ' ' + Convert(VarChar(10), MaxNtc.PRINT_STATUS_DT, 101),'') + ' by ' + MaxNtc.PRINT_STATUS_USER_TX

				When VerifDat.Checked = 'true'
				Then 'VerifyData checked' + IsNull(' -Work-Item_' + WI.STATUS_CD,'') + IsNull(' (delayed ' + Convert(VarChar(10), WI.DELAY_UNTIL_DT, 101) + ')','')

				When VerifDat.Checked = 'false'
				Then 'VerifyData NOT_checked' + IsNull(' -Work-Item_' + WI.STATUS_CD,'') + IsNull(' (delayed ' + Convert(VarChar(10), WI.DELAY_UNTIL_DT, 101) + ')','')

				When MaxNtc.SEQUENCE_NO > IsNull(NullIf(NtcSeqCap.NOTICE_SEQ_NO,0),999)
				Then 'Notice Cap Exceeded' + '(' + Cast(NtcSeqCap.NOTICE_SEQ_NO As VarChar(10)) + ')'

				When MaxNtc.SEQUENCE_NO = IsNull(NullIf(NtcSeqCap.NOTICE_SEQ_NO,0),999)
				Then 'Notice Cap Reached'

				Else Null
			End
	) As PreBinder

	LEFT Join REF_CODE NRef on NRef.DOMAIN_CD = 'NoticeType' and NRef.CODE_CD = RC.NOTICE_TYPE_CD
	LEFT Join REF_CODE CRRef on CRRef.DOMAIN_CD = 'OwnerPolicyCancelReason' and CRRef.CODE_CD = tmpKeys.CANCEL_REASON_CD
	LEFT Join REF_CODE LSRef on LSRef.DOMAIN_CD = 'LoanStatus' and LSRef.CODE_CD = LOAN.STATUS_CD
	LEFT Join REF_CODE CSRef on CSRef.DOMAIN_CD = 'CollateralStatus' and CSRef.CODE_CD = C.STATUS_CD
	LEFT Join REF_CODE RCSRef on RCSRef.DOMAIN_CD = 'RequiredCoverageStatus' and RCSRef.CODE_CD = RC.STATUS_CD
	LEFT Join REF_CODE RCISRef on RCISRef.DOMAIN_CD = 'RequiredCoverageInsStatus' and RCISRef.CODE_CD = RC.SUMMARY_STATUS_CD
	LEFT Join REF_CODE RCISSRef on RCISSRef.DOMAIN_CD = 'RequiredCoverageInsSubStatus' and RCISSRef.CODE_CD = RC.SUMMARY_SUB_STATUS_CD

CROSS Apply(
	Select
	 Coverage =
	 	   CASE
		  WHEN RC.NOTICE_DT is not null and RC.NOTICE_SEQ_NO > 0
		  THEN cast(RC.NOTICE_SEQ_NO as char(1)) +  ' ' + NRef.MEANING_TX + ' ' + CONVERT(nvarchar(10), RC.NOTICE_DT, 101)
	      
		  ELSE
		   IsNull(case when LOAN.STATUS_CD in ('A') then null else LSRef.MEANING_TX end + ' ','') + 
		   IsNull(case when C.STATUS_CD in ('A') then null else CSRef.MEANING_TX end + ' ','') + 
		   IsNull(RCISSRef.MEANING_TX + ' ','') + 
		   IsNull(RCISRef.MEANING_TX,'')
	   +	   
		  CASE
			 WHEN ISNULL(NRef.CODE_CD ,'') = 'AN'  
			 THEN '; ' + NRef.CODE_CD + ' notified ' + IsNull(CONVERT(nvarchar(10), RC.NOTICE_DT, 101), '')
			
			 ELSE ''
		  END
		END
) As [Status]

where 1=1
order by LOAN.NUMBER_TX,REQCOV.TYPE_CD

IF OBJECT_ID(N'tempdb..#tmpTable1',N'U') IS NOT NULL
  DROP TABLE #tmpTable1

SELECT @RecordCount = @@rowcount

/*
--update OWNER Address...
*/


update tt
set
 OWNER_LASTNAME_TX = O.LAST_NAME_TX
,OWNER_FIRSTNAME_TX = O.FIRST_NAME_TX
from #tmpTable tt
Join OWNER_LOAN_RELATE OLR On OLR.LOAN_ID = tt.LOAN_ID And OLR.PURGE_DT Is Null And OLR.PRIMARY_IN = 'Y'
Join OWNER O On O.ID = OLR.OWNER_ID And O.PURGE_DT Is Null
LEFT Join OWNER_ADDRESS OA On OA.ID = O.ADDRESS_ID And OA.PURGE_DT Is Null

--Char(39) is single quote
Declare @SQUOTE As Char(1) = Char(39)

set @sqlstring = N'Update #tmpTable
	Set
/*
	    [INSCOMPANY_UNINSGROUP_TX] = case when [INSCOMPANY_UNINS_DAYS] >= 0 and [INSCOMPANY_UNINS_DAYS] <= 30 then ''0-30 Uninsured Days''
										  when [INSCOMPANY_UNINS_DAYS] > 30 and [INSCOMPANY_UNINS_DAYS] <= 60 then ''31-60 Uninsured Days''
										  when [INSCOMPANY_UNINS_DAYS] > 60 and [INSCOMPANY_UNINS_DAYS] <= 90 then ''61-90 Uninsured Days''
										  when [INSCOMPANY_UNINS_DAYS] > 90 then ''90> Uninsured Days''
										  else ''''
										  END,
*/
		[REPORT_GROUPBY_TX] = ' + IsNull(NullIf(@GroupBySQL,''), @SQUOTE + @SQUOTE) + ',
		[REPORT_GROUPBY_FIELDS_TX] = ' + replace(replace(IsNull(NullIf(@GroupBySQL,''), @SQUOTE + @SQUOTE), '[', ''''),']','''') + ',
		[REPORT_SORTBY_TX] = ' + IsNull(NullIf(@SortBySQL,''), @SQUOTE + @SQUOTE)
		+ case when isnull(@HeaderTx, '') <> '' then ', [REPORT_HEADER_TX] = ' + @HeaderTx else '' end
		+ case when isnull(@FooterTx, '') <> '' then ', [REPORT_FOOTER_TX] = ' + @FooterTx else '' end
		+ case when @PAGEBREAK = 'T' AND @PAGEBREAK_COLUMN <> 'Branch' then ', [LOAN_PAGEBREAK_TX] = ' + @GroupBySQL else '' end
--
EXECUTE sp_executesql @sqlstring

SELECT @RecordCount = @@rowcount

IF @Report_History_ID IS NOT NULL
BEGIN
  Update [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML
  Set
   RECORD_COUNT_NO = @RecordCount
  ,UPDATE_DT = GETDATE()
  where ID = @Report_History_ID
END

	If IsNull(@debug,0)=0
	Begin
		Select *
		From #tmpTable
		Where IsNull(@debug,0)=0
	End
	Else
	Begin
	/*
	--debug:
	*/
		Select 
		 Exposure=tt.Coverage_Exposure_Dt
		,ColId=tt.Collateral_Id
		,CancelReas=tt.Cancel_Meaning_Tx
		,CoverStatus=tt.Coverage_Status_Tx
		,LastNtc_Act=tt.LastNotice_Action_Tx
		,PreBind_Reas=tt.PreBinder_Reason_Tx
		,SortBy=tt.Report_SortBy_Tx
		,tt.*
		From #tmpTable tt
		Where IsNull(@debug,0)<>0
		--Order by tt.owner_lastname_tx,tt.owner_firstname_tx
	End

END


GO

