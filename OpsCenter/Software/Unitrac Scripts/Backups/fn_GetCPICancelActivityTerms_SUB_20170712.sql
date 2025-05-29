USE [Unitrac_Reports]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetCPICancelActivityTerms]    Script Date: 7/12/2017 2:08:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_GetCPICancelActivityTerms] (@FPC_ID BIGINT, @BillingGroupId BIGINT)

RETURNS @FINAL TABLE (FPC_ID BIGINT, FTX_ID BIGINT, TERM_NO INT, AMOUNT_NO DECIMAL(18,2), PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME, ALREADY_REPORTED_IN INT, ALREADY_PROCESSED_IN INT)

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
DECLARE @CPI_TERM_PERIODS AS TABLE (ROWNUM INT, CPIACTIVITYID BIGINT, TERMNO INT, START_DT DATETIME, CREATE_DT DATETIME)           
INSERT INTO @CPI_TERM_PERIODS
SELECT   ROW_NUMBER() OVER (ORDER BY CPI_ACTIVITY.ID),
         CPI_ACTIVITY.ID, 
         prd.TERM_NO,
         CPI_ACTIVITY.START_DT,
         CPI_ACTIVITY.CREATE_DT
FROM     CPI_ACTIVITY CPI_ACTIVITY
         INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.CPI_QUOTE_ID = CPI_ACTIVITY.CPI_QUOTE_ID
         INNER JOIN @periodRawDates prd ON FPC.ID = prd.FPCID 
            AND PRD.PERIOD_START_DT <= CPI_ACTIVITY.START_DT AND CPI_ACTIVITY.START_DT < PRD.PERIOD_END_DT
WHERE    CPI_ACTIVITY.TYPE_CD = 'C' AND 
         CPI_ACTIVITY.PURGE_DT IS NULL
         AND FPC.ID = @FPC_ID
ORDER BY CPI_ACTIVITY.CREATE_DT DESC

-- Analyze any terms that have multiple cancels and build cancel periods
DECLARE @TotalRecords int = @@ROWCOUNT
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
   select   @term = termno,
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

RETURN 

END

GO

