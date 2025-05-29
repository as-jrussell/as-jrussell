USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[DeleteUTL]    Script Date: 1/18/2016 2:23:24 PM ******/
DECLARE

	@utlLoanId		bigint = null

	SET @utlLoanId = '142435339'

   --if @utlLoanId = 0
   --   set @utlLoanId = null
      

	    --IF (@utlLoanId is not null)
   BEGIN
	   DELETE FROM UTLMATCH_REQ_COV_RELATE
	   --SELECT * INTO UniTracHDStorage..INC0218468_5 FROM UTLMATCH_REQ_COV_RELATE
	  WHERE UTL_MATCH_RESULT_ID IN (
									SELECT ID
									FROM UTL_MATCH_RESULT
									WHERE UTL_LOAN_ID = 142435339)
									
		DELETE FROM UTL_MATCH_RESULT

	--SELECT * INTO UniTracHDStorage..INC0218468_6 
	
		FROM dbo.UTL_MATCH_RESULT
		WHERE UTL_LOAN_ID = 142435339
		
		DELETE FROM UTL_QUEUE
	--SELECT * INTO UniTracHDStorage..INC0218468_7
		 FROM dbo.UTL_QUEUE
		WHERE LOAN_ID = 142435339	 
   END     	



--(
--63609313,
--63609314,
--63609315)