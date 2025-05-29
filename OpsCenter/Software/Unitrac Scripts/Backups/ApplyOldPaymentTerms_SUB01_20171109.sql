USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[ApplyOldPaymentTerms]    Script Date: 11/9/2017 1:26:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ApplyOldPaymentTerms]

   @lender_code AS varchar(25),
   @updateUserTx AS varchar(50),
   @startDate AS datetime,
   @endDate AS datetime,
   @doInsert bit = 0,
   @showInserts bit = 0

as

begin

SET NOCOUNT ON 

-- Local Variables
DECLARE @lenderid AS BIGINT

-- Finalization Table
DECLARE @appliedPaymentsByFPC AS table (FPC_ID BIGINT, FTX_ID BIGINT, TERM_NO INT, AMOUNT_NO DECIMAL(8,2), DONE_IN INT)

-- Table for FPCS That Have Unposts
DECLARE @skipped AS TABLE (LOAN_NUMBER_TX VARCHAR(25), CERTIFICATE_NUMBER_TX VARCHAR(25), FPC_ID BIGINT, WHY VARCHAR(25))

-- Determine the Lender Id
select @lenderid = ID from LENDER where code_tx = @lender_code

-- Create a list of FPCs to Look at
DECLARE @fpcList AS TABLE (FPC_ID BIGINT)
insert INTO @fpcList
select   fpc.ID
from     FORCE_PLACED_CERTIFICATE fpc
         inner join LOAN l on fpc.LOAN_ID = l.ID
where    l.LENDER_ID = @lenderid
         and @startDate <= fpc.CREATE_DT and fpc.CREATE_DT < @endDate
--         and fpc.ID in (5910090,5910112)
order by fpc.ID

-- Temporary Join Table (FOR PERFORMANCE)
DECLARE @fpcsListTemp AS TABLE (FPC_ID BIGINT, TXN_TYPE_CD VARCHAR(2), FTX_TERM_NO INT, FTPTD_TERM_NO INT, UNPOSTING_IN INT)
INSERT INTO @fpcsListTemp
SELECT   fpclist.FPC_ID, ftx.TXN_TYPE_CD, ftx.TERM_NO, ISNULL(ftptd.TERM_NO, 0), 
         CASE WHEN ftx.AMOUNT_NO > 0 AND TXN_TYPE_CD = 'P' THEN 1 ELSE 0 END
FROM     @fpcList fpclist
         INNER JOIN FINANCIAL_TXN ftx ON fpclist.FPC_ID = ftx.FPC_ID
         LEFT JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION ftptd ON ftptd.FTX_ID = FTX.ID AND ftptd.PURGE_DT IS NULL
            
-- Save All FPCS That Have Unposts
INSERT @skipped
SELECT   L.NUMBER_TX, FPC.NUMBER_TX, FPC.ID, 'unpost'
FROM     FORCE_PLACED_CERTIFICATE FPC
         INNER JOIN LOAN L ON FPC.LOAN_ID = L.ID
WHERE    FPC.ID IN 
         (
            SELECT DISTINCT FPC_ID 
            FROM @fpcsListTemp tmp
            WHERE UNPOSTING_IN = 1
         )

-- Remove Any From the Temporary List that HAVE UNPOSTS
DELETE   a
FROM     @fpcsListTemp a
         inner join @skipped b on a.FPC_ID = b.FPC_ID

/*
Determine the FPCs To Actually Use
Limits:
- FILTER 1: Use FPCs that have Payments with Term 0 (that aren't split)
- FILTER 3: If there is a Payment Term 1, then all payments have occurred after payment terms went live.
   * DO NOT INCLUDE ANY PAYMENTS WITH TERM ZERO IF A PAYMENT TERM 1 HAS OCCURRED (i.e. Unpostings)
*/
DECLARE @fpcsToUse AS TABLE (FPC_ID BIGINT)
INSERT INTO @fpcsToUse
SELECT   distinct fpclist.FPC_ID
FROM     @fpcList fpclist
         INNER JOIN @fpcsListTemp tmp ON tmp.FPC_ID = fpclist.FPC_ID
         
         -- FILTER 3
         OUTER APPLY
         (
            select   CASE WHEN FPC_ID IS NULL THEN 0 ELSE 1 END HAS_TERM_ONE
            from     @fpcsListTemp
            where    FPC_ID = fpclist.FPC_ID
                     and TXN_TYPE_CD = 'P'
                     and FTPTD_TERM_NO = 1
         ) PAYMENT_TERM_CHECK

