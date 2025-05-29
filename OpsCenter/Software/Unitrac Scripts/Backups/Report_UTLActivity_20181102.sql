USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_UTLActivity]    Script Date: 11/2/2018 12:57:54 PM ******/
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
,@ReportType as nvarchar(50)='ACTIVITY'
,@WorkItemType as bigint=NULL
,@WorkQueue as bigint=NULL
,@Report_History_ID as bigint=NULL
,@debug int = 0
AS
BEGIN
IF OBJECT_ID(N'tempdb..#tmpTable',N'U') IS NOT NULL
  DROP TABLE #tmpTable
IF OBJECT_ID(N'tempdb..#BranchTable',N'U') IS NOT NULL
  DROP TABLE #BranchTable

/*
--debug/test:
  select @ReportType='ACTIVITY'
  --select @lendercode='2771' --Santander
  select @lendercode='2252' --SpaceCoast
  --select @lendercode='USDTEST1'
  select @debug=1
  --select @FromDate='5/1/2018',@ToDate='5/31/2018'
  --select @FromDate='8/7/2018',@ToDate='8/8/2018'
  select @FromDate='9/17/2018',@ToDate='9/18/2018'
   --SELECT @Division = '3'
  --select @workitemtype=coalesce(@workitemtype, 0)
  --select @workitemtype='1' /*LenderExtract/LFP*/
  --select @workitemtype='2' /*UTLMatch*/
  --select @workitemtype='3' /*CPICancelPending*/
  --select @workitemtype='4' /*KeyImage*/
  --select @workitemtype='5' /*I.B.C.*/
  select @workitemtype='6' /*Verif.Event*/
  --select @workitemtype='7' /*ActionRequest*/
  --select @workitemtype='8' /*VerifyData*/
  --select @workitemtype='9' /*Cycle*/
  --select @workitemtype='10' /*BillingGroup*/
  --select @workitemtype='11' /*Escrow/Billing*/
  --select @workitemtype='12' /*I.B.C.*/
  --select @workitemtype='13' /*InsuranceBackfeed*/
  --select @workitemtype='14' /*AgentNotification*/
  --select @workitemtype='15' /*ServiceFee*/
  --select @workitemtype='16' /*LenderPay/Endorsement*/
  --select @workitemtype='17' /*Generic*/
  --select @workitemtype='18' /*EscrowPassThru*/
  --select @workitemtype='19' /*QC*/
*/

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
DECLARE @OutboundWebVerif BigInt = 600

--Make the SubWorkItemType to be one of the Inbound types, AND reset the @WorkItemType to Inbound Call Workflow, value 5
DECLARE @SubWorkItemType as bigint
IF (@WorkItemType LIKE '50%')
SELECT @SubWorkItemType = @WorkItemType, @WorkItemType = ID FROM WORKFLOW_DEFINITION WHERE NAME_TX = 'InboundCall'

--Make the SubWorkItemType to be one of the Outbound types, AND reset the @WorkItemTypeID to Outbound Call Workflow, value 6
IF (@WorkItemType LIKE '60%') 
SELECT @SubWorkItemType = @WorkItemType, @WorkItemType = ID FROM WORKFLOW_DEFINITION WHERE NAME_TX = 'VerificationEvent'

if @debug>0
begin
	print '@WorkItemType:'
	print @WorkItemType
	print '@SubWorkItemType:'
	print @SubWorkItemType
end

Declare @LenderID as bigint
Select @LenderID=ID from LENDER where CODE_TX = @LenderCode AND PURGE_DT is null

Declare @RecordCount as bigint
set @RecordCount = 0

Declare @ToDatePlus1 as date
set @ToDatePlus1 = DATEADD(dd,1,@ToDate)


/* declare variables for building dynamic SQL */
declare @columns nvarchar(max)
declare @insert nvarchar(max)
declare @joins nvarchar(max)
declare @conditions nvarchar(max)
declare @finalquery nvarchar(max)=''

/* declare variables for dynamic sql to get UTL information */
DECLARE @utlSelect NVARCHAR(MAX)
DECLARE @utlInsert NVARCHAR(MAX)
DECLARE @utlJoins NVARCHAR(MAX)
DECLARE @utlConditions NVARCHAR(MAX)
DECLARE @utlQuery NVARCHAR(MAX)

IF (@WorkItemType = 0)
BEGIN
	SET @finalquery = N'SELECT distinct * from ( '
END

IF (@WorkItemType in (0,2))
BEGIN


/***************************************/
/**** BEGIN REMOTE UTL DATA RETREVIAL ****/

CREATE TABLE #tempTable(
  id BIGINT,
  DESCRIPTION_TX NVARCHAR(80),
  CURRENT_QUEUE_ID BIGINT,
  ACTION_CD	NVARCHAR(30), 
  ACTION_NOTE_TX NVARCHAR(1000), 
  UPDATE_DT	DATETIME, 
  UPDATE_USER_TX NVARCHAR(15), 
  LOAN_ID	BIGINT, 
  UTL_LOAN_ID	BIGINT, 
  UTL_PROPERTY_ID	BIGINT, 
  FAMILY_NAME_TX NVARCHAR(50), 
  GIVEN_NAME_TX NVARCHAR(30)
)

SET @utlInsert = N'
INSERT INTO #tempTable(id, DESCRIPTION_TX, CURRENT_QUEUE_ID, ACTION_CD, ACTION_NOTE_TX, UPDATE_DT, UPDATE_USER_TX, LOAN_ID, UTL_LOAN_ID, UTL_PROPERTY_ID, FAMILY_NAME_TX, GIVEN_NAME_TX)
'

SET @utlSelect = N'
SELECT wi.id, wd.DESCRIPTION_TX, wi.CURRENT_QUEUE_ID, 
       wia.ACTION_CD, wia.ACTION_NOTE_TX, wia.UPDATE_DT, wia.UPDATE_USER_TX, 
	   umr.loan_id, umr.utl_loan_id, umr.UTL_PROPERTY_ID, 
	   U.FAMILY_NAME_TX, U.GIVEN_NAME_TX
'

SET @utlJoins = N'
FROM UTL_MATCH_RESULT umr
JOIN WORK_ITEM WI ON umr.ID = wi.RELATE_ID
JOIN WORKFLOW_DEFINITION WD ON WD.ID = wi.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID in (2) AND WD.PURGE_DT IS NULL
JOIN WORK_ITEM_ACTION WIA ON WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL 
JOIN LOAN L ON umr.LOAN_ID = l.ID
JOIN USERS U ON U.USER_NAME_TX = WIA.UPDATE_USER_TX  
'

SET @utlConditions = N'
WHERE WIA.ACTION_CD != ''Complete''  
  --AND U.FAMILY_NAME_TX not like ''%serv%'' 
  AND U.SYSTEM_IN=''N''
  AND WIA.UPDATE_DT >= @FromDate AND WIA.UPDATE_DT < @ToDatePlus1
'
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then char(10) + ' AND L.Lender_ID = @LenderID ' else '' end
+ case when @User <> '' AND @User <> '0000' AND @User is not null then char(10) + ' AND WIA.UPDATE_USER_TX = @User' else '' end


	SELECT @utlQuery = @utlInsert + @utlSelect + @utlJoins + @utlConditions
	--SELECT @utlQuery query, @LenderID LenderId, @user [user], @FromDate fromdate, @ToDate toDate

	exec sp_executesql @utlQuery,
	N'@LenderID bigint, @User nvarchar(15), @FromDate datetime, @ToDatePlus1 datetime',
	@LenderID, @User,@FromDate, @ToDatePlus1



DECLARE @propertyIds NVARCHAR(MAX) = NULL
SELECT @propertyIds = COALESCE(@propertyIds + ',', '') + CAST(ti.UTL_PROPERTY_ID AS NVARCHAR(MAX))
FROM #tempTable ti



CREATE table #remoteDataUTL(
	PROPERTY_ID BIGINT,
	UTL_PROPERTY_DESC NVARCHAR(100),
	COLLATERAL_CODE_ID BIGINT,
	VIN_TX NVARCHAR(18),
	YEAR_TX NVARCHAR(4),
	MAKE_TX NVARCHAR(30),
	MODEL_TX NVARCHAR(30),
	DESCRIPTION_TX NVARCHAR(100),
	LINE_1_TX NVARCHAR(100), 
	LINE_2_TX NVARCHAR(100), 
	CITY_TX  NVARCHAR(30), 
	STATE_PROV_TX  NVARCHAR(30), 
	POSTAL_CODE_TX  NVARCHAR(30),
	TYPE_CD NVARCHAR(30)
)

INSERT INTO #remoteDataUTL
  EXEC UTLSERVER.UTL.dbo.ReportSupport_UTLActivity @idValuesDelimited = @propertyIds, @Division = @Division


/***************************************/
/**** END REMOTE UTL DATA RETREVIAL ****/

