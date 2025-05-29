USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Report_ExtractTOT]    Script Date: 11/5/2015 4:22:58 PM ******/
DROP PROCEDURE [dbo].[Report_ExtractTOT]
GO

/****** Object:  StoredProcedure [dbo].[Report_ExtractTOT]    Script Date: 11/5/2015 4:22:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_ExtractTOT] (
@Report_History_ID as bigint=NULL)
					
AS

BEGIN
IF OBJECT_ID(N'tempdb..#tmpTable',N'U') IS NOT NULL
  DROP TABLE #tmpTable
IF OBJECT_ID(N'tempdb..#Loan',N'U') IS NOT NULL
  DROP TABLE #Loan
IF OBJECT_ID(N'tempdb..#Collateral',N'U') IS NOT NULL
  DROP TABLE #Collateral
IF OBJECT_ID(N'tempdb..#Customer',N'U') IS NOT NULL
  DROP TABLE #Customer
IF OBJECT_ID(N'tempdb..#TransactionXML',N'U') IS NOT NULL
  DROP TABLE #TransactionXML

DECLARE @TransactionId AS bigint
DECLARE @DocumentID as bigint
DECLARE @DivisionCode AS int = null

DECLARE @LenderID AS bigint
DECLARE @LenderCode AS nvarchar(30)
DECLARE @LenderName AS nvarchar(300)
DECLARE @OverrideDrop AS nvarchar(10) 
DECLARE @LoanUpdatesOnly AS nvarchar(10) 
DECLARE @WorkItemID bigint = 0
DECLARE @WorkItemDivision nvarchar(100)
DECLARE @WorkItemDivisionCode AS INT = NULL
DECLARE @ReportDivisionName nvarchar(100)

DECLARE @DEBUGGING as char(1) = 'F'

IF @DEBUGGING = 'T'
SET @DocumentID = 4087545 
ELSE
BEGIN
IF @Report_History_ID IS NOT NULL
	BEGIN
		 SELECT @DocumentID=REPORT_DATA_XML.value('(//ReportData/Report/DocumentID/@value)[1]', 'bigint'),
		 @DivisionCode=REPORT_DATA_XML.value('(//ReportData/Report/Division/@value)[1]', 'int')
			FROM REPORT_HISTORY WHERE ID = @Report_History_ID
	END
END

CREATE TABLE [#tmpTable]
(LenderCode nvarchar(20) NULL,
 LenderName nvarchar(50) NULL,
 TotalExtractRecords bigint NULL,
 TotalDBLoans bigint NULL,
 TotalDBCollaterals bigint NULL,
 TotalCollaterals bigint NULL,
 NewLoans bigint NULL,
 NewCollaterals bigint NULL,
 MatchedLoans bigint NULL,
 ClosedLoans bigint NULL,
 FirstUnmatchingLoans bigint NULL,
 SecondUnmatchingLoans bigint NULL,
 ThirdUnmatchingLoans bigint NULL,
 DeletedLoans bigint NULL,
 FirstUnmatchingCollaterals bigint NULL,
 SecondUnmatchingCollaterals bigint NULL,
 ThirdUnmatchingCollaterals bigint NULL,
 DeletedCollaterals bigint NULL,
 LoanReoccuranceCount bigint NULL,
 CollateralDescriptionUpdates bigint NULL,
 CPIInplaceCount bigint NULL,
 BadDataCount bigint NULL,
 NameUpdates nvarchar(max) NULL,
 AddressUpdates nvarchar(max) NULL,
 BalanceUpdates nvarchar(max) NULL,
 LoanUpdates nvarchar(max) NULL,
 LoanBalanceIncreaseUpdates nvarchar(max) NULL,
 APRUpdates nvarchar(10) NULL,
 LoanEffectiveDateUpdates nvarchar(10) NULL,
 OPT_MinNewLoanPercentage decimal (19, 2) NULL,
 OPT_MaxNewLoanPercentage decimal (19, 2) NULL,
 OPT_MaxNewCollateralPercentage decimal (19, 2) NULL,
 OPT_UnmatchedLoanPercentage decimal (19, 2) NULL,
 OPT_UnmatchedCollateralPercentage decimal (19, 2) NULL,
 OPT_ClosedLoanPercentage decimal (19, 2) NULL,
 OPT_NameUpdatePercentage decimal (19, 2) NULL,
 OPT_AddressUpdatePercentage decimal (19, 2) NULL,
 OPT_LoanUpdatePercentage decimal (19, 2) NULL,
 OPT_LoanBalanceUpdatePercentage decimal (19, 2) NULL,
 OPT_MaxAPRUpdatePercentage decimal (19, 2) NULL,
 WORK_ITEM_ID bigint NULL,
 WORK_ITEM_DIVISION_TX nvarchar(30) NULL,
 FROM_XML_TX varchar(1) NULL
 )

SELECT @TransactionId = ID,
@OverrideDrop = DATA.value('(/Lender/Lender/OptionLenderSummaryMatchResult/OverrideDrop)[1]', 'nvarchar(10)'),
@LoanUpdatesOnly = DATA.value('(/Lender/Lender/OptionLenderSummaryMatchResult/LoanUpdatesOnly)[1]', 'nvarchar(10)'),
@LenderID = DATA.value('(/Lender/Lender/LenderID)[1]', 'bigint') 
FROM [TRANSACTION] t WHERE DOCUMENT_ID = @DocumentID AND PURGE_DT IS NULL and isnull(t.RELATE_TYPE_CD,'') != 'INFA'

SELECT @LenderCode = CODE_TX, @LenderName = NAME_TX FROM LENDER WHERE ID = @LenderID

--GET work item values
SELECT @WorkItemID = MAX(WI.ID) 
FROM WORK_ITEM WI 
WHERE WI.RELATE_ID IN (SELECT MESSAGE_ID FROM [DOCUMENT] where ID = @DocumentID)
	AND WI.RELATE_TYPE_CD = 'LDHLib.Message' AND WI.PURGE_DT IS NULL

SELECT @WorkItemDivision = LO.NAME_TX, @WorkItemDivisionCode = LO.CODE_TX 
FROM WORK_ITEM WI
LEFT JOIN LENDER_ORGANIZATION LO ON WI.CONTENT_XML.value('(/Content/Division/Id)[1]', 'bigint') = lo.ID and lo.purge_dt is null
WHERE WI.ID = @WorkItemID


--IF report division is same as work item division, use values from Transaction XML; otherwise, calculate values and filter by division
IF (@DivisionCode IS NULL OR (@DivisionCode = @WorkItemDivisionCode))
BEGIN
	INSERT INTO #tmpTable (
	LenderCode,LenderName,TotalExtractRecords,TotalDBLoans,TotalDBCollaterals,TotalCollaterals,
	NewLoans,NewCollaterals,MatchedLoans,ClosedLoans, FirstUnmatchingLoans,
	SecondUnmatchingLoans, ThirdUnmatchingLoans,DeletedLoans,
	--Collaterals
	FirstUnmatchingCollaterals,SecondUnmatchingCollaterals,ThirdUnmatchingCollaterals,DeletedCollaterals,LoanReoccuranceCount,
	CollateralDescriptionUpdates,CPIInplaceCount,BadDataCount,NameUpdates,AddressUpdates,BalanceUpdates,
	LoanUpdates,LoanBalanceIncreaseUpdates,APRUpdates,LoanEffectiveDateUpdates,
	--OPTs
	OPT_MinNewLoanPercentage,OPT_MaxNewLoanPercentage,OPT_MaxNewCollateralPercentage,OPT_UnmatchedLoanPercentage,
	OPT_UnmatchedCollateralPercentage,OPT_ClosedLoanPercentage,OPT_NameUpdatePercentage,OPT_AddressUpdatePercentage,
	OPT_LoanUpdatePercentage,OPT_LoanBalanceUpdatePercentage,OPT_MaxAPRUpdatePercentage,WORK_ITEM_ID,WORK_ITEM_DIVISION_TX, FROM_XML_TX
	)
	SELECT 
	----Lender
	DATA.query('./Lender/Lender/LenderCode[1]').value('.','nvarchar(20)') AS LenderCode,
	DATA.query('./Lender/Lender/LenderName[1]').value('.','nvarchar(50)') AS LenderName,
	----CurrentLenderSummaryMatchResults
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/TotalExtractRecords[1]').value('.','decimal') AS TotalExtractRecords,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/TotalDBLoans[1]').value('.','decimal') AS TotalDBLoans,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/TotalDBCollaterals[1]').value('.','decimal') AS TotalDBCollaterals,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/TotalCollaterals[1]').value('.','decimal') AS TotalCollaterals,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/NewLoans[1]').value('.','decimal') AS NewLoans,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/NewCollaterals[1]').value('.','decimal') AS NewCollaterals,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/MatchedLoans[1]').value('.','decimal') AS MatchedLoans,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/ClosedLoans[1]').value('.','decimal') AS ClosedLoans,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/FirstUnmatchingLoans[1]').value('.','decimal') AS FirstUnmatchingLoans,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/SecondUnmatchingLoans[1]').value('.','decimal') AS SecondUnmatchingLoans,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/ThirdUnmatchingLoans[1]').value('.','decimal') AS ThirdUnmatchingLoans,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/DeletedLoans[1]').value('.','decimal') AS DeletedLoans,

	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/FirstUnmatchingCollaterals[1]').value('.','decimal') AS FirstUnmatchingCollaterals,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/SecondUnmatchingCollaterals[1]').value('.','decimal') AS SecondUnmatchingCollaterals,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/ThirdUnmatchingCollaterals[1]').value('.','decimal') AS ThirdUnmatchingCollaterals,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/DeletedCollaterals[1]').value('.','decimal') AS DeletedCollaterals,

	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/LoanReoccuranceCount[1]').value('.','decimal') AS LoanReoccuranceCount,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/CollateralDescriptionUpdates[1]').value('.','decimal') AS CollateralDescriptionUpdates,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/CPIInplaceCount[1]').value('.','decimal') AS CPIInplaceCount,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/BadDataCount[1]').value('.','decimal') AS BadDataCount,

	CASE WHEN DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/NameUpdates[1]').value('.','nvarchar(max)') = '' THEN '0' ELSE DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/NameUpdates[1]').value('.','nvarchar(max)') END AS NameUpdates,
	CASE WHEN DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/AddressUpdates[1]').value('.','nvarchar(max)') = '' THEN '0' ELSE DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/AddressUpdates[1]').value('.','nvarchar(max)') END AS AddressUpdates,
	CASE WHEN DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/BalanceUpdates[1]').value('.','nvarchar(max)') = '' THEN '0' ELSE DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/BalanceUpdates[1]').value('.','nvarchar(max)') END AS BalanceUpdates,
	CASE WHEN DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/LoanUpdates[1]').value('.','nvarchar(max)') = '' THEN '0' ELSE DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/LoanUpdates[1]').value('.','nvarchar(max)') END AS LoanUpdates,
	CASE WHEN DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/LoanBalanceIncreaseUpdates[1]').value('.','nvarchar(max)') = '' THEN '0' ELSE DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/LoanBalanceIncreaseUpdates[1]').value('.','nvarchar(max)') END AS LoanBalanceIncreaseUpdates,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/APRUpdates[1]').value('.','nvarchar(10)') AS APRUpdates,
	DATA.query('./Lender/Lender/CurrentLenderSummaryMatchResult/LoanEffectiveDateUpdates[1]').value('.','nvarchar(10)') AS LoanEffectiveDateUpdates,

	----OptionLenderSummaryMatchResult
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/MinNewLoanPercentage[1]').value('.','decimal') AS OPT_MinNewLoanPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/MaxNewLoanPercentage[1]').value('.','decimal') AS OPT_MaxNewLoanPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/MaxNewCollateralPercentage[1]').value('.','decimal') AS OPT_MaxNewCollateralPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/UnmatchedLoanPercentage[1]').value('.','decimal') AS OPT_UnmatchedLoanPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/UnmatchedCollateralPercentage[1]').value('.','decimal') AS OPT_UnmatchedCollateralPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/ClosedLoanPercentage[1]').value('.','decimal') AS OPT_ClosedLoanPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/NameUpdatePercentage[1]').value('.','decimal') AS OPT_NameUpdatePercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/AddressUpdatePercentage[1]').value('.','decimal') AS OPT_AddressUpdatePercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/LoanUpdatePercentage[1]').value('.','decimal') AS OPT_LoanUpdatePercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/LoanBalanceUpdatePercentage[1]').value('.','decimal') AS OPT_LoanBalanceUpdatePercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/MaxAPRUpdatePercentage[1]').value('.','decimal') AS OPT_MaxAPRUpdatePercentage,
	@WorkItemID AS [WORK_ITEM_ID],		
	ISNULL(@WorkItemDivision, 'All') as [WORK_ITEM_DIVISION_TX],
	'Y' as [FROM_XML_TX]
	FROM [TRANSACTION]
	WHERE DOCUMENT_ID = @DocumentID
	AND PURGE_DT IS NULL and isnull(RELATE_TYPE_CD,'') != 'INFA'
END
ELSE
BEGIN
	--***Calculate counts***
	SELECT @ReportDivisionName = DESCRIPTION_TX FROM REF_CODE WHERE DOMAIN_CD = 'ContractType' and CODE_CD = @DivisionCode

	--Counts for Total DB Loans and Collaterals
	DECLARE @TotalDBLoans AS bigint
	SELECT @TotalDBLoans = COUNT(1) FROM LOAN L WHERE record_type_cd = 'G' and lender_id = @LenderID and (l.DIVISION_CODE_TX = @DivisionCode or @DivisionCode is null)

	DECLARE @TotalDBCollaterals AS bigint
	SELECT @TotalDBCollaterals = COUNT(1) 
	FROM COLLATERAL c JOIN PROPERTY p on c.PROPERTY_ID = p.ID and p.PURGE_DT is null 
	JOIN LOAN l on c.LOAN_ID = l.ID and l.PURGE_DT is null
	WHERE p.RECORD_TYPE_CD = 'G' and p.LENDER_ID = @LenderID 
	AND c.PURGE_DT IS NULL 
	AND (l.DIVISION_CODE_TX = @DivisionCode or @DivisionCode IS NULL)

	--Loan Counts
	SELECT
	@LenderCode AS LenderCode,
	@LenderName AS LenderName,
	SUM(ExtractCount) AS TotalExtractRecords,
	@TotalDBLoans AS TotalDBLoans,
	@TotalDBCollaterals AS TotalDBCollaterals,
	@TotalDBLoans - SUM(MatchedLoans) AS ClosedLoans,
	SUM(NewLoans) AS NewLoans,
	SUM(MatchedLoans) AS MatchedLoans,
	SUM(FirstUnmatchingLoans) AS FirstUnmatchingLoans,
	SUM(SecondUnmatchingLoans) AS SecondUnmatchingLoans,
	SUM(ThirdUnmatchingLoans) AS ThirdUnmatchingLoans,
	SUM(DeletedLoans) AS DeletedLoans,
	SUM(BalanceUpdates) AS BalanceUpdates,
	SUM(APRUpdates) AS APRUpdates,
	SUM(LoanUpdates) AS LoanUpdates,
	SUM(LoanReoccuranceCount) AS LoanReoccuranceCount,
	SUM(LoanBalanceIncreaseUpdates) AS LoanBalanceIncreaseUpdates,
	SUM(LoanEffectiveDateUpdates) AS LoanEffectiveDateUpdates
	INTO #Loan
	FROM
	(SELECT 
		CASE WHEN ((l.LM_MatchStatus_TX = 'New' or l.LM_MatchStatus_TX = 'Match') and (LM_IsDropZeroBalance_IN = 'N' OR @OverrideDrop = 'true')) THEN 1 ELSE 0 END AS ExtractCount,
		CASE WHEN (l.LM_MatchStatus_TX = 'New' and (LM_IsDropZeroBalance_IN = 'N' OR @OverrideDrop = 'true')) THEN 1 ELSE 0 END AS NewLoans,
		CASE WHEN (l.LM_MatchStatus_TX = 'Match'  and (LM_IsDropZeroBalance_IN = 'N' OR @OverrideDrop = 'true') and l.RecordTypeCode_TX = 'G') THEN 1 ELSE 0 END AS MatchedLoans,
		CASE WHEN (((l.LM_MatchStatus_TX = 'Unmatch' and LM_IsDropZeroBalance_IN = 'N') OR (l.LM_MatchStatus_TX = 'Match' and LM_IsDropZeroBalance_IN = 'Y')) and l.LM_ExtractUnmatchCount_NO <= 1 and l.RecordTypeCode_TX = 'G') THEN 1 ELSE 0 END AS FirstUnmatchingLoans,
		CASE WHEN (((l.LM_MatchStatus_TX = 'Unmatch' and LM_IsDropZeroBalance_IN = 'N') OR (l.LM_MatchStatus_TX = 'Match' and LM_IsDropZeroBalance_IN = 'Y')) and l.LM_ExtractUnmatchCount_NO = 2 and l.RecordTypeCode_TX = 'G') THEN 1 ELSE 0 END AS SecondUnmatchingLoans,
		CASE WHEN (((l.LM_MatchStatus_TX = 'Unmatch' and LM_IsDropZeroBalance_IN = 'N') OR (l.LM_MatchStatus_TX = 'Match' and LM_IsDropZeroBalance_IN = 'Y')) and l.LM_ExtractUnmatchCount_NO = 3 and l.RecordTypeCode_TX = 'G') THEN 1 ELSE 0 END AS ThirdUnmatchingLoans,
		CASE WHEN (((l.LM_MatchStatus_TX = 'Unmatch' and LM_IsDropZeroBalance_IN = 'N') OR (l.LM_MatchStatus_TX = 'Match' and LM_IsDropZeroBalance_IN = 'Y')) and l.LM_ExtractUnmatchCount_NO > 3 and l.RecordTypeCode_TX = 'G') THEN 1 ELSE 0 END AS DeletedLoans,
		CASE WHEN (l.LM_BalanceDecrease_IN = 'Y' or l.LM_BalanceIncrease_IN = 'Y') THEN 1 ELSE 0 END AS BalanceUpdates,
		CASE WHEN (l.LM_APRChanged_IN = 'Y') THEN 1 ELSE 0 END AS APRUpdates,
		CASE WHEN (l.LM_LoanChanged_IN = 'Y') THEN 1 ELSE 0 END AS LoanUpdates,
		CASE WHEN (l.LM_ReOccurance_IN = 'Y') THEN 1 ELSE 0 END AS LoanReoccuranceCount,
		CASE WHEN (l.LM_BalanceIncrease_IN = 'Y') THEN 1 ELSE 0 END AS LoanBalanceIncreaseUpdates,
		CASE WHEN (l.LM_EffectiveDateChanged_IN = 'Y') THEN 1 ELSE 0 END AS LoanEffectiveDateUpdates
		FROM LOAN_EXTRACT_TRANSACTION_DETAIL l 
		LEFT JOIN LOAN LN ON LN.ID = l.LM_MatchLoanId_TX and LN.PURGE_DT IS NULL
		WHERE l.TRANSACTION_ID = @TransactionId 
		AND (l.DivisionCode_TX = @DivisionCode or ln.DIVISION_CODE_TX = @DivisionCode or @DivisionCode IS NULL)
	) t

	--Collateral Counts
	SELECT
	SUM(TotalCollateral) AS TotalCollaterals,
	SUM(NewCollateral) AS NewCollaterals,
	SUM(FirstUnmatchingCollateral) AS FirstUnmatchingCollaterals,
	SUM(SecondUnmatchingCollateral) AS SecondUnmatchingCollaterals,
	SUM(ThirdUnmatchingCollateral) AS ThirdUnmatchingCollaterals,
	SUM(DeletedCollaterals) AS DeletedCollaterals,
	SUM(CollateralDescriptionUpdates) AS CollateralDescriptionUpdates,
	SUM(CPIInplaceCount) AS CPIInplaceCount,
	SUM(BadDataCount) AS BadDataCount
	INTO #Collateral
	FROM
	(SELECT 
		1 AS TotalCollateral,
		CASE WHEN (c.CM_MatchStatus_TX = 'New' and (l.LM_MatchStatus_TX = 'Match' and c.Retain_IN = 'N') and (LM_IsDropZeroBalance_IN = 'N' OR @OverrideDrop = 'true')) THEN 1 ELSE 0 END AS NewCollateral,
		CASE WHEN (C.CM_MatchStatus_TX = 'Unmatch' and c.PropertyRecordType_TX = 'G' and c.CM_ExtractUnmatchCount_NO = 1) THEN 1 ELSE 0 END AS FirstUnmatchingCollateral,
		CASE WHEN (C.CM_MatchStatus_TX = 'Unmatch' and c.PropertyRecordType_TX = 'G' and c.CM_ExtractUnmatchCount_NO = 2) THEN 1 ELSE 0 END AS SecondUnmatchingCollateral,
		CASE WHEN (C.CM_MatchStatus_TX = 'Unmatch' and c.PropertyRecordType_TX = 'G' and c.CM_ExtractUnmatchCount_NO = 3) THEN 1 ELSE 0 END AS ThirdUnmatchingCollateral,
		CASE WHEN (C.CM_MatchStatus_TX = 'Unmatch' and c.PropertyRecordType_TX = 'G' and c.CM_ExtractUnmatchCount_NO > 3) THEN 1 ELSE 0 END AS DeletedCollaterals,
		CASE WHEN C.CM_MatchStatus_TX = 'Match' and c.PropertyRecordType_TX = 'G' and c.CM_DescriptionChanged_IN = 'Y' THEN 1 ELSE 0 END AS CollateralDescriptionUpdates,
		CASE WHEN C.CM_MatchStatus_TX = 'Match' and c.PropertyRecordType_TX = 'G' and l.LM_CPIInplace_IN = 'Y' and (LM_IsDropZeroBalance_IN = 'N' OR @OverrideDrop = 'true') THEN 1 ELSE 0 END AS CPIInplaceCount,
		CASE WHEN c.BadData_IN = 'Y' THEN 1 ELSE 0 END AS BadDataCount
		FROM LOAN_EXTRACT_TRANSACTION_DETAIL l 
		JOIN [COLLATERAL_EXTRACT_TRANSACTION_DETAIL] C ON C.TRANSACTION_ID = L.TRANSACTION_ID 
															  AND C.SEQUENCE_ID = L.SEQUENCE_ID 
															  AND C.PURGE_DT IS NULL
		JOIN LOAN LN ON LN.ID = l.LM_MatchLoanId_TX and LN.PURGE_DT IS NULL
		WHERE l.TRANSACTION_ID = @TransactionId 	
		AND (l.DivisionCode_TX = @DivisionCode or ln.DIVISION_CODE_TX = @DivisionCode or @DivisionCode IS NULL)	
	) t

	--Customer counts
	SELECT
	SUM(NameUpdates) AS NameUpdates,
	SUM(AddressUpdates) AS AddressUpdates
	INTO #Customer
	FROM
	(SELECT 
		CASE WHEN (o.CM_NameChanged_IN = 'Y' and (LM_IsDropZeroBalance_IN = 'N' OR @OverrideDrop = 'true')) THEN 1 ELSE 0 END AS NameUpdates,
		CASE WHEN (o.CM_AddressChanged_IN = 'Y' and (LM_IsDropZeroBalance_IN = 'N' OR @OverrideDrop = 'true')) THEN 1 ELSE 0 END AS AddressUpdates
		FROM LOAN_EXTRACT_TRANSACTION_DETAIL l 
		JOIN [OWNER_EXTRACT_TRANSACTION_DETAIL] O ON O.TRANSACTION_ID = L.TRANSACTION_ID 
														 AND O.SEQUENCE_ID = L.SEQUENCE_ID 
														 AND O.PURGE_DT IS NULL
		WHERE l.TRANSACTION_ID = @TransactionId
		AND (l.DivisionCode_TX = @DivisionCode or @DivisionCode IS NULL)
	) t

	--OPT counts
	SELECT
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/MinNewLoanPercentage[1]').value('.','decimal') AS OPT_MinNewLoanPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/MaxNewLoanPercentage[1]').value('.','decimal') AS OPT_MaxNewLoanPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/MaxNewCollateralPercentage[1]').value('.','decimal') AS OPT_MaxNewCollateralPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/UnmatchedLoanPercentage[1]').value('.','decimal') AS OPT_UnmatchedLoanPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/UnmatchedCollateralPercentage[1]').value('.','decimal') AS OPT_UnmatchedCollateralPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/ClosedLoanPercentage[1]').value('.','decimal') AS OPT_ClosedLoanPercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/NameUpdatePercentage[1]').value('.','decimal') AS OPT_NameUpdatePercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/AddressUpdatePercentage[1]').value('.','decimal') AS OPT_AddressUpdatePercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/LoanUpdatePercentage[1]').value('.','decimal') AS OPT_LoanUpdatePercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/LoanBalanceUpdatePercentage[1]').value('.','decimal') AS OPT_LoanBalanceUpdatePercentage,
	DATA.query('./Lender/Lender/OptionLenderSummaryMatchResult/MaxAPRUpdatePercentage[1]').value('.','decimal') AS OPT_MaxAPRUpdatePercentage,
	@WorkItemID AS [WORK_ITEM_ID],		
	COALESCE(@ReportDivisionName,@WorkItemDivision, 'All') as [WORK_ITEM_DIVISION_TX] 
	INTO #TransactionXML
	FROM [TRANSACTION]
	WHERE ID = @TransactionId
	AND PURGE_DT IS NULL and isnull(RELATE_TYPE_CD,'') != 'INFA'

	--Results table
	INSERT INTO #tmpTable (
	LenderCode,LenderName,TotalExtractRecords,TotalDBLoans,TotalDBCollaterals,TotalCollaterals,
	NewLoans,NewCollaterals,MatchedLoans,ClosedLoans, FirstUnmatchingLoans,
	SecondUnmatchingLoans, ThirdUnmatchingLoans,DeletedLoans,
	--Collaterals
	FirstUnmatchingCollaterals,SecondUnmatchingCollaterals,ThirdUnmatchingCollaterals,DeletedCollaterals,LoanReoccuranceCount,
	CollateralDescriptionUpdates,CPIInplaceCount,BadDataCount,NameUpdates,AddressUpdates,BalanceUpdates,
	LoanUpdates,LoanBalanceIncreaseUpdates,APRUpdates,LoanEffectiveDateUpdates,
	--OPTs
	OPT_MinNewLoanPercentage,OPT_MaxNewLoanPercentage,OPT_MaxNewCollateralPercentage,OPT_UnmatchedLoanPercentage,
	OPT_UnmatchedCollateralPercentage,OPT_ClosedLoanPercentage,OPT_NameUpdatePercentage,OPT_AddressUpdatePercentage,
	OPT_LoanUpdatePercentage,OPT_LoanBalanceUpdatePercentage,OPT_MaxAPRUpdatePercentage,WORK_ITEM_ID,WORK_ITEM_DIVISION_TX, FROM_XML_TX
	)
	SELECT l.LenderCode, l.LenderName, l.TotalExtractRecords, l.TotalDBLoans, l.TotalDBCollaterals, c.TotalCollaterals,
	l.NewLoans, c.NewCollaterals, l.MatchedLoans, l.ClosedLoans, l.FirstUnmatchingLoans,
	l.SecondUnmatchingLoans, l.ThirdUnmatchingLoans, l.DeletedLoans, 
	--Collaterals
	c.FirstUnmatchingCollaterals, c.SecondUnmatchingCollaterals, c.ThirdUnmatchingCollaterals, c.DeletedCollaterals, l.LoanReoccuranceCount, 
	c.CollateralDescriptionUpdates, c.CPIInplaceCount, c.BadDataCount, cu.NameUpdates, cu.AddressUpdates, l.BalanceUpdates,
	l.LoanUpdates, l.LoanBalanceIncreaseUpdates, l.APRUpdates, l.LoanEffectiveDateUpdates, 
	--OPTs
	t.OPT_MinNewLoanPercentage, t.OPT_MaxNewLoanPercentage, t.OPT_MaxNewCollateralPercentage, t.OPT_UnmatchedLoanPercentage,
	t.OPT_UnmatchedCollateralPercentage, t.OPT_ClosedLoanPercentage, t.OPT_NameUpdatePercentage, t.OPT_AddressUpdatePercentage,
	t.OPT_LoanUpdatePercentage, t.OPT_LoanBalanceUpdatePercentage, t.OPT_MaxAPRUpdatePercentage, t.WORK_ITEM_ID, t.WORK_ITEM_DIVISION_TX, 'N'
	FROM #Loan l, 
	#Collateral c, 
	#Customer cu, 
	#TransactionXML t
END

SELECT * FROM #tmpTable

END

GO