WHERE    tmp.TXN_TYPE_CD = 'P'
         and tmp.FPC_ID IN 

         -- FILTER 1
         (
            select   FPC_ID
            from     @fpcsListTemp
            where    FPC_ID = fpclist.FPC_ID
                     and TXN_TYPE_CD = 'P'
            group by FPC_ID
            having   MIN(ISNULL(FTPTD_TERM_NO,FTX_TERM_NO)) = 0
         )
         AND PAYMENT_TERM_CHECK.HAS_TERM_ONE IS NULL
                           
-- Get all the Payments By FPC
-- * Only include items in here that HAVE payments that are in Term 0 and that are not split out
DECLARE @paymentFPCsNonTermifiedCount INT = 0
DECLARE @paymentsByFPC AS TABLE (ROWNUM INT, FPC_ID BIGINT, FTX_ID BIGINT, AMOUNT_NO DECIMAL(8,2), TERM_NO INT)
INSERT INTO @paymentsByFPC
SELECT   ROW_NUMBER() OVER (ORDER BY fpclist.FPC_ID, ftx.ID), 
         ftx.FPC_ID, 
         ftx.ID, 
         ftx.AMOUNT_NO, 
         CASE WHEN ftptd.ID IS NULL THEN 0 ELSE ftptd.TERM_NO END
FROM     @fpcsToUse fpclist
         INNER JOIN FINANCIAL_TXN ftx ON fpclist.FPC_ID = ftx.FPC_ID and ftx.PURGE_DT IS NULL
         LEFT JOIN FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION ftptd ON ftptd.FTX_ID = ftx.ID and ftptd.PURGE_DT IS NULL
WHERE    ftx.TXN_TYPE_CD = 'P'

-- Get a count of FPCs that have at payment terms with term zero 
select @paymentFPCsNonTermifiedCount = @@ROWCOUNT
            
