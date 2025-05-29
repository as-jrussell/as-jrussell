USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[RetrieveMonthlyBillingPeriods]    Script Date: 1/4/2017 11:16:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RetrieveMonthlyBillingPeriods]

   @fpcs AS XML,
   @useMidPeriodIfCancelled INT = 1,
   @doCalculateRefund INT = 0,
   @returnOverageAsCancel INT = 0

AS

BEGIN

   -- If the temporary @forcePlacedIDs table isn't created, then 
   -- this will return a blank table, and not cause an error
   DECLARE @forcePlacedIDs AS TABLE ( FPC_ID BIGINT )

   INSERT INTO @forcePlacedIDs
   SELECT   XCol.value('.', 'varchar(50)') 
   FROM     @fpcs.nodes('//FPC_ID') AS XTbl(XCol)

   -- Determine the number of charges (R) and cancels (C)
   DECLARE @numOfRCFinancialTransactions AS INT = 0
   SELECT   @numOfRCFinancialTransactions = COUNT(*)
   FROM     @forcePlacedIDs FPCIDS
            INNER JOIN FINANCIAL_TXN FTX ON FPCIDS.FPC_ID = FTX.FPC_ID
   WHERE    FTX.FPC_ID = FTX.FPC_ID
            AND PURGE_DT IS NULL
            AND TXN_TYPE_CD IN ('R','C')

   IF @numOfRCFinancialTransactions > 0
   BEGIN

      DECLARE @periodProcessing AS TABLE (FPC_ID BIGINT, RECEIVABLES_AMT DECIMAL(8,2), 
         CANCELS_AMT DECIMAL(8,2), REFUNDS_AMT DECIMAL(8,2), START_DT DATETIME, 
         END_DT DATETIME, TERM_NO INT, PAYMENT_AMT DECIMAL(8,2) DEFAULT 0.00, 
         USE_OVERAGES INT, OVER_PAYMENT DECIMAL(8,2) DEFAULT 0.00)

      INSERT INTO 
         @periodProcessing
      SELECT
         FPC_ID,
         ISNULL(RECEIVABLES_AMT,0) AS RECEIVABLES_AMT ,
         CASE WHEN ((@returnOverageAsCancel = 1) AND ( ABS(ISNULL(OVER_PAYMENT_AMOUNTS.TOT_PAYMENT_AMT,0)) > ABS(ISNULL(OVER_PAYMENT_AMOUNTS.TOT_CHARGE_AMT,0))))
            THEN 
               ISNULL(OVER_PAYMENT_AMOUNTS.TOT_PAYMENT_AMT,0) - ISNULL(OVER_PAYMENT_AMOUNTS.TOT_CHARGE_AMT,0)
            ELSE 
               0
            END
         + ISNULL(CANCELS_AMT,0) 
			AS CANCELS_AMT,
         CASE WHEN ISNULL(PAYMENT_AMOUNTS.PERIOD_PAYMENT,0) > 0 THEN ISNULL(REFUNDS_AMT,0) ELSE 0 END AS REFUNDS_AMT,
         CASE WHEN @useMidPeriodIfCancelled = 0 THEN START_DTF ELSE START_DTM END AS START_DT,
         CASE WHEN @useMidPeriodIfCancelled = 0 THEN END_DTF ELSE END_DTM END AS END_DT,
         TERM_NO,
         PAYMENT_AMOUNTS.PERIOD_PAYMENT AS PAYMENT_AMT,
         CASE WHEN (@returnOverageAsCancel = 1 AND ABS(ISNULL(OVER_PAYMENT_AMOUNTS.TOT_PAYMENT_AMT,0)) > ABS(ISNULL(OVER_PAYMENT_AMOUNTS.TOT_CHARGE_AMT,0)))
            THEN 1 ELSE 0 END AS USE_OVERAGES,
         ISNULL(OVER_PAYMENT_AMOUNTS.TOT_PAYMENT_AMT,0) - ISNULL(OVER_PAYMENT_AMOUNTS.TOT_CHARGE_AMT,0) AS OVER_PAYMENT
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
         SELECT
            ABS(SUM(CASE WHEN ftx.TXN_TYPE_CD = 'R' THEN ISNULL(FTXD.AMOUNT_NO,0) ELSE 0 END)) AS RECEIVABLES_AMT,
            ABS(SUM(CASE WHEN ftx.TXN_TYPE_CD = 'C' THEN ISNULL(FTXD.AMOUNT_NO,0) ELSE 0 END)) AS CANCELS_AMT,
            CASE WHEN @doCalculateRefund = 0 THEN
                     ABS(SUM(CASE WHEN ftx.TXN_TYPE_CD = 'CP' THEN FTXD.AMOUNT_NO ELSE NULL END))
                  ELSE
                     -- Build the refund amount as Cancel (C) - Refund (CP), if
                     -- there is no refund amount, then use the Cancel (C) alone
                     ABS(SUM(CASE WHEN ftx.TXN_TYPE_CD = 'C' THEN FTXD.AMOUNT_NO ELSE NULL END))
                        - ISNULL(ABS(SUM(CASE WHEN ftx.TXN_TYPE_CD = 'CP' THEN FTXD.AMOUNT_NO ELSE NULL END)), 0)
            END AS REFUNDS_AMT
         FROM
            FINANCIAL_TXN FTX
            JOIN FINANCIAL_TXN_DETAIL FTXD ON FTXD.FINANCIAL_TXN_ID = FTX.ID AND FTXD.PURGE_DT IS NULL
         WHERE    
            FTX.FPC_ID = DATE_TERM_DATA.FPC_ID
            AND FTX.PURGE_DT is NULL
            AND FTX.TERM_NO = DATE_TERM_DATA.TERM_NO
            AND FTX.TXN_TYPE_CD != 'P'
      ) AS TOTAL_AMOUNTS   

         OUTER APPLY (
         SELECT
            ABS(SUM(CASE WHEN ftx.TXN_TYPE_CD in ('P','CP') THEN ISNULL(FTXD.AMOUNT_NO,0) ELSE 0 END)) AS TOT_PAYMENT_AMT,
            ABS(SUM(CASE WHEN ftx.TXN_TYPE_CD in ('R','C') THEN ISNULL(FTXD.AMOUNT_NO,0) ELSE 0 END)) AS TOT_CHARGE_AMT
          FROM
            FINANCIAL_TXN FTX
            JOIN FINANCIAL_TXN_DETAIL FTXD ON FTXD.FINANCIAL_TXN_ID = FTX.ID AND FTXD.PURGE_DT IS NULL
         WHERE    
            FTX.FPC_ID = DATE_TERM_DATA.FPC_ID
            AND FTX.PURGE_DT is NULL
            AND FTX.TXN_TYPE_CD in ('CP','P','R','C')
      ) AS OVER_PAYMENT_AMOUNTS 

      OUTER APPLY (

         select * from (SELECT PERIOD_PAYMENT = dbo.fn_PaymentPeriodGenerator( DATE_TERM_DATA.FPC_ID,	TERM_NO)) AS PERIOD_PAYMENT

      ) PAYMENT_AMOUNTS

      ORDER BY FPC_ID, TERM_NO
      
      -- Build a table of the maximum period numbers for each FPC
      DECLARE @maxTerms AS TABLE (FPC_ID BIGINT, TERM_NO INT)
      INSERT @maxTerms
      SELECT   FPC_ID, MAX(TERM_NO) TERM_NO
      FROM     @periodProcessing
      GROUP BY FPC_ID
      
      -- For all the periods in an fpc, remove the OVER_PAYMENT total
      -- but if there is already a CANCEL_AMT leave that
      UPDATE a
      SET   a.CANCELS_AMT = a.CANCELS_AMT - a.OVER_PAYMENT 
      FROM  @periodProcessing a
            INNER JOIN @maxTerms b ON a.FPC_ID = b.FPC_ID
      WHERE a.TERM_NO != b.TERM_NO AND a.USE_OVERAGES = 1
      
      -- Return 
      SELECT FPC_ID, RECEIVABLES_AMT, CANCELS_AMT, REFUNDS_AMT, 
             START_DT, END_DT, TERM_NO, PAYMENT_AMT, USE_OVERAGES
      FROM @periodProcessing

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


