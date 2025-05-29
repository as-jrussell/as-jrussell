USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[RetrieveMonthlyBillingPeriods]    Script Date: 5/1/2017 5:06:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RetrieveMonthlyBillingPeriods]

   @fpcs as XML,
   @useMidPeriodIfCancelled int = 1,
   @doCalculateRefund int = 0

AS

BEGIN

   -- If the temporary @forcePlacedIDs table isn't created, then 
   -- this will return a blank table, and not cause an error
   DECLARE @forcePlacedIDs AS TABLE ( FPC_ID BIGINT )

   INSERT INTO @forcePlacedIDs
   SELECT   XCol.value('.', 'varchar(50)') 
   FROM     @fpcs.nodes('//FPC_ID') AS XTbl(XCol)

   -- Determine all the payment periods for each fpc and store it in a local temp table
   DECLARE @financialsByPaymentPeriod as TABLE (fpc_id bigint, term int, charges decimal(19,2), payments decimal(19,2), isOverpayment int)
   insert into @financialsByPaymentPeriod
   select   payment_period.*
   from     @forcePlacedIds t
            outer apply
            (
               select * from dbo.fn_PaymentPeriodTableGenerator(t.FPC_ID)
            ) payment_period
            
   -- Determine the number of charges (R) and cancels (C)
   DECLARE @numOfRCFinancialTransactions AS INT = 0
   select   @numOfRCFinancialTransactions = COUNT(*)
   from     @forcePlacedIDs FPCIDS
            INNER JOIN FINANCIAL_TXN FTX ON FPCIDS.FPC_ID = FTX.FPC_ID
   WHERE    FTX.FPC_ID = FTX.FPC_ID
            and PURGE_DT is null
            and TXN_TYPE_CD in ('R','C')

   -- Output Table
   DECLARE @temp AS TABLE  (FPC_ID BIGINT, RECEIVABLES_AMT DECIMAL(8,2), CANCELS_AMT DECIMAL(8,2), 
      REFUNDS_AMT DECIMAL(8,2), START_DT DATETIME, END_DT DATETIME, TERM_NO INT, 
      PAYMENT_AMT DECIMAL(8,2) DEFAULT 0.00, USE_OVERAGES INT, KEYED_REFUND_AMT DECIMAL(8,2))

   IF @numOfRCFinancialTransactions > 0
   BEGIN
   
      INSERT INTO @temp
      SELECT
         FPC_ID,
         ISNULL(RECEIVABLES_AMT,0) AS RECEIVABLES_AMT,
         ISNULL(CANCELS_AMT,0) AS CANCELS_AMT,
         ISNULL(REFUNDS_AMT,0) as REFUNDS_AMT,
         case when @useMidPeriodIfCancelled = 0 then START_DTF else START_DTM end as START_DT,
         case when @useMidPeriodIfCancelled = 0 then END_DTF else END_DTM end as END_DT,
         TERM_NO,
         ISNULL(PAYMENTS_AMT,0) as PAYMENT_AMT,
         IS_OVERPAYMENT AS USE_OVERAGES,
         ISNULL(KEYED_REFUND_AMT,0) as KEYED_REFUND_AMT
      FROM
      (
         -- Retrieve the FPC ID, TERM NUMBER, START DATE and END DATE (which is calculated 
         -- from the ISSUE DATE from the CPI Activity).  If there is a cancellation then
         -- the cancellation date is also taken into consideration with the END DATE.
         -- Receivables are the initial source of data as they are the source of period 
         -- information.
         SELECT   
            FTX.FPC_ID,
            FTX.TERM_NO,
            MIN(DATEADD(DAY,DATEDIFF(DAY,0,DATEADD(MONTH,FTX.TERM_NO-1,CPIISSUE.ISSUE_DT)),0)) AS START_DTF,
            MIN(DATEADD(DAY,DATEDIFF(DAY,0,
               CASE
                  -- WHEN ISNULL(Cancellation Date, Period End) >= Period Start AND ISNULL(Cancellation Date, Period End) < Period End
                  -- THEN ISNULL(Cancellation Date, Period End)
                  -- ELSE Period End
                  WHEN ISNULL(FPC.CANCELLATION_DT, DATEADD(MONTH,FTX.TERM_NO,CPIISSUE.ISSUE_DT)) >= DATEADD(MONTH,FTX.TERM_NO-1,CPIISSUE.ISSUE_DT) AND ISNULL(FPC.CANCELLATION_DT, DATEADD(MONTH,FTX.TERM_NO,CPIISSUE.ISSUE_DT)) < DATEADD(MONTH,FTX.TERM_NO,CPIISSUE.ISSUE_DT)
                  THEN ISNULL(FPC.CANCELLATION_DT, DATEADD(MONTH,FTX.TERM_NO,CPIISSUE.ISSUE_DT))
                  ELSE DATEADD(MONTH,FTX.TERM_NO,CPIISSUE.ISSUE_DT)
               END
            ),0)) AS END_DTF,
            MIN(DATEADD(DAY,DATEDIFF(DAY,0,
               CASE
                  -- WHEN ISNULL(Cancellation Date, Period Start) >= Period Start AND ISNULL(Cancellation Date, Period Start) < Period End
                  -- THEN ISNULL(Cancellation Date, Period Start)
                  -- ELSE Period Start 
                  WHEN ISNULL(FPC.CANCELLATION_DT, DATEADD(DAY,DATEDIFF(DAY,0,DATEADD(MONTH,FTX.TERM_NO-1,CPIISSUE.ISSUE_DT)),0)) >= DATEADD(MONTH,FTX.TERM_NO-1,CPIISSUE.ISSUE_DT) AND ISNULL(FPC.CANCELLATION_DT, DATEADD(DAY,DATEDIFF(DAY,0,DATEADD(MONTH,FTX.TERM_NO-1,CPIISSUE.ISSUE_DT)),0)) < DATEADD(MONTH,FTX.TERM_NO,CPIISSUE.ISSUE_DT)
                  THEN ISNULL(FPC.CANCELLATION_DT, DATEADD(DAY,DATEDIFF(DAY,0,DATEADD(MONTH,FTX.TERM_NO-1,CPIISSUE.ISSUE_DT)),0))
                  ELSE DATEADD(DAY,DATEDIFF(DAY,0,DATEADD(MONTH,FTX.TERM_NO-1,CPIISSUE.ISSUE_DT)),0)
               END
            ),0)) AS START_DTM,
            MIN(DATEADD(DAY,DATEDIFF(DAY,0,DATEADD(MONTH,FTX.TERM_NO,CPIISSUE.ISSUE_DT)),0)) AS END_DTM
         FROM     
            @forcePlacedIDs FPCIDS
            INNER JOIN FINANCIAL_TXN FTX ON FPCIDS.FPC_ID = FTX.FPC_ID
            INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON FTX.FPC_ID = FPC.ID
            INNER JOIN CPI_ACTIVITY CA ON CA.CPI_QUOTE_ID = FPC.CPI_QUOTE_ID
         
            -- Retrieve CPI Issue Date
            OUTER APPLY (
               SELECT   DATEADD(DAY,DATEDIFF(DAY,0,START_DT), 0) AS ISSUE_DT
               FROM     CPI_ACTIVITY CPI_ACTIVITY 
               WHERE    CPI_ACTIVITY.TYPE_CD = 'I'
                        AND CPI_ACTIVITY.CPI_QUOTE_ID = CA.CPI_QUOTE_ID
                        AND CPI_ACTIVITY.PURGE_DT IS NULL
            ) AS CPIISSUE

         WHERE    
            FTX.TXN_TYPE_CD = 'R'
         GROUP BY 
            FTX.FPC_ID, FTX.TERM_NO
      ) DATE_TERM_DATA
   
      -- Retrieve Summations of the Financial Data for these FPCs (by ID) and Terms
      OUTER APPLY (

         SELECT   RECEIVABLES_AMT,
                  CANCELS_AMT,
                  -- Only if there are payments in this term can there possibly be a refund
                  CASE WHEN fbpp.payments > 0 THEN
                     -- If the request it to get a calculated refund DUE then build that refund 
                     -- amount (Term Payments (P) - Term Charges (R, C, CP)
                     -- Otherwise, return the actual keyed refund amounts if available
                     CASE WHEN @doCalculateRefund = 1 THEN
                        fbpp.payments - fbpp.charges
                     ELSE
                        KEYED_REFUND_AMT
                     END 
                  ELSE 
                     0
                  END as REFUNDS_AMT,
                  KEYED_REFUND_AMT,
                  payments as PAYMENTS_AMT,
                  isOverpayment as IS_OVERPAYMENT
         FROM     @financialsByPaymentPeriod fbpp
         OUTER APPLY (
            SELECT
               ABS(SUM(CASE WHEN TXN_TYPE_CD = 'R'  THEN ISNULL(AMOUNT_NO,0) ELSE 0 END)) AS RECEIVABLES_AMT,
               ABS(SUM(CASE WHEN TXN_TYPE_CD = 'C'  THEN ISNULL(AMOUNT_NO,0) ELSE 0 END)) AS CANCELS_AMT,                  
               ABS(SUM(CASE WHEN TXN_TYPE_CD = 'CP' THEN ISNULL(AMOUNT_NO,0) ELSE 0 END)) AS KEYED_REFUND_AMT
            FROM 
               FINANCIAL_TXN ftx
            WHERE    
               ftx.FPC_ID = fbpp.fpc_id
               AND TERM_NO = fbpp.term
               AND TXN_TYPE_CD != 'P'
               AND PURGE_DT is NULL
         ) AS FTX_AMOUNT_SUMS
         WHERE    
            fpc_id = DATE_TERM_DATA.FPC_ID 
            and term = DATE_TERM_DATA.TERM_NO

      ) AS TOTAL_AMOUNTS 

      ORDER BY FPC_ID, TERM_NO

   END

   -- Special Case for if no financial transactions have occured yet
   ELSE
   BEGIN
   
      INSERT INTO @temp
      SELECT   FTX.FPC_ID,
               ABS(SUM(ftx.AMOUNT_NO)) AS RECEIVABLES_AMT ,
               ABS(SUM(ftx.AMOUNT_NO)) AS CANCELS_AMT,
               ABS(SUM(ftx.AMOUNT_NO)) AS REFUNDS_AMT,
               CASE WHEN @useMidPeriodIfCancelled = 0
                  THEN MIN(CPIISSUE.ISSUE_DT)
                  ELSE MIN(ISNULL(FPC.CANCELLATION_DT, CPIISSUE.ISSUE_DT))
               END AS START_DT,
               MIN(DATEADD(MONTH,1,CPIISSUE.ISSUE_DT)) AS END_DT,
               1 as TERM_NO,
               0 as PAYMENT_AMT,
               0 as USE_OVERAGES,
               0 as KEYED_REFUND_AMT
      FROM     @forcePlacedIDs FPCIDS
               INNER JOIN FINANCIAL_TXN FTX ON FPCIDS.FPC_ID = FTX.FPC_ID
               INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON FTX.FPC_ID = FPC.ID

               -- Retrieve CPI Issue Date
               OUTER APPLY (
                  SELECT   DATEADD(DAY,DATEDIFF(DAY,0,START_DT), 0) AS ISSUE_DT
                  FROM     CPI_ACTIVITY CPI_ACTIVITY 
                  WHERE    CPI_ACTIVITY.TYPE_CD = 'I'
                           AND CPI_ACTIVITY.CPI_QUOTE_ID = FPC.CPI_QUOTE_ID
                           AND CPI_ACTIVITY.PURGE_DT IS NULL
               ) AS CPIISSUE
      WHERE    ftx.PURGE_DT IS NULL   
      GROUP BY FTX.FPC_ID   

   END

   -- Get the Lender Id from the first passed FPC
   DECLARE  @lenderId bigint = 0 
   SELECT   @lenderId = L.LENDER_ID
   FROM     @forcePlacedIds T
            INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON T.FPC_ID = FPC.ID
            INNER JOIN LOAN L ON FPC.LOAN_ID = L.ID

   -- Run the Grace Period Checking as long as the Related Data
   -- "Don't Use Grace Periods" setting is NOT set to Yes
   IF NOT EXISTS
   (
      SELECT   *
      FROM     RELATED_DATA RD 
               INNER JOIN RELATED_DATA_DEF RDD ON RDD.ID = RD.DEF_ID AND RDD.ACTIVE_IN = 'Y'
      WHERE    RDD.NAME_TX = 'DontUseGracePeriods' AND RD.VALUE_TX = 'Y' AND RD.RELATE_ID = @lenderId
   )
   BEGIN

      -- Get a list of FPCs that have grace periods
      DECLARE @forcePlacedIdsWithGracePeriods AS TABLE (FPC_ID BIGINT, FLAT_DAYS_NO INT)
      INSERT INTO @forcePlacedIdsWithGracePeriods
      SELECT   T.FPC_ID, 
               ISNULL(MAX(CRC.FLAT_DAYS_NO),0) AS FLAT_DAYS_NO
      FROM     @forcePlacedIds T
               INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.ID = T.FPC_ID
               LEFT JOIN MASTER_POLICY_ASSIGNMENT MPA ON MPA.ID = ISNULL(FPC.MASTER_POLICY_ASSIGNMENT_ID,0)
               LEFT JOIN CANCEL_RULE_CALC CRC ON CRC.CANCEL_PROCEDURE_ID = MPA.CANCEL_PROCEDURE_ID
      GROUP BY T.FPC_ID
      HAVING ISNULL(MAX(CRC.FLAT_DAYS_NO),0) > 0

      -- Check if there are FPCs that HAVE grace periods before continuing
      DECLARE @forcePlacedIdsWithGracePeriodsCount int = @@ROWCOUNT
      IF (@forcePlacedIdsWithGracePeriodsCount > 0)
      BEGIN         

         -- Using the list of FPCs with grace periods, determine if they have been cancelled during the
         -- grace periods or not; if they have been then the dates for that period will be reset to the
         -- full first period per requirements
         DECLARE @gracePeriods as TABLE (FPC_ID BIGINT, CANCELLED_IN_GRACE_PERIOD INT, PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME)
         INSERT INTO @gracePeriods 
         SELECT   FPC.ID AS FPC_ID,
                  CASE WHEN FPC.CANCELLATION_DT >= EFFECTIVE_DT AND CANCELLATION_DT < DATEADD(D, T.FLAT_DAYS_NO, EFFECTIVE_DT)
                  THEN 1 ELSE 0 END AS CANCELLED_IN_GRACE_PERIOD,
                  EFFECTIVE_DT AS PERIOD_START_DT,
                  DATEADD(M, 1, EFFECTIVE_DT) AS PERIOD_END_DT
         FROM     @forcePlacedIdsWithGracePeriods T
                  INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON T.FPC_ID = FPC.ID

         -- Update the Main Output Table Dates for when cancels were created in the grace period
         UPDATE   T
         SET      START_DT = GP.PERIOD_START_DT,
                  END_DT = GP.PERIOD_END_DT
         FROM     @temp T
                  INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON T.FPC_ID = FPC.ID
                  INNER JOIN @gracePeriods GP ON T.FPC_ID = GP.FPC_ID 
                     AND T.START_DT <= FPC.CANCELLATION_DT AND FPC.CANCELLATION_DT < T.END_DT
         WHERE    CANCELLED_IN_GRACE_PERIOD = 1
   
      END

   END

   -- Output the full main table
   SELECT * FROM @temp
   ORDER BY FPC_ID, TERM_NO

END

GO