-- Confirm that there are Payments that are Not Termified
IF @paymentFPCsNonTermifiedCount > 0
BEGIN

   -- Get the Amounts Due Per FPC Per Not Split Term
   -- * But only use terms that occurred BEFORE the first termified term
   -- * And terms that are less than or equal to the greatest termified term if there one otherwise use them all
   DECLARE  @amountsDue AS table (ROWNUM INT, FPC_ID BIGINT, TERM_NO INT, AMOUNT_NO DECIMAL(8,2), DONE_IN INT)
   insert INTO @amountsDue
   select   ROW_NUMBER() OVER (ORDER BY FTX.FPC_ID ASC, FTX.TERM_NO ASC), FTX.FPC_ID, FTX.TERM_NO, FTX.AMOUNT_NO, 0
   from     FINANCIAL_TXN FTX
            INNER JOIN (select distinct FPC_ID from @paymentsByFPC) pmt on FTX.FPC_ID = pmt.FPC_ID
   where    FTX.TXN_TYPE_CD = 'R'
            and FTX.PURGE_DT IS NULL
            and FTX.TERM_NO NOT IN (select TERM_NO from @paymentsByFPC where FPC_ID = FTX.FPC_ID)
            and FTX.TERM_NO <= 
               CASE WHEN (select MAX(TERM_NO) from @paymentsByFPC where FPC_ID = FTX.FPC_ID) > 0 THEN 
                  (select MAX(TERM_NO) from @paymentsByFPC where FPC_ID = FTX.FPC_ID)
               ELSE 
                  FTX.TERM_NO END
            
   -- Loop thru each of the Payments to Distribute Per FPC
   DECLARE @paymentsToDistributeCounter AS INT = 1, @wasUnpostingRowLast AS INT = 0
   while @paymentsToDistributeCounter <= @paymentFPCsNonTermifiedCount
   begin

      -- Outer Loop Variables
      DECLARE  @fpcId AS BIGINT, @ftxId AS BIGINT, @amountToDistribute AS DECIMAL(8,2)
      select   @fpcId = FPC_ID,
               @ftxId = FTX_ID,
               @amountToDistribute = AMOUNT_NO
      from     @paymentsByFPC
      where    ROWNUM = @paymentsToDistributeCounter
      
      -- Handle "Non-Termified" Unposting
      -- * It will apply the unposting to the last item that was DONE fully
      if @amountToDistribute > 0
      begin
         insert INTO @appliedPaymentsByFPC values (@fpcId, @ftxId, 
            (select MAX(TERM_NO) from @amountsDue where DONE_IN = 1), @amountToDistribute, 0)
      end
      else
      begin
               
         -- Create a Table for the Amounts Still Due for FPCs
         DECLARE @amountsDueForFPC AS table (ROWNUM INT, TERM_NO INT, AMOUNT_NO DECIMAL(8,2))
         insert INTO @amountsDueForFPC
         select   ROW_NUMBER() OVER (ORDER BY TERM_NO), TERM_NO, AMOUNT_NO 
         from     @amountsDue 
         where    FPC_ID = @fpcId 
                  and DONE_IN = 0
         DECLARE @amountsDueForFPCCount AS INT = @@ROWCOUNT
         DECLARE @amountsDueForFPCCounter AS INT = 1

         -- Get a temporary variable to track the distribution amount AS it decrements
         DECLARE @workingAmountToDistribute AS DECIMAL(8,2) = @amountToDistribute

         while @amountsDueForFPCCounter <= @amountsDueForFPCCount
         begin
               
            -- Inner Loop Variables
            DECLARE  @term AS INT, @termAmount AS DECIMAL(8,2)
            select   @term = TERM_NO, 
                     @termAmount = AMOUNT_NO 
            from     @amountsDueForFPC 
            where    ROWNUM = @amountsDueForFPCCounter
                  
            -- Set if this term already had some payment distributed for it
            DECLARE @amountAlreadyforFPCTerm AS DECIMAL(8,2) = 0
            select @amountAlreadyforFPCTerm = ISNULL(SUM(AMOUNT_NO),0) from @appliedPaymentsByFPC where FPC_ID = @fpcId and TERM_NO = @term

            -- Update the term amount to cover if some has been covered already
            select @termAmount = @termAmount + @amountAlreadyforFPCTerm
                  
            -- Decrement the Term Amount form the Working Amount
            if @workingAmountToDistribute + @termAmount <= 0
            begin

               -- Update the Amounts Due Table that this term for this FPC is complete
               update @amountsDue set done_in = 1 where FPC_ID = @fpcId and TERM_NO = @term
                  
               -- Insert INTO the final non-termified split table

               -- Check if the next amount is an unposting, then break
               -- out and the unposting will be handled on the next loop
               DECLARE @nextPaymentAmount DECIMAL(8,2) = 0
               select top 1 @nextPaymentAmount = AMOUNT_NO from @paymentsByFPC where ROWNUM > @paymentsToDistributeCounter
               if @nextPaymentAmount > 0 
               begin
                  -- Take the unposting off the term amount and insert it INTO the final non-termified split table
                  if not exists(select 1 from FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION where FTX_ID = @ftxId and TERM_NO = @term and PURGE_DT is null)
                  begin
                     insert INTO @appliedPaymentsByFPC values (@fpcId, @ftxId, @term, -@termAmount - @nextPaymentAmount, 0)
                  end
                  else                     
                     INSERT @skipped
                     SELECT   L.NUMBER_TX, FPC.NUMBER_TX, @fpcId, 'already inserted A'
                     FROM     FORCE_PLACED_CERTIFICATE fpc
                              inner join LOAN l on fpc.LOAN_ID = l.ID
                     WHERE    fpc.ID = @fpcId
                  break;
               end
               else
               begin
                  if not exists(select 1 from FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION where FTX_ID = @ftxId and TERM_NO = @term and PURGE_DT is null)
                  begin
                     insert INTO @appliedPaymentsByFPC values (@fpcId, @ftxId, @term, -@termAmount, 0)
                  end
                  else                     
                     INSERT @skipped
                     SELECT   L.NUMBER_TX, FPC.NUMBER_TX, @fpcId, 'already inserted B'
                     FROM     FORCE_PLACED_CERTIFICATE fpc
                              inner join LOAN l on fpc.LOAN_ID = l.ID
                     WHERE    fpc.ID = @fpcId
               end

               -- Decrement the Working Amount
               select @workingAmountToDistribute = @workingAmountToDistribute + @termAmount

               -- If the working amount is greater than or equal to zero then break out
               if @workingAmountToDistribute >= 0 break;

            end

            -- The working amount didn't cover everything in the term, so insert that amount for this term and break out
            else
            begin
               if not exists(select 1 from FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION where FTX_ID = @ftxId and TERM_NO = @term and PURGE_DT is null)
               begin
                  insert INTO @appliedPaymentsByFPC values (@fpcId, @ftxId, @term, @workingAmountToDistribute, 0)
               end
               else                     
                  INSERT @skipped
                  SELECT   L.NUMBER_TX, FPC.NUMBER_TX, @fpcId, 'already inserted C'
                  FROM     FORCE_PLACED_CERTIFICATE fpc
                           inner join LOAN l on fpc.LOAN_ID = l.ID
                  WHERE    fpc.ID = @fpcId
               break;
            end

            -- Increment the Counter
            select @amountsDueForFPCCounter = @amountsDueForFPCCounter + 1
         end
      end

      -- Increment the Counter
      set @paymentsToDistributeCounter = @paymentsToDistributeCounter + 1
   end

