IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetrieveMonthlyBillingPeriods]') AND type IN (N'P', N'PC'))
   DROP PROCEDURE [dbo].[RetrieveMonthlyBillingPeriods]
GO

CREATE PROCEDURE [dbo].RetrieveMonthlyBillingPeriods

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

   IF @numOfRCFinancialTransactions > 0
   BEGIN

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
               0 as USE_OVERAGES
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

END
GO