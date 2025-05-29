USE [Unitrac_Reports]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetOutstandingFinancialTxns]    Script Date: 8/10/2017 6:42:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[fn_GetOutstandingFinancialTxns]( 
   @FPC_ID bigint,
   @BILLING_GROUP_ID bigint = 0
)

RETURNS @Results TABLE (
   fpc_id bigint,
   ftx_id bigint,
   term_no int,
   amount_no decimal(18,2)
)

AS

BEGIN

	DECLARE @Transactions TABLE(ftx_id bigint, ftpt_id bigint, fpc_id bigint, ftx_type_cd nvarchar(10), new_txn_in char(1), amount_no decimal(18,2), running_total decimal(18,2), term_no int, transaction_dt datetime2(7), create_dt datetime2(7), rownumber int) 
	DECLARE @Output TABLE (ftx_id bigint, fpc_id bigint, amount_no decimal(18,2), running_total decimal(18,2), term_no int, transaction_dt datetime2(7), ftx_type_cd nvarchar(10),rownumber int)

	--Get all the transactions for the given FPC and order them by Transaction Date and then term.  
	--If BillingGroupId is not provided (i.e. default 0), retrieve New Transactions across billing groups; otherwise, retrieve only those belonging to the provided BillingGroupId
	IF @BILLING_GROUP_ID > 0
	BEGIN
		Insert Into @Transactions (ftx_id, ftpt_id,fpc_id, ftx_type_cd, new_txn_in, amount_no, term_no, transaction_dt, create_dt, rowNumber)
		Select 
			ftx.ID, ftptd.ID, fpc.ID, ftx.TXN_TYPE_CD, fta.NEW_TXN_IN, 
			ISNULL(ftptd.AMOUNT_NO, ftx.AMOUNT_NO), 
			ISNULL(ftptd.term_no, ftx.term_no), 
			ftx.TXN_DT, ftx.CREATE_DT,
			(ROW_NUMBER () Over(order by FPC.ID, FTX.TXN_DT, FTX.term_no desc)) as rownumber		
		From     FORCE_PLACED_CERTIFICATE FPC 
					LEFT JOIN FINANCIAL_TXN ftx on FPC.ID = ftx.FPC_ID and ftx.PURGE_DT is null
					LEFT JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION ftptd on ftx.ID = ftptd.FTX_ID and ftptd.PURGE_DT is null
					LEFT JOIN FINANCIAL_TXN_APPLY FTA ON FTX.ID = FTA.FINANCIAL_TXN_ID AND FTA.PURGE_DT IS NULL
		Where fpc.ID = @FPC_ID and FTA.BILLING_GROUP_ID = @BILLING_GROUP_ID AND FTA.HOLD_IN = CASE WHEN FPC.MONTHLY_BILLING_IN = 'Y' THEN 'N' ELSE FTA.HOLD_IN END
		Order By rownumber
	END
	ELSE
	BEGIN
		Insert Into @Transactions (ftx_id, ftpt_id,fpc_id, ftx_type_cd, new_txn_in, amount_no, term_no, transaction_dt, create_dt, rowNumber)
		Select 
			ftx.ID, ftptd.ID, fpc.ID, ftx.TXN_TYPE_CD, fta.NEW_TXN_IN, 
			ISNULL(ftptd.AMOUNT_NO, ftx.AMOUNT_NO), 
			ISNULL(ftptd.term_no, ftx.term_no), 
			ftx.TXN_DT, ftx.CREATE_DT,
			(ROW_NUMBER () Over(order by FPC.ID, FTX.TXN_DT, FTX.term_no desc)) as rownumber		
		From     FORCE_PLACED_CERTIFICATE FPC 
					LEFT JOIN FINANCIAL_TXN ftx on FPC.ID = ftx.FPC_ID and ftx.PURGE_DT is null
					LEFT JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION ftptd on ftx.ID = ftptd.FTX_ID and ftptd.PURGE_DT is null
					LEFT JOIN FINANCIAL_TXN_APPLY FTA ON FTX.ID = FTA.FINANCIAL_TXN_ID AND FTA.PURGE_DT IS NULL
		Where fpc.ID = @FPC_ID and FTA.BILLING_GROUP_ID = @BILLING_GROUP_ID AND FTA.HOLD_IN = CASE WHEN FPC.MONTHLY_BILLING_IN = 'Y' THEN 'N' ELSE FTA.HOLD_IN END
		Order By rownumber
	END	

		
   -- Check if there are any cancel transactions that have term numbers of zero
   -- if there are, then we will need to give those cancel transactions a term.
   -- Place them in a row order based on the create date.
   declare @CancelTransactionsWithNoTerm as table (rownum int, ftx_id bigint, amount_no decimal(18,2))
   declare @CountCancelTxnsWithNoTerms as int = 0
   insert into @CancelTransactionsWithNoTerm 
   select   ROW_NUMBER() OVER (ORDER BY create_dt),
            ftx_id,
            amount_no
   from     @Transactions 
   where    ftx_type_cd = 'C' and term_no = 0
   select @CountCancelTxnsWithNoTerms = @@ROWCOUNT

   if (@CountCancelTxnsWithNoTerms > 0) 
   BEGIN
      
      -- Get the start date of the policy from the cpi activity 
      -- Get the cancel date from the force place certificate
      declare  @issueDate datetime
      declare  @cancelDate datetime
      select   @issueDate = CPIA.START_DT,
               @cancelDate = FPC.CANCELLATION_DT
      from     FORCE_PLACED_CERTIFICATE FPC
               inner join CPI_ACTIVITY CPIA on FPC.CPI_QUOTE_ID = CPIA.CPI_QUOTE_ID 
      where    FPC.ID = @FPC_ID and CPIA.TYPE_CD = 'I'

      -- Create a period table for a full year starting with the issue date
      declare @periodTable as table (termNumber int, startDate datetime, endDate datetime)
      declare  @periodCtr int = 0
      while(@periodCtr < 12) 
      begin
         insert into @periodTable
         select   @periodCtr+1,
                  dateadd(m,@periodCtr,@issueDate),
                  dateadd(m,@periodCtr+1,@issueDate)
         set      @periodCtr = @periodCtr + 1 
      end

      -- Get the Period Term Cancel Started In
      declare  @termCancelStarted int = 0
      select   @termCancelStarted = termNumber
      from     @periodTable
      where    @cancelDate >= startDate and @cancelDate < endDate

      -- Get all Charge Terms From The Cancel Period and Beyond (in order)
      declare @ftxs as table (rownum int, ftxid bigint, term_no int, amount_no decimal(18,2))
      declare @ftxTotal as int = 0
      insert into @ftxs
      select   ROW_NUMBER() OVER(ORDER BY TERM_NO), FTX.ID, FTX.TERM_NO, FTX.AMOUNT_NO
      from     FINANCIAL_TXN FTX
      where    FPC_ID = @FPC_ID and TERM_NO >= @termCancelStarted and TXN_TYPE_CD = 'R'
      order by TERM_NO
      select @ftxTotal = @@ROWCOUNT
   
      -- Get Total Cancel Amount
      declare  @totalCancelAmount decimal(18,2) = 0.0
      select   @totalCancelAmount = SUM(AMOUNT_NO)
      from     @CancelTransactionsWithNoTerm
      
      -- Distrubute the Total Cancel Amount over each of the terms in order
      declare @cancelListInOrder as table (rownum int, term_no int, amount_no decimal(18,2))
      declare @termCtr int = 1
      while (@termCtr < @ftxTotal) 
      begin
         -- Get the Amount Charge and Term of Each Month
         declare  @termChargeAmount as decimal(18,2) = 0.0
         declare  @termNumber as int
         select   @termChargeAmount = amount_no, 
                  @termNumber = term_no
         from     @ftxs t
         where    rownum = @termCtr

         -- If there is total cancel amount covers all of or less than this
         -- term, then stop here and insert that total cancel amount
         if (@termChargeAmount + @totalCancelAmount >= 0) 
         begin
            insert into @cancelListInOrder values (@termCtr, @termNumber, @totalCancelAmount)
            break
         end
         else
         begin
            -- If there are no more terms, then add any additional 
            -- amount into the first term of the cancel
            if (@termChargeAmount = 0) 
            begin
               update   @cancelListInOrder
               set      amount_no = amount_no + @totalCancelAmount
               where    term_no = @termCancelStarted
               break               
            end
            else
                        
            -- Add the amount in the term as a cancel amount, decrement
            -- the total cancel amount and continue the loop            
            begin
               insert into @cancelListInOrder values (@termCtr, @termNumber, -@termChargeAmount)
               select @totalCancelAmount = @totalCancelAmount + @termChargeAmount
            end
         end

         -- Increment the loop
         set @termCtr = @termCtr + 1
      end

      -- Update the Term Number for each Cancel Transaction in the
      -- Transaction table (with a Term Number of 0)
      declare @updateCancelCtr int = 1
      while (@updateCancelCtr <= @CountCancelTxnsWithNoTerms) 
      begin           
         update   txns  
         set      term_no = clio.term_no
         from     @CancelTransactionsWithNoTerm ctxns
                  inner join @cancelListInOrder clio on ctxns.rownum = clio.rownum
                  inner join @Transactions txns on ctxns.ftx_id = txns.ftx_id

         set @updateCancelCtr = @updateCancelCtr + 1
      end
      
   END
 
	--Calculate the running total for each transaction 
	Insert into @Output (ftx_id, fpc_id, amount_no, running_total, term_no, transaction_dt,ftx_type_cd, rownumber)
	Select max(t1.ftx_id) as ftx_id, t1.fpc_id as FPC_ID, max(t1.amount_no) as Amount_No, SUM(t2.amount_no) as RUNNING_TOTAL, 
	MAX(t1.term_no) as TERM_NO, MAX(t1.transaction_dt) AS TRANSACTION_DT, MAX(t1.ftx_type_cd) as ftx_type_cd,
	MAX(t1.rownumber) as rownumber
	From @Transactions t1, @Transactions t2 
	Where t1.fpc_id = t2.fpc_id and t2.rownumber <= t1.rownumber
	Group By isnull(t1.ftpt_id, t1.ftx_id), t1.fpc_id 
	Order By t1.fpc_id, TRANSACTION_DT desc, rownumber desc 

	--Declare loop variables
	Declare @rownumber as bigint 
	Declare @runningTotal as decimal(18,2)

	--Set the value of the initial loop counter
	Set @rownumber = (Select Top 1 Case When rownumber <> 0 Then rownumber Else null End From @Output)
   
   -- Build a Temporary Output Table
    declare @tmpResults as table (fpc_id bigint, ftx_id bigint, term_no int, amount_no decimal(18,2), ftx_type_cd nvarchar(10),rownumber int)
	declare @tmpResultsWithCancels as table (fpc_id bigint, ftx_id bigint, term_no int, amount_no decimal(18,2), ftx_type_cd nvarchar(10),rownumber int)
	declare @tmpResultsWithPayments as table (fpc_id bigint, ftx_id bigint, term_no int, amount_no decimal(18,2), ftx_type_cd nvarchar(10),rownumber int)

	--Get all the transactions that are outstanding, i.e. after the running total was 0
	While @rownumber is not null
	Begin
		Select @runningTotal = RUNNING_TOTAL from @Output where rownumber = @rownumber
		
		If @runningTotal = 0 or @runningTotal is null
			break;	
		else 
			Begin
	         insert into @tmpResults (fpc_id, ftx_id, term_no, Amount_no, ftx_type_cd, rownumber) 
				Select fpc_id, ftx_id, term_no, amount_no, ftx_type_cd, rownumber 
				From @Output where rownumber = @rownumber

				--update the loop variable to go to the next fin. transaction
				Select @rownumber = max(rownumber) from @Output where rownumber < @rownumber
			End		
	End
	

   -- If there are cancel transactions with no term numbers,
   -- then potentially recombine the totals per term
   if (@CountCancelTxnsWithNoTerms > 0)
      insert into @tmpResultsWithCancels
      select   t.fpc_id,t.ftx_id,t.term_no,totalSum.totalAmountNo, t.ftx_type_cd, t.rownumber
      from     @tmpResults t
               inner join (
                  select   term_no, sum(amount_no) as totalAmountNo
                  from     @tmpResults
                  group by term_no
               ) totalSum on t.term_no = totalSum.term_no
    else
    begin
		insert into @tmpResultsWithCancels
		select * from @tmpResults
    end      
   
   
   --***       
   -- Check if there are any payment transactions that have term numbers of zero
   -- if there are, then we will need to give those payment transactions a term.
   -- Place them in a row order based on the create date.
   --declare @PaymentTransactionsWithNoTerm as table (ftx_id bigint, amount_no decimal(18,2), rownumber int)
   declare @PaymentDistribution as table (amount_no decimal(18,2), term_no int, rownumber int)
   
   declare @CountPaymentTxnsWithNoTerms as int = 0
   declare @runningPaymentTotal decimal(19,2) = 0; 
   
   select  @CountPaymentTxnsWithNoTerms = count(1), 
			@runningPaymentTotal = sum(amount_no)
   from     @tmpResultsWithCancels 
   where    ftx_type_cd = 'P' and term_no = 0
   
  