end
   
/*
------------------------------------------------------------------------
Insert into the FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION table in batches
------------------------------------------------------------------------
*/

DECLARE @batchCounter AS INT = 1

-- Loop Thru the Batches
while 1=1
begin

   DECLARE @batchItemsCount INT = 0 

   DECLARE @batchItems AS table (FPC_ID BIGINT, FTX_ID BIGINT, TERM_NO INT, AMOUNT_NO DECIMAL(18,2))
   insert INTO @batchItems
   select   top 1000 FPC_ID, FTX_ID, TERM_NO, AMOUNT_NO
   from     @appliedPaymentsByFPC
   where    DONE_IN = 0

   -- Get the count of items that are going to be inserted
   select @batchItemsCount = @@ROWCOUNT

   -- If there is nothing else to insert then split out
   if @batchItemsCount > 0 
      print 'Batch #: ' + cast(@batchCounter AS varchar(25)) + ' - ' + cast(@batchItemsCount AS varchar(25)) + ' terms inserted'
   else
      break;

   -- Insert the new payment split rows
   if @doInsert = 1
   begin
      INSERT INTO FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION 
         (FTX_ID,AMOUNT_NO,TERM_NO,IS_OVERAGE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,PURGE_DT,LOCK_ID)
      select FTX_ID, AMOUNT_NO, TERM_NO, 'N', GETDATE(), GETDATE(), @updateUserTx, NULL, 1 from @batchItems
   end
   else if @showInserts = 1
      -- Don't do the inserts ... just show them         
      select 'TO INSERT', fpc.number_tx, a.FTX_ID, a.AMOUNT_NO, a.TERM_NO, 'N', GETDATE(), GETDATE(), @updateUserTx, NULL, 1 from @batchItems a
         inner join FORCE_PLACED_CERTIFICATE fpc on fpc.ID = a.FPC_ID

   -- Update DONE Indicator
   update   ps
   set      ps.DONE_IN = 1
   from     @batchItems t inner join @appliedPaymentsByFPC ps on t.FPC_ID = ps.FPC_ID and t.FTX_ID = ps.FTX_ID

   -- Increment the Batch Counter
   set @batchCounter = @batchCounter + 1

   -- Clear Loop Table
   delete from @batchItems

end

select 'SKIPPED', * from @skipped

set nocount off

end
GO

