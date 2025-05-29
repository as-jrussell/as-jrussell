USE [QCModule]
GO

/****** Object:  StoredProcedure [dbo].[GetQCBatchItems]    Script Date: 11/19/2018 1:13:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetQCBatchItems]
(
	@batchid   bigint,
	@lenderid   bigint = null,
	@PageNumber  int = 0,
	@NumOfRowsToDisplay int = 0
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @select NVARCHAR(MAX)
	DECLARE @joins NVARCHAR(MAX)
	DECLARE @where NVARCHAR(MAX)
	DECLARE @order NVARCHAR(MAX)
	DECLARE @query NVARCHAR(MAX)

	-- SELECT Clause
	SELECT @select = 'SELECT
      ID,
      QC_BATCH_ID,
      LOAN_ID,
      NUMBER_TX,
      FIRST_NAME_TX,
      MIDDLE_INITIAL_TX,
      LAST_NAME_TX,
      LOAN_CREATE_DT,
      PROPERTY_ID,
	  PROPERTY_TYPE_CD,
	  PROPERTY_DESCRIPTION_TX,
      LINE_1_TX,
      LINE_2_TX,
      CITY_TX,
      STATE_PROV_TX,
      POSTAL_CODE_TX,
      YEAR_TX,
      MAKE_TX,
      MODEL_TX,
      BODY_TX,
      VIN_TX,
      REQUIRED_COVERAGE_ID,
      REQUIRED_COVERAGE_TYPE_CD,
      SUMMARY_STATUS_CD,
      SUMMARY_SUB_STATUS_CD,	  
	  LENDER_ID,
	  LENDER_CODE,
	  LENDER_NAME,
      LOCK_ID
	'
	
	-- From/Join Clauses
	SELECT @joins = 'FROM QC_BATCH_ITEM
	'
    
	-- Where Clauses
	SELECT @where = 'WHERE QC_BATCH_ID = @batchid AND PURGE_DT IS NULL 
	'

	if (@lenderid IS NOT NULL)
		SELECT @where = @where + 'AND LENDER_ID = @lenderid '
   
	-- Order Clauses
	SELECT @order = 'ORDER BY ID '
   
	-- Add Paging Information if the Page Number and Number of Rows To Display is set
	IF @PageNumber > 0 AND @NumOfRowsToDisplay > 0
		SELECT @order = @order + 'OFFSET ((@PageNumber - 1) * @NumOfRowsToDisplay) ROWS FETCH NEXT @NumOfRowsToDisplay ROWS ONLY'
	
	-- Build Query
	SELECT @query =  @select + @joins + @where + @order

	-- Execute Dynamic Query
	EXEC sys.sp_executesql @query, 
		 N'	@batchid BIGINT, @lenderid BIGINT, @PageNumber INT, @NumOfRowsToDisplay INT',
		 @batchid,
		 @lenderid,
		 @PageNumber,
		 @NumOfRowsToDisplay
END

GO


