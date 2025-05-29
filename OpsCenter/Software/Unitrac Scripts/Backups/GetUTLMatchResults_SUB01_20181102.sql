USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetUTLMatchResults]    Script Date: 11/2/2018 12:53:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec [GetUTLMatchResults] 0, 23418, 83
ALTER PROCEDURE [dbo].[GetUTLMatchResults]
(
 @id   bigint = null,
 @utlLoanId   bigint = null,
 @utlPropertyId   bigint = null,
 @propertyId	bigint = null,
 @applyStatus nvarchar(10) = null 
 )
AS
BEGIN
   SET NOCOUNT ON
   if @id = 0
      set @id = null
   if @utlLoanId = 0
      set @utlLoanId = null
   if @utlPropertyId = 0
      set @utlPropertyId = null
   if @propertyId = 0
      set @propertyId = null

   IF (@id is not null)
   BEGIN	
	   SELECT
		  ID,
		  UTL_LOAN_ID,
		  UTL_PROPERTY_ID,
		  AGENCY_ID,
		  PROPERTY_ID,
		  LOAN_ID,
		  UTL_OWNER_POLICY_ID,
		  UTL_VERSION_NO,
		  SCORE_NO,
		  SCORE_PERCENT_NO,
		  SCORE_DETAIL_XML,
		  MATCH_RESULT_CD,
		  USER_MATCH_RESULT_CD,
		  USER_MATCH_TX,
		  MSG_LOG_TX,
		  LOG_TX,
		  APPLY_STATUS_CD,
		  CRITERIA_XML,
		  ESCROW_IN,
		  CREATE_DT,
		  LOCK_ID
	   FROM UTL_MATCH_RESULT
	   WHERE
		  ID = @id
		OPTION (RECOMPILE)	
	END
	ELSE IF (@utlLoanId is not null and @utlPropertyId is null and @propertyId is not null)
	BEGIN
	  SELECT
		  ID,
		  UTL_LOAN_ID,
		  UTL_PROPERTY_ID,
		  AGENCY_ID,
		  PROPERTY_ID,
		  LOAN_ID,
		  UTL_OWNER_POLICY_ID,
		  UTL_VERSION_NO,
		  SCORE_NO,
		  SCORE_PERCENT_NO,
		  SCORE_DETAIL_XML,
		  MATCH_RESULT_CD,
		  USER_MATCH_RESULT_CD,
		  USER_MATCH_TX,
		  MSG_LOG_TX,
		  LOG_TX,
		  APPLY_STATUS_CD,
		  CRITERIA_XML,
		  ESCROW_IN,
		  CREATE_DT,
		  LOCK_ID
	   FROM UTL_MATCH_RESULT
	   WHERE
		  UTL_LOAN_ID = @utlLoanId
		  AND PROPERTY_ID = @propertyId
		  AND PURGE_DT IS NULL
		OPTION (RECOMPILE)	
	END
	ELSE IF (@utlLoanId is not null and @utlPropertyId is not null and @propertyId is not null)
	BEGIN
	  SELECT
		  ID,
		  UTL_LOAN_ID,
		  UTL_PROPERTY_ID,
		  AGENCY_ID,
		  PROPERTY_ID,
		  LOAN_ID,
		  UTL_OWNER_POLICY_ID,
		  UTL_VERSION_NO,
		  SCORE_NO,
		  SCORE_PERCENT_NO,
		  SCORE_DETAIL_XML,
		  MATCH_RESULT_CD,
		  USER_MATCH_RESULT_CD,
		  USER_MATCH_TX,
		  MSG_LOG_TX,
		  LOG_TX,
		  APPLY_STATUS_CD,
		  CRITERIA_XML,
		  ESCROW_IN,
		  CREATE_DT,
		  LOCK_ID
	   FROM UTL_MATCH_RESULT
	   WHERE
		  UTL_LOAN_ID = @utlLoanId
		  AND UTL_PROPERTY_ID = @utlPropertyId
		  AND PROPERTY_ID = @propertyId
		  AND PURGE_DT IS NULL
		OPTION (RECOMPILE)	
	END
	ELSE IF (@utlLoanId is not null and @propertyId is null)
	BEGIN
	  SELECT
		  ID,
		  UTL_LOAN_ID,
		  UTL_PROPERTY_ID,
		  AGENCY_ID,
		  PROPERTY_ID,
		  LOAN_ID,
		  UTL_OWNER_POLICY_ID,
		  UTL_VERSION_NO,
		  SCORE_NO,
		  SCORE_PERCENT_NO,
		  SCORE_DETAIL_XML,
		  MATCH_RESULT_CD,
		  USER_MATCH_RESULT_CD,
		  USER_MATCH_TX,
		  MSG_LOG_TX,
		  LOG_TX,
		  APPLY_STATUS_CD,
		  CRITERIA_XML,
		  ESCROW_IN,
		  CREATE_DT,
		  LOCK_ID
	   FROM UTL_MATCH_RESULT
	   WHERE
		  UTL_LOAN_ID = @utlLoanId
		  AND PURGE_DT IS NULL
		OPTION (RECOMPILE)	
	END	
   --- Added by AD - 04/09/12
	ELSE IF ISNULL(@applyStatus,'') <> ''
	BEGIN
	  SELECT TOP 10000
		  ID,
		  UTL_LOAN_ID,
		  UTL_PROPERTY_ID,
		  AGENCY_ID,
		  PROPERTY_ID,
		  LOAN_ID,
		  UTL_OWNER_POLICY_ID,
		  UTL_VERSION_NO,
		  SCORE_NO,
		  SCORE_PERCENT_NO,
		  SCORE_DETAIL_XML,
		  MATCH_RESULT_CD,
		  USER_MATCH_RESULT_CD,
		  USER_MATCH_TX,
		  MSG_LOG_TX,
		  LOG_TX,
		  APPLY_STATUS_CD,
		  CRITERIA_XML,
		  ESCROW_IN,
		  CREATE_DT,
		  LOCK_ID
	   FROM UTL_MATCH_RESULT
	   WHERE APPLY_STATUS_CD = @applyStatus
	   AND PURGE_DT IS NULL
	   AND UTL_LOAN_ID NOT IN (
								SELECT UTL_LOAN_ID
								FROM UTL_MATCH_RESULT
								WHERE APPLY_STATUS_CD = 'HOLD'
								AND UTL_LOAN_ID IN (
													SELECT UTL_LOAN_ID
													FROM UTL_MATCH_RESULT
													WHERE APPLY_STATUS_CD = @applyStatus
													)
								)
		ORDER BY ID
		OPTION (RECOMPILE)	   
	END
	--- End Added - 04/09/02
END

GO

