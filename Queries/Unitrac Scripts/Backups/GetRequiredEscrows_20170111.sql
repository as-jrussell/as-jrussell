USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[GetRequiredEscrows]    Script Date: 1/11/2017 1:19:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DECLARE

  @id   bigint = null,
  @requiredCoverageId  bigint = null

SET @requiredCoverageId = '4372019'


BEGIN
   SET NOCOUNT ON
   
   if @id is not null and @id > 0 
     BEGIN
	   SELECT
		  ID,
		  REQUIRED_COVERAGE_ID,
		  TYPE_CD,
		  SUB_TYPE_CD,
		  EXCESS_IN,
		  ACTIVE_IN,
		  LOCK_ID,
		  STATUS_CD,
		  SUB_STATUS_CD,
		  PAID_THRU_DT
	   FROM REQUIRED_ESCROW
	   WHERE
		  ID = @id
	END
  else if @requiredCoverageId > 0
	BEGIN 
	  SELECT
		  ID,
		  REQUIRED_COVERAGE_ID,
		  TYPE_CD,
		  SUB_TYPE_CD,
		  EXCESS_IN,
		  ACTIVE_IN,
		  LOCK_ID,
		  STATUS_CD,
		  SUB_STATUS_CD,
		  PAID_THRU_DT
	   FROM REQUIRED_ESCROW
	   WHERE REQUIRED_COVERAGE_ID = @requiredCoverageId
	   AND PURGE_DT IS NULL
	END
END

