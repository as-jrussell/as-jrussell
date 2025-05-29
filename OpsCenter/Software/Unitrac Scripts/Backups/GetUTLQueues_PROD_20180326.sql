USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetUTLQueues]    Script Date: 3/26/2018 4:05:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--EXEC [GetUTLQueues] @queueMode=2
--EXEC [GetUTLQueues] @lenderId=317, @coverageGroup='vehicle'
ALTER PROCEDURE [dbo].[GetUTLQueues]
(
	@loanId					bigint = null,
	@lenderId				bigint = null,
	@queueItemAgeMinutes	int = -15,
	@coverageGroup			nvarchar(20) = null
)
AS
BEGIN
   SET NOCOUNT ON
   if @loanId = 0
      set @loanId = null
   if @lenderId = 0
      set @lenderId = null
   if @queueItemAgeMinutes > 0
	  set @queueItemAgeMinutes = @queueItemAgeMinutes * -1
   
   IF (@loanId is not null)
   BEGIN   
	   SELECT
		  LOAN_ID,
		  LENDER_ID,
		  RECORD_TYPE_CD,
		  EVALUATION_DT,
		  CREATE_DT,
		  LOCK_ID
	   FROM UTL_QUEUE
	   WHERE
		  LOAN_ID = @loanId
   END
   ELSE IF (@lenderId is not null and @coverageGroup is null)
   BEGIN
	   SELECT
		  LOAN_ID,
		  LENDER_ID,
		  RECORD_TYPE_CD,
		  EVALUATION_DT,
		  CREATE_DT,
		  LOCK_ID
	   FROM UTL_QUEUE
	   WHERE
		  LENDER_ID = @lenderId
		  AND EVALUATION_DT = CONVERT(DATE, '1/1/1900')   
		  AND UPDATE_DT < DATEADD(MINUTE, @queueItemAgeMinutes, GETDATE())
		  AND PURGE_DT IS NULL
		  ORDER BY EVALUATION_DT ASC
   END
   ELSE IF (@lenderId is not null and @coverageGroup is not null)
   BEGIN
		SELECT
		  Q.LOAN_ID,
		  Q.LENDER_ID,
		  Q.RECORD_TYPE_CD,
		  Q.EVALUATION_DT,
		  Q.CREATE_DT,
		  Q.LOCK_ID
		FROM UTL_QUEUE Q
			JOIN COLLATERAL COL ON COL.LOAN_ID = Q.LOAN_ID AND COL.PRIMARY_LOAN_IN='Y' AND COL.PURGE_DT IS NULL
			JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = COL.PROPERTY_ID AND RC.PURGE_DT IS NULL
			JOIN REF_CODE REF ON REF.DOMAIN_CD = 'Coverage' AND REF.CODE_CD = RC.TYPE_CD
			JOIN REF_CODE_ATTRIBUTE RCA ON RCA.REF_CD = REF.CODE_CD AND RCA.DOMAIN_CD = 'Coverage' AND RCA.ATTRIBUTE_CD='CoverageGroup'
		WHERE Q.LENDER_ID = @lenderId
		  AND Q.EVALUATION_DT = CONVERT(DATE, '1/1/1900')   
		  AND Q.UPDATE_DT < DATEADD(MINUTE, @queueItemAgeMinutes, GETDATE())
		  AND RCA.VALUE_TX = @coverageGroup
		  AND Q.PURGE_DT IS NULL
		  ORDER BY Q.EVALUATION_DT ASC
	END	
END

GO

