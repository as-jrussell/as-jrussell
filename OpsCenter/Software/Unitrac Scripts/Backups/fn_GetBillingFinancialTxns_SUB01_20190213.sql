USE [Unitrac_Reports]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetBillingFinancialTxns]    Script Date: 2/13/2019 11:40:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[fn_GetBillingFinancialTxns]( 
   @FPC_ID bigint,
   @BILLING_GROUP_ID bigint = 0,
   @ShowAllTransactions int = 1
)

RETURNS @Results TABLE (
   fpc_id bigint,
   ftx_id bigint,
   TERM_NO int,
   AMOUNT_NO decimal(18,2),
   IS_PREV_BILL_FILE_BY_TERM varchar(5),
   STATEMENT_DT datetime,
   LENDER_INTENT_TX varchar(50),
   IsHold varchar(5)
   
)

AS

BEGIN

	--Get all the transactions for the given FPC and the statement date of the most recent unpaid receivable  
	
	IF @BILLING_GROUP_ID > 0 AND @FPC_ID > 0
	BEGIN
		    
      insert into @Results
	  SELECT f.FPC_ID, f.ftx_ID, f.TERM_NO, f.AMOUNT_NO,TBL2.IS_PREV_BILL_FILE_BY_TERM,bg.STATEMENT_DT,fta.LENDER_INTENT_TX,TBL3.IsHold
			FROM dbo.fn_GetOutstandingFinancialTxns(@FPC_ID, @BILLING_GROUP_ID, default) f
			JOIN FINANCIAL_TXN ft on f.ftx_id = ft.ID and ft.PURGE_DT IS NULL
			JOIN FINANCIAL_TXN_APPLY fta on ft.ID = fta.FINANCIAL_TXN_ID and fta.PURGE_DT is null and fta.NEW_TXN_IN = 'Y'
			JOIN BILLING_GROUP BG ON FTA.BILLING_GROUP_ID = BG.ID AND BG.PURGE_DT IS NULL
               
            -- Since this is an all transactions lookup, the system needs to   
            -- check the FPC by TERM to see if any items were on previous bills
            OUTER APPLY
	            (	select case when exists (select *				  
		            from FINANCIAL_TXN_APPLY fta
		            inner join FINANCIAL_TXN ftn on ftn.ID = fta.FINANCIAL_TXN_ID 
				            and ftn.PURGE_DT is null 
				            and ftn.FPC_ID = @FPC_ID
                        and ftn.TERM_NO = ft.TERM_NO
		            inner join WORK_ITEM wi on wi.RELATE_ID = fta.BILLING_GROUP_ID 
				            and wi.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup' 
				            and wi.PARENT_ID is null
				            and 
				            ((wi.CONTENT_XML.value ('(//Content//Message//MessageId)[1]', 'varchar(50)') is not null) or
				            (wi.CONTENT_XML.value ('(//Content//Message//ChargeMessageId)[1]', 'varchar(50)') is not null) or
				            (wi.CONTENT_XML.value ('(//Content//Message//RefundMessageId)[1]', 'varchar(50)') is not null))
		            where fta.HOLD_IN = 'N'
				            and fta.BILLING_GROUP_ID != @BILLING_GROUP_ID
				            and fta.PURGE_DT is null
				            )  then 1 else 0 end 
	                ) TBL2 (IS_PREV_BILL_FILE_BY_TERM)

               -- Look at all of the financial transactions for each fpc
               -- and billing group by term and determine "on hold" states
               OUTER APPLY
               (
                  SELECT   CASE WHEN ISNULL(HOLD_IN, 'N') = 'Y' THEN 1 ELSE 0 END AS IsHold
                  FROM     FINANCIAL_TXN FTXH
                           INNER JOIN FINANCIAL_TXN_APPLY FTAH
                              ON FTXH.ID = FTAH.FINANCIAL_TXN_ID AND FTAH.PURGE_DT IS NULL
                  WHERE    BILLING_GROUP_ID = @BILLING_GROUP_ID
                           AND FTXH.FPC_ID = @FPC_ID
                           AND FTXH.TERM_NO = f.term_no
                           AND FTXH.PURGE_DT IS NULL
                  GROUP BY HOLD_IN
               ) TBL3

			WHERE @ShowAllTransactions = 1

	END

	RETURN

END


GO

