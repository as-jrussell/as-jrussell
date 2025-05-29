USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetBillingFileDetails]    Script Date: 10/5/2017 4:39:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetBillingFileDetails]
(
  @billingGroupId bigint
)
AS
BEGIN
	
	SET NOCOUNT ON

    DECLARE @DEF_ID AS BIGINT	
	SELECT @DEF_ID = ID from RELATED_DATA_DEF WHERE NAME_TX = 'Misc2'
   
   -- Drop Temporary Tables
   if OBJECT_ID('tempdb..#t1') is not null
      drop table #t1
      
	SELECT
	--TRANSACTION
	BG.ID BG_ID,
	FPC.ID FPC_ID, FT.ID FT_ID,
	FT.TXN_TYPE_CD, FT.TXN_DT,
	FT.AMOUNT_NO BILLED_AMOUNT_NO,
	FTA.ID FTA_ID, FTA.HOLD_IN,
	FTA.NEW_TXN_IN,
	--- LOAN
	LN.NUMBER_TX as LOAN_NUMBER_TX ,
   ISNULL(LN.LENDER_BRANCH_CODE_TX,'') AS BRANCH_CODE_TX,
   ISNULL(LN.OFFICER_CODE_TX,'') AS LOAN_OFFICER_CODE_TX,
	---COLLATERAL
	CL.COLLATERAL_NUMBER_NO ,
	ISNULL(CL.ASSET_NUMBER_TX,'') AS ASSET_NUMBER_TX,
	--- OWNER
	ISNULL(O.LAST_NAME_TX,'') AS LAST_NAME_TX,
	ISNULL(O.FIRST_NAME_TX,'') AS FIRST_NAME_TX,
	ISNULL(O.MIDDLE_INITIAL_TX,'') AS  MIDDLE_INITIAL_TX,
	-- OWNER ADDR
	ISNULL(OA.LINE_1_TX,'') AS  OWNER_LINE1_TX,
	ISNULL(OA.LINE_2_TX,'') AS  OWNER_LINE2_TX,
	ISNULL(OA.CITY_TX,'') AS OWNER_CITY_TX ,
	ISNULL(OA.STATE_PROV_TX,'') AS OWNER_STATE_TX ,
	ISNULL(OA.POSTAL_CODE_TX,'') AS OWNER_POSTAL_CODE_TX,
	--- PROPERTY
	ISNULL(P.YEAR_TX,'') AS YEAR_TX,
	ISNULL(P.MAKE_TX,'') AS MAKE_TX,
	ISNULL(P.MODEL_TX,'') AS MODEL_TX,
   ISNULL(P.BODY_TX,'') AS BODY_TX,
	ISNULL(P.VIN_TX,'') AS VIN_TX,

	ISNULL(PA.LINE_1_TX,'') AS  PROP_LINE1_TX,
	ISNULL(PA.LINE_2_TX,'') AS  PROP_LINE2_TX,
	ISNULL(PA.CITY_TX,'') AS PROP_CITY_TX ,
	ISNULL(PA.STATE_PROV_TX,'') AS PROP_STATE_TX ,
	ISNULL(PA.POSTAL_CODE_TX,'') AS PROP_POSTAL_CODE_TX,
   P.ADDRESS_ID ,
	-- FPC
	FPC.NUMBER_TX as POLICY_NUMBER_TX ,
	FPC.STATUS_CD,
	FPC.EFFECTIVE_DT ,
	FPC.EXPIRATION_DT ,
	FPC.CANCELLATION_DT ,
	FPC.ISSUE_DT,
	FPC.MONTHLY_BILLING_IN ,

	--- CPIQuote
	CPQ.BASIS_NO,
	CPQ.BASIS_TYPE_CD,
	CPQ.TERM_NO,
	CPQ.TERM_TYPE_CD,
   CPQ.PAYMENT_INCREASE_METHOD_CD,
   ISNULL(FIRST_MONTH_BILL_NO,0) AS FIRST_MONTH_BILL_NO ,
   ISNULL(NEXT_MONTH_BILL_NO,0) AS NEXT_MONTH_BILL_NO ,
	--- CPIActivity
	CPA_I.REASON_CD AS ISSUE_REASON_CD,
	CPA_I.TOTAL_PREMIUM_NO AS CALC_ISSUE_TOTAL_NO,
   CPA_I.NEW_PAYMENT_AMOUNT_NO,
	CPI_C.CANCEL_EVENT_DT,
   ISNULL(CPIA_CANCEL.CALC_CXL_TTL_NO,0) AS CALC_CXL_TTL_NO ,
   CASE WHEN (CPA_I.TOTAL_PREMIUM_NO  + (ISNULL(CPIA_CANCEL.CALC_CXL_TTL_NO,0))) = 0 
   THEN 'Y'
   ELSE 'N'
   END AS IS_FULL_REFUND,
	--LENDER
	LND.CODE_TX AS LENDER_CODE_TX,
	-- CARRIER
	ISNULL(CR.CODE_TX,'') AS CARRIER_CODE_TX,
	ISNULL(CC.CODE_TX,'') AS CC_CODE_TX, CC.ID AS CC_ID,
   --- RC
    RC.TYPE_CD AS COV_TYPE_CD , RC_COV.MEANING_TX AS COV_TYPE_TX , 
	BORR_INS_COMP = CASE WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' THEN ISNULL(CR.CODE_TX,'')
	                   ELSE ISNULL(ISNULL(ISNULL(BIC.NAME , OP.BIC_NAME_TX ),CR.CODE_TX),'') END ,
   ISNULL(CXL_RSN.CXL_REASON_CD,'') AS CXL_REASON_CD ,
   ISNULL(RC_CXL.MEANING_TX,'') AS CXL_REASON_TX ,
   ISSUE_TXN.ISSUE_PAID_DT, ISNULL(CXL_TXN.PAID_CXL_TTL,0) AS PAID_CXL_TTL, 
   TXN_ISS_BILL.CHARGES_BILL_DT , TXN_CXL_BILL.REFUND_BILL_DT , 
   ISNULL(BG_SD.PAST_DUE_DAYS,0) AS [CPI_DUE_DAYS_NO] ,
	ISNULL(RC.ForcedPlcyOptReportNonPayDays,0) AS [CPI_FPC_OPT_BILL_DUE_DAYS_NO],
	LN.ID AS LOAN_ID,
	CBC_CHARGE.BillCycle AS [CPI_BILL_CYCLE_CHARGE],
	CBC_Refund.BillCycle AS [CPI_BILL_CYCLE_REFUND],
   ISNULL(MONTHTERM.MAX_TERM_NO , 0) AS  MAX_TERM_NO, ISNULL(MONTHTERM.MIN_TERM_NO, 0 ) AS MIN_TERM_NO,   
	FPC.EFFECTIVE_DT as 'MNTH_EFFECTIVE_DT',
	FPC.EXPIRATION_DT as 'MNTH_EXPIRATION_DT',
   ISNULL(RD.VALUE_TX,'') as MISC2,
   FT.TERM_NO as FT_TERM_NO
   INTO #t1
	FROM BILLING_GROUP BG
		JOIN FINANCIAL_TXN_APPLY FTA ON FTA.BILLING_GROUP_ID = BG.ID AND FTA.PURGE_DT IS NULL
		JOIN FINANCIAL_TXN FT ON FT.ID = FTA.FINANCIAL_TXN_ID AND FT.PURGE_DT IS NULL
		JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.ID = FT.FPC_ID AND FPC.PURGE_DT IS NULL
		JOIN CPI_QUOTE CPQ on  CPQ.ID = FPC.CPI_QUOTE_ID
		LEFT JOIN CPI_ACTIVITY CPA_I on CPA_I.CPI_QUOTE_ID = CPQ.ID AND CPA_I.TYPE_CD = 'I'
      AND CPA_I.PURGE_DT IS NULL
		OUTER APPLY ( SELECT MAX(PROCESS_DT) AS CANCEL_EVENT_DT FROM CPI_ACTIVITY CPA
		             WHERE TYPE_CD IN ('C', 'MT') AND CPA.PURGE_DT IS NULL AND
		            CPA.CPI_QUOTE_ID = CPQ.ID) AS CPI_C
      OUTER APPLY (SELECT TOP 1 CPA.REASON_CD AS CXL_REASON_CD FROM CPI_ACTIVITY CPA
		             WHERE TYPE_CD IN ('C', 'MT') AND CPA.PURGE_DT IS NULL AND
		             CPA.CPI_QUOTE_ID = CPQ.ID ORDER BY PROCESS_DT DESC) AS CXL_RSN
      OUTER APPLY (SELECT
						SUM(CPA.TOTAL_PREMIUM_NO) AS CALC_CXL_TTL_NO
						FROM CPI_ACTIVITY CPA
						WHERE TYPE_CD IN ('C', 'MT', 'R') AND
                  CPA.PURGE_DT IS NULL AND
						CPA.CPI_QUOTE_ID = CPQ.ID)
						AS CPIA_CANCEL
		JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = FT.FPC_ID AND FPCRCR.PURGE_DT IS NULL
		JOIN REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
		JOIN PROPERTY P ON P.ID = RC.PROPERTY_ID AND P.PURGE_DT IS NULL
      OUTER APPLY
		(
		  SELECT TOP 1 ID , BIC_NAME_TX , BIC_ID  FROM dbo.GetCurrentCoverage(P.ID, RC.ID, RC.TYPE_CD)
         WHERE ISNULL(EXCESS_IN , 'N' ) = 'N'
          ORDER BY ISNULL(UNIT_OWNERS_IN, 'N') DESC
		) AS OP
      OUTER APPLY
		(
		  SELECT MAX(TXN_DT) AS ISSUE_PAID_DT FROM FINANCIAL_TXN WHERE FPC_ID = FPC.ID
		  AND PURGE_DT IS NULL AND TXN_TYPE_CD = 'P'
		) AS ISSUE_TXN
	  OUTER APPLY
		(
		  SELECT MAX(TXN_DT) AS CHARGES_BILL_DT FROM FINANCIAL_TXN FT_R WHERE FT_R.FPC_ID = FPC.ID
		  AND FT_R.PURGE_DT IS NULL AND FT_R.TXN_TYPE_CD = 'R'
		) AS TXN_ISS_BILL
	  OUTER APPLY
		(
		  SELECT MAX(TXN_DT) AS REFUND_BILL_DT FROM FINANCIAL_TXN FT_C WHERE FT_C.FPC_ID = FPC.ID
		  AND FT_C.PURGE_DT IS NULL AND FT_C.TXN_TYPE_CD = 'C'
		) AS TXN_CXL_BILL
      OUTER APPLY
		(
		  SELECT SUM(AMOUNT_NO) AS PAID_CXL_TTL FROM FINANCIAL_TXN WHERE FPC_ID = FPC.ID
		  AND PURGE_DT IS NULL AND TXN_TYPE_CD IN ('CP')
		) AS CXL_TXN
		LEFT JOIN BORROWER_INSURANCE_COMPANY BIC ON BIC.ID = OP.BIC_ID
		LEFT OUTER JOIN OWNER_ADDRESS PA ON PA.ID = P.ADDRESS_ID
		JOIN COLLATERAL CL ON CL.PROPERTY_ID = RC.PROPERTY_ID 
			AND CL.LOAN_ID = FPC.LOAN_ID 
			AND CL.PURGE_DT IS NULL
		LEFT JOIN COLLATERAL_CODE CC ON CL.COLLATERAL_CODE_ID = CC.ID
		JOIN LOAN LN ON LN.ID = CL.LOAN_ID AND LN.PURGE_DT IS NULL
		JOIN OWNER_LOAN_RELATE OL on  OL.LOAN_ID = LN.ID and OL.PRIMARY_IN='Y' AND OL.PURGE_DT IS NULL
      AND OL.PRIMARY_IN = 'Y'
		JOIN [OWNER] O on  O.ID = OL.OWNER_ID
		LEFT JOIN [OWNER_ADDRESS] OA on  OA.ID = O.ADDRESS_ID
		LEFT JOIN CARRIER CR on  CR.ID = FPC.CARRIER_ID
		JOIN LENDER LND on  LND.ID = LN.LENDER_ID
		OUTER APPLY
		(
			SELECT COUNT(1) as BillCycle FROM FINANCIAL_TXN FTX JOIN FINANCIAL_TXN_APPLY FTA ON FTA.FINANCIAL_TXN_ID = FTX.ID AND FTA.PURGE_DT IS NULL
			WHERE FTX.FPC_ID = FPC.ID AND FTX.PURGE_DT IS NULL AND FTX.TXN_TYPE_CD = 'P' AND FTA.BILLING_GROUP_ID = BG.ID
		) AS CBC_CHARGE
		OUTER APPLY
		(
			SELECT COUNT(1) AS BillCycle FROM CPI_ACTIVITY ca
			WHERE ca.CPI_QUOTE_ID = FPC.CPI_QUOTE_ID AND ca.PURGE_DT IS NULL AND fpc.PURGE_DT IS NULL	AND ca.TYPE_CD = 'C'
		) AS CBC_Refund
      OUTER APPLY
		(
		  SELECT MAX(FTX.TERM_NO) AS MAX_TERM_NO , MIN(FTX.TERM_NO) AS MIN_TERM_NO
		  FROM FINANCIAL_TXN FTX JOIN FINANCIAL_TXN_APPLY FTA ON FTA.FINANCIAL_TXN_ID = FTX.ID AND FTA.PURGE_DT IS NULL
		  WHERE FTX.FPC_ID = FPC.ID AND FTX.PURGE_DT IS NULL AND FTX.TXN_TYPE_CD = 'R' AND FTA.BILLING_GROUP_ID = BG.ID
		  AND FPC.MONTHLY_BILLING_IN = 'Y'
		) AS MONTHTERM
      OUTER APPLY (
		SELECT PAST_DUE_DAYS
		FROM dbo.GetPastDueDaysDaysAndDate(FPC.ID,RC.DelayedBilling,
											RC.ForcedPlcyOptReportNonPayDays)
		) BG_SD
      LEFT JOIN RELATED_DATA RD ON RD.DEF_ID = @DEF_ID and RD.RELATE_ID = LN.ID
	  LEFT JOIN REF_CODE RC_COV ON RC_COV.CODE_CD = RC.TYPE_CD
      AND RC_COV.DOMAIN_CD = 'Coverage'
      LEFT JOIN REF_CODE RC_CXL ON RC_CXL.CODE_CD = CXL_RSN.CXL_REASON_CD
      AND RC_CXL.DOMAIN_CD = 'CancelReason'
		WHERE BG.ID = @billingGroupId
   ORDER BY FT.FPC_ID
   OPTION (FAST 1)

   -- Variable to hold FPCs to Update            
   DECLARE @toUpdateFpcIds AS VARCHAR(MAX) = ''

   -- Monthly billers take into account account that some terms may be on hold and others not
   declare @honorTermHolds AS VARCHAR(1) = 'N'

   --Retrieve Extra Configuration For This Lender from Related Data
   -- Check if this is a lender configured for SMP billing
      -- If the billing file has items for monthly billing, then add in the specific monthly 
   -- date information and the managed code will determine if it is useful to use for output
   declare  @useMonthlyBreakouts int = 0,
            @useSMP int = 0   
   select   @useMonthlyBreakouts = CASE WHEN RD.VALUE_TX = 'true' and RDD.NAME_TX = 'UsesCustomMonthlyBillingProration' THEN 1 ELSE 0 END, 
            @useSMP = CASE WHEN RD.VALUE_TX = 'true' and RDD.NAME_TX = 'IsSMPLender'THEN 1 ELSE 0 END 
   from     #t1 t
            INNER JOIN LENDER LND ON t.LENDER_CODE_TX = LND.CODE_TX
            INNER JOIN RELATED_DATA RD ON LND.ID = RD.RELATE_ID
            INNER JOIN RELATED_DATA_DEF RDD ON RDD.ID = RD.DEF_ID and RDD.RELATE_CLASS_NM = 'Lender'
   where    RDD.NAME_TX = 'UsesCustomMonthlyBillingProration' or RDD.NAME_TX = 'IsSMPLender'

   IF @useMonthlyBreakouts > 0
   BEGIN
      -- Create a temporary table
      -- Added a "Uses Custom Monthly Billing Flag" to determine 
      -- which FPCs are used for custom monthly billing
      select   t.FPC_ID,
               CASE 
                  WHEN FPC.MONTHLY_BILLING_IN = 'Y' AND RD.VALUE_TX = 'true' AND FPC.EFFECTIVE_DT >= RD.START_DT THEN
                     ISNULL(MP.MONTHLY_BILLING_PRORATION_CD, 'DollarsToFirstMonth')
                  ELSE 
                     'DollarsToFirstMonth'
               END AS 'USES_CUSTOM_MONTHLY_BILLING_CD'
               INTO #t2
      from     #t1 t
               INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON t.FPC_ID = FPC.ID
               INNER JOIN MASTER_POLICY MP on FPC.MASTER_POLICY_ID = MP.ID
               INNER JOIN LOAN L on FPC.LOAN_ID = L.ID
               INNER JOIN RELATED_DATA RD on RD.RELATE_ID = L.LENDER_ID
               INNER JOIN RELATED_DATA_DEF RDD ON RD.DEF_ID = RDD.ID AND RDD.NAME_TX = 'UsesCustomMonthlyBillingProration'
            
      -- Create a field holding the listing of FPC IDs to pass to the get the monthly period information 
      SET @toUpdateFpcIds = (
         SELECT   FPC_ID
         FROM     #t2 t 
         WHERE    USES_CUSTOM_MONTHLY_BILLING_CD != 'DollarsToFirstMonth' 
         GROUP BY FPC_ID FOR XML PATH(''))
   
      -- Clean up
      DROP TABLE #t2
   END

   -- If the lender is configured for SMP billing, add in FPCs that need their specific
   -- monthly date information updated (check the SMPPayConfigType per FPC), only update
   -- SMP Pay Config Types that are Monthly (M)
   ELSE IF @useSMP > 0
   BEGIN   
      SET @toUpdateFpcIds = 
      (
         select   t.FPC_ID
         from     #t1 t
                  INNER JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON t.FPC_ID = FPCRCR.FPC_ID
                  INNER JOIN REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID and RC.PURGE_DT IS NULL
                  OUTER APPLY (
                     SELECT   RD.RELATE_ID, RD.VALUE_TX 
                     FROM     RELATED_DATA RD
                              INNER JOIN RELATED_DATA_DEF RDD ON RD.DEF_ID = RDD.ID 
                     WHERE    RD.RELATE_ID = RC.LENDER_PRODUCT_ID
                              AND RDD.RELATE_CLASS_NM = 'LenderProduct'
                              AND RDD.NAME_TX = 'SMPPayConfigType'
                  ) RDDCONFIG
         where    RDDCONFIG.VALUE_TX = 'M'
         GROUP BY t.FPC_ID FOR XML PATH('')
      )

      -- If the lender was set to be SMP (thus they came into this IF/THEN), but there are 
      -- no FPCs that were set up propriately to USE SMP, then turn off the @useSMP variable
      select @useSMP = CASE WHEN ISNULL(@toUpdateFpcIds,'') = '' THEN 0 ELSE 1 END
   END

   -- Only update date information if the toUpdateFpcIds variable has data
   IF @toUpdateFpcIds != ''
   BEGIN

      -- Create a temporary table to hold monthly period information for refunds
      DECLARE @monthlyPeriodsRefunds AS TABLE  (FPC_ID BIGINT, MTHN_R_TOT_PRM DECIMAL(8,2), MTHN_C_TOT_PRM DECIMAL(8,2), 
            MTHN_PC_TOT_PRM DECIMAL(8,2), PRD_START_DT DATETIME, PRD_END_DT DATETIME, TERM_NO INT, 
            MTHN_P_TOT_PRM DECIMAL(8,2) DEFAULT 0.00, USE_OVERAGES int, MTHN_CP_TOT_PRM DECIMAL(8,2))
            
      -- Load the refunds monthly period table (using the first of the month or cancel date 
      -- if there is one as period start to the end of month as period end)
      INSERT INTO @monthlyPeriodsRefunds EXEC RetrieveMonthlyBillingPeriods @toUpdateFpcIds, 1, 1
      
      -- Create a temporary table to hold monthly period information for charges
      DECLARE @monthlyPeriodsCharges AS TABLE  (FPC_ID BIGINT, MTHN_R_TOT_PRM DECIMAL(8,2), MTHN_C_TOT_PRM DECIMAL(8,2), 
            MTHN_PC_TOT_PRM DECIMAL(8,2), PRD_START_DT DATETIME, PRD_END_DT DATETIME, TERM_NO INT, 
            MTHN_P_TOT_PRM DECIMAL(8,2) DEFAULT 0.00, USE_OVERAGES int, MTHN_CP_TOT_PRM DECIMAL(8,2))
      
      -- Load the charges monthly period table (using the first of the month thru the cancel date  
      -- if there is one or to the end of month as period end)
      INSERT INTO @monthlyPeriodsCharges EXEC RetrieveMonthlyBillingPeriods @toUpdateFpcIds, 0
      
      -- In a breakout scenario:
      --   All the dates will need to be updated for charges and refunds to handle period start and end dates
      --   (NOTE: the end dates DO take the cancellation date into consideration already)
      UPDATE   t
      SET      MNTH_EFFECTIVE_DT= CASE WHEN t.TXN_TYPE_CD = 'R' THEN mpc.PRD_START_DT else mpr.PRD_START_DT end,
               MNTH_EXPIRATION_DT = CASE WHEN t.TXN_TYPE_CD = 'R' THEN mpc.PRD_END_DT else mpr.PRD_END_DT end
      FROM     #t1 t
               inner join FINANCIAL_TXN FTX ON t.FT_ID = FTX.ID AND FTX.PURGE_DT IS NULL
               inner join @monthlyPeriodsCharges mpc ON t.FPC_ID = mpc.FPC_ID AND ftx.TERM_NO = mpc.TERM_NO
               inner join @monthlyPeriodsRefunds mpr ON t.FPC_ID = mpr.FPC_ID AND ftx.TERM_NO = mpr.TERM_NO
      WHERE    t.TXN_TYPE_CD in ('R','C')
      
      -- Monthly Billing or SMP will honor Term Holds
      set @honorTermHolds = 'Y'    
            
   END
      
   -- Check if there are payments that were around before payments were "termified" those 
   -- payments need to be distributed to months accordingly; payments that are now termified (post 7.2)
   -- will not need to process thru this functionality
   if (@useMonthlyBreakouts > 0 or @useSMP > 0)
   BEGIN

      -- Get all the Payments By FPC
      -- * Only include items in here that HAVE payments that are in Term 0 and that are not split out
      DECLARE @paymentFPCsNonTermifiedCount INT = 0
      DECLARE @paymentsByFPC AS TABLE (ROWNUM INT, FPC_ID BIGINT, FTX_ID BIGINT, AMOUNT_NO DECIMAL(8,2), TERM_NO INT)
      INSERT INTO @paymentsByFPC
      SELECT   ROW_NUMBER() OVER (ORDER BY FPC_ID, FTX_ID, ftx.TERM_NO), 
               ftx.FPC_ID, 
               ftx.ID, 
               ftx.AMOUNT_NO, 
               CASE WHEN ftptd.ID IS NULL THEN 0 ELSE ftptd.TERM_NO END
      FROM     FINANCIAL_TXN_APPLY fta
               INNER JOIN FINANCIAL_TXN ftx ON fta.FINANCIAL_TXN_ID = ftx.ID
               LEFT JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION ftptd ON ftptd.FTX_ID = fta.FINANCIAL_TXN_ID
      WHERE    BILLING_GROUP_ID = @billingGroupId
               and ftx.TXN_TYPE_CD = 'P'
               and FPC_ID IN 
               (
                  select   FPC_ID
                  from     FINANCIAL_TXN FTX
                           LEFT JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION ftptd ON ftptd.FTX_ID = FTX.ID
                  where    FPC_ID = ftx.FPC_ID
                           and TXN_TYPE_CD = 'P'
                  group by FPC_ID
                  having   MIN(ISNULL(ftptd.TERM_NO,FTX.TERM_NO)) = 0
               )
               
      -- Get a count of FPCs that have at payment terms with term zero 
      select @paymentFPCsNonTermifiedCount = @@ROWCOUNT

      -- Confirm that there are Payments that are Not Termified
      IF @paymentFPCsNonTermifiedCount > 0
      BEGIN
       
         -- Finalization Table
         declare  @paymentsByFPCSplit as table (FPC_ID bigint, FTX_ID bigint, TERM_NO int, AMOUNT_NO decimal(8,2))

         -- Get the Amounts Due Per FPC Per Not Split Term
         declare  @amountsDue as table (ROWNUM int, FPC_ID bigint, TERM_NO int, AMOUNT_NO decimal(8,2), DONE_IN INT)
         insert into @amountsDue
         select   ROW_NUMBER() OVER (ORDER BY FTX.FPC_ID ASC, FTX.TERM_NO ASC), FTX.FPC_ID, FTX.TERM_NO, FTX.AMOUNT_NO, 0
         from     FINANCIAL_TXN FTX
                  INNER JOIN (select distinct FPC_ID from @paymentsByFPC) pmt on FTX.FPC_ID = pmt.FPC_ID
         where    FTX.TXN_TYPE_CD = 'R'
                  and FTX.PURGE_DT IS NULL
                  and FTX.TERM_NO NOT IN (select TERM_NO from @paymentsByFPC where FPC_ID = FTX.FPC_ID)
                  and FTX.TERM_NO < (select MIN(TERM_NO) from @paymentsByFPC where TERM_NO > 0)
         
         -- Loop thru each of the Payments to Distribute Per FPC
         declare @paymentsToDistributeCounter as int = 1
         while @paymentsToDistributeCounter <= @paymentFPCsNonTermifiedCount
         begin

            -- Outer Loop Variables
            declare  @fpcId as bigint, @ftxId as bigint, @amountToDistribute as decimal(8,2)
            select   @fpcId = FPC_ID,
                     @ftxId = FTX_ID,
                     @amountToDistribute = AMOUNT_NO
            from     @paymentsByFPC
            where    ROWNUM = @paymentsToDistributeCounter

            -- Handle "Non-Termified" Unposting
            -- * It will apply the unposting to the last item that was DONE fully
            if @amountToDistribute > 0
            begin
               insert into @paymentsByFPCSplit values (@fpcId, @ftxId, 
                  (select MAX(TERM_NO) from @amountsDue where DONE_IN = 1), @amountToDistribute)
            end
            else
            begin
               
               -- Create a Table for the Amounts Still Due for FPCs
               declare @amountsDueForFPC as table (ROWNUM INT, TERM_NO INT, AMOUNT_NO DECIMAL(8,2))
               insert into @amountsDueForFPC
               select   ROW_NUMBER() OVER (ORDER BY TERM_NO), TERM_NO, AMOUNT_NO 
               from     @amountsDue 
               where    FPC_ID = @fpcId 
                        and DONE_IN = 0
               declare @amountsDueForFPCCount as int = @@ROWCOUNT
               declare @amountsDueForFPCCounter as int = 1
               
               -- Get a temporary variable to track the distribution amount as it decrements
               declare @workingAmountToDistribute as decimal(8,2) = @amountToDistribute

               while @amountsDueForFPCCounter <= @amountsDueForFPCCount
               begin
               
                  -- Inner Loop Variables
                  declare  @term as int, @termAmount as decimal(8,2)
                  select   @term = TERM_NO, 
                           @termAmount = AMOUNT_NO 
                  from     @amountsDueForFPC 
                  where    ROWNUM = @amountsDueForFPCCounter
                  
                  -- Set if this term already had some payment distributed for it
                  declare @amountAlreadyforFPCTerm as decimal(8,2) = 0
                  select @amountAlreadyforFPCTerm = ISNULL(SUM(AMOUNT_NO),0) from @paymentsByFPCSplit where FPC_ID = @fpcId and TERM_NO = @term

                  -- Update the term amount to cover if some has been covered already
                  select @termAmount = @termAmount + @amountAlreadyforFPCTerm
                  
                  -- Decrement the Term Amount form the Working Amount
                  if @workingAmountToDistribute + @termAmount <= 0
                  begin

                     -- Update the Amounts Due Table that this term for this FPC is complete
                     update @amountsDue set done_in = 1 where FPC_ID = @fpcId and TERM_NO = @term

                     -- Insert into the final non-termified split table

                     -- Check if the next amount is an unposting, then break out and the unposting will be handled on the next loop
                     declare @nextPaymentAmount decimal(8,2) = 0
                     select top 1 @nextPaymentAmount = AMOUNT_NO from @paymentsByFPC where ROWNUM > @paymentsToDistributeCounter
                     if @nextPaymentAmount > 0 
                     begin
                        -- Take the unposting off the term amount and insert it into the final non-termified split table
                        insert into @paymentsByFPCSplit values (@fpcId, @ftxId, @term, -@termAmount - @nextPaymentAmount)
                        break;
                     end
                     else
                     begin
                        insert into @paymentsByFPCSplit values (@fpcId, @ftxId, @term, -@termAmount)
                     end

                     -- Decrement the Working Amount
                     select @workingAmountToDistribute = @workingAmountToDistribute + @termAmount

                     -- If the working amount is greater than or equal to zero then break out
                     if @workingAmountToDistribute >= 0 break;
                  end

                  -- The working amount didn't cover everything in the term, so insert that amount for this term and break out
                  else
                  begin
                     insert into @paymentsByFPCSplit values (@fpcId, @ftxId, @term, @workingAmountToDistribute)
                     break;
                  end

                  -- Increment the Counter
                  select @amountsDueForFPCCounter = @amountsDueForFPCCounter + 1
               end
            end

            -- Increment the Counter
            set @paymentsToDistributeCounter = @paymentsToDistributeCounter + 1
         end

         -- Create #t3 Table with the Split Non-Termified Payments
         select   t.*,
                  p.AMOUNT_NO AS SPLIT_AMOUNT_NO,
                  p.TERM_NO AS SPLIT_TERM_NO
         into     #t3
         from     #t1 t
                  inner join @paymentsByFPCSplit p on t.FT_ID = p.FTX_ID

         -- Remove source rows from main #t1 table
         DELETE   t
         FROM     #t1 t
                  inner join #t3 t3 on t.FT_ID = t3.FT_ID     
                  
         -- Update the #t3
         update   #t3 
         set      BILLED_AMOUNT_NO = SPLIT_AMOUNT_NO,
                  FT_TERM_NO = SPLIT_TERM_NO

         -- Removed the calculation columns from the #t3 table so it can be inserted with ease
         alter table #t3 drop column SPLIT_AMOUNT_NO, SPLIT_TERM_NO
         
         -- Re-add the #t3 to the main #t1 table
         INSERT INTO #t1 SELECT * FROM #t3
         
         -- Remove the #t3 table from further use      
         drop table #t3
   
