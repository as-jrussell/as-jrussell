USE [UniTrac]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_PaymentPeriodTableGenerator]    Script Date: 2/9/2018 7:24:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[fn_PaymentPeriodTableGenerator]( 
   @FPC_ID bigint
)

RETURNS @FINAL TABLE (
   fpc_id bigint,
   term int,
   charges decimal(19,2),
   payments decimal(19,2),
   isOverpayment int
)

AS

begin

-- Create an output table
-- term - the term for this set of charges and payments
-- charges - the total of all the charges, cancels, and cancel payments in this period
-- payments - the payments applied to this period
-- paymentPeriod - this is for tracking and debugging only; this holds the payment period number
DECLARE @OUTPUT as TABLE(
   term int,
   charges decimal(19,2),
   payments decimal(19,2),
   paymentPeriod int,
   isOverpayment int
)

-- Create a table for payment group dates
-- START_DT - the start date of the payment period
-- END_DT - the end date of the payment period
-- PAYMENT_PERIOD - the payment period number
declare @paymentGroupDates as table (START_DT datetime2, END_DT datetime2, PAYMENT_PERIOD int)

-- Get the Minimum Date of All the Transactions for this FPC
declare  @minTransactionDate datetime2
select   @minTransactionDate = min(TXN_DT)
from     FINANCIAL_TXN
where    FPC_ID = @FPC_ID
         and PURGE_DT is null

-- Get the Maximum Payment Term for this FPC
declare  @maxPaymentDate datetime2
select   @maxPaymentDate = max(TXN_DT)
from     FINANCIAL_TXN
where    FPC_ID = @FPC_ID
         and PURGE_DT is null and TXN_TYPE_CD = 'P'

-- Create Looping Variables
declare @useStartDate datetime2, @useEndDate datetime2, @paymentPeriod int
set @useStartDate = @minTransactionDate
set @useEndDate = @maxPaymentDate
set @paymentPeriod = 1

-- Create Payment Period Date Table
while @useStartDate < GETDATE()
begin

   -- Create an End Date Variable
   declare @endDate datetime2 = null
     
   -- Find the First Payment Transaction Date after the "useStartDate"
   -- (which initially is the minimum transaction date)
   select   TOP 1 
            @endDate = TXN_DT
   from     FINANCIAL_TXN
   where    FPC_ID = @FPC_ID
            and TXN_DT >  @useStartDate 
            and TXN_TYPE_CD = 'P' 
            and PURGE_DT is null 
   order by TXN_DT

   -- If the endDate is still NULL, after the lookup, then set it to today's date
   if @endDate is null set @endDate = GETDATE()
      
   -- insert the variables into the paymentGroupDates table
   insert into @paymentGroupDates values (@useStartDate, @endDate, @paymentPeriod)

   -- Reset the useStartDate to the endDate of this group and increment the paymentPeriod
   select   @useStartDate = @endDate,
            @paymentPeriod = @paymentPeriod + 1

end

-- Get the Total Payment for the Entire Group
declare @totalpayment as decimal(19,2)
select   @totalpayment =  sum(ft.amount_no)
from     FINANCIAL_TXN ft
where    ft.FPC_ID = @FPC_ID
         and ft.PURGE_DT is null
         and ft.TXN_TYPE_CD in ('P')
group by ft.FPC_ID

-- Get the Payments by Term for the Entire Group
declare @splitPayments as table (term_no int, term_amount decimal(19,2), payment_period_no int)
insert into @splitPayments
select   ftptd.TERM_NO, 
         SUM(ftptd.AMOUNT_NO),
         pgd.PAYMENT_PERIOD
from     FINANCIAL_TXN ftx with (nolock)
         LEFT JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION ftptd with (nolock)
            ON ftptd.FTX_ID = ftx.ID AND ftptd.PURGE_DT IS NULL
         INNER JOIN @paymentGroupDates pgd
            ON pgd.START_DT < ftx.TXN_DT AND ftx.TXN_DT <= pgd.END_DT
