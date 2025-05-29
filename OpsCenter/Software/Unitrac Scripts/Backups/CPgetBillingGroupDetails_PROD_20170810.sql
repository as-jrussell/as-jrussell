USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[CPGetBillingGroupDetails]    Script Date: 8/10/2017 6:46:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CPGetBillingGroupDetails]
(
	@id   bigint = null
	,@Skip bigint = 0
	,@Take bigint = 0
    ,@ReturnRefunds bigint = 0
	,@OnlyNewFTA bigint = 0
	,@LenderRoleOnly bigint = 1
	,@ShowAllTransactions bigint = 0
)
AS
BEGIN
--CPGetBillingGroupDetails 655470, 0, 0, 0, 0, 1
--DECLARE @id BIGINT = 655470 --635055 --351108 --(WI 655470 -2,709) 351107 --(WI 655469 - 55) --351108 --(WU 655470 - 2,709) --351105 --(WI 655460 - 2) 351108 --(WU 655470) 
--DECLARE @Skip Int = 0
--DECLARE @Take Int = 0
--DECLARE @ReturnRefunds int = 2		--0 = return negative, 1 = return non zero (pos and neg), 2 = return only positive
--DECLARE @OnlyNewFTA int = 0
--DECLARE @LenderRoleOnly int = 0

DECLARE @vid BIGINT  
DECLARE @vSkip Int 
DECLARE @vTake Int 
DECLARE @vReturnRefunds int
DECLARE @vOnlyNewFTA  int
DECLARE @vLenderRoleOnly int
DECLARE @vShowAllTransactions int 


