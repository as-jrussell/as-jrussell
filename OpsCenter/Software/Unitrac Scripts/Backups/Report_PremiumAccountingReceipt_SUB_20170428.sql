USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Report_PremiumAccountingReceipt]    Script Date: 4/28/2017 2:43:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Report_PremiumAccountingReceipt] 
(	@Report_History_ID as bigint=NULL, @work_item_id as bigint=NULL   )
	
AS
BEGIN
--Report_PremiumAccountingReceipt 939276, 546379

--declare @Report_History_ID as bigint = 4601795
--declare @work_item_id as bigint=null

IF(@Report_History_ID is not NULL or @work_item_id is not NULL)
BEGIN

DECLARE @RecordCount bigint = 0
IF @work_item_id IS NULL AND @Report_History_ID IS NOT NULL
	Begin
		SELECT @work_item_id=REPORT_DATA_XML.value('(//ReportData/Report/WorkItemID/@value)[1]', 'bigint')
		FROM REPORT_HISTORY WHERE ID = @Report_History_ID
	End

DECLARE @TEMPVAR TABLE 
(
	[ROW_NUMBER] [bigint] NULL,
	[FPC_ID] [bigint] NOT NULL,
	[BillingGroupId] [bigint] NOT NULL,
	[WorkItemId] [bigint] NOT NULL,
	[RelateClassName] [varchar](max) NULL,
	[RelateClassId] [bigint] NOT NULL,
	[LoanId] [bigint] NOT NULL,
	[PropertyId] [bigint] NOT NULL,
	[RequiredCoverageId] [bigint] NOT NULL,
	[Certificate] [nvarchar](max) NULL,
	[LoanNumber] [nvarchar](max) NULL,
	[CollateralNumber] [int] NULL,
	[AssetNumber] [nvarchar](max) NULL,
	[OwnerName] [nvarchar](max) NULL,
	[OnPreviousBillFile] int null,
	[Description] [nvarchar](100) NULL,
	[VIN] [nvarchar](max) NULL,
	[Basis] [decimal](18, 2) NOT NULL,
	[PolicyEffectiveDate] [datetime2](7) NULL,
	[CPIPolicyExpCxlDate] [datetime2](7) NULL,
	[Term] [int] NOT NULL,
	[IssueCancelCode] [nvarchar](max) NULL,
	[IssueReason] [nvarchar](max) NULL,
	[EarnedIssueAmount] [decimal](38, 2) NULL,
	[TotalAmount] [decimal](38, 2) NULL,
	[PastDue] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[Division] [nvarchar](max) NULL,
	[PropertyType] [nvarchar](max) NULL,
	[Line1] [varchar](max) NULL,
	[Line2] [varchar](max) NULL,
	[City] [varchar](max) NULL,
	[State] [varchar](max) NULL,
	[PostalCode] [varchar](max) NULL,
	[Country] [varchar](max) NULL,
	[LenderIntent] [varchar](max) NULL,
	[LenderResponse] [nvarchar](max) NULL,
	[LenderStartDate] [nvarchar](max) NULL,
	[LenderEndDate] [nvarchar](max) NULL,
	[LenderComment] [nvarchar](max) NULL,
	[CheckedOutUser] [nvarchar](max) NULL,
	[FT_TXN_DT] [datetime2](7) NULL,
	[Hold] [int] NULL,
	[Resolution] [varchar](max) NULL,
	[CallAttempts] [varchar](max) NULL,
	[Action] [varchar](max) NULL,
	[TotalRelates] bigint NULL,
	[TotalCompleteRelates] bigint NULL
) 

INSERT INTO @TEMPVAR
EXEC CPGetBillingGroupDetails @id = @work_item_id, @Skip = 0, @Take = 0, @ReturnRefunds = 2, @OnlyNewFTA = 0, @LenderRoleOnly = 0;

UPDATE @TEMPVAR SET LenderResponse = RC_ACTION.MEANING_TX,
PastDue = CASE WHEN ISNUMERIC(REPLACE(REPLACE(PastDue,' ',''),'*','')) = 0 THEN ''
	 WHEN REPLACE(REPLACE(PastDue,'*',''),'','') > 31 THEN 'Critical Past Due ' + REPLACE(REPLACE(PastDue,'*',''),'','') + ' Days'
	 ELSE 'Past Due ' + REPLACE(REPLACE(PastDue,'*',''),'','') + ' Days'
END
FROM @TEMPVAR TV
LEFT JOIN REF_CODE RC_ACTION ON RC_ACTION.CODE_CD = TV.LenderResponse AND RC_ACTION.PURGE_DT IS NULL AND RC_ACTION.DOMAIN_CD = 'BillingGroupLenderIntent'