If @CountPaymentTxnsWithNoTerms > 0
BEGIN
	declare @counter as int
	declare @counterMax as int 

	select @counter = MIN(rownumber),  @counterMax = MAX(rownumber) from @tmpResultsWithCancels

	WHILE @counter <= @counterMax
	BEGIN
 
		DECLARE @amount decimal(19,2) = 0, 
				@txnType char(1)

		SELECT @txnType = ftx_type_cd, @amount = amount_no FROM @tmpResultsWithCancels WHERE  rownumber = @counter

		IF @txnType = 'R'
		BEGIN
	
				IF ABS(@runningPaymentTotal) >= @amount
				BEGIN				   
					   INSERT INTO @PaymentDistribution
					   SELECT -(@amount), term_no, rownumber from @tmpResultsWithCancels where rownumber = @counter
		
		
					   SET @runningpaymenttotal = @runningpaymenttotal + @amount
				END
				ELSE IF ABS(@runningpaymenttotal) >= 0
				BEGIN
			 		INSERT INTO @PaymentDistribution
					SELECT @runningpaymenttotal, term_no, rownumber from @tmpResultsWithCancels where rownumber = @counter
				   
					SET @runningpaymenttotal = 0
				END
		END
		--if there is still payment left after all the charges, create a record with the remaining funds (overfund)  
		IF @counter = @counterMax AND @runningpaymenttotal > 0 
		BEGIN
			INSERT INTO @PaymentDistribution
			SELECT @runningpaymenttotal, rownumber, rownumber from @tmpResultsWithCancels where rownumber = @counter
			SET @runningpaymenttotal = 0
		END
		set @counter = @counter + 1

	END
   
END      
--***
   
   
   If @CountPaymentTxnsWithNoTerms > 0 
   BEGIN
    insert into @tmpResultsWithPayments
      select   t.fpc_id,t.ftx_id,t.term_no, t.amount_no + ISNULL(pd.amount_no,0) as amount_no, t.ftx_type_cd, t.rownumber
      from     @tmpResultsWithCancels t
				left join @PaymentDistribution pd on t.term_no = pd.term_no
		WHERE 1=1 and 
		NOT(t.term_no = 0 and t.ftx_type_cd = 'P')
   END
   ELSE
     begin
		insert into @tmpResultsWithPayments
		select * from @tmpResultsWithCancels
    end      
   
   
      insert into @Results
      select fpc_id, MIN(ftx_id) as ftx_id, term_no, SUM(amount_no) as amount_no 
      from @tmpResultsWithPayments
      group by fpc_id, term_no      
      having SUM(amount_no) <> 0

	RETURN

END


GO