-- a sample (wid 655470 with 2,709 fpc took 3 min to process until I changed the query to use
-- DECALRE variables instead of the paramater references. Now it takes 27 seconds
SELECT @vid = @id, @vSkip = @Skip, @vTake = @Take, @vReturnRefunds = @ReturnRefunds, @vOnlyNewFTA = @OnlyNewFTA, @vLenderRoleOnly = @LenderRoleOnly, @vShowAllTransactions = @ShowAllTransactions


SET NOCOUNT ON
SELECT @vid = RELATE_ID FROM WORK_ITEM WHERE ID = @vid

DECLARE @FPC_COUNT bigint = 0
DECLARE @FPC_WITH_LENDER_INTENT bigint = 0

DECLARE @TEMPVAR TABLE 
(
	[ROW_NUMBER] [bigint] NOT NULL primary key,
	[FPC_ID] [bigint] NOT NULL,
	[BillingGroupId] [bigint] NOT NULL,
	[RelateClassName] [varchar](max) NULL,
	[RelateClassId] [bigint] NOT NULL,
	[LoanId] [bigint] NOT NULL,
	[RequiredCoverageId] [bigint] NOT NULL,
	[Certificate] [nvarchar](max) NULL,
	[LoanNumber] [nvarchar](max) NULL,
	[CollateralNumber] [int] NULL,
	[AssetNumber] [nvarchar](max) NULL,
	[OwnerName] [nvarchar](max) NULL,
	[PolicyEffectiveDate] [datetime2](7) NULL,
	[CPIPolicyExpCxlDate] [datetime2](7) NULL,
	[EarnedIssueAmount] [decimal](38, 2) NULL,
	[TotalAmount] [decimal](38, 2) NULL,
	[Branch] [nvarchar](max) NULL,
	[Division] [nvarchar](max) NULL,
	[LenderIntent] [varchar](max) NULL,
	[LenderResponse] [nvarchar](max) NULL,
	[LenderStartDate] [nvarchar](max) NULL,
	[LenderComment] [nvarchar](max) NULL,
	[FT_TXN_DT] [datetime2](7) NULL,
	[Hold] [int] NULL,
	COLLATERAL_CODE_ID bigint null,
	PROPERTY_ID bigint null,
	CPI_QUOTE_ID bigint null
	,DelayedBilling int null
	,ForcedPlcyOptReportNonPayDays int null
	,CAPTURED_DATA_XML XML null
	,ISSUE_DT datetime2 null
) 

-- First get just the primary rows based upon search conditions and key join conditions
-- store into table variable
INSERT INTO @TEMPVAR
select 	
	ROW_NUMBER() OVER (ORDER BY TBL.OWNER_NAME, FPC.ID) AS [ROW_NUMBER]
	,FPC.ID AS FPC_ID
	,BG.ID AS BillingGroupId
	,'Allied.UniTrac.ForcePlacedCertificate' AS RelateClassName
	,FPC.ID AS RelateClassId
	,LN.ID LoanId
	,RC.ID AS RequiredCoverageId
	,FPC.NUMBER_TX AS [Certificate]
	,LN.NUMBER_TX AS LoanNumber
	,COL.COLLATERAL_NUMBER_NO AS CollateralNumber
	,COL.ASSET_NUMBER_TX as AssetNumber
	,TBL.OWNER_NAME AS OwnerName
	,FPC.EFFECTIVE_DT PolicyEffectiveDate
	,isnull(FPC.CANCELLATION_DT,FPC.EXPIRATION_DT) as CPIPolicyExpCxlDate
	,FT.EE_AMOUNT_NO AS EarnedIssueAmount
	,FT.TXN_AMOUNT_NO AS TotalAmount
	,LN.BRANCH_CODE_TX AS Branch
	,LN.DIVISION_CODE_TX AS Division
	,FPC.LenderIntent
	,FPC.LenderResponse
	,FPC.LenderStartDate
    ,FPC.LenderComment
    ,FT.TXN_DT AS FT_TXN_DT
	,CASE WHEN FT.HOLD_CNT > 0 THEN 1 ELSE 0 END AS Hold
	,COL.COLLATERAL_CODE_ID
	,RC.PROPERTY_ID
	,FPC.CPI_QUOTE_ID
	,RC.DelayedBilling
	,RC.ForcedPlcyOptReportNonPayDays
	,FPC.CAPTURED_DATA_XML
	,FPC.ISSUE_DT
FROM BILLING_GROUP BG
CROSS APPLY
(SELECT DISTINCT FTX.FPC_ID AS FPC_ID, MAX(FTX.TXN_DT) AS TXN_DT,  SUM(CASE WHEN FTX.TXN_TYPE_CD <> 'P' THEN FTX.AMOUNT_NO ELSE 0 END) AS EE_AMOUNT_NO,  SUM(FTX.AMOUNT_NO) AS TXN_AMOUNT_NO, SUM(CASE WHEN ISNULL(FTA.HOLD_IN,'N') = 'Y' THEN 1 ELSE 0 END) AS HOLD_CNT
FROM FINANCIAL_TXN_APPLY FTA
JOIN FINANCIAL_TXN FTX ON FTX.ID = FTA.FINANCIAL_TXN_ID AND FTX.PURGE_DT IS NULL
WHERE FTA.PURGE_DT IS NULL AND FTA.BILLING_GROUP_ID = BG.ID
AND ((FTA.NEW_TXN_IN = 'Y' AND @vOnlyNewFTA = 1) OR @vOnlyNewFTA = 0)
GROUP BY FTX.FPC_ID
having ((ISNULL(SUM(FTX.AMOUNT_NO),0) < 0 AND @vReturnRefunds = 0) OR (ISNULL(SUM(FTX.AMOUNT_NO),0) <> 0 AND @vReturnRefunds = 1) OR (ISNULL(SUM(FTX.AMOUNT_NO),0) > 0 AND @vReturnRefunds = 2))
) AS FT
JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = FT.FPC_ID AND FPCRCR.PURGE_DT IS NULL
JOIN REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
JOIN (SELECT fpcv.Id, fpcv.PURGE_DT, fpcv.LENDER_INTENT [LenderIntent], r.CODE_CD AS [LenderResponse]  
			,fpcv.NUMBER_TX, fpcv.EFFECTIVE_DT, fpcv.CANCELLATION_DT,fpcv.EXPIRATION_DT, fpcv.CAPTURED_DATA_XML, fpcv.LENDER_INTENT, fpcv.CPI_QUOTE_ID, fpcv.ISSUE_DT,		
	CASE 
		WHEN CHARINDEX(',', fpcv.LENDER_INTENT) > 0 THEN RIGHT(fpcv.LENDER_INTENT, (LEN(fpcv.LENDER_INTENT) - CHARINDEX(',', fpcv.LENDER_INTENT) - 1)) 
		ELSE fpcv.LENDER_INTENT
	END [LenderComment],
	CASE 
		WHEN ISDATE(RIGHT(fpcv.LENDER_INTENT, LEN(fpcv.LENDER_INTENT) - CHARINDEX(',', fpcv.LENDER_INTENT))) = 1  AND CHARINDEX(',', fpcv.LENDER_INTENT) > 0
				THEN RIGHT(fpcv.LENDER_INTENT, LEN(fpcv.LENDER_INTENT) - CHARINDEX(',', fpcv.LENDER_INTENT))
		ELSE null
	END AS [LenderStartDate]
	,fpcv.LOAN_ID		
	FROM FORCE_PLACED_CERTIFICATE fpcv 
	LEFT JOIN REF_CODE r ON DESCRIPTION_TX = 
		CASE 
			WHEN CHARINDEX(',', fpcv.LENDER_INTENT) > 0 THEN LEFT(fpcv.LENDER_INTENT, CHARINDEX(',', fpcv.LENDER_INTENT) - 1) 
			ELSE fpcv.LENDER_INTENT
		END
		AND DOMAIN_CD ='BillingGroupLenderIntent' AND fpcv.PURGE_DT IS NULL) FPC ON FPC.ID = FT.FPC_ID AND FPC.PURGE_DT IS NULL
JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.LOAN_ID = FPC.LOAN_ID AND COL.PURGE_DT IS NULL
JOIN LOAN LN ON LN.ID = COL.LOAN_ID AND LN.PURGE_DT IS NULL
CROSS APPLY (
	SELECT LAST_NAME_TX + ', ' + isnull(FIRST_NAME_TX,'') /*+ '|'*/
	FROM [OWNER] OWN
	JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = LN.ID
		AND OWN.ID = OLR.OWNER_ID
		and olr.PRIMARY_IN = 'Y'
	FOR XML PATH('')
	) TBL(OWNER_NAME)
--JOIN PROPERTY PR ON PR.ID = RC.PROPERTY_ID AND PR.PURGE_DT IS NULL
WHERE BG.ID = @vid AND BG.PURGE_DT IS NULL 

--AND ((ISNULL(FT.TXN_AMOUNT_NO,0) < 0 AND @vReturnRefunds = 0) OR (ISNULL(FT.TXN_AMOUNT_NO,0) <> 0 AND @vReturnRefunds = 1) OR (ISNULL(FT.TXN_AMOUNT_NO,0) > 0 AND @vReturnRefunds = 2))

-- Get the total row counts
SELECT 
@FPC_COUNT = COUNT(*)
,@FPC_WITH_LENDER_INTENT = SUM(CASE WHEN ISNULL(tmp.LenderResponse,'') <> '' THEN 1 ELSE 0 END)
FROM @TEMPVAR tmp

-- Now, get the additional information to be included in the final result
--  only getting it for the rows to be returned (if @Skip and @Take are both not 0)
SELECT tmp.[ROW_NUMBER]
	,tmp.FPC_ID
	,tmp.BillingGroupId
	,WI.ID AS WorkItemId
	,tmp.RelateClassName
	,tmp.RelateClassId
	,tmp.LoanId
	,PR.ID AS PropertyId
	,tmp.RequiredCoverageId
	,tmp.[Certificate]
	,tmp.LoanNumber
	,tmp.CollateralNumber
	,tmp.AssetNumber
	,tmp.OwnerName
   ,CASE 
      WHEN @vShowAllTransactions = 1 THEN ISNULL(FTX.IS_PREV_BILL_FILE_BY_TERM,0) 
      ELSE ISNULL(TBL2.IS_PREV_BILL_FILE,0) 
    END as OnPreviousBillFile
	,ISNULL(FTX.TERM_NO,-1) as PreviousTermNo
	,CASE 
		WHEN RCA.VALUE_TX IN ('VEH', 'BOAT') OR (RCA.VALUE_TX = 'MH' AND ISNULL(PR.ADDRESS_ID,0) = 0)
			THEN ISNULL(PR.YEAR_TX, '') + ' ' + ISNULL(PR.MAKE_TX, '') + ' ' + ISNULL(PR.MODEL_TX, '')
		WHEN ISNULL(PR.DESCRIPTION_TX, '') <> ''
			THEN PR.DESCRIPTION_TX
		ELSE ''
		END AS [Description]
	,PR.VIN_TX AS VIN
	,CPIQ.BASIS_NO AS Basis
	,tmp.PolicyEffectiveDate
	,tmp.CPIPolicyExpCxlDate
	,CPIQ.TERM_NO AS Term
	,CPIA.REASON_CD AS IssueCancelCode
	,REF.DESCRIPTION_TX AS IssueReason
	--,(SELECT SUM(AMOUNT_NO) FROM FINANCIAL_TXN WHERE TXN_TYPE_CD <> 'P' AND FINANCIAL_TXN.FPC_ID = FPC.ID AND FINANCIAL_TXN.PURGE_DT is null) AS EarnedIssueAmount
	,tmp.EarnedIssueAmount
	,(CASE WHEN @vShowAllTransactions = 1 THEN ISNULL(FTX.AMOUNT_NO,0) ELSE tmp.TotalAmount END) AS TotalAmount
	,tmp.TotalAmount AS TotalNetAmountFPC
	--,IsNull(ForcedPlcyOptReportNonPayDays,0) AS BillDueDays
	,CASE 
		WHEN @ShowAllTransactions = 1 THEN 
				CASE WHEN FTX.amount_no > 0 AND DATEDIFF(d, ftx.STATEMENT_DT, GETDATE()) > IsNull(ForcedPlcyOptReportNonPayDays,0) THEN CAST(ISNULL(DATEDIFF(d, ftx.STATEMENT_DT, GETDATE()),0) as nvarchar(20)) + ' *' 
				ELSE '' END
		WHEN ISNULL(BG_SD.PAST_DUE_DAYS,0) > IsNull(ForcedPlcyOptReportNonPayDays,0)
			THEN CAST(ISNULL(BG_SD.PAST_DUE_DAYS,0) AS nvarchar(20)) + ' *'
		ELSE CAST(ISNULL(BG_SD.PAST_DUE_DAYS,0) AS nvarchar(20))
		END AS PastDue
	,tmp.Branch
	,tmp.Division
	,CC.SECONDARY_CLASS_CD AS PropertyType
	,IsNull(CAPTURED_DATA_XML.value('(//CapturedData/Property/Address/@Line1)[1]', 'varchar(800)'), '') AS Line1
	,IsNull(CAPTURED_DATA_XML.value('(//CapturedData/Property/Address/@Line2)[1]', 'varchar(800)'), '') AS Line2
	,IsNull(CAPTURED_DATA_XML.value('(//CapturedData/Property/Address/@City)[1]', 'varchar(800)'), '') AS City
	,IsNull(CAPTURED_DATA_XML.value('(//CapturedData/Property/Address/@State)[1]', 'varchar(800)'), '') AS [STATE]
	,IsNull(CAPTURED_DATA_XML.value('(//CapturedData/Property/Address/@PostalCode)[1]', 'varchar(800)'), '') AS PostalCode
	,IsNull(CAPTURED_DATA_XML.value('(//CapturedData/Property/Address/@Country)[1]', 'varchar(800)'), '') AS Country
	,CASE WHEN FTX.ftx_id IS NULL THEN tmp.LenderIntent ELSE FTX.LENDER_INTENT_TX END as LenderIntent
	,FTX.TERM_NO AS BillCycle
	,tmp.LenderResponse 
	,tmp.LenderStartDate
	,LI.LENDER_END_DATE_TX AS [LenderEndDate]
    ,tmp.LenderComment
	,CASE WHEN DATEDIFF(mi,LI.UPDATE_DT,GETDATE()) > 60 THEN NULL ELSE CHECKED_OUT_OWNER_SUB_TX END AS CheckedOutUser
	,tmp.FT_TXN_DT
   ,CASE WHEN FTX.term_no > 0 THEN FTX.IsHold ELSE tmp.Hold END AS Hold
	,OBC_IH.Resolution AS Resolution
	,OBC_IH.CallAttempts as CallAttempts
	,OBC_IH.Action AS [Action]

,@FPC_COUNT AS TotalRelates, @FPC_WITH_LENDER_INTENT AS TotalCompleteRelates
FROM @TEMPVAR tmp
JOIN PROPERTY PR ON PR.ID = tmp.PROPERTY_ID AND PR.PURGE_DT IS NULL
LEFT JOIN COLLATERAL_CODE CC ON tmp.COLLATERAL_CODE_ID = CC.ID
JOIN CPI_QUOTE CPIQ ON tmp.CPI_QUOTE_ID = CPIQ.ID AND CPIQ.PURGE_DT IS NULL
LEFT JOIN CPI_ACTIVITY CPIA ON CPIA.ID = (SELECT TOP 1 ID FROM CPI_ACTIVITY WHERE CPIQ.ID = CPI_QUOTE_ID and PURGE_DT IS NULL ORDER BY ISSUE_DT DESC)
LEFT JOIN REF_CODE REF ON REF.DOMAIN_CD = 'CPIActivityIssueReason' and REF.CODE_CD = CPIA.REASON_CD
LEFT JOIN REF_CODE_ATTRIBUTE RCA ON RCA.REF_CD = CC.SECONDARY_CLASS_CD
	AND RCA.DOMAIN_CD = 'SecondaryClassification' AND RCA.ATTRIBUTE_CD = 'PropertyType'
--The following outer apply takes the FPC ID and looks to see if it was related to any other Billing Work Item
-- where the BWI generated a Billing File and the FPC was not marked as being held from the Billing file (Financial Txn Apply HOLD_IN). 
--It returns a 0 if none are found and a 1 if any number other than 0.
OUTER APPLY
	(	select case when exists (select *				  
		from FINANCIAL_TXN_APPLY fta
		inner join FINANCIAL_TXN ftn on ftn.ID = fta.FINANCIAL_TXN_ID 
				and ftn.PURGE_DT is null 
				and ftn.FPC_ID = tmp.FPC_ID
		inner join WORK_ITEM wi on wi.RELATE_ID = fta.BILLING_GROUP_ID 
				and wi.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup' 
				and wi.PARENT_ID is null
				and 
				((wi.CONTENT_XML.value ('(//Content//Message//MessageId)[1]', 'varchar(50)') is not null) or
				(wi.CONTENT_XML.value ('(//Content//Message//ChargeMessageId)[1]', 'varchar(50)') is not null) or
				(wi.CONTENT_XML.value ('(//Content//Message//RefundMessageId)[1]', 'varchar(50)') is not null))
		where fta.HOLD_IN = 'N'
				and fta.BILLING_GROUP_ID != tmp.BillingGroupId
				and fta.PURGE_DT is null
				)  then 1 else 0 end 
	   ) TBL2 (IS_PREV_BILL_FILE)

OUTER APPLY (
SELECT PAST_DUE_DAYS, STATEMENT_DT
FROM dbo.GetPastDueDaysDaysAndDate(tmp.FPC_ID,tmp.DelayedBilling, 
									tmp.ForcedPlcyOptReportNonPayDays)
) BG_SD
/*
need CROSS APPLY TOP 1 because of multple Work Items for billing group
SELECT * FROM WORK_ITEM WHERE ID IN(655470,655454)			--QA3
*/
CROSS APPLY (
	SELECT TOP 1 WI1.ID, WI1.CONTENT_XML, WI1.UPDATE_DT
	FROM WORK_ITEM WI1
	WHERE WI1.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup'
		AND WI1.RELATE_ID = tmp.BillingGroupID
		AND ISNULL(WI1.PARENT_ID, 0) = 0
		AND ((WI1.USER_ROLE_CD = 'LENDER' AND @vLenderRoleOnly = 1) OR @vLenderRoleOnly =  0)
		AND WI1.PURGE_DT IS NULL
		AND ISNULL(WI1.CONTENT_XML.value('(./Content/IsRefundWorkitem)[1]', 'nvarchar(20)'), 'False') <> 'True'
		--AND CONTENT_XML.exist('//Content/BillingGroup') = 1
		ORDER BY WI1.ID DESC
	) WI
	
OUTER APPLY
	(select top 1 ih2.ID as IH2Id,
		isnull(ih2.SPECIAL_HANDLING_XML.value ('(//SH//CallAttempts)[1]', 'varchar(50)'), '0') as CallAttempts,
		ih2.SPECIAL_HANDLING_XML.value ('(//SH//Resolution)[1]', 'varchar(50)') as Resolution,
		ih2.SPECIAL_HANDLING_XML.value ('(//SH//Action)[1]', 'varchar(50)') as Action
		from INTERACTION_HISTORY ih2 
		where ih2.PROPERTY_ID = PR.ID
		and IH2.TYPE_CD = 'VRFCTNEVT' 
		and ih2.SPECIAL_HANDLING_XML.value ('(//SH//ReasonCode)[1]', 'varchar(50)') = 'PROA'
		order by ih2.ID desc
	) as OBC_IH
LEFT JOIN LENDER_INTENT LI ON WI.ID = LI.WORK_ITEM_ID AND tmp.fpc_ID = LI.FPC_ID AND LI.PURGE_DT IS NULL
OUTER APPLY
	(
				   SELECT f.*, BG.STATEMENT_DT, fta.LENDER_INTENT_TX, TBL2.IS_PREV_BILL_FILE_BY_TERM, TBL3.IsHold
				   FROM dbo.fn_GetOutstandingFinancialTxns(tmp.FPC_ID, @vid) f
				   JOIN FINANCIAL_TXN ft on f.ftx_id = ft.ID and ft.PURGE_DT IS NULL
				   JOIN FINANCIAL_TXN_APPLY fta on ft.ID = fta.FINANCIAL_TXN_ID and fta.PURGE_DT is null and fta.NEW_TXN_IN = 'Y'
				   JOIN BILLING_GROUP BG ON FTA.BILLING_GROUP_ID = BG.ID AND BG.PURGE_DT IS NULL
               
               -- Since this is an all transactions lookup, the system needs to   
               -- check the FPC by TERM to see if any items were on previous bills
               OUTER APPLY
	               (	select case when exists (select *				  
		               from FINANCIAL_TXN_APPLY fta
		               inner join FINANCIAL_TXN ftn on ftn.ID = fta.FINANCIAL_TXN_ID 
				               and ftn.PURGE_DT is null 
				               and ftn.FPC_ID = tmp.FPC_ID
                           and ftn.TERM_NO = ft.TERM_NO
		               inner join WORK_ITEM wi on wi.RELATE_ID = fta.BILLING_GROUP_ID 
				               and wi.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup' 
				               and wi.PARENT_ID is null
				               and 
				               ((wi.CONTENT_XML.value ('(//Content//Message//MessageId)[1]', 'varchar(50)') is not null) or
				               (wi.CONTENT_XML.value ('(//Content//Message//ChargeMessageId)[1]', 'varchar(50)') is not null) or
				               (wi.CONTENT_XML.value ('(//Content//Message//RefundMessageId)[1]', 'varchar(50)') is not null))
		               where fta.HOLD_IN = 'N'
				               and fta.BILLING_GROUP_ID != tmp.BillingGroupId
				               and fta.PURGE_DT is null
				               )  then 1 else 0 end 
	                  ) TBL2 (IS_PREV_BILL_FILE_BY_TERM)

               -- Look at all of the financial transactions for each fpc
               -- and billing group by term and determine "on hold" states
               OUTER APPLY
               (
                  SELECT   CASE WHEN ISNULL(HOLD_IN, 'N') = 'Y' THEN 1 ELSE 0 END AS IsHold
                  FROM     FINANCIAL_TXN FTXH
                           INNER JOIN FINANCIAL_TXN_APPLY FTAH
                              ON FTXH.ID = FTAH.FINANCIAL_TXN_ID AND FTAH.PURGE_DT IS NULL
                  WHERE    BILLING_GROUP_ID = tmp.BillingGroupId
                           AND FTXH.FPC_ID = tmp.FPC_ID
                           AND FTXH.TERM_NO = f.term_no
                           AND FTXH.PURGE_DT IS NULL
               ) TBL3

				   WHERE @vShowAllTransactions = 1
	) FTX
				
WHERE 1=1
AND ((tmp.[ROW_NUMBER] BETWEEN @vSkip + 1 AND @vSkip + @vTake AND @vTake > 0) OR @vTake = 0)
ORDER BY tmp.OwnerName, tmp.RelateClassId, tmp.FT_TXN_DT


END


GO