END
   END

   -- If any financial txn has payments that are split, then run the split payment code
   DECLARE @useSplitPayments INT = 0
   SELECT   @useSplitPayments = COUNT(*)
   FROM     FINANCIAL_TXN_APPLY fta
            INNER JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION ftptd ON ftptd.FTX_ID = fta.FINANCIAL_TXN_ID
   WHERE    BILLING_GROUP_ID = @billingGroupId

   IF @useSplitPayments > 0
   BEGIN

      -- Split payments if there are any; if there are no payments TO split then, it will work as before
      SELECT   distinct
               t.*,
               ISNULL(t2.SPLIT_TERM_NO,0) as SPLIT_TERM_NO,
               ISNULL(t2.SPLIT_AMOUNT_NO,t.BILLED_AMOUNT_NO) as FINAL_BILLED_AMOUNT_NO,
               CASE WHEN ISNULL(SPLIT_FPC_ID,0) = 0 THEN 0 ELSE 1 END AS USES_SPLITS_IN
      INTO     #splitPayments
      FROM     #t1 t
               INNER JOIN 
               (
                  -- Sum up all the split payments by term for each FPC in the group
                  SELECT   t.FPC_ID as SPLIT_FPC_ID,
                           ftptd.TERM_NO as SPLIT_TERM_NO,
                           ftx.ID as SPLIT_FT_ID,
                           SUM(ftptd.AMOUNT_NO) AS SPLIT_AMOUNT_NO
                  FROM     #t1 t
                           INNER JOIN FINANCIAL_TXN FTX ON T.FT_ID = FTX.ID AND FTX.PURGE_DT IS NULL
                           INNER JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION ftptd WITH (NOLOCK) ON ftptd.FTX_ID = ftx.ID AND ftptd.PURGE_DT IS NULL
                  WHERE    t.TXN_TYPE_CD IN ('P')
                  GROUP BY t.FPC_ID, ftptd.TERM_NO, FTX.ID
               ) t2 ON t2.SPLIT_FPC_ID = t.FPC_ID AND t.FT_ID = t2.SPLIT_FT_ID
      WHERE    t.TXN_TYPE_CD IN ('P')
      
      -- Remove source payments from the main #t1 table that were split in the distribution table
      DELETE   t
      FROM     #t1 t
               INNER JOIN #splitPayments sp ON t.FPC_ID = sp.FPC_ID AND t.FT_ID = sp.FT_ID
      WHERE    t.TXN_TYPE_CD IN ('P')
      
      -- Update the #splitPayments 
      UPDATE   #splitPayments 
      SET      BILLED_AMOUNT_NO = FINAL_BILLED_AMOUNT_NO,
               FT_TERM_NO = SPLIT_TERM_NO

      -- Removed the calculation columns from the #splitPayments table so it can be inserted with ease
      ALTER TABLE #splitPayments DROP COLUMN SPLIT_TERM_NO, FINAL_BILLED_AMOUNT_NO, USES_SPLITS_IN

      -- Re-add the now split payments (from the source that was deleted earlier) to the main #t1 table
      INSERT INTO #t1 SELECT * FROM #splitPayments
            
      -- Remove the #splitPayments table from further use
      DROP TABLE #splitPayments
   
   END
   
   -- Return the billing data
   SELECT   T.*,
            FPC.MASTER_POLICY_ID,
            FPC.CAPTURED_DATA_XML FPC_CAPTURED_DATA_XML 
   FROM #t1 T
      INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON T.FPC_ID = FPC.ID
   WHERE    T.HOLD_IN = CASE WHEN @honorTermHolds = 'Y' THEN 'N' ELSE T.HOLD_IN END
   ORDER BY FPC_ID, FT_TERM_NO

END

GO