where    ftx.FPC_ID = @FPC_ID
         and ftx.PURGE_DT is null
         and ftx.TXN_TYPE_CD in ('P')
group by ftptd.TERM_NO, pgd.PAYMENT_PERIOD
having isnull(ftptd.TERM_NO,0) != 0

-- Get the Maximum Date of Receivables and Cancels
declare @maxTxnDateRC datetime
select   @maxTxnDateRC = MAX(TXN_DT)
from     FINANCIAL_TXN
where    FPC_ID = @FPC_ID
         AND TXN_TYPE_CD in ('R','C')

-- Check if there are any Payments that occur before the Maximum Date of Receivables and Cancels
-- ** If here are payments before the maximum date, then the no payment special case will not happen
declare  @noPaymentSpecialCase int
select   @noPaymentSpecialCase = case when COUNT(*) = 0 then 1 else 0 end
from     FINANCIAL_TXN
where    FPC_ID = @FPC_ID
         AND TXN_TYPE_CD in ('P')
         AND TXN_DT < @maxTxnDateRC

-- Total Amount of the Not Split Items
declare @totalAmountNotSplit decimal(19,2) = 0
select @totalAmountNotSplit = @totalpayment - ISNULL(SUM(term_amount), 0) from @splitPayments

-- Create variables for the loop      
declare @runningpaymenttotal decimal(19,2) = 0, @maxPaymentPeriod int = 0, @paymentPeriodCounter int = 1
set @runningpaymenttotal = @totalAmountNotSplit
select @maxPaymentPeriod=MAX(PAYMENT_PERIOD) from @paymentGroupDates