--UTL Match
SET @columns = N'
select distinct
	(ISNULL(LND.CODE_TX,''No Lender'') + '' '' + ISNULL(LND.NAME_TX,'''') + '' / '' +
	(CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '''' then ''No Branch'' else L.BRANCH_CODE_TX END) + '' / '' +
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), tt.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
tt.UPDATE_USER_TX, tt.FAMILY_NAME_TX, tt.GIVEN_NAME_TX, tt.UPDATE_DT, tt.ACTION_CD,
CASE WHEN tt.ACTION_NOTE_TX = ''system note:''
	THEN ''''
	ELSE tt.ACTION_NOTE_TX
END AS ACTION_NOTE_TX,
NULL as COMMENT_TX,
NULL as REASON_TX,
NULL as IH_ID,
tt.ID as WorkItemID, tt.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX,
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'''') = ''''
	THEN ''0''
	ELSE L.DIVISION_CODE_TX
END AS DIVISION_CODE_TX,
ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as DivisionDescription,
RC_COVERAGETYPE.MEANING_TX as RequiredCoverage,
L.NUMBER_TX as LoanNumber,
O.FIRST_NAME_TX, O.LAST_NAME_TX,
rutl.VIN_TX, rutl.YEAR_TX, rutl.MAKE_TX, rutl.MODEL_TX, rutl.DESCRIPTION_TX as EquipmentDescription,
AO.LINE_1_TX as BorrowerAddressLine1, AO.LINE_2_TX as BorrowerAddressLine2,
AO.CITY_TX as BorrowerAddressCity, AO.STATE_PROV_TX as BorrowerAddressStateProvince, AO.POSTAL_CODE_TX as BorrowerAddressPostalCode,
rutl.LINE_1_TX as MortgageAddressLine1, rutl.LINE_2_TX as MortgageAddressLine2,
rutl.CITY_TX as MortgageAddressCity, rutl.STATE_PROV_TX as MortgageAddressStateProvince, rutl.POSTAL_CODE_TX as MortgageAddressPostalCode,
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD,
PROPERTY_DESCRIPTION = rutl.UTL_PROPERTY_DESC,
NULL AS CALL_ATTEMPTS
'
select @joins = N'
from #remoteDataUTL rutl
JOIN #tempTable tt ON rutl.PROPERTY_ID = tt.UTL_PROPERTY_ID
'
+ case when @WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0 then 'JOIN' else 'LEFT JOIN' end + 
' WORK_QUEUE WQ ON tt.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
' 
+ 
'
JOIN LOAN L ON L.ID = tt.LOAN_ID
JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
left JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,''N'') = ''Y''
left JOIN [OWNER] O ON O.ID = OLR.OWNER_ID
left JOIN [OWNER_ADDRESS] AO ON AO.ID = O.ADDRESS_ID
JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = ''ContractType'' AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = rutl.TYPE_CD
JOIN COLLATERAL_CODE CC ON CC.ID = rutl.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
'
select @conditions = N'
where 1 = 1
'
+ case when @Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
+ case when @Coverage <> '1' AND @Coverage <> '' AND @Coverage is NOT NULL then char(10) + ' AND (RC.TYPE_CD = @Coverage) ' else '' end
+ case when @WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0 then char(10) + ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then char(10) + ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end


IF (@WorkItemType = 0 )
BEGIN
	select @finalquery = @finalquery + @columns + @joins + @conditions + ' UNION ALL '
END

IF (@WorkItemType NOT In (0,5,6) AND @ReportType != 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions --+ ' ORDER BY REPORT_SORTBY_TX OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02'')) '
END

IF (@WorkItemType != 0 AND @ReportType = 'ACTIVITYSUMM')
BEGIN
	select @finalquery =  @columns + @joins + @conditions 
END

if @debug>0
BEGIN
		select isnull(@columns, '@columns IS NULL') as '@columns'
		select isnull(@joins,'@joins IS NULL') as '@joins'
		select isnull(@conditions, '@conditions IS NULL') as '@conditions'
		SELECT @finalquery as '@finalquery'
end


END


IF (@WorkItemType in (0,4))
BEGIN

--Key Image, Work Item Action
select @columns = '
select distinct
(ISNULL(LND.CODE_TX,''No Lender'') + '' '' + ISNULL(LND.NAME_TX,'''') + '' / '' +
	(CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '''' then ''No Branch'' else L.BRANCH_CODE_TX END) + '' / '' +
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, 
WIA.UPDATE_DT, WIA.ACTION_CD, 
CASE WHEN WIA.ACTION_NOTE_TX = ''system note:''
	THEN ''''
	ELSE WIA.ACTION_NOTE_TX
END AS ACTION_NOTE_TX,
COMMENT_TX = Coalesce(Left(IH.NOTE_TX,3500), ''''),
REASON_TX = null,--Coalesce(IH_SH.Resolution, ''''),
IH.ID as IH_ID,
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX,
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'''') = ''''
	THEN ''0''
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
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD, PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescriptionForReports(C.ID),
NULL AS CALL_ATTEMPTS
'
select @joins = '
FROM WORK_ITEM_ACTION WIA
JOIN WORK_ITEM WI ON WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
'
+ case when (@WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0) OR @XQ = 1 then 'JOIN' else 'LEFT JOIN' end + 
' WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID in (4)
JOIN VUT.dbo.tblImageQueue IQ ON IQ.ID = WI.RELATE_ID
left JOIN INTERACTION_HISTORY IH ON IH.DOCUMENT_ID = IQ.DOCUMENT_CONTAINER_ID AND IH.TYPE_CD <> ''MEMO'' AND IH.PURGE_DT IS NULL
JOIN USERS U ON U.USER_NAME_TX = WIA.UPDATE_USER_TX
'
+ case when (@LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null)
		  or (@Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL)
       then
'JOIN PROPERTY P ON P.ID = IH.PROPERTY_ID
JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
JOIN LOAN L ON L.ID = C.LOAN_ID
'
else
'left JOIN PROPERTY P ON P.ID = IH.PROPERTY_ID
left JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
left JOIN LOAN L ON L.ID = C.LOAN_ID
'
end
+ case when isnull(@Coverage , '1') <> '1' then 'JOIN' else 'LEFT JOIN' end +
' REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
	AND IH.SPECIAL_HANDLING_XML.value(''(/SH/RC)[1]'', ''nvarchar(15)'') = RC.ID
'
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then '' else 'LEFT' end
+' JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT is null
left  JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,''N'') = ''Y''
left  JOIN [OWNER] O ON O.ID = OLR.OWNER_ID
left  JOIN [OWNER_ADDRESS] AO ON AO.ID = O.ADDRESS_ID
left JOIN [OWNER_ADDRESS] AM ON AM.ID = P.ADDRESS_ID
left JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = ''ContractType'' AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + 'CROSS APPLY dbo.fn_FilterCollateralByDivisionCd2(C.ID, @Division) fn_FCBD ' else '' end

select @conditions = '
WHERE WIA.PURGE_DT IS NULL 
--AND U.FAMILY_NAME_TX not like ''%serv%''
AND U.SYSTEM_IN=''N''
AND WIA.ACTION_CD <> ''Complete''
AND ISNULL(IH.SPECIAL_HANDLING_XML.value(''(/SH/Source)[1]'', ''nvarchar(15)''),'''') in ('''',''UniTrac'')
AND (WIA.UPDATE_DT >= @FromDate AND WIA.UPDATE_DT < @ToDatePlus1)
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + ' AND fn_FCBD.loanType IS NOT NULL ' else '' end
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then char(10) + ' AND L.Lender_ID = @LenderID' else '' end
+ case when @Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
+ case when @Coverage <> '1' AND @Coverage <> '' AND @Coverage is NOT NULL then char(10) + ' AND (RC.TYPE_CD = @Coverage) ' else '' end
+ case when @User <> '' AND @User <> '0000' AND @User is not null then char(10) + ' AND WIA.UPDATE_USER_TX = @User' else '' end
+ case when @WorkItemType <> '' AND @WorkItemType is not null AND @WorkItemType <> 0 then char(10) + ' AND WD.ID = @WorkItemType' else '' end
+ case when @WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0 then char(10) + ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then char(10) + ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end


IF (@WorkItemType = 0)
BEGIN
	select @finalquery = @finalquery + @columns + @joins + @conditions + ' UNION ALL '
END

IF (@WorkItemType != 0)
BEGIN
	select @finalquery = N'SELECT distinct * from ( ' + @columns + @joins + @conditions + ' UNION ALL '
END

if @debug>0
begin
		select isnull(@columns, '@columns IS NULL') as '@columns'
		select isnull(@joins,'@joins IS NULL') as '@joins'
		select isnull(@conditions, '@conditions IS NULL') as '@conditions'
		SELECT @finalquery as '@finalquery'
end

END



IF (@WorkItemType in (0,4))
BEGIN

/***************************************/
/**** BEGIN REMOTE UTL DATA RETREVIAL ****/

	CREATE table #remoteDataUTL2(
	IH_ID BIGINT,
	IH_DOCUMENT_ID BIGINT,
	IH_CREATE_DT DATETIME,
	IH_CREATE_USER NVARCHAR(50),
	FIRST_NAME_TX NVARCHAR(200),
	LAST_NAME_TX NVARCHAR(100),
	IH_NOTE_TX NVARCHAR(4000),
	VIN_TX NVARCHAR(18),
	YEAR_TX NVARCHAR(4),
	MAKE_TX NVARCHAR(30),
	MODEL_TX NVARCHAR(30),
	DESCRIPTION_TX NVARCHAR(100),
	OWNER_LINE_1_TX NVARCHAR(100), 
	OWNER_LINE_2_TX NVARCHAR(100), 
	OWNER_CITY_TX  NVARCHAR(30), 
	OWNER_STATE_PROV_TX  NVARCHAR(30), 
	OWNER_POSTAL_CODE_TX  NVARCHAR(30),
	PROPERTY_LINE_1_TX NVARCHAR(100), 
	PROPERTY_LINE_2_TX NVARCHAR(100), 
	PROPERTY_CITY_TX  NVARCHAR(30), 
	PROPERTY_STATE_PROV_TX  NVARCHAR(30), 
	PROPERTY_POSTAL_CODE_TX  NVARCHAR(30),
	PROPERTY_DESCRIPTION NVARCHAR(100),
	RC_TYPE_CD NVARCHAR(30),
	IH_TYPE_CD NVARCHAR(30),
	CC_ID BIGINT,
	DIVISION_CODE_TX NVARCHAR(20),
	BRANCH_CODE_TX NVARCHAR(20),
	LOAN_NUMBER_TX NVARCHAR(18)
	)



INSERT INTO #remoteDataUTL2
  EXEC UTLSERVER.UTL.dbo.ReportSupport_UTLActivityKeyImage @LenderId = @LenderID, @User = @User, @Division = @Division, @Coverage = @Coverage, @FromDate = @FromDate, @ToDate = @ToDatePlus1

  select distinct
'' AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), rd.IH_CREATE_DT, 120) AS REPORT_SORTBY_TX,
rd.IH_CREATE_USER,U.FAMILY_NAME_TX,U.GIVEN_NAME_TX,
rd.IH_CREATE_DT as Update_dt,
RC_IHTYPE.DESCRIPTION_TX as Action_Cd,
rd.IH_NOTE_TX AS ACTION_NOTE_TX,
NULL as COMMENT_TX,
NULL as REASON_TX,
rd.IH_ID as IH_ID,
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
rd.BRANCH_CODE_TX,
CASE WHEN ISNULL(rd.DIVISION_CODE_TX,'') = ''
	THEN '0'
	ELSE rd.DIVISION_CODE_TX
