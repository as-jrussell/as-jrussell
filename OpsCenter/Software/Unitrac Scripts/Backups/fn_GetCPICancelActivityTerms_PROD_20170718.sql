USE [UniTrac]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetCPICancelActivityTerms]    Script Date: 7/18/2017 5:01:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_GetCPICancelActivityTerms] (@FPC_ID BIGINT, @BillingGroupId BIGINT)

RETURNS @OUTPUT TABLE (FPC_ID BIGINT, TERM_NO INT, AMOUNT_NO DECIMAL(18,2), PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME)

AS

BEGIN

   -- CPI Cancel Activities and their corresponding terms
   DECLARE @CPI_ACTIVITY_TERMS TABLE (FPC_ID BIGINT, CPI_ACTIVITY_ID BIGINT, TERM_NO INT,
   PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME, CREATE_START_DT DATETIME, CREATE_END_DT DATETIME)

   -- Build a Table to Handle the Raw Unaffected Period Dates for 12 Months
   DECLARE  @periodRawDates AS TABLE (FPCID BIGINT, TERM_NO INT, PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME)
   DECLARE  @IssueStartDate DATETIME
   SELECT   @IssueStartDate = CPI.START_DT
   FROM     FORCE_PLACED_CERTIFICATE FPC
            INNER JOIN CPI_ACTIVITY CPI ON FPC.CPI_QUOTE_ID = CPI.CPI_QUOTE_ID
   WHERE    FPC.ID = @FPC_ID AND CPI.TYPE_CD = 'I'

   DECLARE @TERMCOUNTER INT = 0
   WHILE @TERMCOUNTER < 12 
   BEGIN
      INSERT INTO @periodRawDates
      SELECT   @FPC_ID, 
               @TERMCOUNTER + 1,
               DATEADD(M, @TERMCOUNTER, @IssueStartDate) AS PERIOD_START_DT,
               DATEADD(M, @TERMCOUNTER+1, @IssueStartDate) AS PERIOD_END_DT

      SET @TERMCOUNTER = @TERMCOUNTER + 1
   END

   -- Find CPI Cancel Activities and determine the term in which they occured
   DECLARE @CPI_TERM_PERIODS AS TABLE (ROWNUM INT, CPIACTIVITYID BIGINT, START_TERM_NO INT, END_TERM_NO INT, START_DT DATETIME, CREATE_DT DATETIME)           
   INSERT INTO @CPI_TERM_PERIODS
   SELECT   ROW_NUMBER() OVER (ORDER BY CPI_ACTIVITY.ID),
            CPI_ACTIVITY.ID, 
            SPRD.TERM_NO,
            EPRD.TERM_NO,
            CPI_ACTIVITY.START_DT,
            CPI_ACTIVITY.CREATE_DT
   FROM     CPI_ACTIVITY CPI_ACTIVITY
            INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.CPI_QUOTE_ID = CPI_ACTIVITY.CPI_QUOTE_ID
            OUTER APPLY (
               SELECT PRD.TERM_NO
               FROM  @periodRawDates PRD
               WHERE PRD.PERIOD_START_DT <= CPI_ACTIVITY.START_DT AND CPI_ACTIVITY.START_DT < PRD.PERIOD_END_DT
            ) SPRD
            OUTER APPLY (
               SELECT PRD.TERM_NO
               FROM  @periodRawDates PRD
               WHERE PRD.PERIOD_START_DT <= CPI_ACTIVITY.END_DT AND CPI_ACTIVITY.END_DT < PRD.PERIOD_END_DT
            ) EPRD
   WHERE    CPI_ACTIVITY.TYPE_CD = 'C' AND 
            CPI_ACTIVITY.PURGE_DT IS NULL
            AND FPC.ID = @FPC_ID
   ORDER BY CPI_ACTIVITY.CREATE_DT DESC

   -- Get the term that has more than one cancellation
   DECLARE @termToAddress AS INT = 0 
   SELECT @termToAddress = MAXSTARTTERM.TERM
   FROM @CPI_TERM_PERIODS T
      OUTER APPLY (
         SELECT MAX(START_TERM_NO) TERM
         FROM @CPI_TERM_PERIODS
      ) MAXSTARTTERM
   WHERE START_TERM_NO = MAXSTARTTERM.TERM OR END_TERM_NO = MAXSTARTTERM.TERM
   GROUP BY MAXSTARTTERM.TERM
   HAVING COUNT(*) > 1

   -- Only proceed IF there are terms to be addressed
   if @termToAddress > 0
   BEGIN 

      -- Check if cancels crosses into the term to address which has more 
      -- than one cancellation, then update the start term and date of  
      -- that cancel to be the one for the term to address
      declare @hasSplitTerms int = 0
      select   @hasSplitTerms = COUNT(*)
      from     @CPI_TERM_PERIODS T
      where    START_TERM_NO < END_TERM_NO AND END_TERM_NO = @termToAddress

      if @hasSplitTerms > 0
      begin  

         -- Insert into the OUTPUT table for terms that are NOT going to be adjusted
         -- but WERE part of the split term so their amounts get output correctly
         insert into @OUTPUT
         select   @FPC_ID, T.START_TERM_NO, ftx.AMOUNT_NO, CPI.START_DT, prd.PERIOD_END_DT 
         from     @CPI_TERM_PERIODS T
                  INNER JOIN CPI_ACTIVITY CPI ON T.CPIACTIVITYID = CPI.ID
                  INNER JOIN @periodRawDates prd ON prd.TERM_NO = START_TERM_NO
                  INNER JOIN FINANCIAL_TXN ftx ON ftx.FPC_ID = @FPC_ID
                     AND ftx.TERM_NO = T.START_TERM_NO AND ftx.TXN_TYPE_CD = 'C' AND ftx.PURGE_DT IS NULL
         where    START_TERM_NO < END_TERM_NO AND START_TERM_NO != @termToAddress

         update   T
         set      START_TERM_NO = @termToAddress,
                  START_DT = prd.PERIOD_START_DT
         from     @CPI_TERM_PERIODS T
                  INNER JOIN CPI_ACTIVITY CPI ON T.CPIACTIVITYID = CPI.ID
                  LEFT JOIN @periodRawDates prd on prd.TERM_NO = @termToAddress
         where    START_TERM_NO < END_TERM_NO AND END_TERM_NO = @termToAddress
      end

      -- Analyze any terms that have multiple cancels and build cancel periods
      DECLARE @TotalRecords int = 0
      SELECT @TotalRecords = COUNT(*) from @CPI_TERM_PERIODS
      DECLARE @RowNum int = @TotalRecords

      WHILE @RowNum > 0 
      BEGIN
   
         -- Loop Variables
         declare @term int = 1
         declare @cpiActivityId bigint = null
         declare @useStartDate datetime = null
         declare @useEndDate datetime = null
         declare @useCreateStartDate datetime = null
         declare @useCreateEndDate datetime = null

         -- Get Term, CPI Activity ID, Start Date, and the Start Created Date for which this CPI Cancel Applied to
         select   @term = START_TERM_NO,
                  @cpiActivityId = cpiactivityid,
                  @useStartDate = start_dt,
                  @useCreateStartDate = create_dt
         from     @CPI_TERM_PERIODS 
         where    rownum = @RowNum

         -- Get The End Date (which is the start date of the next date range)
         -- If there is NO next range, then get the end from the Period Raw Dates
         -- or if this is the 12th term (or greater), then end date will be 1 year
         -- after the issue date
         select @useEndDate = MIN(start_dt) from @CPI_TERM_PERIODS where start_dt > @useStartDate
         if (@useEndDate is null)  
            if (@term >= 12) 
               select @useEndDate = DATEADD(YY, 1, @IssueStartDate)
            else
               select @useEndDate = MIN(PERIOD_END_DT) from @periodRawDates where PERIOD_END_DT > @useStartDate
         
         -- Get the End Date for which this CPI Cancel Applied to
         -- If there is NO item created after this, then there is no "end" date per se
         select @useCreateEndDate = MIN(create_dt) from @CPI_TERM_PERIODS where create_dt > @useCreateStartDate
         if (@useCreateEndDate is null) set @useCreateEndDate = GETDATE()
   
         -- Insert into the CPI Activity Terms output table
         insert into @CPI_ACTIVITY_TERMS
         select @FPC_ID, @cpiActivityId, @term, @useStartDate, @useEndDate, @useCreateStartDate, @useCreateEndDate

         -- Decrement the Row Number
         SET @RowNum = @RowNum - 1

      END

      -- Get Cancel Financial Transactions (from FINANCIAL_TXN) And the Period Dates (from CPI_ACTIVITY) for Each Term
      DECLARE  @financialTxnPeriodDates AS TABLE (FTX_ID BIGINT, TERM_NO INT, AMOUNT_NO DECIMAL(18,2), PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME)
      INSERT   @financialTxnPeriodDates
      select   FTX.ID AS FTX_ID,
               FTX.TERM_NO AS TERM_NO,
               FTX.AMOUNT_NO AS TERM_NO,
               cat.PERIOD_START_DT, 
               cat.PERIOD_END_DT
      from     @CPI_ACTIVITY_TERMS cat
               INNER JOIN FINANCIAL_TXN FTX on cat.FPC_ID = FTX.FPC_ID AND FTX.PURGE_DT IS NULL
                  AND cat.CREATE_START_DT <= FTX.CREATE_DT AND FTX.CREATE_DT < cat.CREATE_END_DT
                  AND cat.TERM_NO = FTX.TERM_NO
      WHERE    FTX.FPC_ID = @FPC_ID AND TXN_TYPE_CD = 'C'

      -- Cancel Financial Transactions Split Cancel Periods
      -- NOTE: Checks if the financial transaction has been reported on a prior refund due report and/or refund processed
      DECLARE @FINAL as TABLE (FPC_ID BIGINT, FTX_ID BIGINT, TERM_NO INT, AMOUNT_NO DECIMAL(18,2), PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME, ALREADY_REPORTED_IN INT, ALREADY_PROCESSED_IN INT)
      INSERT INTO @FINAL
      SELECT   @FPC_ID FPC_ID,
               FPD.FTX_ID,
               FPD.TERM_NO,
               FPD.AMOUNT_NO,
               FPD.PERIOD_START_DT,
               FPD.PERIOD_END_DT,
               CASE WHEN FTX_ALREADY_REPORTED.FTX_ID = FPD.FTX_ID THEN 1 ELSE 0 END ALREADY_REPORTED_IN,
               0 ALREADY_PROCESSED_IN
      FROM     @financialTxnPeriodDates FPD
               INNER JOIN FINANCIAL_TXN_APPLY FTA ON FTA.FINANCIAL_TXN_ID = FPD.FTX_ID
               LEFT JOIN  
               (
                  -- Financial Transactions that were included on earlier billing groups
                  SELECT   DISTINCT FTX_ID
                  FROM     @financialTxnPeriodDates FPD
                           LEFT JOIN FINANCIAL_TXN_APPLY FTA ON FTA.FINANCIAL_TXN_ID = FPD.FTX_ID
                  WHERE    FTA.BILLING_GROUP_ID < @BillingGroupId
               ) FTX_ALREADY_REPORTED ON FTX_ALREADY_REPORTED.FTX_ID = FPD.FTX_ID
      WHERE    FTA.BILLING_GROUP_ID = @BillingGroupId

      -- Get cancel portions already reported on in prior billing groups
      -- Sum their totals and get the earliest cancel created date
      DECLARE  @MIN_REPORTED_CREATE_DT DATETIME = NULL, 
               @TOTAL_REPORTED_AMOUNT_NO DECIMAL(18,2) = 0

      SELECT   @MIN_REPORTED_CREATE_DT = MIN(FTX.CREATE_DT),
               @TOTAL_REPORTED_AMOUNT_NO = SUM(FTX.AMOUNT_NO)
      FROM     @FINAL F
               INNER JOIN FINANCIAL_TXN FTX ON F.FTX_ID = FTX.ID
      WHERE    ALREADY_REPORTED_IN = 1 

      -- Get the total amount of refunds already processed after the 
      -- minimum reported created date for this FPC
      DECLARE  @AlreadyProcessedTotal DECIMAL(18,2) = 0
      SELECT   @AlreadyProcessedTotal = SUM(FTX.AMOUNT_NO)
      FROM     FINANCIAL_TXN FTX
      WHERE    FPC_ID = @FPC_ID
               AND TXN_TYPE_CD = 'CP'
               AND FTX.CREATE_DT > @MIN_REPORTED_CREATE_DT
               AND PURGE_DT is NULL

      -- Get All the Financial Transaction IDs and thier amounts for
      -- Financial Transactions that were already reported on earlier billing groups
      DECLARE  @AlreadyProcessed AS TABLE (RowNum INT, FTX_ID BIGINT, AMOUNT_NO DECIMAL(18,2))
      INSERT INTO @AlreadyProcessed
      SELECT   ROW_NUMBER() OVER (ORDER BY FTX.TERM_NO),
               F.FTX_ID,
               F.AMOUNT_NO
      FROM     @FINAL F
               INNER JOIN FINANCIAL_TXN FTX ON F.FTX_ID = FTX.ID
      WHERE    ALREADY_REPORTED_IN = 1
      
      -- Loop thru the reported on earlier billing group financial transactions
      -- and determine if they have had their refunds processed yet
      DECLARE @AlreadyProcessedRecords int = @@ROWCOUNT
      DECLARE @AlreadyProcessedRowNum int = 1
      WHILE @AlreadyProcessedRowNum < @AlreadyProcessedRecords + 1
      BEGIN
   
         -- Create and Fill Loop Variables
         DECLARE  @AlreadyProcessedLookupAmount decimal(18,2),
                  @FTXID BIGINT

         SELECT   @FTXID = FTX_ID,
                  @AlreadyProcessedLookupAmount = AMOUNT_NO 
         FROM     @AlreadyProcessed AP 
         WHERE    RowNum = @AlreadyProcessedRowNum

         -- Update the Already Processed Total
         SET @AlreadyProcessedTotal = ISNULL(@AlreadyProcessedTotal,0) + @AlreadyProcessedLookupAmount

         -- If the Already Processed Total is Zero or Greater, then the
         -- Financial Transaction has been processed
         IF (@AlreadyProcessedTotal >= 0) 
            UPDATE @FINAL SET ALREADY_PROCESSED_IN = 1 WHERE FTX_ID = @FTXID

         -- If it hasn't been fully processed and there is some 
         -- that has been processed then update the amount
         ELSE IF (@AlreadyProcessedTotal > @AlreadyProcessedLookupAmount)
            UPDATE @FINAL SET AMOUNT_NO = @AlreadyProcessedTotal WHERE FTX_ID = @FTXID

         -- Increment the Counter
         SET @AlreadyProcessedRowNum = @AlreadyProcessedRowNum + 1   

      END

      -- Check if there has already been terms processed in the @termToAddress month,
      -- if there has NOT, then use the WHOLE MONTH
      DECLARE @hasProcessedTerms INT = 0
      SELECT @hasProcessedTerms = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END from @FINAL WHERE ALREADY_PROCESSED_IN = 1
      IF @hasProcessedTerms = 0
      BEGIN
         UPDATE   F
         SET      PERIOD_END_DT = prd.PERIOD_END_DT
         FROM     @FINAL F
                  INNER JOIN @periodRawDates prd ON F.TERM_NO = prd.TERM_NO
      END

      -- Insert the Merged Infromation
      INSERT INTO @OUTPUT
      SELECT @FPC_ID, @termToAddress, SUM(AMOUNT_NO), MIN(PERIOD_START_DT), MAX(PERIOD_END_DT)
      FROM @FINAL T
      WHERE ALREADY_PROCESSED_IN = 0 AND TERM_NO = @termToAddress

   END
   
   RETURN

END

GO

