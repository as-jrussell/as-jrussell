USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_UTLActivity]    Script Date: 11/23/2015 1:00:43 PM ******/
DROP PROCEDURE [dbo].[Report_UTLActivity]
GO

/****** Object:  StoredProcedure [dbo].[Report_UTLActivity]    Script Date: 11/23/2015 1:00:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_UTLActivity]
--declare
 @LenderCode as nvarchar(10)=NULL
,@Branch as nvarchar(max)=NULL
,@Division as nvarchar(10)=NULL
,@Coverage as nvarchar(25)=NULL
,@FromDate as datetime=NULL
,@ToDate as datetime=NULL
,@User as nvarchar(15)=NULL
,@ReportType as nvarchar(50)=NULL
,@WorkItemType as bigint=NULL
,@WorkQueue as bigint=NULL
,@Report_History_ID as bigint=NULL
AS
BEGIN
IF OBJECT_ID(N'tempdb..#tmpTable',N'U') IS NOT NULL
  DROP TABLE #tmpTable
IF OBJECT_ID(N'tempdb..#BranchTable',N'U') IS NOT NULL
  DROP TABLE #BranchTable

DECLARE @IsFiltered_History As Bit = 0
DECLARE @IsFiltered_Lender As Bit = 0
DECLARE @IsFiltered_Branch As Bit = 0
DECLARE @IsFiltered_Division As Bit = 0
DECLARE @IsFiltered_Coverage As Bit = 0
DECLARE @IsFiltered_User As Bit = 0
DECLARE @IsFiltered_WorkQueue As Bit = 0
	SELECT
	 @IsFiltered_History = CAST(CASE WHEN @Report_History_ID IS NOT NULL AND @Report_History_ID > 0 THEN 1 ELSE 0 END As Bit)
	,@IsFiltered_Lender = CAST(CASE WHEN @LenderCode IS NOT NULL AND @LenderCode <> '' AND @LenderCode <> '0' THEN 1 ELSE 0 END As Bit)
	,@IsFiltered_Branch = CAST(CASE WHEN @Branch IS NOT NULL AND @Branch <> '' AND @Branch <> '1' THEN 1 ELSE 0 END As Bit)
	,@IsFiltered_Division = CAST(CASE WHEN @Division IS NOT NULL AND @Division <> '' AND @Division <> '1' THEN 1 ELSE 0 END As Bit)
	,@IsFiltered_Coverage = CAST(CASE WHEN @Coverage IS NOT NULL AND @Coverage <> '' AND @Coverage <> '1' THEN 1 ELSE 0 END As Bit)
	,@IsFiltered_User = CAST(CASE WHEN @User IS NOT NULL AND @User <> '' AND @User <> '0000' THEN 1 ELSE 0 END As Bit)
	,@IsFiltered_WorkQueue = CAST(CASE WHEN @WorkQueue IS NOT NULL AND @WorkQueue > 0 THEN 1 ELSE 0 END As Bit)

IF @IsFiltered_History = 1 -- NullIf(@Report_History_ID, 0) IS NOT NULL
BEGIN
  SELECT
   @FromDate = CASE WHEN NullIf(NullIf(Dates.FromDate, ''), '1/1/0001') IS NOT NULL AND IsDate(Dates.FromDate) = 1 THEN Dates.FromDate ELSE @FromDate END 
  ,@ToDate = CASE WHEN NullIf(NullIf(Dates.ToDate, ''), '1/1/0001') IS NOT NULL AND IsDate(Dates.ToDate) = 1 THEN Dates.ToDate ELSE @ToDate END 
  FROM REPORT_HISTORY
  CROSS APPLY (SELECT
   FromDate=REPORT_DATA_XML.value('(/ReportData[1]/Report[1]/StartDate/@value)[1]', 'NVarChar(25)')
  ,ToDate=REPORT_DATA_XML.value('(/ReportData[1]/Report[1]/EndDate/@value)[1]', 'NVarChar(25)')
  ) As Dates
  WHERE ID = @Report_History_ID

  SET @FromDate = DATEADD(HH,0,@FromDate)			
  SET @ToDate = DATEADD(HH,0,@ToDate)				
END
  
IF @ToDate > GETDATE()
BEGIN
	SELECT @ToDate = GETDATE()
END
IF @FromDate > @ToDate
BEGIN
	SELECT @FromDate = DateAdd(day, -1, @ToDate)
END

CREATE TABLE [dbo].[#BranchTable] (ID int, STRVALUE nvarchar(30))
DECLARE @BranchTable TABLE (ID int, STRVALUE nvarchar(30))
	INSERT INTO @BranchTable SELECT * FROM SplitFunction(@Branch, ',')  
	INSERT INTO #BranchTable SELECT * FROM @BranchTable -- SplitFunction(@Branch, ',')  

DECLARE @debug as Bit = 0

DECLARE @XQ as Bit = 0
IF @WorkItemType = 999
BEGIN
	SET @XQ = 1
	SET @WorkItemType = (SELECT ID FROM WORKFLOW_DEFINITION WHERE DESCRIPTION_TX = 'Key Image')
END 

--WorkItemType values from RDL 
DECLARE @InboundCallerNotSatisfied as bigint,@InboundEscalated as bigint,@InboundLiveChat as bigint
SET @InboundCallerNotSatisfied = 500
SET @InboundEscalated = 501
SET @InboundLiveChat = 502

--Make the SubWorkItemType to be one of the Inbound types, and reset the @WorkItemType to Inbound Call Workflow, value 5
DECLARE @SubWorkItemType as bigint
IF (@WorkItemType LIKE '50%') 
SELECT @SubWorkItemType = @WorkItemType, @WorkItemType = ID FROM WORKFLOW_DEFINITION WHERE NAME_TX = 'InboundCall'

Declare @LenderID as bigint
Select @LenderID=ID from LENDER where CODE_TX = @LenderCode and PURGE_DT is null

Declare @RecordCount as bigint
set @RecordCount = 0

Declare @ToDatePlus1 as date
set @ToDatePlus1 = DATEADD(dd,1,@ToDate)

CREATE TABLE [dbo].[#tmpTable](
[REPORT_GROUPBY_TX] nvarchar(100) NULL,
[REPORT_SORTBY_TX] nvarchar(100) NULL,
[UPDATE_USER_TX] nvarchar(15) NULL,
[FAMILY_NAME_TX] nvarchar(50) NULL,
[GIVEN_NAME_TX] nvarchar(30) NULL,
[UPDATE_DT] datetime2(7) NULL,
[ACTION_CD] nvarchar(30) NULL,
[ACTION_NOTE_TX] nvarchar(4000) NULL,
[COMMENT_TX] nvarchar(4000) NULL,
[REASON_TX] nvarchar(4000) NULL,
[WorkItemID] bigint NULL,
[WorkItemType] nvarchar(80) NULL,
[WorkQueueName] nvarchar(30) NULL,
[LenderCode] nvarchar(10) NULL,
[LenderName] nvarchar(50) NULL,
[BRANCH_CODE_TX] nvarchar(20) NULL,
[DIVISION_CODE_TX] nvarchar(20) NULL,
[DivisionDescription] nvarchar(200) NULL,
[RequiredCoverage] nvarchar (200) NULL,
[LoanNumber] nvarchar(20) NULL,
[FIRST_NAME_TX] nvarchar(30) NULL,
[LAST_NAME_TX] nvarchar(30) NULL,
[VIN_TX] nvarchar(18) NULL,
[YEAR_TX] nvarchar(4) NULL,
[MAKE_TX] nvarchar(30) NULL,
[MODEL_TX] nvarchar(30) NULL,
[EquipmentDescription] nvarchar(100) NULL,
[BorrowerAddressLine1] nvarchar(100) NULL,
[BorrowerAddressLine2] nvarchar(100) NULL,
[BorrowerAddressCity] nvarchar(40) NULL,
[BorrowerAddressStateProvince] nvarchar(30) NULL,
[BorrowerAddressPostalCode] nvarchar(30) NULL,
[MortgageAddressLine1] nvarchar(100) NULL,
[MortgageAddressLine2] nvarchar(100) NULL,
[MortgageAddressCity] nvarchar(40) NULL,
[MortgageAddressStateProvince] nvarchar(30) NULL,
[MortgageAddressPostalCode] nvarchar(30) NULL,
[PROPERTY_TYPE_CD] nvarchar(100) NULL,
[PROPERTY_DESCRIPTION] nvarchar(800) NULL,
[CALL_ATTEMPTS] nvarchar(2) NULL)

IF (@WorkItemType in (0,2)) 
BEGIN
INSERT INTO #tmpTable ([REPORT_GROUPBY_TX], [REPORT_SORTBY_TX],[UPDATE_USER_TX],[FAMILY_NAME_TX],[GIVEN_NAME_TX],
[UPDATE_DT],[ACTION_CD],[ACTION_NOTE_TX],[WorkItemID],[WorkItemType], [WorkQueueName],
[LenderCode], [LenderName], [BRANCH_CODE_TX], [DIVISION_CODE_TX], [DivisionDescription],
[RequiredCoverage], [LoanNumber], [FIRST_NAME_TX], [LAST_NAME_TX], [VIN_TX], [YEAR_TX],[MAKE_TX],[MODEL_TX],
[EquipmentDescription],[BorrowerAddressLine1],[BorrowerAddressLine2],[BorrowerAddressCity],[BorrowerAddressStateProvince],[BorrowerAddressPostalCode],
[MortgageAddressLine1],[MortgageAddressLine2],[MortgageAddressCity], [MortgageAddressStateProvince],[MortgageAddressPostalCode],[PROPERTY_TYPE_CD],[PROPERTY_DESCRIPTION],[CALL_ATTEMPTS] )
--UTL Match
select 
(ISNULL(LND.CODE_TX,'No Lender') + ' ' + ISNULL(LND.NAME_TX,'') + ' / ' + 
	(CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '' then 'No Branch' else L.BRANCH_CODE_TX END) + ' / ' + 
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, WIA.UPDATE_DT, WIA.ACTION_CD, 
CASE WHEN WIA.ACTION_NOTE_TX = 'system note:' 
	THEN ''
	ELSE WIA.ACTION_NOTE_TX
END AS ACTION_NOTE_TX, 
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX, 
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'') = ''
	THEN '0'
	ELSE L.DIVISION_CODE_TX
END AS DIVISION_CODE_TX,
ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as DivisionDescription, 
RC_COVERAGETYPE.MEANING_TX as RequiredCoverage,
L.NUMBER_TX as LoanNumber,
O.FIRST_NAME_TX, O.LAST_NAME_TX,
P.VIN_TX, P.YEAR_TX, P.MAKE_TX, P.MODEL_TX, P.DESCRIPTION_TX as EquipmentDescription,
AO.LINE_1_TX as BorrowerAddressLine1, AO.LINE_2_TX as BorrowerAddressLine2,
AO.CITY_TX as BorrowerAddressCity, AO.STATE_PROV_TX as BorrowerAddressStateProvince, AO.POSTAL_CODE_TX as BorrowerAddressPostalCode,
AM.LINE_1_TX as MortgageAddressLine1, AM.LINE_2_TX as MortgageAddressLine2,
AM.CITY_TX as MortgageAddressCity, AM.STATE_PROV_TX as MortgageAddressStateProvince, AM.POSTAL_CODE_TX as MortgageAddressPostalCode, 
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD,
dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION,
NULL AS CALL_ATTEMPTS
from WORK_ITEM_ACTION WIA 
join WORK_ITEM WI on WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
LEFT JOIN WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
join USERS U on U.USER_NAME_TX = WIA.UPDATE_USER_TX 
join WORKFLOW_DEFINITION WD on WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL and WD.ID in (2) AND WD.PURGE_DT IS NULL
join UTL_MATCH_RESULT UMR on UMR.ID = WI.RELATE_ID
Join LOAN L on L.ID = UMR.LOAN_ID
Join LENDER LND on LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
Join COLLATERAL C on C.LOAN_ID = UMR.UTL_LOAN_ID
Join PROPERTY P on P.ID = C.PROPERTY_ID and P.LENDER_ID = L.LENDER_ID
inner loop Join REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
left Join OWNER_LOAN_RELATE OLR on OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,'N') = 'Y'
left Join [OWNER] O on O.ID = OLR.OWNER_ID
left Join [OWNER_ADDRESS] AO on AO.ID = O.ADDRESS_ID
left Join [OWNER_ADDRESS] AM on AM.ID = P.ADDRESS_ID
left Join REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left Join REF_CODE RC_COVERAGETYPE on RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
where U.FAMILY_NAME_TX not like '%serv%' and WIA.ACTION_CD != 'Complete'
and
(L.LENDER_ID = @LenderID or @LenderCode is NULL or @LenderCode = '' or @LenderCode = '0') 
and
(L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable) or @Branch = '1' or @Branch = '' or @Branch is NULL)
AND fn_FCBD.loanType IS NOT NULL
and
(RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage = '' or @Coverage is NULL)
and
(WIA.UPDATE_USER_TX = @User or @User is NULL or @User = '' or @User = '0000')
and
WIA.UPDATE_DT >= @FromDate and WIA.UPDATE_DT < @ToDatePlus1 
and
(WQ.ID = @WorkQueue or @WorkQueue is NULL or @WorkQueue = '' or @WorkQueue = 0)
AND (((WQ.NAME_TX LIKE '%XQ%' OR WQ.NAME_TX LIKE '%X Queue%') AND @XQ = 1) OR @XQ = 0)
OPTION(OPTIMIZE FOR (@FromDate = '2014-01-01', @ToDatePlus1 = '2014-01-02'))
END



IF (@WorkItemType in (0,4)) 
BEGIN
INSERT INTO #tmpTable ([REPORT_GROUPBY_TX], [REPORT_SORTBY_TX],[UPDATE_USER_TX],[FAMILY_NAME_TX],[GIVEN_NAME_TX],
[UPDATE_DT],[ACTION_CD],[ACTION_NOTE_TX],[WorkItemID],[WorkItemType], [WorkQueueName],
[LenderCode], [LenderName], [BRANCH_CODE_TX], [DIVISION_CODE_TX], [DivisionDescription],
[RequiredCoverage], [LoanNumber], [FIRST_NAME_TX], [LAST_NAME_TX], [VIN_TX], [YEAR_TX],[MAKE_TX],[MODEL_TX],
[EquipmentDescription],[BorrowerAddressLine1],[BorrowerAddressLine2],[BorrowerAddressCity],[BorrowerAddressStateProvince],[BorrowerAddressPostalCode],
[MortgageAddressLine1],[MortgageAddressLine2],[MortgageAddressCity], [MortgageAddressStateProvince],[MortgageAddressPostalCode],[PROPERTY_TYPE_CD], PROPERTY_DESCRIPTION,[CALL_ATTEMPTS] )
--Key Image, Work Item Action
select 
(ISNULL(LND.CODE_TX,'No Lender') + ' ' + ISNULL(LND.NAME_TX,'') + ' / ' + 
	(CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '' then 'No Branch' else L.BRANCH_CODE_TX END) + ' / ' + 
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, WIA.UPDATE_DT, WIA.ACTION_CD, 
CASE WHEN WIA.ACTION_NOTE_TX = 'system note:' 
	THEN ''
	ELSE WIA.ACTION_NOTE_TX
END AS ACTION_NOTE_TX, 
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX, 
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'') = ''
	THEN '0'
	ELSE L.DIVISION_CODE_TX
END AS DIVISION_CODE_TX,
ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as DivisionDescription, 
RC_COVERAGETYPE.MEANING_TX as RequiredCoverage,
L.NUMBER_TX as LoanNumber,
O.FIRST_NAME_TX, O.LAST_NAME_TX,
P.VIN_TX, P.YEAR_TX, P.MAKE_TX, P.MODEL_TX, P.DESCRIPTION_TX as EquipmentDescription,
AO.LINE_1_TX as BorrowerAddressLine1, AO.LINE_2_TX as BorrowerAddressLine2,
AO.CITY_TX as BorrowerAddressCity, AO.STATE_PROV_TX as BorrowerAddressStateProvince, AO.POSTAL_CODE_TX as BorrowerAddressPostalCode,
AM.LINE_1_TX as MortgageAddressLine1, AM.LINE_2_TX as MortgageAddressLine2,
AM.CITY_TX as MortgageAddressCity, AM.STATE_PROV_TX as MortgageAddressStateProvince, AM.POSTAL_CODE_TX as MortgageAddressPostalCode,
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD, dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION,
NULL AS CALL_ATTEMPTS
from WORK_ITEM_ACTION WIA 
join WORK_ITEM WI on WI.ID = WIA.WORK_ITEM_ID and WI.PURGE_DT IS NULL
LEFT JOIN WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
join WORKFLOW_DEFINITION WD on WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL and WD.ID in (4)
join VUT.dbo.tblImageQueue IQ on IQ.ID = WI.RELATE_ID
left join INTERACTION_HISTORY IH on IH.DOCUMENT_ID = IQ.DOCUMENT_CONTAINER_ID and IH.TYPE_CD <> 'MEMO' and IH.PURGE_DT IS NULL
join USERS U on U.USER_NAME_TX = WIA.UPDATE_USER_TX
left Join PROPERTY P on P.ID = IH.PROPERTY_ID
left Join REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
	AND IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'nvarchar(15)') = RC.ID
left LOOP Join COLLATERAL C on C.PROPERTY_ID = P.ID
left LOOP Join LOAN L on L.ID = C.LOAN_ID
left Join LENDER LND on LND.ID = L.LENDER_ID and LND.PURGE_DT is null
left LOOP Join OWNER_LOAN_RELATE OLR on OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,'N') = 'Y'
left LOOP Join [OWNER] O on O.ID = OLR.OWNER_ID
left LOOP Join [OWNER_ADDRESS] AO on AO.ID = O.ADDRESS_ID
left Join [OWNER_ADDRESS] AM on AM.ID = P.ADDRESS_ID
left Join REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left Join REF_CODE RC_COVERAGETYPE on RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
where WIA.PURGE_DT IS NULL and U.FAMILY_NAME_TX not like '%serv%'
and
(L.LENDER_ID = @LenderID or @LenderCode is NULL or @LenderCode = '' or @LenderCode = '0') 
and
(L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable) or @Branch = '1' or @Branch = '' or @Branch is NULL)
AND fn_FCBD.loanType IS NOT NULL
and
(RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage = '' or @Coverage is NULL)
and
(WIA.UPDATE_USER_TX = @User or @User is NULL or @User = '' or @User = '0000')
and
(WIA.UPDATE_DT >= @FromDate and WIA.UPDATE_DT < @ToDatePlus1)
and
(WQ.ID = @WorkQueue or @WorkQueue is NULL or @WorkQueue = '' or @WorkQueue = 0)
AND (((WQ.NAME_TX LIKE '%XQ%' OR WQ.NAME_TX LIKE '%X Queue%') AND @XQ = 1) OR @XQ = 0)
and WIA.ACTION_CD <> 'Complete'
and ISNULL(IH.SPECIAL_HANDLING_XML.value('(/SH/Source)[1]', 'nvarchar(15)'),'') in ('','UniTrac')
OPTION(OPTIMIZE FOR (@FromDate = '2014-01-01', @ToDatePlus1 = '2014-01-02'))
END


IF (@WorkItemType in (0,4)) 
BEGIN
INSERT INTO #tmpTable ([REPORT_GROUPBY_TX], [REPORT_SORTBY_TX],[UPDATE_USER_TX],[FAMILY_NAME_TX],[GIVEN_NAME_TX],
[UPDATE_DT],[ACTION_CD],[ACTION_NOTE_TX],[WorkItemID],[WorkItemType], [WorkQueueName],
[LenderCode], [LenderName], [BRANCH_CODE_TX], [DIVISION_CODE_TX], [DivisionDescription],
[RequiredCoverage], [LoanNumber], [FIRST_NAME_TX], [LAST_NAME_TX], [VIN_TX], [YEAR_TX],[MAKE_TX],[MODEL_TX],
[EquipmentDescription],[BorrowerAddressLine1],[BorrowerAddressLine2],[BorrowerAddressCity],[BorrowerAddressStateProvince],[BorrowerAddressPostalCode],
[MortgageAddressLine1],[MortgageAddressLine2],[MortgageAddressCity], [MortgageAddressStateProvince],[MortgageAddressPostalCode],[PROPERTY_TYPE_CD], PROPERTY_DESCRIPTION,[CALL_ATTEMPTS] )
--Key Image, Interaction History
select 
'' AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), IH.CREATE_DT, 120) AS REPORT_SORTBY_TX,
IH.CREATE_USER_TX,U.FAMILY_NAME_TX,U.GIVEN_NAME_TX,IH.CREATE_DT,RC_IHTYPE.DESCRIPTION_TX,
Left(IH.NOTE_TX,4000) AS ACTION_NOTE_TX, 
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX, 
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'') = ''
	THEN '0'
	ELSE L.DIVISION_CODE_TX
END AS DIVISION_CODE_TX,
ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as DivisionDescription, 
RC_COVERAGETYPE.MEANING_TX as RequiredCoverage,
L.NUMBER_TX as LoanNumber,
O.FIRST_NAME_TX, O.LAST_NAME_TX,
P.VIN_TX, P.YEAR_TX, P.MAKE_TX, P.MODEL_TX, P.DESCRIPTION_TX as EquipmentDescription,
AO.LINE_1_TX as BorrowerAddressLine1, AO.LINE_2_TX as BorrowerAddressLine2,
AO.CITY_TX as BorrowerAddressCity, AO.STATE_PROV_TX as BorrowerAddressStateProvince, AO.POSTAL_CODE_TX as BorrowerAddressPostalCode,
AM.LINE_1_TX as MortgageAddressLine1, AM.LINE_2_TX as MortgageAddressLine2,
AM.CITY_TX as MortgageAddressCity, AM.STATE_PROV_TX as MortgageAddressStateProvince, AM.POSTAL_CODE_TX as MortgageAddressPostalCode,
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD,
dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION,
NULL AS CALL_ATTEMPTS
from WORK_ITEM_ACTION WIA 
join WORK_ITEM WI on WI.ID = WIA.WORK_ITEM_ID and WI.PURGE_DT IS NULL
LEFT JOIN WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
join WORKFLOW_DEFINITION WD on WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL and WD.ID in (4)
join VUT.dbo.tblImageQueue IQ on IQ.ID = WI.RELATE_ID 
left join INTERACTION_HISTORY IH on IH.DOCUMENT_ID = IQ.DOCUMENT_CONTAINER_ID and IH.TYPE_CD <> 'MEMO' and IH.PURGE_DT IS NULL
join USERS U on U.USER_NAME_TX = IH.CREATE_USER_TX
left Join PROPERTY P on P.ID = IH.PROPERTY_ID
left Join REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
	AND IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'nvarchar(15)') = RC.ID
left Join COLLATERAL C on C.PROPERTY_ID = P.ID
left Join LOAN L on L.ID = C.LOAN_ID 
left Join LENDER LND on LND.ID = L.LENDER_ID and LND.PURGE_DT is null
left Join OWNER_LOAN_RELATE OLR on OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,'N') = 'Y'	
left Join [OWNER] O on O.ID = OLR.OWNER_ID
left Join [OWNER_ADDRESS] AO on AO.ID = O.ADDRESS_ID
left Join [OWNER_ADDRESS] AM on AM.ID = P.ADDRESS_ID
left Join REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left Join REF_CODE RC_COVERAGETYPE on RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
left Join REF_CODE RC_IHTYPE on RC_IHTYPE.DOMAIN_CD = 'InteractionHistoryType' and RC_IHTYPE.CODE_CD = IH.TYPE_CD
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
where WIA.PURGE_DT IS NULL and U.FAMILY_NAME_TX not like '%serv%'
and
(L.LENDER_ID = @LenderID or @LenderCode is NULL or @LenderCode = '' or @LenderCode = '0') 
and
(L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable) or @Branch = '1' or @Branch = '' or @Branch is NULL)
AND fn_FCBD.loanType IS NOT NULL
and
(RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage = '' or @Coverage is NULL)
and
(IH.CREATE_USER_TX = @User or @User is NULL or @User = '' or @User = '0000')
and
(IH.CREATE_DT >= @FromDate and IH.CREATE_DT < @ToDatePlus1)
and
(WQ.ID = @WorkQueue or @WorkQueue is NULL or @WorkQueue = '' or @WorkQueue = 0)
AND (((WQ.NAME_TX LIKE '%XQ%' OR WQ.NAME_TX LIKE '%X Queue%') AND @XQ = 1) OR @XQ = 0)
and ISNULL(IH.SPECIAL_HANDLING_XML.value('(/SH/Source)[1]', 'nvarchar(15)'),'') in ('','UniTrac')
OPTION(OPTIMIZE FOR (@FromDate = '2014-01-01', @ToDatePlus1 = '2014-01-02'))
END

IF (@WorkItemType in (0,5,6) or @WorkItemType LIKE '50%') 
BEGIN
declare @columns nvarchar(max)
declare @insert nvarchar(max)
declare @joins nvarchar(max)
declare @conditions nvarchar(max)

--Inbound call
SET @insert = N'
INSERT INTO #tmpTable ([REPORT_GROUPBY_TX], [REPORT_SORTBY_TX],[UPDATE_USER_TX],[FAMILY_NAME_TX],[GIVEN_NAME_TX],
[UPDATE_DT],[ACTION_CD],[ACTION_NOTE_TX],[COMMENT_TX],[REASON_TX],[WorkItemID],[WorkItemType], [WorkQueueName],
[LenderCode], [LenderName], [BRANCH_CODE_TX], [DIVISION_CODE_TX], [DivisionDescription],
[RequiredCoverage], [LoanNumber], [FIRST_NAME_TX], [LAST_NAME_TX], [VIN_TX], [YEAR_TX],[MAKE_TX],[MODEL_TX],
[EquipmentDescription],[BorrowerAddressLine1],[BorrowerAddressLine2],[BorrowerAddressCity],[BorrowerAddressStateProvince],[BorrowerAddressPostalCode],
[MortgageAddressLine1],[MortgageAddressLine2],[MortgageAddressCity], [MortgageAddressStateProvince],[MortgageAddressPostalCode],[PROPERTY_TYPE_CD],[PROPERTY_DESCRIPTION],[CALL_ATTEMPTS] )'

SET @columns = N'
select 
(ISNULL(LND.CODE_TX,''No Lender'') + '' '' + ISNULL(LND.NAME_TX,'''') + '' / '' + 
	(CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '''' then ''No Branch'' else L.BRANCH_CODE_TX END) + '' / '' + 
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, WIA.UPDATE_DT, WIA.ACTION_CD, 
Left(IH.NOTE_TX,3500) + 
CASE WHEN ISNULL(IH_SH.Resolution, '''') = '''' OR
          ISNULL(Left(IH.NOTE_TX,3500), '''') = ''''
	THEN ''''
	ELSE '' / '' 
END +
ISNULL(IH_SH.Resolution, '''') AS ACTION_NOTE_TX, 
Coalesce(Left(IH.NOTE_TX,3500), '''') AS COMMENT_TX, 
Coalesce(IH_SH.Resolution, '''') AS REASON_TX, 
WI.ID as WorkItemID, 
CASE 
	WHEN @SubWorkItemType = @InboundCallerNotSatisfied THEN ''Inbound Call Workflow - Caller Not Satisfied''
	WHEN @SubWorkItemType = @InboundEscalated THEN ''Inbound Call Workflow - Escalated''
	WHEN @SubWorkItemType = @InboundLiveChat THEN ''Inbound Call Workflow - Live Chat''
	ELSE WD.DESCRIPTION_TX 
END as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX, 
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'''') = ''''
	THEN ''0''
	ELSE L.DIVISION_CODE_TX
END AS DIVISION_CODE_TX,
ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as DivisionDescription, 
RequiredCoverage = STUFF(COVERAGE.CSV, 1, 2, '''')
 + ''' + CASE WHEN IsNull(@Coverage, '1') <> '1' THEN ' (filtered)' ELSE '' END + ''',
L.NUMBER_TX as LoanNumber,
O.FIRST_NAME_TX, O.LAST_NAME_TX,
P.VIN_TX, P.YEAR_TX, P.MAKE_TX, P.MODEL_TX, P.DESCRIPTION_TX as EquipmentDescription,
AO.LINE_1_TX as BorrowerAddressLine1, AO.LINE_2_TX as BorrowerAddressLine2,
AO.CITY_TX as BorrowerAddressCity, AO.STATE_PROV_TX as BorrowerAddressStateProvince, AO.POSTAL_CODE_TX as BorrowerAddressPostalCode,
AM.LINE_1_TX as MortgageAddressLine1, AM.LINE_2_TX as MortgageAddressLine2,
AM.CITY_TX as MortgageAddressCity, AM.STATE_PROV_TX as MortgageAddressStateProvince, AM.POSTAL_CODE_TX as MortgageAddressPostalCode,
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD,
dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION,
ISNULL(IH.SPECIAL_HANDLING_XML.value(''(/SH/CallAttempts/text())[1]'', ''NVARCHAR(2)''), '''') AS CALL_ATTEMPTS'

set @joins = N' 
FROM WORK_ITEM_ACTION WIA WITH(NOLOCK)
INNER loop JOIN WORK_ITEM WI WITH(NOLOCK) on WI.ID = WIA.WORK_ITEM_ID and WI.PURGE_DT IS NULL
LEFT JOIN WORK_QUEUE WQ WITH(NOLOCK) ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
JOIN USERS U WITH(NOLOCK) on Left(U.USER_NAME_TX,15) = Left(WIA.UPDATE_USER_TX,15) 
JOIN WORKFLOW_DEFINITION WD WITH(NOLOCK) on WD.ID = WI.WORKFLOW_DEFINITION_ID and WD.PURGE_DT IS NULL and WD.ID in (5,6)
LEFT JOIN INTERACTION_HISTORY IH WITH(NOLOCK) on IH.ID = WI.RELATE_ID AND IH.PURGE_DT IS NULL
LEFT JOIN PROPERTY P WITH(NOLOCK) on P.ID = IH.PROPERTY_ID AND P.PURGE_DT IS NULL
CROSS APPLY (SELECT CSV = (SELECT '', '' + RC_COVERAGETYPE.MEANING_TX FROM REQUIRED_COVERAGE AS RC WITH(NOLOCK), REF_CODE AS RC_COVERAGETYPE WITH(NOLOCK) WHERE RC.PROPERTY_ID = P.ID AND RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD AND (RC.TYPE_CD = ' + Case When @IsFiltered_Coverage = 1 THEN '''' + @Coverage + '''' Else 'RC.TYPE_CD' End + ') ORDER BY RC_COVERAGETYPE.MEANING_TX FOR XML PATH(''''))) AS COVERAGE
LEFT JOIN REQUIRED_COVERAGE RC_IH WITH(NOLOCK) on RC_IH.ID = IH.REQUIRED_COVERAGE_ID
LEFT JOIN COLLATERAL C WITH(NOLOCK) on C.PROPERTY_ID = P.ID AND C.PURGE_DT IS NULL
LEFT JOIN LOAN L WITH(NOLOCK) on L.ID = C.LOAN_ID AND L.PURGE_DT IS NULL
LEFT JOIN LENDER LND WITH(NOLOCK) on LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
LEFT JOIN OWNER_LOAN_RELATE OLR WITH(NOLOCK) on OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,''N'') = ''Y''	AND OLR.PURGE_DT IS NULL
LEFT loop JOIN [OWNER] O WITH(NOLOCK) on O.ID = OLR.OWNER_ID AND O.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AO WITH(NOLOCK) on AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AM WITH(NOLOCK) on AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
LEFT JOIN REF_CODE RC_DIVISION WITH(NOLOCK) on RC_DIVISION.DOMAIN_CD = ''ContractType'' and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
LEFT JOIN COLLATERAL_CODE CC WITH(NOLOCK) ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
LEFT JOIN REF_CODE RC_SC WITH(NOLOCK) on RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
LEFT JOIN REF_CODE_ATTRIBUTE RCA_PROP WITH(NOLOCK) on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
CROSS APPLY (Select Resolution = IH.SPECIAL_HANDLING_XML.value(''(/SH/Resolution/text())[1]'', ''NVARCHAR(500)'')) IH_SH
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD 
'

select @conditions = N'
WHERE WIA.UPDATE_DT >= @FromDate and WIA.UPDATE_DT < @ToDatePlus1 
AND U.FAMILY_NAME_TX not like ''%serv%''
and
WIA.PURGE_DT IS NULL and WIA.ACTION_CD != ''Initial''' 
+ case when @LenderCode <> '' and @LenderCode <> '0' and @LenderCode is not null then ' AND L.Lender_ID = @LenderID' else '' end
+ case when @Branch <> '1' and @Branch <> '' and @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
+ case when @Division <> '1' and @Division <> '' and @Division is NOT NULL then ' AND fn_FCBD.loanType IS NOT NULL '
else '' end
+ case when isnull(@Coverage , '1') <> '1' then char(10) + ' and (@Coverage = IsNull(RC_IH.TYPE_CD, @Coverage) AND @Coverage IN (SELECT RC.TYPE_CD FROM REQUIRED_COVERAGE AS RC, REF_CODE AS RC_COVERAGETYPE WHERE RC.PROPERTY_ID = P.ID AND RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD)) ' else '' end
+ case when @User <> '' and @User <> '0000' and @User is not null then ' AND WIA.UPDATE_USER_TX = @User' else '' end
+ case when @WorkItemType <> '' and @WorkItemType is not null and @WorkItemType <> 0 then ' AND WD.ID = @WorkItemType' else '' end
+ case when @SubWorkItemType = @InboundCallerNotSatisfied then ' AND  IH.SPECIAL_HANDLING_XML.exist(''(/SH/CallerSatisfied)[. = ''''N'''']'') = 1' 
	when @SubWorkItemType = @InboundEscalated then ' AND IH.SPECIAL_HANDLING_XML.exist(''(/SH/EscalatedCall)[. = ''''Y'''']'') = 1'
	when @SubWorkItemType = @InboundLiveChat then ' AND IH.SPECIAL_HANDLING_XML.exist(''(/SH/LiveChat)[. = ''''Y'''']'') = 1'
	else '' end
+ case when @WorkQueue <> '' and @WorkQueue <> '' and @WorkQueue <> 0 then ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end
+ ' OPTION(OPTIMIZE FOR (@FromDate = ''' + CONVERT(VarChar(10), @FromDate, 111) + ''', @ToDatePlus1 = ''' + CONVERT(VarChar(10), @ToDatePlus1, 111) + ''''
+ case when @IsFiltered_Lender = 1 then ', @LenderID = ' + CAST(@LenderID As VarChar(10)) else '' end
+ '))'

declare @finalquery nvarchar(max)
--select @finalquery = @insert + @columns + @joins + @conditions
select @finalquery = @columns + @joins + @conditions

if @debug = 1
begin
	If @finalquery Is Null
	BEGIN
		print isnull(@columns, '@columns IS NULL')
		print isnull(@joins,'@joins IS NULL')
		print isnull(@conditions, '@conditions IS NULL')
	END
	ELSE
	BEGIN
		print 'LEN_finalquery: '
		print LEN(@finalquery)
		print 'finalquery: '
		print substring(@finalquery, 1, 4000)
		print substring(@finalquery, 4001, 4000)
	END
end
IF @finalquery NOT LIKE @insert + '%'
BEGIN
INSERT INTO #tmpTable ([REPORT_GROUPBY_TX], [REPORT_SORTBY_TX],[UPDATE_USER_TX],[FAMILY_NAME_TX],[GIVEN_NAME_TX],
[UPDATE_DT],[ACTION_CD],[ACTION_NOTE_TX],[WorkItemID],[WorkItemType], [WorkQueueName],
[LenderCode], [LenderName], [BRANCH_CODE_TX], [DIVISION_CODE_TX], [DivisionDescription],
[RequiredCoverage], [LoanNumber], [FIRST_NAME_TX], [LAST_NAME_TX], [VIN_TX], [YEAR_TX],[MAKE_TX],[MODEL_TX],
[EquipmentDescription],[BorrowerAddressLine1],[BorrowerAddressLine2],[BorrowerAddressCity],[BorrowerAddressStateProvince],[BorrowerAddressPostalCode],
[MortgageAddressLine1],[MortgageAddressLine2],[MortgageAddressCity], [MortgageAddressStateProvince],[MortgageAddressPostalCode],[PROPERTY_TYPE_CD], PROPERTY_DESCRIPTION,[CALL_ATTEMPTS] )
	exec sp_executesql @finalquery, 
	N'@SubWorkItemType bigint, @InboundCallerNotSatisfied bigint, @InboundEscalated bigint, @InboundLiveChat bigint,
	@LenderID bigint, @Division nvarchar(10), @Coverage nvarchar(10), @User nvarchar(15),
	@FromDate datetime, @ToDatePlus1 datetime,@WorkItemType bigint,@WorkQueue bigint',
	@SubWorkItemType, @InboundCallerNotSatisfied, @InboundEscalated, @InboundLiveChat,
	@LenderID, @Division, @Coverage, @User,
	@FromDate, @ToDatePlus1,@WorkItemType,@WorkQueue
END
ELSE
exec sp_executesql @finalquery, 
	N'@SubWorkItemType bigint, @InboundCallerNotSatisfied bigint, @InboundEscalated bigint, @InboundLiveChat bigint,
	@LenderID bigint, @Division nvarchar(10), @Coverage nvarchar(10), @User nvarchar(15),
	@FromDate datetime, @ToDatePlus1 datetime,@WorkItemType bigint,@WorkQueue bigint',
	@SubWorkItemType, @InboundCallerNotSatisfied, @InboundEscalated, @InboundLiveChat,
	@LenderID, @Division, @Coverage, @User,
	@FromDate, @ToDatePlus1,@WorkItemType,@WorkQueue
END


IF (@WorkItemType in (0,7,8)) 
BEGIN
INSERT INTO #tmpTable ([REPORT_GROUPBY_TX], [REPORT_SORTBY_TX],[UPDATE_USER_TX],[FAMILY_NAME_TX],[GIVEN_NAME_TX],
[UPDATE_DT],[ACTION_CD],[ACTION_NOTE_TX],[WorkItemID],[WorkItemType], [WorkQueueName],
[LenderCode], [LenderName], [BRANCH_CODE_TX], [DIVISION_CODE_TX], [DivisionDescription],
[RequiredCoverage], [LoanNumber], [FIRST_NAME_TX], [LAST_NAME_TX], [VIN_TX], [YEAR_TX],[MAKE_TX],[MODEL_TX],
[EquipmentDescription],[BorrowerAddressLine1],[BorrowerAddressLine2],[BorrowerAddressCity],[BorrowerAddressStateProvince],[BorrowerAddressPostalCode],
[MortgageAddressLine1],[MortgageAddressLine2],[MortgageAddressCity], [MortgageAddressStateProvince],[MortgageAddressPostalCode],[PROPERTY_TYPE_CD], PROPERTY_DESCRIPTION,[CALL_ATTEMPTS] )
--Verify Data or Action Request
select 
(ISNULL(LND.CODE_TX,'No Lender') + ' ' + ISNULL(LND.NAME_TX,'') + ' / ' + 
	(CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '' then 'No Branch' else L.BRANCH_CODE_TX END) + ' / ' + 
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, WIA.UPDATE_DT, WIA.ACTION_CD, 
CASE WHEN WIA.ACTION_NOTE_TX = 'system note:' 
	THEN ''
	ELSE WIA.ACTION_NOTE_TX
END AS ACTION_NOTE_TX, 
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX, 
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'') = ''
	THEN '0'
	ELSE L.DIVISION_CODE_TX
END AS DIVISION_CODE_TX,
ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as DivisionDescription, 
RC_COVERAGETYPE.MEANING_TX as RequiredCoverage,
L.NUMBER_TX as LoanNumber,
O.FIRST_NAME_TX, O.LAST_NAME_TX,
P.VIN_TX, P.YEAR_TX, P.MAKE_TX, P.MODEL_TX, P.DESCRIPTION_TX as EquipmentDescription,
AO.LINE_1_TX as BorrowerAddressLine1, AO.LINE_2_TX as BorrowerAddressLine2,
AO.CITY_TX as BorrowerAddressCity, AO.STATE_PROV_TX as BorrowerAddressStateProvince, AO.POSTAL_CODE_TX as BorrowerAddressPostalCode,
AM.LINE_1_TX as MortgageAddressLine1, AM.LINE_2_TX as MortgageAddressLine2,
AM.CITY_TX as MortgageAddressCity, AM.STATE_PROV_TX as MortgageAddressStateProvince, AM.POSTAL_CODE_TX as MortgageAddressPostalCode,
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD,
dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION,
NULL AS CALL_ATTEMPTS
from WORK_ITEM_ACTION WIA 
inner loop join WORK_ITEM WI on WI.ID = WIA.WORK_ITEM_ID
LEFT JOIN WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
join USERS U on U.USER_NAME_TX = WIA.UPDATE_USER_TX AND U.PURGE_DT IS NULL
join WORKFLOW_DEFINITION WD on WD.ID = WI.WORKFLOW_DEFINITION_ID and WD.PURGE_DT IS NULL and WD.ID in (7,8)
left Join LOAN L on L.ID = WI.RELATE_ID 
left Join COLLATERAL C on C.LOAN_ID = L.ID
left Join PROPERTY P on P.ID = C.PROPERTY_ID and P.LENDER_ID = L.LENDER_ID
left Join REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
left Join LENDER LND on LND.ID = L.LENDER_ID
left Join OWNER_LOAN_RELATE OLR on OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,'N') = 'Y'	
left Join [OWNER] O on O.ID = OLR.OWNER_ID
left Join [OWNER_ADDRESS] AO on AO.ID = O.ADDRESS_ID
left Join [OWNER_ADDRESS] AM on AM.ID = P.ADDRESS_ID
left Join REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left Join REF_CODE RC_COVERAGETYPE on RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
where U.FAMILY_NAME_TX not like '%serv%' 
and
(L.LENDER_ID = @LenderID or @LenderCode is NULL or @LenderCode = '' or @LenderCode = '0') 
and
(L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable) or @Branch = '1' or @Branch = '' or @Branch is NULL)
AND fn_FCBD.loanType IS NOT NULL
and
(RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage = '' or @Coverage is NULL)
and
(WIA.UPDATE_USER_TX = @User or @User is NULL or @User = '' or @User = '0000')
and
WIA.UPDATE_DT >= @FromDate and WIA.UPDATE_DT < @ToDatePlus1
and
(WD.ID = @WorkItemType or @WorkItemType is NULL or @WorkItemType = '' or @WorkItemType = 0)
and
(WQ.ID = @WorkQueue or @WorkQueue is NULL or @WorkQueue = '' or @WorkQueue = 0)
AND (((WQ.NAME_TX LIKE '%XQ%' OR WQ.NAME_TX LIKE '%X Queue%') AND @XQ = 1) OR @XQ = 0)
OPTION(OPTIMIZE FOR (@FromDate = '2014-01-01', @ToDatePlus1 = '2014-01-02'))
END

IF (@WorkItemType in (0,3)) 
BEGIN
INSERT INTO #tmpTable ([REPORT_GROUPBY_TX], [REPORT_SORTBY_TX],[UPDATE_USER_TX],[FAMILY_NAME_TX],[GIVEN_NAME_TX],
[UPDATE_DT],[ACTION_CD],[ACTION_NOTE_TX],[WorkItemID],[WorkItemType], [WorkQueueName],
[LenderCode], [LenderName], [BRANCH_CODE_TX], [DIVISION_CODE_TX], [DivisionDescription],
[RequiredCoverage], [LoanNumber], [FIRST_NAME_TX], [LAST_NAME_TX], [VIN_TX], [YEAR_TX],[MAKE_TX],[MODEL_TX],
[EquipmentDescription],[BorrowerAddressLine1],[BorrowerAddressLine2],[BorrowerAddressCity],[BorrowerAddressStateProvince],[BorrowerAddressPostalCode],
[MortgageAddressLine1],[MortgageAddressLine2],[MortgageAddressCity], [MortgageAddressStateProvince],[MortgageAddressPostalCode],[PROPERTY_TYPE_CD], PROPERTY_DESCRIPTION,[CALL_ATTEMPTS] )
--CPI Cancel Pending
select 
(ISNULL(LND.CODE_TX,'No Lender') + ' ' + ISNULL(LND.NAME_TX,'') + ' / ' + 
	(CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '' then 'No Branch' else L.BRANCH_CODE_TX END) + ' / ' + 
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, WIA.UPDATE_DT, RC_ACTION.MEANING_TX, 
isnull(WI.CONTENT_XML.value('(/Content/CancelCPIWorkflow/UnableToProcessReason/@meaning)[1]', 'varchar(100)'),
	CASE WHEN WIA.ACTION_NOTE_TX = 'system note:' THEN ''
		ELSE WIA.ACTION_NOTE_TX
	END) as ACTION_NOTE_TX,
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX, 
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'') = ''
	THEN '0'
	ELSE L.DIVISION_CODE_TX
END AS DIVISION_CODE_TX,
ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as DivisionDescription, 
RC_COVERAGETYPE.MEANING_TX as RequiredCoverage,
L.NUMBER_TX as LoanNumber,
O.FIRST_NAME_TX, O.LAST_NAME_TX,
P.VIN_TX, P.YEAR_TX, P.MAKE_TX, P.MODEL_TX, P.DESCRIPTION_TX as EquipmentDescription,
AO.LINE_1_TX as BorrowerAddressLine1, AO.LINE_2_TX as BorrowerAddressLine2,
AO.CITY_TX as BorrowerAddressCity, AO.STATE_PROV_TX as BorrowerAddressStateProvince, AO.POSTAL_CODE_TX as BorrowerAddressPostalCode,
AM.LINE_1_TX as MortgageAddressLine1, AM.LINE_2_TX as MortgageAddressLine2,
AM.CITY_TX as MortgageAddressCity, AM.STATE_PROV_TX as MortgageAddressStateProvince, AM.POSTAL_CODE_TX as MortgageAddressPostalCode,
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD,
dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION,
NULL AS CALL_ATTEMPTS
from WORK_ITEM_ACTION WIA 
join WORK_ITEM WI on WI.ID = WIA.WORK_ITEM_ID and WI.PURGE_DT IS NULL
LEFT JOIN WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
join USERS U on U.USER_NAME_TX = WIA.UPDATE_USER_TX AND U.PURGE_DT IS NULL
join WORKFLOW_DEFINITION WD on WD.ID = WI.WORKFLOW_DEFINITION_ID and WD.PURGE_DT IS NULL and WD.ID in (3)
left join REQUIRED_COVERAGE RC on RC.ID = WI.RELATE_ID AND RC.PURGE_DT IS NULL
left Join COLLATERAL C on C.PROPERTY_ID = RC.PROPERTY_ID AND C.PURGE_DT IS NULL
left Join LOAN L on L.ID = C.LOAN_ID AND L.PURGE_DT IS NULL
left Join PROPERTY P on P.ID = C.PROPERTY_ID and P.LENDER_ID = L.LENDER_ID AND P.PURGE_DT IS NULL
left Join LENDER LND on LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
left Join OWNER_LOAN_RELATE OLR on OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,'N') = 'Y' AND OLR.PURGE_DT IS NULL
left Join [OWNER] O on O.ID = OLR.OWNER_ID AND O.PURGE_DT IS NULL
left Join [OWNER_ADDRESS] AO on AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
left Join [OWNER_ADDRESS] AM on AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
left Join REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left Join REF_CODE RC_COVERAGETYPE on RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
left Join REF_CODE RC_ACTION on RC_ACTION.DOMAIN_CD = 'CPICancelPendingStatus' and RC_ACTION.CODE_CD = WIA.ACTION_CD
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
where U.FAMILY_NAME_TX not like '%serv%' --and WIA.ACTION_CD != 'Complete'
and
WIA.PURGE_DT IS NULL
and
(L.LENDER_ID = @LenderID or @LenderCode is NULL or @LenderCode = '' or @LenderCode = '0') 
and
(L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable) or @Branch = '1' or @Branch = '' or @Branch is NULL)
AND fn_FCBD.loanType IS NOT NULL
and
(RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage = '' or @Coverage is NULL)
and
(WIA.UPDATE_USER_TX = @User or @User is NULL or @User = '' or @User = '0000')
and
WIA.UPDATE_DT >= @FromDate and WIA.UPDATE_DT < @ToDatePlus1
and
(WQ.ID = @WorkQueue or @WorkQueue is NULL or @WorkQueue = '' or @WorkQueue = 0)
AND (((WQ.NAME_TX LIKE '%XQ%' OR WQ.NAME_TX LIKE '%X Queue%') AND @XQ = 1) OR @XQ = 0)
OPTION(OPTIMIZE FOR (@FromDate = '2014-01-01', @ToDatePlus1 = '2014-01-02'))
END


IF (@WorkItemType in (0,1,9,10,11)) 
BEGIN
--Lender File Processing, Cycle, Billing Group, Escrow
SET @insert = N'
INSERT INTO #tmpTable ([REPORT_GROUPBY_TX], [REPORT_SORTBY_TX],[UPDATE_USER_TX],[FAMILY_NAME_TX],[GIVEN_NAME_TX],
[UPDATE_DT],[ACTION_CD],[ACTION_NOTE_TX],[WorkItemID],[WorkItemType], [WorkQueueName],
[LenderCode], [LenderName], [BRANCH_CODE_TX], [DIVISION_CODE_TX], [DivisionDescription],
[RequiredCoverage], [LoanNumber], [FIRST_NAME_TX], [LAST_NAME_TX], [VIN_TX], [YEAR_TX],[MAKE_TX],[MODEL_TX],
[EquipmentDescription],[BorrowerAddressLine1],[BorrowerAddressLine2],[BorrowerAddressCity],[BorrowerAddressStateProvince],[BorrowerAddressPostalCode],
[MortgageAddressLine1],[MortgageAddressLine2],[MortgageAddressCity], [MortgageAddressStateProvince],[MortgageAddressPostalCode],[PROPERTY_TYPE_CD], PROPERTY_DESCRIPTION,[CALL_ATTEMPTS] )'

SET @columns = N'
select 
'''' AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, WIA.UPDATE_DT, WIA.ACTION_CD, 
CASE WHEN WIA.ACTION_NOTE_TX = ''system note:'' 
	THEN ''''
	ELSE WIA.ACTION_NOTE_TX
END AS ACTION_NOTE_TX, 
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
isnull(WI.CONTENT_XML.value(''(/Content/Lender/Code)[1]'', ''varchar(100)''),'''') as LenderCode,
isnull(WI.CONTENT_XML.value(''(/Content/Lender/Name)[1]'', ''varchar(100)''),'''') as LenderName,
'''' AS BRANCH_CODE_TX, ''0'' AS DIVISION_CODE_TX, '''' as DivisionDescription, '''' as RequiredCoverage, '''' as LoanNumber,
'''' AS FIRST_NAME_TX, '''' AS LAST_NAME_TX,'''' as VIN_TX,'''' AS YEAR_TX, '''' AS MAKE_TX, '''' AS MODEL_TX, '''' AS EquipmentDescription,
'''' AS BorrowerAddressLine1, '''' as BorrowerAddressLine2,
'''' as BorrowerAddressCity, '''' as BorrowerAddressStateProvince, '''' as BorrowerAddressPostalCode,
'''' AS MortgageAddressLine1, '''' AS MortgageAddressLine2, 
'''' AS MortgageAddressCity, '''' AS MortgageAddressStateProvince, '''' AS MortgageAddressPostalCode, 
'''' AS PROPERTY_TYPE_CD,
dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION,
NULL AS CALL_ATTEMPTS
'
select @joins = N' 
from WORK_ITEM_ACTION WIA 
join WORK_ITEM WI on WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
LEFT JOIN WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
join USERS U on U.USER_NAME_TX = WIA.UPDATE_USER_TX AND U.PURGE_DT IS NULL
join WORKFLOW_DEFINITION WD on WD.ID = WI.WORKFLOW_DEFINITION_ID and WD.PURGE_DT IS NULL and WD.ID in (1,9,10,11)
left Join LENDER LND on LND.CODE_TX = WI.CONTENT_XML.value(''(/Content/Lender/Code)[1]'', ''varchar(100)'') AND LND.PURGE_DT IS NULL
left Join LOAN L on L.LENDER_ID = LND.ID AND L.PURGE_DT IS NULL
left Join COLLATERAL C on C.LOAN_ID = L.ID
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
'

select @joins = @joins + 
case when (@Division <> '1' or @Branch <> '1' OR @Coverage <> '1') then  char(10) 
+ 
' left Join PROPERTY P on P.ID = C.PROPERTY_ID and P.LENDER_ID = L.LENDER_ID
left Join REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
'
else '' end
select @conditions = N'
where U.FAMILY_NAME_TX not like ''%serv%'' and WIA.PURGE_DT IS NULL'
+ case when @LenderCode <> '' and @LenderCode <> '0' and @LenderCode is not null then ' AND LND.ID = @LenderID' else '' end
+ case when @Branch <> '1' and @Branch <> '' and @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
+ case when @Division <> '1' and @Division <> '' and @Division is NOT NULL then ' AND fn_FCBD.loanType IS NOT NULL '
else '' end
+ case when isnull(@Coverage , '1') <> '1' then char(10) + ' and (RC.TYPE_CD = @Coverage) ' else '' end
+ case when @User <> '0000' then ' AND WIA.UPDATE_USER_TX = @User' else '' end
+ case when @WorkItemType <> '0' then ' AND WD.ID = @WorkItemType' else '' end
+ ' AND WIA.UPDATE_DT >= @FromDate and WIA.UPDATE_DT < @ToDatePlus1'
+ case when @WorkQueue <> '' and @WorkQueue <> '' and @WorkQueue <> 0 then ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end
+ '
OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02''))
'

--declare @finalquery nvarchar(max)
select @finalquery = @insert + @columns + @joins + @conditions

exec sp_executesql @finalquery, 
				N'@LenderID bigint, @Division nvarchar(10), @Coverage nvarchar(10), @User nvarchar(15),
@FromDate datetime, @ToDatePlus1 datetime,@WorkItemType bigint,@WorkQueue bigint',
@LenderID, @Division, @Coverage, @User, @FromDate, @ToDatePlus1,@WorkItemType,@WorkQueue

	If @debug = 1
	BEGIN
		print 'LEN_finalquery: '
		print LEN(@finalquery)
		print 'finalquery: '
		print substring(@finalquery, 1, 4000)
		print substring(@finalquery, 4001, 4000)
	END
END

IF (@WorkItemType in (14)) 
BEGIN
	/*
	-- Agent Notification:
	*/
	INSERT INTO #tmpTable (
	 REPORT_GROUPBY_TX
	,REPORT_SORTBY_TX
	,UPDATE_USER_TX
	,FAMILY_NAME_TX
	,GIVEN_NAME_TX
	,UPDATE_DT
	,ACTION_CD
	,ACTION_NOTE_TX
	,WorkItemID
	,WorkItemType
	,WorkQueueName
	,LenderCode
	,LenderName
	,BRANCH_CODE_TX
	,DIVISION_CODE_TX
	,DivisionDescription
	,RequiredCoverage
	,LoanNumber
	,FIRST_NAME_TX
	,LAST_NAME_TX
	,VIN_TX
	,YEAR_TX
	,MAKE_TX
	,MODEL_TX
	,EquipmentDescription
	,BorrowerAddressLine1
	,BorrowerAddressLine2
	,BorrowerAddressCity
	,BorrowerAddressStateProvince
	,BorrowerAddressPostalCode
	,MortgageAddressLine1
	,MortgageAddressLine2
	,MortgageAddressCity
	,MortgageAddressStateProvince
	,MortgageAddressPostalCode
	,PROPERTY_TYPE_CD
   ,PROPERTY_DESCRIPTION
	,CALL_ATTEMPTS
	)
	SELECT
	 REPORT_GROUPBY_TX = SortGroup.AgentLetterOptionValue /*SortGroup.LenderBranch*/
	,REPORT_SORTBY_TX = Substring(SortGroup.LenderCode + '|' + SortGroup.AgentLetterOptionValue + '|' + SortGroup.AgentName + '|' + SortGroup.StatusDate + '|' + SortGroup.[Sequence], 1, 100)
	,UPDATE_USER_TX = IH.CREATE_USER_TX
	,U.FAMILY_NAME_TX
	,U.GIVEN_NAME_TX
	,UPDATE_DT = IH.CREATE_DT
	,ACTION_CD = Substring(RTrim(RC_IHTYPE.DESCRIPTION_TX) + ' (' + CASE WHEN IH_SH.AgentLetterOptionValue <> '' AND IH_SH.SentToDesc <> '' THEN IH_SH.AgentLetterOptionValue + ' to ' + IH_SH.SentToDesc ELSE IsNull(NullIf(IH_SH.AgentLetterOptionValue, ''), IH_SH.SentToDesc) END + ')', 1, 30)
	,ACTION_NOTE_TX = SortGroup.StatusDate + ' ' + IH_SH.AgentName + ' (' + CASE WHEN IH_SH.AgentLetterOptionValue = 'Fax' THEN SortGroup.AgentFax WHEN IH_SH.AgentLetterOptionValue = 'Email' THEN SortGroup.AgentEmail ELSE IH_SH.AgentEmail END + ')' + ' ' + IsNull(Left(IH.NOTE_TX,4000), '')
	,WorkItemID = n.REFERENCE_ID_TX -- WI.ID 
	,WorkItemType = Substring(RTrim(n.NAME_TX) + ' (reference)', 1, 80) -- WD.DESCRIPTION_TX 
	,WorkQueueName = Substring(SortGroup.PDF_GENERATE_CD + '|' + SortGroup.MailStatus + '|' + SortGroup.[Status], 1, 30) -- WQ.NAME_TX
	,LenderCode = LND.CODE_TX
	,LenderName = LND.NAME_TX
	,L.BRANCH_CODE_TX
	,DIVISION_CODE_TX =
	 CASE WHEN L.DIVISION_CODE_TX = @Division OR IsFiltered.Division = 0 OR NullIf(RCA_PROP.VALUE_TX, '') IS NULL
	      THEN IsNull(NullIf(L.DIVISION_CODE_TX, ''), '0')
	 ELSE L.DIVISION_CODE_TX + ' (' + NullIf(RCA_PROP.VALUE_TX, '') + ')'
	 END
	,DivisionDescription = ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)
	,RequiredCoverage = COALESCE(RC.TYPE_CD, STUFF(Coverage.CSV, 1, 2, '') + CASE WHEN IsNull(@Coverage, '1') <> '1' THEN ' (filtered)' ELSE '' END)
	,LoanNumber = L.NUMBER_TX
	,FIRST_NAME_TX = COALESCE(O.FIRST_NAME_TX, '')
	,LAST_NAME_TX = COALESCE(O.LAST_NAME_TX, '')
	,VIN_TX = COALESCE(P.VIN_TX, '')
	,YEAR_TX = COALESCE(P.YEAR_TX, '')
	,MAKE_TX = COALESCE(P.MAKE_TX, '')
	,MODEL_TX = COALESCE(P.MODEL_TX, '')
	,EquipmentDescription = COALESCE(P.DESCRIPTION_TX, '')
	,BorrowerAddressLine1 = COALESCE(AO.LINE_1_TX, '')
	,BorrowerAddressLine2 = COALESCE(AO.LINE_2_TX, '')
	,BorrowerAddressCity = COALESCE(AO.CITY_TX, '')
	,BorrowerAddressStateProvince = COALESCE(AO.STATE_PROV_TX, '')
	,BorrowerAddressPostalCode = COALESCE(AO.POSTAL_CODE_TX, '')
	,MortgageAddressLine1 = COALESCE(AM.LINE_1_TX, '')
	,MortgageAddressLine2 = COALESCE(AM.LINE_2_TX, '')
	,MortgageAddressCity = COALESCE(AM.CITY_TX, '')
	,MortgageAddressStateProvince = COALESCE(AM.STATE_PROV_TX, '')
	,MortgageAddressPostalCode = COALESCE(AM.POSTAL_CODE_TX, '')
	,PROPERTY_TYPE_CD = RCA_PROP.VALUE_TX
   ,dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION
	,CALL_ATTEMPTS = NULL
	FROM INTERACTION_HISTORY ih
	JOIN USERS U ON U.USER_NAME_TX = IH.CREATE_USER_TX
	LEFT JOIN NOTICE n ON n.ID = ih.RELATE_ID AND ih.RELATE_CLASS_TX = 'Allied.UniTrac.Notice'
	--JOIN WORK_ITEM WI ON WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
	--LEFT JOIN WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
	--JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID IN (4)
	--JOIN VUT.dbo.tblImageQueue IQ ON IQ.ID = WI.RELATE_ID 
	--LEFT JOIN INTERACTION_HISTORY IH ON IH.DOCUMENT_ID = IQ.DOCUMENT_CONTAINER_ID AND IH.TYPE_CD <> 'MEMO' and IH.PURGE_DT IS NULL
	LEFT JOIN PROPERTY P ON P.ID = IH.PROPERTY_ID
	CROSS APPLY (SELECT
	 Lender = CAST(CASE WHEN @LenderCode IS NOT NULL AND @LenderCode <> '' AND @LenderCode <> '0' THEN 1 ELSE 0 END As Bit)
	,Branch = CAST(CASE WHEN @Branch IS NOT NULL AND @Branch <> '' AND @Branch <> '1' THEN 1 ELSE 0 END As Bit)
	,Division = CAST(CASE WHEN @Division IS NOT NULL AND @Division <> '' AND @Division <> '1' THEN 1 ELSE 0 END As Bit)
	,Coverage = CAST(CASE WHEN @Coverage IS NOT NULL AND @Coverage <> '' AND @Coverage <> '1' THEN 1 ELSE 0 END As Bit)
	) AS IsFiltered
	CROSS APPLY (SELECT
	 RC = IsNull(NullIf(IH.SPECIAL_HANDLING_XML.value('(/SH[1]/RC[1]/text())[1]', 'NVARCHAR(15)'), ''), '0')
	,[Type] = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/Type[1]/text())[1]', 'NVARCHAR(15)')
	,SentToDesc = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/SentToDesc[1]/text())[1]', 'NVARCHAR(15)')
	,AgentLetterOptionValue = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/AgentLetterOptionValue[1]/text())[1]', 'NVARCHAR(15)')
	,AgentName = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/AgentName[1]/text())[1]', 'NVARCHAR(50)')
	,AgentEmail = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/AgentEmail[1]/text())[1]', 'NVARCHAR(50)')
	,AgentFax = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/AgentFax[1]/text())[1]', 'NVARCHAR(15)')
	,[Status] = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/Status[1]/text())[1]', 'NVARCHAR(15)')
	,MailStatus = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/MailStatus[1]/text())[1]', 'NVARCHAR(15)')
	,StatusDate = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/StatusDate[1]/text())[1]', 'NVARCHAR(25)')
	,[Sequence] = IH.SPECIAL_HANDLING_XML.value('(/SH[1]/Sequence[1]/text())[1]', 'NVARCHAR(25)')
	) AS IH_SH
	CROSS APPLY (SELECT
	 StatusDate = CAST(CASE WHEN NullIf(IH_SH.StatusDate, '') IS NOT NULL AND IH_SH.StatusDate <> '1/1/0001' AND IH_SH.StatusDate >= '1/1/1900' AND IsDate(IH_SH.StatusDate) = 1 THEN 1 ELSE 0 END As Bit) -- sometimes StatusDate is '1/1/0001', which is an invalid date in SQL
	) AS IsValid
	LEFT JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
		  AND (RC.ID = COALESCE(IH.REQUIRED_COVERAGE_ID, IH_SH.RC))
	LEFT JOIN REF_CODE AS RC_COVERAGEFILTER ON RC_COVERAGEFILTER.DOMAIN_CD = 'Coverage' AND (RC_COVERAGEFILTER.CODE_CD = @Coverage)
	LEFT JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
	LEFT JOIN LOAN L ON L.ID = C.LOAN_ID 
	LEFT JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,'N') = 'Y'	
	LEFT JOIN [OWNER] O ON O.ID = OLR.OWNER_ID
	LEFT JOIN OWNER_ADDRESS AO ON AO.ID = O.ADDRESS_ID
	LEFT JOIN OWNER_ADDRESS AM ON AM.ID = P.ADDRESS_ID
	LEFT JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = 'ContractType' AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
	LEFT JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
	LEFT JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
	LEFT JOIN REF_CODE RC_IHTYPE ON RC_IHTYPE.DOMAIN_CD = 'InteractionHistoryType' AND RC_IHTYPE.CODE_CD = IH.TYPE_CD
	LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
	LEFT JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
	LEFT JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
	CROSS APPLY (SELECT
	 CSV = (SELECT ', ' + RC_COVERAGETYPE.MEANING_TX FROM REQUIRED_COVERAGE AS RC, REF_CODE AS RC_COVERAGETYPE WHERE RC.PROPERTY_ID = P.ID AND RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD AND (RC.TYPE_CD = @Coverage OR @Coverage = '1') ORDER BY RC_COVERAGETYPE.MEANING_TX FOR XML PATH(''))
	) AS Coverage
	CROSS APPLY (SELECT
	 LenderCode = ISNULL(LND.CODE_TX,'0000')
	,LenderName = ISNULL(LND.NAME_TX, '_no_lender')
	,LenderBranch = ISNULL(L.BRANCH_CODE_TX, '_no_branch')
	,LenderBranchDivision = (ISNULL(LND.CODE_TX,'No Lender') + ' ' + ISNULL(LND.NAME_TX,'') + ' / ' + 
		(CASE WHEN L.BRANCH_CODE_TX IS NULL OR L.BRANCH_CODE_TX = '' THEN 'No Branch' ELSE L.BRANCH_CODE_TX END) + ' / ' + 
		ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX))
	,AgentLetterOptionValue = IsNull(NullIf(IH_SH.AgentLetterOptionValue, ''), '_no_option')
	,AgentName = IsNull(NullIf(IH_SH.AgentName, ''), '_no_name')
	,AgentEmail = IsNull(NullIf(IH_SH.AgentEmail, ''), '_no_email')
	,AgentFax = STUFF(IsNull(NullIf(IH_SH.AgentFax, ''), '0000000000'), 4, 1, '-')
	,[Status] = IsNull(NullIf(IH_SH.[Status], ''), '_no_status')
	,MailStatus = IsNull(NullIf(IH_SH.MailStatus, ''), '_no_mailstatus')
	,StatusDate = CONVERT(NVARCHAR(10), CASE WHEN IsValid.StatusDate = 1 THEN CAST(IH_SH.StatusDate AS Date) ELSE CAST(IH.UPDATE_DT As Date) END, 111)
	,[Sequence] = IsNull(NullIf(IH_SH.[Sequence], ''), '0')
	,PDF_GENERATE_CD = IsNull(n.PDF_GENERATE_CD, '?')
	) AS SortGroup
   CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD

	WHERE ih.PURGE_DT IS NULL
	AND (IH.CREATE_USER_TX = @User OR @IsFiltered_User = 0) -- @User IS NULL OR @User = '' OR @User = '0000')
	--AND CAST(IH_SH.StatusDate AS DateTime) BETWEEN @FromDate AND @ToDatePlus1
	AND (IH.CREATE_DT >= @FromDate AND IH.CREATE_DT < @ToDatePlus1)
	AND (L.LENDER_ID = @LenderID OR @LenderCode IS NULL OR @LenderCode = '' OR @LenderCode = '0') 
	AND fn_FCBD.loanType IS NOT NULL	
	AND (@IsFiltered_Coverage = 0 OR RC_COVERAGEFILTER.CODE_CD = RC.TYPE_CD OR (RC.TYPE_CD IS NULL AND Coverage.CSV LIKE ',%' + @Coverage + '%'))
	AND U.FAMILY_NAME_TX NOT LIKE '%serv%'
	AND (@IsFiltered_Branch = 0 OR L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM @BranchTable)) -- OR @Branch = '1' OR @Branch = '' OR @Branch IS NULL)
	AND IH_SH.[Type] = 'AN'
	--AND (WQ.ID = @WorkQueue OR @WorkQueue is NULL OR @WorkQueue = '' OR @WorkQueue = 0)
	--AND (((WQ.NAME_TX LIKE '%XQ%' OR WQ.NAME_TX LIKE '%X Queue%') AND @XQ = 1) OR @XQ = 0)
	--ORDER BY REPORT_SORTBY_TX
	OPTION(OPTIMIZE FOR (@FromDate = '2014-01-01', @ToDatePlus1 = '2014-01-02'))
END

IF @ReportType IS NULL OR @ReportType = 'ACTIVITY'
BEGIN
	SELECT distinct * FROM #tmpTable
	ORDER BY REPORT_SORTBY_TX
END
ELSE IF @ReportType = 'ACTIVITYSUMM'
BEGIN
	select FAMILY_NAME_TX, GIVEN_NAME_TX, WorkItemType, COUNT(*) as WorkItemCount 
	from (select distinct * from #tmpTable) T
	group by FAMILY_NAME_TX, GIVEN_NAME_TX, WorkItemType
	order by FAMILY_NAME_TX, GIVEN_NAME_TX, WorkItemType
END

SELECT @RecordCount = @@ROWCOUNT
If @debug = 1 print @RecordCount

IF @Report_History_ID IS NOT NULL
AND @debug = 0
BEGIN
  UPDATE REPORT_HISTORY
  SET RECORD_COUNT_NO = @RecordCount
  WHERE ID = @Report_History_ID
END

END



GO