END AS DIVISION_CODE_TX,
ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX) as DivisionDescription,
RC_COVERAGETYPE.MEANING_TX as RequiredCoverage,
rd.LOAN_NUMBER_TX as LoanNumber,
rd.FIRST_NAME_TX, rd.LAST_NAME_TX,
rd.VIN_TX, rd.YEAR_TX, rd.MAKE_TX, rd.MODEL_TX, rd.DESCRIPTION_TX as EquipmentDescription,
rd.OWNER_LINE_1_TX as BorrowerAddressLine1, rd.OWNER_LINE_2_TX as BorrowerAddressLine2,
rd.OWNER_CITY_TX as BorrowerAddressCity, rd.OWNER_STATE_PROV_TX as BorrowerAddressStateProvince, rd.OWNER_POSTAL_CODE_TX as BorrowerAddressPostalCode,
rd.PROPERTY_LINE_1_TX as MortgageAddressLine1, rd.PROPERTY_LINE_2_TX as MortgageAddressLine2,
rd.PROPERTY_CITY_TX as MortgageAddressCity, rd.PROPERTY_STATE_PROV_TX as MortgageAddressStateProvince, rd.PROPERTY_POSTAL_CODE_TX as MortgageAddressPostalCode,
RCA_PROP.VALUE_TX AS PROPERTY_TYPE_CD,
rd.PROPERTY_DESCRIPTION,
NULL AS CALL_ATTEMPTS
INTO #remoteData
FROM #remoteDataUTL2 rd
INNER JOIN VUT.dbo.tblImageQueue iq ON iq.DOCUMENT_CONTAINER_ID = rd.IH_DOCUMENT_ID
JOIN WORK_ITEM WI ON WI.relate_id = iq.ID AND WI.PURGE_DT IS NULL
JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID in (4)
JOIN WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
JOIN USERS U ON U.USER_NAME_TX = rd.IH_CREATE_USER
left JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = 'ContractType' AND RC_DIVISION.CODE_CD = rd.DIVISION_CODE_TX
left JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' AND RC_COVERAGETYPE.CODE_CD = rd.RC_TYPE_CD
left JOIN REF_CODE RC_IHTYPE ON RC_IHTYPE.DOMAIN_CD = 'InteractionHistoryType' AND RC_IHTYPE.CODE_CD = rd.IH_TYPE_CD
JOIN COLLATERAL_CODE CC ON CC.ID = rd.CC_ID AND CC.PURGE_DT IS NULL
left JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
LEFT JOIN LENDER LND ON LND.ID = wi.LENDER_ID AND LND.PURGE_DT is NULL


select @columns = '
select * from #remoteData
UNION
select distinct
'''' AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), IH.CREATE_DT, 120) AS REPORT_SORTBY_TX,
IH.CREATE_USER_TX,U.FAMILY_NAME_TX,U.GIVEN_NAME_TX,
IH.CREATE_DT as Update_dt,
RC_IHTYPE.DESCRIPTION_TX as Action_Cd,
Left(IH.NOTE_TX,4000) AS ACTION_NOTE_TX,
NULL as COMMENT_TX,
NULL as REASON_TX,
IH.ID as IH_ID,
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX,
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'''') = ''''
	THEN ''0''
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
PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescriptionForReports(C.ID),
NULL AS CALL_ATTEMPTS
'
select @joins = '
FROM WORK_ITEM_ACTION WIA
JOIN WORK_ITEM WI ON WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
'
+ case when (@WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0) OR @XQ = 1 then 'JOIN' else 'LEFT JOIN' end + 
' WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID in (4)
JOIN VUT.dbo.tblImageQueue IQ ON IQ.ID = WI.RELATE_ID
JOIN INTERACTION_HISTORY IH ON IH.DOCUMENT_ID = IQ.DOCUMENT_CONTAINER_ID AND IH.TYPE_CD <> ''MEMO'' AND IH.PURGE_DT IS NULL
JOIN USERS U ON U.USER_NAME_TX = IH.CREATE_USER_TX
'
+ case when (@LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null)
		  or (@Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL)
       then
'JOIN PROPERTY P ON P.ID = IH.PROPERTY_ID
JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
JOIN LOAN L ON L.ID = C.LOAN_ID
'
else
'left JOIN PROPERTY P ON P.ID = IH.PROPERTY_ID
left JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
left JOIN LOAN L ON L.ID = C.LOAN_ID
'
end
+ case when isnull(@Coverage , '1')  not in ('1', '') then 'JOIN' else 'LEFT JOIN' end +
' REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
	AND IH.SPECIAL_HANDLING_XML.value(''(/SH/RC)[1]'', ''nvarchar(15)'') = RC.ID
'
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then '' else 'LEFT' end
+' JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT is null
left JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,''N'') = ''Y''
left JOIN [OWNER] O ON O.ID = OLR.OWNER_ID
left JOIN [OWNER_ADDRESS] AO ON AO.ID = O.ADDRESS_ID
left JOIN [OWNER_ADDRESS] AM ON AM.ID = P.ADDRESS_ID
left JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = ''ContractType'' AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
left JOIN REF_CODE RC_IHTYPE ON RC_IHTYPE.DOMAIN_CD = ''InteractionHistoryType'' AND RC_IHTYPE.CODE_CD = IH.TYPE_CD
JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + 'CROSS APPLY dbo.fn_FilterCollateralByDivisionCd2(C.ID, @Division) fn_FCBD ' else '' end

select @conditions = '
WHERE WIA.PURGE_DT IS NULL 
AND U.SYSTEM_IN=''N''
AND ISNULL(IH.SPECIAL_HANDLING_XML.value(''(/SH/Source)[1]'', ''nvarchar(15)''),'''') in ('''',''UniTrac'')
AND (IH.CREATE_DT >= @FromDate AND IH.CREATE_DT < @ToDatePlus1)
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + ' AND fn_FCBD.loanType IS NOT NULL ' else '' end
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then char(10) + ' AND L.Lender_ID = @LenderID' else '' end
+ case when @Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
+ case when @Coverage <> '1' AND @Coverage <> '' AND @Coverage is NOT NULL then char(10) + ' AND (RC.TYPE_CD = @Coverage) ' else '' end
+ case when @User <> '0000' AND @User <> '' AND @User is NOT NULL then char(10) + ' AND (IH.CREATE_USER_TX = @User) ' else '' end
+ case when @WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0 then char(10) + ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then char(10) + ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end


IF (@WorkItemType = 0)
BEGIN
	select @finalquery = @finalquery + @columns + @joins + @conditions + ' UNION ALL '
END

IF (@WorkItemType NOT In (0,5,6) AND @ReportType != 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions + ' ORDER BY REPORT_SORTBY_TX OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02'')) '
END

IF (@WorkItemType != 0 AND @ReportType = 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions 
END

if @debug>0
begin
		select isnull(@columns, '@columns IS NULL') as '@columns'
		select isnull(@joins,'@joins IS NULL') as '@joins'
		select isnull(@conditions, '@conditions IS NULL') as '@conditions'
		 SELECT @finalquery as '@finalquery'
end



END

IF (@WorkItemType in (0,5,6) or @WorkItemType LIKE '50%' or @WorkItemType LIKE '60%')
BEGIN

SET @columns = N'
select distinct
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
IH.ID as IH_ID,
WI.ID as WorkItemID,
CASE
	WHEN @SubWorkItemType = @InboundCallerNotSatisfied THEN ''Inbound Call Workflow - Caller Not Satisfied''
	WHEN @SubWorkItemType = @InboundEscalated THEN ''Inbound Call Workflow - Escalated''
	WHEN @SubWorkItemType = @InboundLiveChat THEN ''Inbound Call Workflow - Live Chat''
	WHEN @SubWorkItemType = @OutboundWebVerif THEN ''Outbound Call Workflow - Web Verification''
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
PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescriptionForReports(C.ID),
ISNULL(IH.SPECIAL_HANDLING_XML.value(''(/SH/CallAttempts/text())[1]'', ''NVARCHAR(2)''), '''') AS CALL_ATTEMPTS
'

set @joins = N'
FROM WORK_ITEM_ACTION WIA 
/*INNER LOOP*/ JOIN WORK_ITEM WI ON WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
'
+ case when (@WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0) OR @XQ = 1 then 'JOIN' else 'LEFT JOIN' end + 
' WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
JOIN USERS U ON Left(U.USER_NAME_TX,15) = Left(WIA.UPDATE_USER_TX,15)
JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID in (5,6)
'
+  case when (@SubWorkItemType in (@InboundCallerNotSatisfied, @InboundEscalated, @InboundLiveChat) )
			or isnull(@Coverage , '1') <> '1' 
			then 'JOIN' else 'LEFT JOIN' end
+ ' INTERACTION_HISTORY IH ON IH.ID = WI.RELATE_ID AND IH.PURGE_DT IS NULL
'
+ case when (@LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null)
		  or (@Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL)
       then