while @paymentPeriodCounter <= @maxPaymentPeriod
begin

   -- Get the start and end dates for the period
   declare @start_dt datetime2, @end_dt datetime2
   select   @start_dt = START_DT,
            @end_dt = END_DT
   from     @paymentGroupDates
   where    PAYMENT_PERIOD = @paymentPeriodCounter

   -- Create a temp table to hold calculations FOR this payment period ONLY
   DECLARE @Temp1 as TABLE(
      term int ,
      charges decimal(19,2),
      payments decimal(19,2)
   )
   
   -- Insert into the temp table the amounts per TERM in this payment period
   insert into @Temp1
   select ft.TERM_NO, sum(ft.amount_no) as charges, 0
   from  FINANCIAL_TXN ft
   where ft.FPC_ID = @FPC_ID 
         and ft.TXN_DT >= @start_dt and ft.TXN_DT < @end_dt
         and ft.PURGE_DT is null
         and ft.TXN_TYPE_CD in ('R','C','CP')
   group by ft.TERM_NO
   order by ft.TERM_NO

   -- Total Number of All Charges (R,C,CP)
   DECLARE @totalNumberOfRCCPs INT
   SELECT @totalNumberOfRCCPs = COUNT(*) FROM @Temp1
   
   -- If there are no charges, cancels or refunds paid in this payment 
   -- period then just use the payments for the payment period
   IF @totalNumberOfRCCPs = 0 
   
      INSERT INTO @Temp1
      SELECT   term_no, 0, ABS(term_amount)
      FROM     @splitPayments 
      WHERE    payment_period_no = @paymentPeriodCounter
   
   ELSE
   BEGIN

      -- Get the First Term Number to Start with in this Payment Period
      DECLARE @startTerm INT 
      SELECT @startTerm = MIN(term) from @Temp1

      -- Loop Counter
      DECLARE @termCounter INT
      SELECT @termCounter = 1
   
      -- Loop thru each term in the payment period   
      WHILE @termCounter <= @totalNumberOfRCCPs 
      BEGIN

         -- Get the Charges (R,C,CP) for this Term
         DECLARE  @charges decimal(19,2) = 0
         SELECT   @charges = charges
         FROM     @Temp1 
         WHERE    term = @startTerm

         -- Check if there are split payments for this term and payment period and apply those
         declare  @splitTotalPaymentForTerm as decimal(19,2) = 0
         SELECT   @splitTotalPaymentForTerm = ABS(SUM(term_amount))
         FROM     @splitPayments
         WHERE    term_no = @startTerm and payment_period_no = @paymentPeriodCounter

         -- If there is a split full payment for this term, then set that and move to the next term
         IF (ABS(@splitTotalPaymentForTerm) = @charges AND @charges > 0)       
         BEGIN
            UPDATE @Temp1
            SET payments = @splitTotalPaymentForTerm
            WHERE term = @startTerm
         END       
         ELSE 
         BEGIN
      
            -- Combine the running payment total and the split total for this period
            declare @rptAndSplit as decimal(19,2) = @runningpaymenttotal - ISNULL(@splitTotalPaymentForTerm,0)

            -- If the running and split payment total is greater than the "charges" (and is greater than zero),
            -- then update the payments for this term to be completely satisfied (if the "charges" are less than 
            -- zero, then there is nothing to charge, so neither the term payments will be updated, nor will 
            -- the running payment total be decremented
            IF ABS(@rptAndSplit) > @charges AND ABS(@rptAndSplit) > 0
            BEGIN
                  if (@charges > 0) 
                  begin
                     UPDATE @Temp1
                     SET payments = @charges
                     WHERE term = @startTerm

                     SET @runningpaymenttotal = @runningpaymenttotal + @charges
                  end
            END

            -- If there running payment total is greater than zero (but not greater
            -- than the charges), then set the payments for this term as EQUAL to the
            -- running payment total (as a positive) and update the running payment
            -- total to 0
            ELSE IF ABS(@rptAndSplit) >= 0
            BEGIN       
                  UPDATE @Temp1
                  SET payments = ABS(@rptAndSplit)
                  WHERE term = @startTerm
 
                  SET @runningpaymenttotal = 0
            END

         END  

         -- Increment the start term and the loop counter
         SELECT   @startTerm = @startTerm + 1,
                  @termCounter =  @termCounter + 1

      END
   END

   -- Insert into the OUTPUT table, the generated data
   insert into @OUTPUT
   select *, @paymentPeriodCounter, 0 from @Temp1

   -- Clear the temp1 table
   delete from @Temp1  

   -- Special Case - This occurs when a policy is charged and then fully cancelled off BEFORE the first payment 
   --                and THEN a payment comes in for the policy. In this special case ONLY, make an attempt to 
   --                split out the payment across the terms (ignoring the cancels).
   if ABS(@runningpaymenttotal) = 0 AND ABS(@totalPayment) > 0 AND @noPaymentSpecialCase = 1
   begin

      -- Get the maximum term being set in this Payment Period
      declare  @maxTermInPaymentPeriod as int
      select   @maxTermInPaymentPeriod = max(term) from @OUTPUT where paymentPeriod = @paymentPeriodCounter

      -- Get the sum of the charges and payments for this payment period
      declare  @sumCharges as decimal(19,2) = 0
      declare  @sumPayments as decimal(19,2) = 0
      select   @sumCharges = SUM(charges), 
               @sumPayments = SUM(payments) 
      from     @OUTPUT 
      where    paymentPeriod = @paymentPeriodCounter
               
      if @sumCharges = 0 AND @sumPayments = 0
      begin
      
         -- Set the running payment total here to the total payment for looping
         select   @runningpaymenttotal = ABS(@totalpayment)

         -- Note: Remove already created refunds from the payment total
         select   @runningpaymenttotal = @runningpaymenttotal - sum(ft.amount_no)
         from     FINANCIAL_TXN ft
         where    ft.FPC_ID = @FPC_ID 
                  and ft.TXN_DT >= @start_dt and ft.TXN_DT < @end_dt
                  and ft.PURGE_DT is null
                  and ft.TXN_TYPE_CD = 'CP'
         having sum(ft.amount_no) != 0
         
         -- Loop thru each of the terms (or until the running payment total is used up)
         -- and first get the original charge (before cancelling) and then determine 
         -- and apply the payment that would have gone with that charge
         declare @specialCaseCounter as int = 1
         while @specialCaseCounter <= @maxTermInPaymentPeriod and @runningpaymenttotal > 0
         begin

            -- Original Charges for the Term
            declare  @originalCharge as decimal(19,2) = 0
            select   @originalCharge = amount_no
            from     financial_txn
            where    FPC_ID = @FPC_ID
                     AND TXN_TYPE_CD = 'R'
                     AND TERM_NO = @specialCaseCounter
                     AND PURGE_DT IS NULL

            -- Determine the special payment amount, if there is more 
            -- payment availiable than the original charge, just use
            -- the original charge and then decrement the running amount,
            -- otherwise, use the running amount and then set it to zero
            declare @useSpecialPayment as decimal(19,2) = 0
            if (@runningpaymenttotal - @originalCharge > 0)
            begin          
               set @useSpecialPayment = @originalCharge
               set @runningpaymenttotal = @runningpaymenttotal - @originalCharge
            end
            else  
            begin
               set @useSpecialPayment = @runningpaymenttotal
               set @runningpaymenttotal = 0
            end
         
            -- Confirm the special payment is greater than zero and update the output for this term
            if (@useSpecialPayment > 0) 
               update   @OUTPUT
               set      payments = @useSpecialPayment,
                        isOverpayment = 1
               where    term = @specialCaseCounter and paymentPeriod = @paymentPeriodCounter

               -- Increment the loop counter
            set @specialCaseCounter = @specialCaseCounter + 1
         end
      end
   end

   -- Increment the payment period loop counter
   set @paymentPeriodCounter = @paymentPeriodCounter + 1

end

-- If after everything is done, there is still a running payment total, then 
-- add it as a row for the final term (but for debugging purposes, put it in 
-- it's own period payment group (-1)
if ABS(@runningpaymenttotal) > 0
begin
   declare @maxTerm as int
   select @maxTerm = max(term) from @OUTPUT

   insert into @OUTPUT values (@maxTerm,0,ABS(@runningpaymenttotal),-1, 1)
end

-- Sum charges and payments by term
insert into @FINAL
select   @FPC_ID as FPC_ID,
         term,
         SUM(charges) as charges,
         SUM(payments) as payments,
         SUM(isOverpayment) as isOverpayment
from     @OUTPUT
group by term

-- Special Case - If there are two terms only and the cancellation still occurs within the grace period, the standard
--                logic to determine the cancel amount (put overages in the last month) is not desired by the business, 
--                this fix will TEMPORARILY adress the issue until the full code change is implemented
declare  @numberOfTermsInFinal as int = @@ROWCOUNT
if @numberOfTermsInFinal = 2
begin
   declare  @fpcCancelIsWithinGracePeriod as varchar(1) = 'N'
   select   @fpcCancelIsWithinGracePeriod = CASE WHEN DATEDIFF(D,EFFECTIVE_DT,CANCELLATION_DT) <= CRC.FLAT_DAYS_NO THEN 'Y' ELSE 'N' END
   from     FORCE_PLACED_CERTIFICATE FPC
            inner join MASTER_POLICY_ASSIGNMENT MPA on FPC.MASTER_POLICY_ASSIGNMENT_ID = MPA.ID
            inner join CANCEL_RULE_CALC CRC on CRC.CANCEL_PROCEDURE_ID = MPA.CANCEL_PROCEDURE_ID and TYPE_CD = 'PRM'
   where    FPC.ID = @FPC_ID

   -- Confirm that the FPC Cancels within the Grace Period
   if @fpcCancelIsWithinGracePeriod = 'Y'
   begin      

      -- Get the Charges for Term 2
      declare  @chargeTermTwo as decimal(19,2) = 0
      select   @chargeTermTwo = charges 
      from     @FINAL 
      where    term = 2
      
      -- If there are negative charges in term 2, then this scenario 
      -- has occurred, clear out the charges for both terms 1 and 2
      if @chargeTermTwo < 0
         update @FINAL set charges = 0

   end
end

return

end

GO