/*
SELECT 
ROW_NUMBER() OVER(ORDER BY WI.ID) AS SEQ,
CAST(WI.ID AS nvarchar(max)) AS WorkItemID,
T2.Loc.value('(./@RelateClassId)[1]','nvarchar(Max)') AS RelateClassId,
T2.Loc.value('(./@LoanId)[1]','nvarchar(Max)') AS LoanId,
T2.Loc.value('(./@PropertyId)[1]','nvarchar(Max)') AS PropertyId,
T2.Loc.value('(./@RequiredCoverageId)[1]','nvarchar(Max)') AS RequiredCoverageId,
T2.Loc.value('(./@Certificate)[1]','nvarchar(Max)') AS Certificate,
T2.Loc.value('(./@LoanNumber)[1]','nvarchar(Max)') AS LoanNumber,
T2.Loc.value('(./@CollateralNumber)[1]','nvarchar(Max)') AS CollateralNumber,
T2.Loc.value('(./@OwnerName)[1]','nvarchar(Max)') AS OwnerName,
T2.Loc.value('(./@Description)[1]','nvarchar(Max)') AS Description,
T2.Loc.value('(./@VIN)[1]','nvarchar(Max)') AS VIN,
T2.Loc.value('(./@Basis)[1]','money') AS Basis,
T2.Loc.value('(./@EffectiveDate)[1]','datetime2') AS EffectiveDate,
T2.Loc.value('(./@CPIPolicyExpCxlDate)[1]','datetime2') AS CPIPolicyExpCxlDate,
T2.Loc.value('(./@Term)[1]','nvarchar(Max)') AS Term,
T2.Loc.value('(./@IssueReason)[1]','nvarchar(Max)') AS IssueReason,
T2.Loc.value('(./@EarnedIssueAmount)[1]','money') AS EarnedIssueAmount,
T2.Loc.value('(./@PastDue)[1]','nvarchar(Max)') AS PastDue,
--'(' + REPLACE(REPLACE(T2.Loc.value('(./@PastDue)[1]','nvarchar(max)'),'*',''),'','') + ')'AS TEST,
CASE WHEN ISNUMERIC(REPLACE(REPLACE(T2.Loc.value('(./@PastDue)[1]','nvarchar(Max)'),' ',''),'*','')) = 0 THEN ''
	 WHEN REPLACE(REPLACE(T2.Loc.value('(./@PastDue)[1]','nvarchar(max)'),'*',''),'','') > 31 THEN 'Critical Past Due ' + REPLACE(REPLACE(T2.Loc.value('(./@PastDue)[1]','nvarchar(max)'),'*',''),'','') + ' Days'
	 ELSE 'Past Due ' + REPLACE(REPLACE(T2.Loc.value('(./@PastDue)[1]','nvarchar(max)'),'*',''),'','') + ' Days'
END AS PastDueStatus,
T2.Loc.value('(./@Branch)[1]','nvarchar(Max)') AS Branch,
T2.Loc.value('(./@Division)[1]','nvarchar(Max)') AS Division,
T2.Loc.value('(./@PropertyType)[1]','nvarchar(Max)') AS PropertyType,
T2.Loc.value('(./@Line1)[1]','nvarchar(Max)') AS Line1,
T2.Loc.value('(./@Line2)[1]','nvarchar(Max)') AS Line2,
T2.Loc.value('(./@City)[1]','nvarchar(Max)') AS City,
T2.Loc.value('(./@State)[1]','nvarchar(Max)') AS State,
T2.Loc.value('(./@PostalCode)[1]','nvarchar(Max)') AS PostalCode,
T2.Loc.value('(./@Country)[1]','nvarchar(Max)') AS Country,
T2.Loc.value('(./@LenderResponse)[1]','nvarchar(Max)') AS LenderResponse,
RC_ACTION.MEANING_TX AS Action,
CASE WHEN T2.Loc.value('(./@PropertyType)[1]','nvarchar(Max)') = 'RES' THEN
	T2.Loc.value('(./@Line1)[1]','nvarchar(Max)') + ' ' +
	T2.Loc.value('(./@Line2)[1]','nvarchar(Max)') + ' ' +
	T2.Loc.value('(./@City)[1]','nvarchar(Max)') + ', ' +
	T2.Loc.value('(./@State)[1]','nvarchar(Max)') + ' ' +
	T2.Loc.value('(./@PostalCode)[1]','nvarchar(Max)')
	ELSE
	T2.Loc.value('(./@Description)[1]','nvarchar(Max)') + ' ' +
	T2.Loc.value('(./@VIN)[1]','nvarchar(Max)')
END AS PDescrption,
T2.Loc.value('(./@LenderStartDate)[1]','datetime2') AS LenderStartDate,
T2.Loc.value('(./@LenderEndDate)[1]','datetime2') AS LenderEndDate,
T2.Loc.value('(./@LenderComment)[1]','nvarchar(Max)') AS LenderComment
FROM WORK_ITEM WI
CROSS APPLY WI.CONTENT_XML.nodes('/Content/BillingGroup/Detail') As T2(Loc)
LEFT JOIN REF_CODE RC_ACTION ON RC_ACTION.CODE_CD = T2.Loc.value('(./@LenderResponse)[1]','nvarchar(Max)') AND RC_ACTION.PURGE_DT IS NULL AND RC_ACTION.DOMAIN_CD = 'BillingGroupLenderIntent'
WHERE 1=1
AND WI.PURGE_DT IS NULL
AND WI.ID = @work_item_id
*/
SELECT @RecordCount = COUNT(*) FROM @TEMPVAR

IF @Report_History_ID IS NOT NULL
BEGIN
  UPDATE REPORT_HISTORY
  SET RECORD_COUNT_NO = @RecordCount
  WHERE ID = @Report_History_ID
END
SELECT * FROM @TEMPVAR tmp ORDER BY tmp.OwnerName, tmp.RelateClassId, tmp.FT_TXN_DT
END
END



GO