'
JOIN PROPERTY P ON P.ID = IH.PROPERTY_ID  AND P.PURGE_DT IS NULL
JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID  AND C.PURGE_DT IS NULL
JOIN LOAN L ON L.ID = C.LOAN_ID  AND L.PURGE_DT IS NULL
'
else
'left JOIN PROPERTY P ON P.ID = IH.PROPERTY_ID  AND P.PURGE_DT IS NULL
left JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID  AND C.PURGE_DT IS NULL
left JOIN LOAN L ON L.ID = C.LOAN_ID AND L.PURGE_DT IS NULL
'
end
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then '' else 'LEFT' end
+' JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT is null
CROSS APPLY (SELECT CSV = (SELECT '', '' + RC_COVERAGETYPE.MEANING_TX FROM REQUIRED_COVERAGE AS RC , REF_CODE AS RC_COVERAGETYPE  WHERE RC.PROPERTY_ID = P.ID AND RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD AND (RC.TYPE_CD = ' + Case When @IsFiltered_Coverage = 1 THEN '''' + @Coverage + '''' Else 'RC.TYPE_CD' End + ') ORDER BY RC_COVERAGETYPE.MEANING_TX FOR XML PATH(''''))) AS COVERAGE
LEFT JOIN REQUIRED_COVERAGE RC_IH ON RC_IH.ID = IH.REQUIRED_COVERAGE_ID
LEFT JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,''N'') = ''Y''	AND OLR.PURGE_DT IS NULL
LEFT JOIN [OWNER] O ON O.ID = OLR.OWNER_ID AND O.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AO ON AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AM ON AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
LEFT JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = ''ContractType'' AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
LEFT JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
LEFT JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
CROSS APPLY (Select Resolution = IH.SPECIAL_HANDLING_XML.value(''(/SH/Resolution/text())[1]'', ''NVARCHAR(500)'')
	,ReviewStatus = IH.SPECIAL_HANDLING_XML.value(''(/SH/ReviewStatus/text())[1]'', ''NVARCHAR(50)'')
	,WebVerif = IH.SPECIAL_HANDLING_XML.value(''(/SH/SubResolutionCode/text())[1]'', ''NVARCHAR(10)'')
) IH_SH
CROSS APPLY (
	Select
	 WebVerif = CASE WHEN IH_SH.WebVerif in (''V'', ''PV'') AND IH_SH.ReviewStatus <> ''OnHold'' THEN 1 ELSE 0 END
) AS OBC
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + 'CROSS APPLY dbo.fn_FilterCollateralByDivisionCd2(C.ID, @Division) fn_FCBD ' else '' end

select @conditions = N'
WHERE WIA.UPDATE_DT >= @FromDate AND WIA.UPDATE_DT < @ToDatePlus1
--AND U.FAMILY_NAME_TX not like ''%serv%''
AND U.SYSTEM_IN=''N''
AND WIA.PURGE_DT IS NULL AND WIA.ACTION_CD != ''Initial'' '
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then ' AND L.Lender_ID = @LenderID' else '' end
+ case when @Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + ' AND fn_FCBD.loanType IS NOT NULL ' else '' end
+ case when isnull(@Coverage , '1') <> '1' then char(10) + ' AND (@Coverage = IsNull(RC_IH.TYPE_CD, @Coverage) AND @Coverage IN (SELECT RC.TYPE_CD FROM REQUIRED_COVERAGE AS RC, REF_CODE AS RC_COVERAGETYPE WHERE RC.PROPERTY_ID = P.ID AND RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD)) ' else '' end
+ case when @User <> '' AND @User <> '0000' AND @User is not null then char(10) + ' AND WIA.UPDATE_USER_TX = @User' else '' end
+ case when @WorkItemType <> '' AND @WorkItemType is not null AND @WorkItemType <> 0 then char(10) + ' AND WD.ID = @WorkItemType' else '' end
+ case when @SubWorkItemType = @InboundCallerNotSatisfied then char(10) + ' AND  IH.SPECIAL_HANDLING_XML.exist(''(/SH/CallerSatisfied)[. = ''''N'''']'') = 1'
	when @SubWorkItemType = @InboundEscalated then char(10) + ' AND IH.SPECIAL_HANDLING_XML.exist(''(/SH/EscalatedCall)[. = ''''Y'''']'') = 1'
	when @SubWorkItemType = @InboundLiveChat then char(10) + ' AND IH.SPECIAL_HANDLING_XML.exist(''(/SH/LiveChat)[. = ''''Y'''']'') = 1'
	when @SubWorkItemType = @OutboundWebVerif then ' AND OBC.WebVerif <> 0'
	else '' end
+ case when @WorkQueue <> '' AND @WorkQueue <> '' AND @WorkQueue <> 0 then ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end


IF (@WorkItemType = 0)
BEGIN
	select @finalquery = @finalquery + @columns + @joins + @conditions + ' UNION ALL '
END

IF (@WorkItemType NOT In (0,5,6) AND @ReportType != 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions  + ' ORDER BY REPORT_SORTBY_TX 
		OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02'''
		+ case when @IsFiltered_Lender = 1 then ', @LenderID = 0' else '' end
		+ '))'
END
ELSE
BEGIN
	select @finalquery = @columns + @joins + @conditions
END

IF (@WorkItemType != 0 AND @ReportType = 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions 
END

if @debug>0
BEGIN

		select isnull(@columns, '@columns IS NULL') as '@columns'
		select isnull(@joins,'@joins IS NULL') as '@joins'
		select isnull(@conditions, '@conditions IS NULL')  as '@conditions'
		SELECT @finalquery as '@finalquery'
end


END


IF (@WorkItemType in (0,7,8))
BEGIN

--Verify Data or Action Request
select @columns = '
select distinct
(ISNULL(LND.CODE_TX,''No Lender'') + '' '' + ISNULL(LND.NAME_TX,'''') + '' / '' +
	(CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '''' then ''No Branch'' else L.BRANCH_CODE_TX END) + '' / '' +
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, WIA.UPDATE_DT, WIA.ACTION_CD,
CASE WHEN WIA.ACTION_NOTE_TX = ''system note:''
	THEN ''''
	ELSE WIA.ACTION_NOTE_TX
END AS ACTION_NOTE_TX,
COMMENT_TX = Coalesce(Left(IH.NOTE_TX,3500), ''''),
REASON_TX = Coalesce(IH_SH.Resolution, ''''),
IH.ID as IH_ID,
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX,
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'''') = ''''
	THEN ''0''
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
PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescriptionForReports(C.ID),
CALL_ATTEMPTS = null--ISNULL(IH.SPECIAL_HANDLING_XML.value(''(/SH/CallAttempts/text())[1]'', ''NVARCHAR(2)''), '''')
'
select @joins = '
FROM WORK_ITEM_ACTION WIA
JOIN WORK_ITEM WI ON WI.ID = WIA.WORK_ITEM_ID
LEFT JOIN INTERACTION_HISTORY IH WITH(NOLOCK) ON IH.ID = WI.RELATE_ID AND IH.PURGE_DT IS NULL
CROSS APPLY (Select Resolution = IH.SPECIAL_HANDLING_XML.value(''(/SH/Resolution/text())[1]'', ''NVARCHAR(500)'')) IH_SH
'
+ case when (@WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0) OR @XQ = 1 then 'JOIN' else 'LEFT JOIN' end + 
' WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
JOIN USERS U ON U.USER_NAME_TX = WIA.UPDATE_USER_TX AND U.PURGE_DT IS NULL
JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID in (7,8)
'
+ case when (@LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null)
		  or (@Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL)
       then
'JOIN LOAN L ON L.ID = WI.RELATE_ID 
JOIN COLLATERAL C ON C.LOAN_ID = L.ID
JOIN PROPERTY P ON P.ID = C.PROPERTY_ID AND P.LENDER_ID = L.LENDER_ID
'
else
'left JOIN LOAN L ON L.ID = WI.RELATE_ID 
left JOIN COLLATERAL C ON C.LOAN_ID = L.ID
left JOIN PROPERTY P ON P.ID = C.PROPERTY_ID AND P.LENDER_ID = L.LENDER_ID
'
end
+ case when isnull(@Coverage , '1')  not in ('1', '') then 'JOIN' else 'LEFT JOIN' end +
' REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
'
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then '' else 'LEFT' end
+' JOIN LENDER LND ON LND.ID = L.LENDER_ID 
left JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,''N'') = ''Y''
left JOIN [OWNER] O ON O.ID = OLR.OWNER_ID
left JOIN [OWNER_ADDRESS] AO ON AO.ID = O.ADDRESS_ID
left JOIN [OWNER_ADDRESS] AM ON AM.ID = P.ADDRESS_ID
JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = ''ContractType'' AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + 'CROSS APPLY dbo.fn_FilterCollateralByDivisionCd2(C.ID, @Division) fn_FCBD ' else '' end

select @conditions = '
--where U.FAMILY_NAME_TX not like ''%serv%''
WHERE U.SYSTEM_IN=''N''
AND WIA.UPDATE_DT >= @FromDate AND WIA.UPDATE_DT < @ToDatePlus1
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + ' AND fn_FCBD.loanType IS NOT NULL ' else '' end
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then char(10) + ' AND L.Lender_ID = @LenderID' else '' end
+ case when @Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
+ case when @Coverage <> '1' AND @Coverage <> '' AND @Coverage is NOT NULL then char(10) + ' AND (RC.TYPE_CD = @Coverage) ' else '' end
+ case when @User <> '' AND @User <> '0000' AND @User is not null then char(10) + ' AND WIA.UPDATE_USER_TX = @User' else '' end
+ case when @WorkItemType <> '' AND @WorkItemType is not null AND @WorkItemType <> 0 then char(10) + ' AND WD.ID = @WorkItemType' else '' end
+ case when @WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0 then char(10) + ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then char(10) + ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end

IF (@WorkItemType = 0)
BEGIN
	select @finalquery = @finalquery + @columns + @joins + @conditions + ' UNION ALL '
END

IF (@WorkItemType != 0 AND @ReportType != 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions + ' ORDER BY REPORT_SORTBY_TX OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02'')) '
END

IF (@WorkItemType != 0 AND @ReportType = 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions 
END

if @debug>0
begin
		select isnull(@columns, '@columns IS NULL') as '@columns'
		select isnull(@joins,'@joins IS NULL') as '@joins'
		select isnull(@conditions, '@conditions IS NULL') as '@conditions'
		 SELECT @finalquery as '@finalquery'
end


END

IF (@WorkItemType in (0,3))
BEGIN

--CPI Cancel Pending
select @columns = '
select distinct
(ISNULL(LND.CODE_TX,''No Lender'') + '' '' + ISNULL(LND.NAME_TX,'''') + '' / '' +
	(CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '''' then ''No Branch'' else L.BRANCH_CODE_TX END) + '' / '' +
	ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, WIA.UPDATE_DT, RC_ACTION.MEANING_TX as action_cd,
isnull(WI.CONTENT_XML.value(''(/Content/CancelCPIWorkflow/UnableToProcessReason/@meaning)[1]'', ''varchar(100)''),
	CASE WHEN WIA.ACTION_NOTE_TX = ''system note:'' THEN ''''
		ELSE WIA.ACTION_NOTE_TX
	END) as ACTION_NOTE_TX,
COMMENT_TX = Coalesce(Left(IH.NOTE_TX,3500) + ''; '', '''') + Coalesce(Left(IH_OBC.NOTE_TX,3500) + '' (OBC)'', ''''),
REASON_TX = Coalesce(IH_SH.Resolution + ''; '', IH_SH.Reason + ''; '', '''') + IsNull(NullIf(OBC.REASON_TX,'''') + '' (OBC)'',''''),
IH.ID as IH_ID,
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX,
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'''') = ''''
	THEN ''0''
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
PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescriptionForReports(C.ID),
NULL AS CALL_ATTEMPTS
'
select @joins = '
FROM WORK_ITEM_ACTION WIA
JOIN WORK_ITEM WI ON WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
LEFT JOIN INTERACTION_HISTORY IH WITH(NOLOCK) ON IH.ID = WI.RELATE_ID AND IH.PURGE_DT IS NULL
CROSS APPLY (Select
	 Resolution = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Resolution/text())[1]'', ''NVARCHAR(500)'')
	,Reason = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Reason/text())[1]'', ''NVARCHAR(500)'')
) IH_SH
'
+ case when (@WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0) OR @XQ = 1 then 'JOIN' else 'LEFT JOIN' end + 
' WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
JOIN USERS U ON U.USER_NAME_TX = WIA.UPDATE_USER_TX AND U.PURGE_DT IS NULL
JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID in (3)
'
+ case when isnull(@Coverage , '1') <> '1' then 'JOIN' else 'LEFT JOIN' end +
' REQUIRED_COVERAGE RC ON RC.ID = WI.RELATE_ID AND RC.PURGE_DT IS NULL
'
+ case when (@LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null)
		  or (@Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL)
       then
'JOIN COLLATERAL C ON C.PROPERTY_ID = RC.PROPERTY_ID AND C.PURGE_DT IS NULL
JOIN LOAN L ON L.ID = C.LOAN_ID AND L.PURGE_DT IS NULL
JOIN PROPERTY P ON P.ID = C.PROPERTY_ID AND P.LENDER_ID = L.LENDER_ID AND P.PURGE_DT IS NULL
'
else
'left JOIN COLLATERAL C ON C.PROPERTY_ID = RC.PROPERTY_ID AND C.PURGE_DT IS NULL
left JOIN LOAN L ON L.ID = C.LOAN_ID AND L.PURGE_DT IS NULL
left JOIN PROPERTY P ON P.ID = C.PROPERTY_ID AND P.LENDER_ID = L.LENDER_ID AND P.PURGE_DT IS NULL
'
end
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then '' else 'LEFT' end
+' JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT is null
OUTER Apply(Select TOP 1 IH_OBC.* From INTERACTION_HISTORY IH_OBC (NoLock) Where IH_OBC.PROPERTY_ID=P.ID AND IH_OBC.TYPE_CD=''VRFCTNEVT'' AND IH_OBC.PURGE_DT Is Null
 AND Abs(DateDiff(minute,IH_OBC.CREATE_DT,WIA.CREATE_DT))<2
 Order By IH_OBC.CREATE_DT) As IH_OBC
OUTER APPLY (Select Resolution_OBC = IH_OBC.SPECIAL_HANDLING_XML.value(''(/SH[1]/Resolution/text())[1]'', ''NVARCHAR(500)'')
	,ReviewStatus_OBC = IH_OBC.SPECIAL_HANDLING_XML.value(''(/SH[1]/ReviewStatus/text())[1]'', ''NVARCHAR(50)'')
	,Reason_OBC = IH_OBC.SPECIAL_HANDLING_XML.value(''(/SH[1]/Reason/text())[1]'', ''NVARCHAR(50)'')
) IH_SH_OBC
OUTER APPLY(Select
 REASON_TX =
 Case
	When IH_OBC.ID Is Null
	Then Null

	When WIA.ACTION_CD NOT In (''Complete'', ''Withdrawn'')
	Then Null
	
	When IH_OBC.CREATE_DT<WIA.CREATE_DT
	Then Coalesce(IH_SH_OBC.Reason_OBC, '''')

	When IH_OBC.CREATE_DT<@FromDate
	Then Coalesce(IH_SH_OBC.Reason_OBC + '' before this report start date'', '''')

	When IH_OBC.CREATE_DT>=@ToDatePlus1
	Then Coalesce(IH_SH_OBC.Reason_OBC + '' after this report end date'', '''')

	Else Coalesce(IH_SH_OBC.Reason_OBC, '''')
 End
 ) OBC
left JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,''N'') = ''Y'' AND OLR.PURGE_DT IS NULL
left JOIN [OWNER] O ON O.ID = OLR.OWNER_ID AND O.PURGE_DT IS NULL
left JOIN [OWNER_ADDRESS] AO ON AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
left JOIN [OWNER_ADDRESS] AM ON AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = ''ContractType'' AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
left JOIN REF_CODE RC_ACTION ON RC_ACTION.DOMAIN_CD = ''CPICancelPendingStatus'' AND RC_ACTION.CODE_CD = WIA.ACTION_CD
JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + 'CROSS APPLY dbo.fn_FilterCollateralByDivisionCd2(C.ID, @Division) fn_FCBD ' else '' end

select @conditions = '
--where U.FAMILY_NAME_TX not like ''%serv%''
WHERE U.SYSTEM_IN=''N''
AND WIA.PURGE_DT IS NULL
AND WIA.UPDATE_DT >= @FromDate AND WIA.UPDATE_DT < @ToDatePlus1
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + ' AND fn_FCBD.loanType IS NOT NULL ' else '' end
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then char(10) + ' AND L.Lender_ID = @LenderID' else '' end
+ case when @Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
+ case when @Coverage <> '1' AND @Coverage <> '' AND @Coverage is NOT NULL then char(10) + ' AND (RC.TYPE_CD = @Coverage) ' else '' end
+ case when @User <> '' AND @User <> '0000' AND @User is not null then char(10) + ' AND WIA.UPDATE_USER_TX = @User' else '' end
+ case when @WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0 then char(10) + ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then char(10) + ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end

IF (@WorkItemType = 0)
BEGIN
	select @finalquery = @finalquery + @columns + @joins + @conditions + ' UNION ALL '
END

IF (@WorkItemType != 0 AND @ReportType != 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions + ' ORDER BY REPORT_SORTBY_TX OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02'')) '
END

IF (@WorkItemType != 0 AND @ReportType = 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions 
END

if @debug>0
begin
		select isnull(nullif(@columns,''), '@columns IS NULL') as '@columns'
		select isnull(nullif(@joins,''),'@joins IS NULL') as '@joins'
		select isnull(nullif(@conditions,''), '@conditions IS NULL') as '@conditions'
		 SELECT @finalquery as '@finalquery'
end


END


IF (@WorkItemType in (0,1,9,10,11))
BEGIN
--Lender File Processing, Cycle, Billing Group, Escrow

SET @columns = N'
select distinct
'''' AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX, WIA.UPDATE_DT, WIA.ACTION_CD,
CASE WHEN WIA.ACTION_NOTE_TX = ''system note:''
	THEN ''''
	ELSE WIA.ACTION_NOTE_TX
END AS ACTION_NOTE_TX,
NULL as COMMENT_TX,
NULL as REASON_TX,
NULL as IH_ID,
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
'''' PROPERTY_DESCRIPTION,
NULL AS CALL_ATTEMPTS
'
select @joins = N'
FROM WORK_ITEM_ACTION WIA
JOIN WORK_ITEM WI ON WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
'
+ case when @WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0 then 'JOIN' else 'LEFT JOIN' end + 
' WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
JOIN USERS U ON U.USER_NAME_TX = WIA.UPDATE_USER_TX AND U.PURGE_DT IS NULL
JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID in (1,9,10,11)
'
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then '' else 'LEFT' end
+' JOIN LENDER LND ON LND.CODE_TX = WI.CONTENT_XML.value(''(/Content/Lender/Code)[1]'', ''varchar(100)'') AND LND.PURGE_DT IS NULL
'

select @conditions = N'
--where U.FAMILY_NAME_TX not like ''%serv%''
WHERE U.SYSTEM_IN=''N''
 AND WIA.PURGE_DT IS NULL
 AND WIA.UPDATE_DT >= @FromDate AND WIA.UPDATE_DT < @ToDatePlus1'
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then char(10) + ' AND LND.ID = @LenderID' else '' end
--+ case when @Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
--+ case when @Coverage <> '1' AND @Coverage <> '' AND @Coverage is NOT NULL then char(10) + ' AND (RC.TYPE_CD = @Coverage) ' else '' end
+ case when @User <> '0000' AND @User <> '' AND @User is NOT NULL then char(10) + ' AND (WIA.UPDATE_USER_TX = @User) ' else '' end
+ case when @WorkItemType <> '' AND @WorkItemType is not null AND @WorkItemType <> 0 then ' AND WD.ID = @WorkItemType' else '' end
+ case when @WorkQueue <> '' AND @WorkQueue <> '' AND @WorkQueue <> 0 then ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end


IF (@WorkItemType = 0 AND @ReportType != 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @finalquery + @columns + @joins + @conditions + ' ) t ORDER BY REPORT_SORTBY_TX  OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02'')) '
END

IF (@WorkItemType = 0 AND @ReportType = 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @finalquery + @columns + @joins + @conditions + ' ) t '
END

IF (@WorkItemType != 0 AND @ReportType != 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions + ' ORDER BY REPORT_SORTBY_TX OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02'')) '
END

IF (@WorkItemType != 0 AND @ReportType = 'ACTIVITYSUMM')
BEGIN
	select @finalquery = @columns + @joins + @conditions 
END

if @debug>0
begin
		select isnull(@columns, '@columns IS NULL') as '@columns'
		select isnull(@joins,'@joins IS NULL') as '@joins'
		select isnull(@conditions, '@conditions IS NULL')  as '@conditions'
		SELECT @finalquery as '@finalquery'
end

END

IF (@WorkItemType in (14))
BEGIN
	/*
	-- Agent Notification:
	*/
select @columns = '
	SELECT distinct
	 REPORT_GROUPBY_TX = SortGroup.AgentLetterOptionValue /*SortGroup.LenderBranch*/
	,REPORT_SORTBY_TX = Substring(SortGroup.LenderCode + ''|'' + SortGroup.AgentLetterOptionValue + ''|'' + SortGroup.AgentName + ''|'' + SortGroup.StatusDate + ''|'' + SortGroup.[Sequence], 1, 100)
	,UPDATE_USER_TX = IH.CREATE_USER_TX
	,U.FAMILY_NAME_TX
	,U.GIVEN_NAME_TX
	,UPDATE_DT = IH.CREATE_DT
	,ACTION_CD = Substring(RTrim(RC_IHTYPE.DESCRIPTION_TX) + '' ('' + CASE WHEN IH_SH.AgentLetterOptionValue <> '''' AND IH_SH.SentToDesc <> '''' THEN IH_SH.AgentLetterOptionValue + '' to '' + IH_SH.SentToDesc ELSE IsNull(NullIf(IH_SH.AgentLetterOptionValue, ''''), IH_SH.SentToDesc) END + '')'', 1, 30)
	,ACTION_NOTE_TX = SortGroup.StatusDate + '' '' + IH_SH.AgentName + '' ('' + CASE WHEN IH_SH.AgentLetterOptionValue = ''Fax'' THEN SortGroup.AgentFax WHEN IH_SH.AgentLetterOptionValue = ''Email'' THEN SortGroup.AgentEmail ELSE IH_SH.AgentEmail END + '')'' + '' '' + IsNull(Left(IH.NOTE_TX,4000), '''')
	,COMMENT_TX = NULL
	,REASON_TX = NULL
	,IH_ID = IH.ID
	,WorkItemID = n.REFERENCE_ID_TX 
	,WorkItemType = Substring(RTrim(n.NAME_TX) + '' (reference)'', 1, 80) 
	,WorkQueueName = Substring(SortGroup.PDF_GENERATE_CD + ''|'' + SortGroup.MailStatus + ''|'' + SortGroup.[Status], 1, 30) 
	,LenderCode = LND.CODE_TX
	,LenderName = LND.NAME_TX
	,L.BRANCH_CODE_TX
	,DIVISION_CODE_TX =
	 CASE WHEN L.DIVISION_CODE_TX = @Division OR IsFiltered.Division = 0 OR NullIf(RCA_PROP.VALUE_TX, '''') IS NULL
	      THEN IsNull(NullIf(L.DIVISION_CODE_TX, ''''), ''0'')
	 ELSE L.DIVISION_CODE_TX + '' ('' + NullIf(RCA_PROP.VALUE_TX, '''') + '')''
	 END
	,DivisionDescription = ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)
	,RequiredCoverage = COALESCE(RC.TYPE_CD, STUFF(Coverage.CSV, 1, 2, '''') + CASE WHEN IsNull(@Coverage, ''1'') <> ''1'' THEN '' (filtered)'' ELSE '''' END)
	,LoanNumber = L.NUMBER_TX
	,FIRST_NAME_TX = COALESCE(O.FIRST_NAME_TX, '''')
	,LAST_NAME_TX = COALESCE(O.LAST_NAME_TX, '''')
	,VIN_TX = COALESCE(P.VIN_TX, '''')
	,YEAR_TX = COALESCE(P.YEAR_TX, '''')
	,MAKE_TX = COALESCE(P.MAKE_TX, '''')
	,MODEL_TX = COALESCE(P.MODEL_TX, '''')
	,EquipmentDescription = COALESCE(P.DESCRIPTION_TX, '''')
	,BorrowerAddressLine1 = COALESCE(AO.LINE_1_TX, '''')
	,BorrowerAddressLine2 = COALESCE(AO.LINE_2_TX, '''')
	,BorrowerAddressCity = COALESCE(AO.CITY_TX, '''')
	,BorrowerAddressStateProvince = COALESCE(AO.STATE_PROV_TX, '''')
	,BorrowerAddressPostalCode = COALESCE(AO.POSTAL_CODE_TX, '''')
	,MortgageAddressLine1 = COALESCE(AM.LINE_1_TX, '''')
	,MortgageAddressLine2 = COALESCE(AM.LINE_2_TX, '''')
	,MortgageAddressCity = COALESCE(AM.CITY_TX, '''')
	,MortgageAddressStateProvince = COALESCE(AM.STATE_PROV_TX, '''')
	,MortgageAddressPostalCode = COALESCE(AM.POSTAL_CODE_TX, '''')
	,PROPERTY_TYPE_CD = RCA_PROP.VALUE_TX
   ,PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescriptionForReports(C.ID)
	,CALL_ATTEMPTS = NULL
'
select @joins = '
	FROM INTERACTION_HISTORY ih
	JOIN USERS U ON U.USER_NAME_TX = IH.CREATE_USER_TX
	LEFT JOIN NOTICE n ON n.ID = ih.RELATE_ID AND ih.RELATE_CLASS_TX = ''Allied.UniTrac.Notice''
	CROSS APPLY (SELECT
	 Lender = CAST(' + CASE WHEN @LenderCode IS NOT NULL AND @LenderCode <> '' AND @LenderCode <> '0' THEN '1' ELSE '0' END + ' As Bit)
	,Branch = CAST(' + CASE WHEN @Branch IS NOT NULL AND @Branch <> '' AND @Branch <> '1' THEN '1' ELSE '0' END + ' As Bit)
	,Division = CAST(' + CASE WHEN @Division IS NOT NULL AND @Division <> '' AND @Division <> '1' THEN '1' ELSE '0' END + ' As Bit)
	,Coverage = CAST(' + CASE WHEN @Coverage IS NOT NULL AND @Coverage <> '' AND @Coverage <> '1' THEN '1' ELSE '0' END + ' As Bit)
	) AS IsFiltered
	CROSS APPLY (SELECT
	 RC = IsNull(NullIf(IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/RC[1]/text())[1]'', ''NVARCHAR(15)''), ''''), ''0'')
	,[Type] = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Type[1]/text())[1]'', ''NVARCHAR(15)'')
	,SentToDesc = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/SentToDesc[1]/text())[1]'', ''NVARCHAR(15)'')
	,AgentLetterOptionValue = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/AgentLetterOptionValue[1]/text())[1]'', ''NVARCHAR(15)'')
	,AgentName = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/AgentName[1]/text())[1]'', ''NVARCHAR(50)'')
	,AgentEmail = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/AgentEmail[1]/text())[1]'', ''NVARCHAR(50)'')
	,AgentFax = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/AgentFax[1]/text())[1]'', ''NVARCHAR(15)'')
	,[Status] = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Status[1]/text())[1]'', ''NVARCHAR(15)'')
	,MailStatus = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/MailStatus[1]/text())[1]'', ''NVARCHAR(15)'')
	,StatusDate = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/StatusDate[1]/text())[1]'', ''NVARCHAR(25)'')
	,[Sequence] = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Sequence[1]/text())[1]'', ''NVARCHAR(25)'')
	) AS IH_SH
	CROSS APPLY (SELECT
	 StatusDate = CAST(CASE WHEN NullIf(IH_SH.StatusDate, '''') IS NOT NULL AND IH_SH.StatusDate <> ''1/1/0001'' AND IH_SH.StatusDate >= ''1/1/1900'' AND IsDate(IH_SH.StatusDate) = 1 THEN 1 ELSE 0 END As Bit) 
	) AS IsValid
'
+ case when @IsFiltered_Branch = 0 
then 
'
	JOIN PROPERTY P ON P.ID = IH.PROPERTY_ID
	JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
	JOIN LOAN L ON L.ID = C.LOAN_ID
'
else
'
	LEFT JOIN PROPERTY P ON P.ID = IH.PROPERTY_ID
	LEFT JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
	LEFT JOIN LOAN L ON L.ID = C.LOAN_ID
'
end
+ '
	LEFT JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
		  AND (RC.ID = COALESCE(IH.REQUIRED_COVERAGE_ID, IH_SH.RC))
	LEFT JOIN REF_CODE AS RC_COVERAGEFILTER ON RC_COVERAGEFILTER.DOMAIN_CD = ''Coverage'' AND (RC_COVERAGEFILTER.CODE_CD = @Coverage)
	LEFT JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,''N'') = ''Y''
	LEFT JOIN [OWNER] O ON O.ID = OLR.OWNER_ID
	LEFT JOIN OWNER_ADDRESS AO ON AO.ID = O.ADDRESS_ID
	LEFT JOIN OWNER_ADDRESS AM ON AM.ID = P.ADDRESS_ID
	JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = ''ContractType'' AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
'
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then '' else 'LEFT' end
+' JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT is null
	LEFT JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
	LEFT JOIN REF_CODE RC_IHTYPE ON RC_IHTYPE.DOMAIN_CD = ''InteractionHistoryType'' AND RC_IHTYPE.CODE_CD = IH.TYPE_CD
	JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
	LEFT JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
	LEFT JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
	CROSS APPLY (SELECT
	 CSV = (SELECT '', '' + RC_COVERAGETYPE.MEANING_TX FROM REQUIRED_COVERAGE AS RC, REF_CODE AS RC_COVERAGETYPE WHERE RC.PROPERTY_ID = P.ID AND RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD AND (RC.TYPE_CD = @Coverage OR @Coverage = ''1'') ORDER BY RC_COVERAGETYPE.MEANING_TX FOR XML PATH(''''))
	) AS Coverage
	CROSS APPLY (SELECT
	 LenderCode = ISNULL(LND.CODE_TX,''0000'')
	,LenderName = ISNULL(LND.NAME_TX, ''_no_lender'')
	,LenderBranch = ISNULL(L.BRANCH_CODE_TX, ''_no_branch'')
	,LenderBranchDivision = (ISNULL(LND.CODE_TX,''No Lender'') + '' '' + ISNULL(LND.NAME_TX,'''') + '' / '' +
		(CASE WHEN L.BRANCH_CODE_TX IS NULL OR L.BRANCH_CODE_TX = '''' THEN ''No Branch'' ELSE L.BRANCH_CODE_TX END) + '' / '' +
		ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX))
	,AgentLetterOptionValue = IsNull(NullIf(IH_SH.AgentLetterOptionValue, ''''), ''_no_option'')
	,AgentName = IsNull(NullIf(IH_SH.AgentName, ''''), ''_no_name'')
	,AgentEmail = IsNull(NullIf(IH_SH.AgentEmail, ''''), ''_no_email'')
	,AgentFax = STUFF(IsNull(NullIf(IH_SH.AgentFax, ''''), ''0000000000''), 4, 1, ''-'')
	,[Status] = IsNull(NullIf(IH_SH.[Status], ''''), ''_no_status'')
	,MailStatus = IsNull(NullIf(IH_SH.MailStatus, ''''), ''_no_mailstatus'')
	,StatusDate = CONVERT(NVARCHAR(10), CASE WHEN IsValid.StatusDate = 1 THEN CAST(IH_SH.StatusDate AS Date) ELSE CAST(IH.UPDATE_DT As Date) END, 111)
	,[Sequence] = IsNull(NullIf(IH_SH.[Sequence], ''''), ''0'')
	,PDF_GENERATE_CD = IsNull(n.PDF_GENERATE_CD, ''?'')
	) AS SortGroup
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + 'CROSS APPLY dbo.fn_FilterCollateralByDivisionCd2(C.ID, @Division) fn_FCBD ' else '' end
select @conditions = '
	WHERE ih.PURGE_DT IS NULL
	AND IH_SH.[Type] = ''AN''
	AND (IH.CREATE_DT >= @FromDate AND IH.CREATE_DT < @ToDatePlus1)
	--AND U.FAMILY_NAME_TX NOT LIKE ''%serv%''
	AND U.SYSTEM_IN=''N''
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + ' AND fn_FCBD.loanType IS NOT NULL ' else '' end
+ case when @IsFiltered_User = 0 then '' else char(10) + 'AND (IH.CREATE_USER_TX = @User)' end

+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then char(10) + ' AND LND.ID = @LenderID' else '' end
+ case when @IsFiltered_Coverage = 0 then '' else char(10) + 'and (RC_COVERAGEFILTER.CODE_CD = RC.TYPE_CD OR (RC.TYPE_CD IS NULL AND Coverage.CSV LIKE '',%'' + @Coverage + ''%''))' end
+ case when @IsFiltered_Branch = 0 then '' else char(10) + 'and (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' end  

IF ( @ReportType != 'ACTIVITYSUMM')
begin
	select @finalquery = @columns + @joins + @conditions + ' ORDER BY REPORT_SORTBY_TX OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02'')) '
end

IF ( @ReportType = 'ACTIVITYSUMM')
begin
	select @finalquery = @columns + @joins + @conditions 
end

if @debug>0
begin
		select isnull(@columns, '@columns IS NULL') as '@columns'
		select isnull(@joins,'@joins IS NULL') as '@joins'
		select isnull(@conditions, '@conditions IS NULL')  as '@conditions'
		SELECT @coverage coverage, @finalquery as '@finalquery'
end


END

-- QC
IF (@WorkItemType in (0, 19))
BEGIN

-- QC
SET @columns = N'
select distinct 
   (ISNULL(LND.CODE_TX,''No Lender'') + '' '' + ISNULL(LND.NAME_TX,'''') + '' / '' +
   (CASE when L.BRANCH_CODE_TX is null or L.BRANCH_CODE_TX = '''' then ''No Branch'' else L.BRANCH_CODE_TX END) + '' / '' +
   ISNULL(RC_DIVISION.DESCRIPTION_TX,RC_SC.DESCRIPTION_TX)) AS REPORT_GROUPBY_TX,
CONVERT(nvarchar(19), WIA.UPDATE_DT, 120) AS REPORT_SORTBY_TX,
WIA.UPDATE_USER_TX, U.FAMILY_NAME_TX, U.GIVEN_NAME_TX,
WIA.CREATE_DT, WIA.UPDATE_DT,
WIA.ACTION_CD,
CASE WHEN WIA.ACTION_NOTE_TX = ''system note:''
   THEN ''''
   ELSE WIA.ACTION_NOTE_TX
END AS ACTION_NOTE_TX,
qci.MEMO_TX as COMMENT_TX,
NULL as REASON_TX,
NULL as IH_ID,
WI.ID as WorkItemID, WD.DESCRIPTION_TX as WorkItemType, WQ.NAME_TX as WorkQueueName,
LND.CODE_TX as LenderCode, LND.NAME_TX as LenderName,
L.BRANCH_CODE_TX,
CASE WHEN ISNULL(L.DIVISION_CODE_TX,'''') = ''''
   THEN ''0''
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
PROPERTY_DESCRIPTION = dbo.fn_GetPropertyDescriptionForReports(C.ID),
NULL AS CALL_ATTEMPTS
'
select @joins = N'
FROM WORK_ITEM_ACTION WIA
JOIN WORK_ITEM WI ON WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
'
+ case when @WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0 then 'JOIN' else 'LEFT JOIN' end +
' WORK_QUEUE WQ ON WI.CURRENT_QUEUE_ID = WQ.ID AND WQ.PURGE_DT IS NULL
' 
+ 'JOIN USERS U ON U.USER_NAME_TX = WIA.UPDATE_USER_TX
JOIN WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL AND WD.ID in (19) AND WD.PURGE_DT IS NULL
JOIN QUALITY_CONTROL_ITEM qci ON qci.ID = WI.RELATE_ID
JOIN LOAN L ON L.ID = qci.LOAN_ID
JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
JOIN COLLATERAL C ON C.LOAN_ID = qci.LOAN_ID
JOIN PROPERTY P ON P.ID = C.PROPERTY_ID AND P.LENDER_ID = L.LENDER_ID
JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
left JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND ISNULL(OLR.PRIMARY_IN,''N'') = ''Y''
left JOIN [OWNER] O ON O.ID = OLR.OWNER_ID
left JOIN [OWNER_ADDRESS] AO ON AO.ID = O.ADDRESS_ID
left JOIN [OWNER_ADDRESS] AM ON AM.ID = P.ADDRESS_ID
JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = ''ContractType'' AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = ''Coverage'' AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = ''SecondaryClassification'' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD AND RC_SC.CODE_CD = RCA_PROP.REF_CD AND RCA_PROP.ATTRIBUTE_CD = ''PropertyType''
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + 'CROSS APPLY dbo.fn_FilterCollateralByDivisionCd2(C.ID, @Division) fn_FCBD ' else '' end

select @conditions = N'
--where U.FAMILY_NAME_TX not like ''%serv%'' 
WHERE U.SYSTEM_IN=''N''
AND WIA.ACTION_CD != ''Complete''
AND WIA.UPDATE_DT >= @FromDate AND WIA.UPDATE_DT < @ToDatePlus1
'
+ case when @Division <> '1' AND @Division <> '' AND @Division is NOT NULL then char(10) + ' AND fn_FCBD.loanType IS NOT NULL ' else '' end
+ case when @LenderCode <> '' AND @LenderCode <> '0' AND @LenderCode is not null then char(10) + ' AND L.Lender_ID = @LenderID ' else '' end
+ case when @Branch <> '1' AND @Branch <> '' AND @Branch is NOT NULL then char(10) + ' AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM #BranchTable)) ' else '' end
+ case when @Coverage <> '1' AND @Coverage <> '' AND @Coverage is NOT NULL then char(10) + ' AND (RC.TYPE_CD = @Coverage) ' else '' end
+ case when @User <> '' AND @User <> '0000' AND @User is not null then char(10) + ' AND WIA.UPDATE_USER_TX = @User' else '' end
+ case when @WorkQueue is not null AND @WorkQueue <> '' AND @WorkQueue <> 0 then char(10) + ' AND WQ.ID = @WorkQueue' else '' end
+ case when @XQ = 1 then char(10) + ' AND (WQ.NAME_TX LIKE ''%XQ%'' OR WQ.NAME_TX LIKE ''%X Queue%'')' else '' end

IF (@WorkItemType = 0 )
BEGIN
   select @finalquery = @finalquery + @columns + @joins + @conditions + ' UNION ALL '
END

IF (@WorkItemType != 0 AND @ReportType != 'ACTIVITYSUMM')
BEGIN
   select @finalquery = @columns + @joins + @conditions + ' ORDER BY REPORT_SORTBY_TX OPTION(OPTIMIZE FOR (@FromDate = ''2014-01-01'', @ToDatePlus1 = ''2014-01-02'')) '
END

IF (@WorkItemType != 0 AND @ReportType = 'ACTIVITYSUMM')
BEGIN
   select @finalquery =  @columns + @joins + @conditions
END

if @debug>0
begin
   select isnull(nullif(@columns,''), '@columns IS NULL') as '@columns'
   select isnull(nullif(@joins,''),'@joins IS NULL') as '@joins'
   select isnull(nullif(@conditions,''), '@conditions IS NULL') as '@conditions'

   SELECT @finalquery as '@finalquery'
end

END  -- if (@WorkItemType in (0, 19))


IF @ReportType IS NULL OR @ReportType = 'ACTIVITY'
BEGIN
	
/*
*/
	IF @WorkItemType In (5,6)
	BEGIN
		declare @finalquerycnttop nvarchar(20) = '' --default until reset
		--set @finalquerycnttop = ' top 100 percent ' --default until reset
		/*Try to optimize FQ with Count of the actual cardinality:
		*/
		declare @finalquerycntsql nvarchar(max)
			--set @finalquerycntsql = 'select count(*) from ( ' + @finalquery + ' ) as FQ'
			set @finalquerycntsql = '
SELECT COUNT(DISTINCT C.ID)
FROM dbo.WORK_ITEM_ACTION WIA (NoLock)
/*INNER LOOP*/ JOIN dbo.WORK_ITEM WI (NoLock) ON WI.ID = WIA.WORK_ITEM_ID AND WI.PURGE_DT IS NULL
JOIN dbo.WORKFLOW_DEFINITION WD (NoLock) ON WD.ID = WI.WORKFLOW_DEFINITION_ID AND WD.PURGE_DT IS NULL' + case when @WorkItemType=0 then '' else ' AND WD.ID = ' + cast(@WorkItemType as varchar(30)) end + '
JOIN dbo.USERS U (NoLock) ON Left(U.USER_NAME_TX,15) = Left(WIA.UPDATE_USER_TX,15)
/*LEFT*/ JOIN dbo.INTERACTION_HISTORY IH (NoLock) ON IH.ID = WI.RELATE_ID AND IH.PURGE_DT IS NULL
JOIN dbo.COLLATERAL C (NoLock) ON C.PROPERTY_ID = IH.PROPERTY_ID  AND C.PURGE_DT IS NULL
JOIN dbo.LOAN L (NoLock) ON L.ID = C.LOAN_ID  AND L.PURGE_DT IS NULL
JOIN dbo.LENDER LND (NoLock) ON LND.ID = L.LENDER_ID AND LND.PURGE_DT is null
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd2(C.ID, @Division) fn_FCBD 
WHERE WIA.UPDATE_DT >= @FromDate AND WIA.UPDATE_DT < @ToDatePlus1
--AND U.FAMILY_NAME_TX not like ''%serv%''
AND U.SYSTEM_IN=''N''
AND WIA.PURGE_DT IS NULL AND WIA.ACTION_CD != ''Initial'' AND L.Lender_ID = @LenderID
AND fn_FCBD.loanType IS NOT NULL
'

		declare @FinalQueryCntTab table(FQCnt int NOT null)
			insert into @FinalQueryCntTab(FQCnt)
			exec sp_executesql @finalquerycntsql,
			N'@SubWorkItemType bigint, @InboundCallerNotSatisfied bigint, @InboundEscalated bigint, @InboundLiveChat bigint, @OutboundWebVerif bigint,
			@LenderID bigint, @Division nvarchar(10), @Coverage nvarchar(25), @User nvarchar(15),
			@FromDate datetime, @ToDatePlus1 datetime,@WorkItemType bigint,@WorkQueue bigint',
			@SubWorkItemType, @InboundCallerNotSatisfied, @InboundEscalated, @InboundLiveChat, @OutboundWebVerif,
			@LenderID, @Division, @Coverage, @User,
			@FromDate, @ToDatePlus1,@WorkItemType,@WorkQueue

			declare @finalquerycnt int = (select top 1 FQCnt from @FinalQueryCntTab)
			select @finalquerycnttop = ' top '  + cast(@finalquerycnt as nvarchar(10))
			if @debug>0
			begin
				select *, FinalQueryCnt=@FinalQueryCnt, FinalQueryCntTop=@finalquerycnttop from @FinalQueryCntTab
			end

		declare @finalquerywithxmlval nvarchar(max)

		declare @newline as nvarchar(2) = char(13) + char(10)
		declare @b as nvarchar(1) = nchar(8199) --blank; fixed width "figure" space
		--declare @tab as nvarchar(1) = char(9)
		declare @tab as nvarchar(1) = @b + @b + @b + @b
		declare @tab2 as nvarchar(2) = @tab + @tab
		declare @tab3 as nvarchar(3) = @tab + @tab + @tab
		declare @pipe as nvarchar(3) = char(9) + '|' + char(9)

		SELECT @finalquerywithxmlval = 
		N' /* Report_UTLActivity; finalquery wrapped with XML values from IH_SH (see TFS#45633 #45634, #45834): */
		select 
		 ' + @finalquerycnttop + '
			 InteractionHistory_ID　
--,LAST_NAME_TX
--,FIRST_NAME_TX
--,SPECIAL_HANDLING_XML
			,Insurance_Company_Name = InsuranceCompanyName　
			,Caller_ID = CallID
			,FormattedMemo = REPLACE(REPLACE(Formatted.CpiMemo,'' '',@b),''?'',@b)
			,FormattedMemo1 = REPLACE(REPLACE(Formatted.CpiMemo1,'' '',@b),''?'',@b)
			,FormattedMemo2 = REPLACE(REPLACE(Formatted.CpiMemo2,'' '',@b),''?'',@b)
			,Lapse = case when Lower(IsLapse)=''true'' then ''Yes'' else ''No'' end　
			,Deductible　
			,Lienholder_Added_On = LHAddedDate　
			,New_Business = case when Lower(NewBusiness)=''true'' then ''Yes'' else ''No'' end　
			,[Susp_of_Comp_Clsn] = case when Lower(SuspCompClsn)=''true'' then ''Yes'' else ''No'' end　
			,Lienholder = case when Lower(IsLienholder)=''yes'' then ''Yes'' else ''No'' end　
			,Current_Exp_Date = ExpDate　
			,No_Coverage_Prior_To = NoCvgPriorDate　
			,FQ.*　
		from ( ' + @finalquery + ' ) as FQ　
		LEFT JOIN INTERACTION_HISTORY as IH (NoLock) ON IH.ID=FQ.IH_ID　
		OUTER apply(select　
			 InteractionHistory_ID = IH_ID　
			,InsuranceCompanyName = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/InsuranceCompanyName)[1]'', ''nvarchar(100)'')　
			,CallID = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/CallID)[1]'', ''nvarchar(30)'')　
			,IsLapse = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Vehicle/IsLapse)[1]'', ''nvarchar(5)'')　
			,LapseDates = NullIf(IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Vehicle/LapseDates)[1]'', ''nvarchar(25)''), '''')　
			,Deductible = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Vehicle/Deductible)[1]'', ''nvarchar(10)'')　
			,LHAddedDate = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Vehicle/LHAddedDate)[1]'', ''nvarchar(10)'')　
			,NewBusiness = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Vehicle/NewBusiness)[1]'', ''nvarchar(30)'')　
			,SuspCompClsn = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Vehicle/SuspCompClsn)[1]'', ''nvarchar(5)'')　
			,IsLienholder = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Vehicle/IsLienholder)[1]'', ''nvarchar(5)'')　
			,ExpDate = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Vehicle/ExpDate)[1]'', ''nvarchar(10)'')　
			,NoCvgPriorDate = IH.SPECIAL_HANDLING_XML.value(''(/SH[1]/Vehicle/NoCvgPriorDate)[1]'', ''nvarchar(10)'')　
		) as IH_SH
		OUTER Apply(select
			 CpiMemo = 
			''Lapse:                '' + @tab + Coalesce(LapseDates, IsLapse,''false'') + @pipe + 
			''Susp of Comp/Clsn:    '' + @tab + IsNull(SuspCompClsn,''false'') + @newline + 
			''Deductible:           '' + @tab + IsNull(Deductible,''???'') + @pipe + 
			''Lienholder:           '' + @tab + case Lower(IsLienholder) when ''yes'' then ''Yes'' when ''ok'' then ''OK'' when ''no'' then ''No'' else IsLienholder end + @newline + 
			''Lienholder Added On:  '' + @tab + IsNull(LHAddedDate,''?? ?? ????'') + @pipe + 
			''Current Exp Date:     '' + @tab + IsNull(ExpDate,''?? ?? ????'') + @newline + 
			''New Business:         '' + @tab + IsNull(NewBusiness,''false'') + @pipe + 
			''No Coverage Prior To: '' + @tab + IsNull(NoCvgPriorDate,''?? ?? ????'') + @newline 
			,CpiMemo1 = 
			''Lapse:                '' + @tab + Coalesce(LapseDates, IsLapse,''false'') + @pipe + 
			''Deductible:           '' + @tab + IsNull(Deductible,''???'') + @newline + 
			''Lienholder Added On:  '' + @tab + IsNull(LHAddedDate,''? ? ?'') + @newline + 
			''New Business:         '' + @tab + case when Lower(NewBusiness)=''true'' then ''Yes'' else ''No'' end + @newline
			,CpiMemo2 = 
			''Susp of Comp/Clsn:    '' + @tab + case when Lower(SuspCompClsn)=''true'' then ''Yes'' else ''No'' end + @newline + 
			''Lienholder:           '' + @tab + case Lower(IsLienholder) when ''yes'' then ''Yes'' when ''ok'' then ''OK'' when ''no'' then ''No'' else IsLienholder end + @newline + 
			''Current Exp Date:     '' + @tab + IsNull(ExpDate,''? ? ?'') + @newline + 
			''No Coverage Prior To: '' + @tab + IsNull(NoCvgPriorDate,''? ? ?'') + @newline 
		) as Formatted
		'

		select @finalquery = @finalquerywithxmlval

	if @debug>0
	begin
		print '@FinalQueryWithXmlVal:'
		print substring(@finalquerywithxmlval,1,4000)
		print substring(@finalquerywithxmlval,4001,4000)
	end
　	END

	if @debug>0
	begin
		print '@FinalQuery:'
		print substring(@finalquery,1,4000)
		print substring(@finalquery,4001,4000)
	end

	exec sp_executesql @finalquery,
	N'@SubWorkItemType bigint, @InboundCallerNotSatisfied bigint, @InboundEscalated bigint, @InboundLiveChat bigint, @OutboundWebVerif bigint,
	@LenderID bigint, @Division nvarchar(10), @Coverage nvarchar(25), @User nvarchar(15),
	@FromDate datetime, @ToDatePlus1 datetime,@WorkItemType bigint,@WorkQueue bigint, @newline nvarchar(2), @tab nvarchar(1), @tab2 nvarchar(2), @tab3 nvarchar(3), @pipe nvarchar(3), @b nvarchar(1)',
	@SubWorkItemType, @InboundCallerNotSatisfied, @InboundEscalated, @InboundLiveChat, @OutboundWebVerif,
	@LenderID, @Division, @Coverage, @User,
	@FromDate, @ToDatePlus1,@WorkItemType,@WorkQueue, @newline, @tab, @tab2, @tab3, @pipe, @b
END
ELSE IF @ReportType = 'ACTIVITYSUMM'
BEGIN
SELECT @finalquery = N'	select FAMILY_NAME_TX, GIVEN_NAME_TX, WorkItemType, COUNT(*) as WorkItemCount from ( ' + @finalquery + ') T	group by FAMILY_NAME_TX, GIVEN_NAME_TX, WorkItemType order by FAMILY_NAME_TX, GIVEN_NAME_TX, WorkItemType'

	exec sp_executesql @finalquery,
	N'@SubWorkItemType bigint, @InboundCallerNotSatisfied bigint, @InboundEscalated bigint, @InboundLiveChat bigint, @OutboundWebVerif bigint,
	@LenderID bigint, @Division nvarchar(10), @Coverage nvarchar(25), @User nvarchar(15),
	@FromDate datetime, @ToDatePlus1 datetime,@WorkItemType bigint,@WorkQueue bigint',
	@SubWorkItemType, @InboundCallerNotSatisfied, @InboundEscalated, @InboundLiveChat, @OutboundWebVerif,
	@LenderID, @Division, @Coverage, @User,
	@FromDate, @ToDatePlus1,@WorkItemType,@WorkQueue

END

SELECT @RecordCount = @@ROWCOUNT
If @debug>0 print @RecordCount

IF @Report_History_ID IS NOT NULL
AND @debug = 0
BEGIN
  UPDATE REPORT_HISTORY
  SET RECORD_COUNT_NO = @RecordCount
  ,UPDATE_DT = getdate()
  WHERE ID = @Report_History_ID
END

END


GO

