USE [UniTrac]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetCPICancelActivityTerms]    Script Date: 11/9/2017 1:21:56 PM ******/
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
            CASE WHEN CPI_ACTIVITY.START_DT >= @IssueStartDate AND CPI_ACTIVITY.START_DT < GP.GRACE_PERIOD_END_DT
               THEN @IssueStartDate
               ELSE CPI_ACTIVITY.START_DT
            END,
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
            OUTER APPLY (
               SELECT   DATEADD(D,ISNULL(MAX(CRC.FLAT_DAYS_NO),0)+1, @IssueStartDate) AS GRACE_PERIOD_END_DT
               FROM     FORCE_PLACED_CERTIFICATE FPC
                        LEFT JOIN MASTER_POLICY_ASSIGNMENT MPA ON MPA.ID = ISNULL(FPC.MASTER_POLICY_ASSIGNMENT_ID,0)
                        LEFT JOIN CANCEL_RULE_CALC CRC ON CRC.CANCEL_PROCEDURE_ID = MPA.CANCEL_PROCEDURE_ID
               WHERE FPC.ID = @FPC_ID
               GROUP BY FPC.ID
               HAVING ISNULL(MAX(CRC.FLAT_DAYS_NO),0) > 0
            ) GP
   WHERE    CPI_ACTIVITY.TYPE_CD = 'C' AND 
            CPI_ACTIVITY.PURGE_DT IS NULL
            AND FPC.ID = @FPC_ID
   ORDER BY CPI_ACTIVITY.CREATE_DT DESC
   
   -- Determine the Term To Address
   DECLARE @termToAddress AS INT = 0 
   SELECT @termToAddress = MAXSTARTTERM.TERM
   FROM @CPI_TERM_PERIODS T
      OUTER APPLY (
         SELECT MAX(START_TERM_NO) TERM
         FROM @CPI_TERM_PERIODS
      ) MAXSTARTTERM
   WHERE START_TERM_NO = MAXSTARTTERM.TERM OR END_TERM_NO = MAXSTARTTERM.TERM

   -- Only proceed IF there are terms to be addressed
   if @termToAddress > 0
   BEGIN 

      -- Determine all the payment periods for each fpc and store it in a local temp table
      DECLARE @financialsByPaymentPeriod as TABLE (fpc_id bigint, term int, charges decimal(19,2), payments decimal(19,2), isOverpayment int)
      insert @financialsByPaymentPeriod select * from dbo.fn_PaymentPeriodTableGenerator(@FPC_ID)

      -- Determine if the term to Address HAS payments
      --  Note: The fn_PaymentPeriodTableGenerator takes both split payment terms post 7.1 and original payment distribution pre 7.1
      --        It also takes into account keyed refunds that may have already been entered and adjusts values accordingly
      declare @payments decimal(19,2) = 0
      declare @charges decimal(19,2) = 0
      select   @payments = payments,
               @charges = charges
      from     @financialsByPaymentPeriod 
      where    term = @termToAddress and payments > 0
      
      if @payments > 0
      begin

         -- Check if cancels crosses into the term to address which has more 
         -- than one cancellation, then update the start term and date of  
         -- that cancel to be the one for the term to address
         declare @hasSplitTerms int = 0
         select   @hasSplitTerms = COUNT(*)
         from     @CPI_TERM_PERIODS T
         where    START_TERM_NO < END_TERM_NO AND END_TERM_NO = @termToAddress
                     
         -- Insert into the OUTPUT table for terms that are NOT going to be adjusted
         -- but WERE part of the split term so their amounts get output only if they 
         -- haven't been fully satisfied
         if @hasSplitTerms > 0
         begin  

            -- Starting with the earliest term, loop up to (but not including
            -- the term to address), check if there should be a refund by 
            -- subtracting the payments from charges for that term
            declare  @splitTermCounter int = 0
            select   @splitTermCounter = MIN(START_TERM_NO)
            from     @CPI_TERM_PERIODS

            while @splitTermCounter < @termToAddress
            begin
               -- Get the cancel start date from the cpi term periods (if there is one)
               -- NOTE: If there isn't, it will use the period start date
               declare  @cancelStartDate datetime = null, @rawPeriodStartDate datetime = null, @rawPeriodEndDate datetime = null
               select   @cancelStartDate = 
                           CASE WHEN ISNULL(PT.PRIOR_TERM_WAS_CANCELLED,0) != 0 
                              THEN prd.PERIOD_START_DT
                              ELSE ISNULL(CPI.START_DT, prd.PERIOD_START_DT)
                           END,
                        @rawPeriodStartDate = prd.PERIOD_START_DT,
                        @rawPeriodEndDate = prd.PERIOD_END_DT
               from     @periodRawDates prd
                        LEFT JOIN @CPI_TERM_PERIODS CPI ON prd.TERM_NO = CPI.START_TERM_NO
                        OUTER APPLY
                        (
                           SELECT 1 AS PRIOR_TERM_WAS_CANCELLED 
                           FROM  @OUTPUT 
                           WHERE TERM_NO = @splitTermCounter - 1
                        ) PT
               where    prd.term_no = @splitTermCounter 

               -- Determine the end date for the split term
               -- NOTE: Check future CPI Term Periods to get the earliest cancel start date from one of
               --       those periods that may potentially be in this term period. Per the business, use the
               --       earliest future START DATE (that fits within this term) as the END DATE of this term.
               declare  @useEndDateForThisPeriod datetime = null
               select   @useEndDateForThisPeriod = ISNULL(MIN(START_DT), @rawPeriodEndDate)
               from     @CPI_TERM_PERIODS 
               where    START_DT > @cancelStartDate and START_DT > @rawPeriodStartDate and START_DT < @rawPeriodEndDate

               -- If the charges minus the payments for this term is less than zero
               -- then there is a refund for this term, so add that to the output
               insert into @OUTPUT
               select   @FPC_ID, @splitTermCounter, charges - payments, @cancelStartDate, @useEndDateForThisPeriod
               from     @financialsByPaymentPeriod fbpp
                        inner join @periodRawDates prd on fbpp.term = prd.TERM_NO
               where    term = @splitTermCounter and charges - payments < 0

               -- Increment the loop counter
               set @splitTermCounter = @splitTermCounter + 1
            end
            
            update   T
            set      START_TERM_NO = @termToAddress,
                     START_DT = prd.PERIOD_START_DT
            from     @CPI_TERM_PERIODS T
                     INNER JOIN CPI_ACTIVITY CPI ON T.CPIACTIVITYID = CPI.ID
                     LEFT JOIN @periodRawDates prd on prd.TERM_NO = @termToAddress
            where    START_TERM_NO < END_TERM_NO AND END_TERM_NO = @termToAddress
         end

         -- If the charges minus the payments is less that zero, then the 
         -- term to address can be processed to see if there are refunds,
         -- otherwise this will not be on the output
         if (@charges - @payments < 0) 
         begin

            -- Analyze any term(s) and build the CPI_ACTIVITY_TERMS table
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
            DECLARE  @financialTxnPeriodDates AS TABLE (FTX_ID BIGINT, TERM_NO INT, AMOUNT_NO DECIMAL(18,2), PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME, CREATE_END_DT DATETIME)
            INSERT   @financialTxnPeriodDates
            select   FTX.ID AS FTX_ID,
                     FTX.TERM_NO AS TERM_NO,
                     FTX.AMOUNT_NO AS TERM_NO,
                     cat.PERIOD_START_DT, 
                     cat.PERIOD_END_DT,
                     cat.CREATE_END_DT
            from     @CPI_ACTIVITY_TERMS cat
                     INNER JOIN FINANCIAL_TXN FTX on cat.FPC_ID = FTX.FPC_ID AND FTX.PURGE_DT IS NULL
                        AND cat.CREATE_START_DT <= FTX.CREATE_DT AND FTX.CREATE_DT < cat.CREATE_END_DT
                        AND cat.TERM_NO = FTX.TERM_NO
            WHERE    FTX.FPC_ID = @FPC_ID AND TXN_TYPE_CD = 'C'
           

		    -- Looking at the end dates for any consecutive cancels that may have happened. 
		   -- Looking for any CP FTX records that have happened in the term but after the first cancel. 
		   -- This way the CP will be marked as already processed and offset Amount_No correctly. 
		   -- Related to TFS 42267. The issued refund to offset the first cancel was not reported as processed and post second cancel the already refunded amount was still reported
		   declare @financialsEndDateCheck as table (ROWNUM INT, DT DATETIME, TERM_NO INT, FTX_ID BIGINT)
           insert into @financialsEndDateCheck
           select   ROW_NUMBER() OVER (ORDER BY CREATE_END_DT),
                    CREATE_END_DT,
                    TERM_NO, 
					FTX_ID
           FROM     @financialTxnPeriodDates

           DECLARE @endDateTotalRows int = @@ROWCOUNT
           DECLARE @endDateRowCounter int = 1
           WHILE @endDateRowCounter < @endDateTotalRows + 1
           BEGIN

				declare @minDt as datetime, @maxDt as datetime, @tTerm as int					

				select   @minDt = DT, @tTerm = TERM_NO
				from     @financialsEndDateCheck
				where    ROWNUM = @endDateRowCounter 

				if (@endDateRowCounter + 1 < @endDateTotalRows + 1)
					select   @maxDt = DT
					from     @financialsEndDateCheck
					where    ROWNUM = @endDateRowCounter + 1
				else
					select   @maxDt = '1/1/9999'
				declare @CP_CREATE_DT as datetime = null

				select top 1 @CP_CREATE_DT = ftx.CREATE_DT 
				from FINANCIAL_TXN ftx				 
				Where ftx.FPC_ID = @FPC_ID AND ftx.TXN_TYPE_CD = 'CP' and ftx.TERM_NO = @tTerm
				and ftx.CREATE_DT >= @minDt and ftx.CREATE_DT < @maxDt and ftx.PURGE_DT is null
				order by ftx.CREATE_DT DESC
			
				if(@CP_CREATE_DT IS NOT null)
				begin
					-- Update the create end date in Financial Txn Period Dates to be the create date of the CP record.				
					update ftd set ftd.CREATE_END_DT = @CP_CREATE_DT 	
					From @financialTxnPeriodDates ftd					
					join @financialsEndDateCheck fedc on fedc.FTX_ID = ftd.FTX_ID and ROWNUM = @endDateRowCounter			
					 	
				end
              -- Increment the Counter
              SET @endDateRowCounter = @endDateRowCounter + 1 

           END


            -- Cancel Financial Transactions Split Cancel Periods
            -- NOTE: Checks if the financial transaction has been reported on a prior refund due report and/or refund processed
            DECLARE @FINAL as TABLE (FPC_ID BIGINT, FTX_ID BIGINT, TERM_NO INT, AMOUNT_NO DECIMAL(18,2), PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME, CREATE_END_DT DATETIME, ALREADY_REPORTED_IN INT, ALREADY_PROCESSED_IN INT)
            INSERT INTO @FINAL
            SELECT   @FPC_ID FPC_ID,
                     FPD.FTX_ID,
                     FPD.TERM_NO,
                     FPD.AMOUNT_NO,
                     FPD.PERIOD_START_DT,
                     FPD.PERIOD_END_DT,
                     FPD.CREATE_END_DT,
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
      
            -- Get All the Financial Transaction IDs and thier amounts for
            -- Financial Transactions that were already reported on earlier billing groups
            DECLARE  @AlreadyProcessed AS TABLE (RowNum INT, FTX_ID BIGINT, AMOUNT_NO DECIMAL(18,2), CREATE_END_DT DATETIME)
            INSERT INTO @AlreadyProcessed
            SELECT   ROW_NUMBER() OVER (ORDER BY FTX.TERM_NO),
                     F.FTX_ID,
                     F.AMOUNT_NO,
                     F.CREATE_END_DT
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
                        @FTXID BIGINT,
                        @createEndDateAtTheTime DATETIME

               SELECT   @FTXID = FTX_ID,
                        @AlreadyProcessedLookupAmount = AMOUNT_NO ,
                        @CreateEndDateAtTheTime = CREATE_END_DT
               FROM     @AlreadyProcessed AP 
               WHERE    RowNum = @AlreadyProcessedRowNum

               -- Determine the R+C+CP+P for the term at the time the cancel that was reported,
               DECLARE  @AlreadyProcessedTotal decimal(18,2)
               select   @AlreadyProcessedTotal = SUM(ISNULL(PD.AMOUNT_NO, FTX.AMOUNT_NO))
               from     FINANCIAL_TXN FTX
                           LEFT JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION PD 
                              ON FTX.ID = PD.FTX_ID AND PD.CREATE_DT < @CreateEndDateAtTheTime
               where    FTX.FPC_ID = @FPC_ID
                        AND (FTX.TERM_NO = @termToAddress OR PD.TERM_NO = @termToAddress)
                        AND FTX.CREATE_DT <= @CreateEndDateAtTheTime

               -- If the Already Processed Total is Zero, then the
               -- Financial Transaction has been processed
               IF (@AlreadyProcessedTotal = 0) 
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

            -- Build a "To Merge" table, but only insert it to the output if there are values in it
            DECLARE @TO_MERGE TABLE (AMOUNT_NO DECIMAL(18,2), PERIOD_START_DT DATETIME, PERIOD_END_DT DATETIME)
            INSERT INTO @TO_MERGE
            SELECT AMOUNT_NO, PERIOD_START_DT, PERIOD_END_DT
            FROM @FINAL T
            WHERE ALREADY_PROCESSED_IN = 0 AND TERM_NO = @termToAddress
            
            -- Insert the Merged Infromation   
            IF (@@ROWCOUNT > 0)
               INSERT INTO @OUTPUT
               SELECT @FPC_ID, @termToAddress, SUM(AMOUNT_NO), MIN(PERIOD_START_DT), MAX(PERIOD_END_DT)
               FROM @TO_MERGE
               HAVING SUM(AMOUNT_NO) < 0 

         END
      END
               
      -- The term does NOT have payments associated with it, so per business decision (7/26/2017) do the following:
      --   The cancel amount may be greater than what was charged, so since nothing was paid yet
      --   set the cancel equal to the charge for the term in the output, and if there is any refund 
      --   left over, move that to the last funded term and set the start and end dates to the 
      --   last day of that term
      else
      begin

         -- Determine the refund that will need to be shifted periods for the term to address;
         -- if one exists, it will be a negative "charges" amount
         declare  @refundToMove as decimal(18,2) = 0
         select   @refundToMove = charges
         from     @financialsByPaymentPeriod
         where    term = @termToAddress and charges < 0
         
         -- If there is a negative charges amount, then move that to the 
         -- last funded term  and clear the term that had no payments
         if (@refundToMove < 0)
         begin
            insert into @OUTPUT
            select   @FPC_ID, term_no, @refundToMove, prd.PERIOD_END_DT, prd.PERIOD_END_DT 
            from     @periodRawDates prd
            where    term_no = (select max(term) from @financialsByPaymentPeriod where payments > 0)

            insert into @OUTPUT
            select   @FPC_ID, term_no, 0, null, null
            from     @periodRawDates prd
            where    term_no = @termToAddress
         end

      end

   END
   
   RETURN

END

GO

