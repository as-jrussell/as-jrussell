USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[UndoCheckoutTransactionDataLoanExtract]    Script Date: 9/5/2017 10:42:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[UndoCheckoutTransactionDataLoanExtract]
(
   @documentId bigint,
   @checkOutOwnerId bigint
)  
as 
begin
   update LOAN_EXTRACT_TRANSACTION_DETAIL
   set CHECKED_OUT_OWNER_ID = null, 
      CHECKED_OUT_DT = null, 
      lock_id = letd.lock_id + 1
   from LOAN_EXTRACT_TRANSACTION_DETAIL letd
      inner join [TRANSACTION] t on t.id = letd.TRANSACTION_ID
      inner join [DOCUMENT] d on d.id = t.DOCUMENT_ID
   where DOCUMENT_ID = @documentId and CHECKED_OUT_OWNER_ID = @checkOutOwnerId
   OPTION (QUERYTRACEON 9481)
end

