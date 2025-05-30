USE [UniTrac]
GO

/****** Object:  UserDefinedFunction [dbo].[GetQCInsuranceExpiredNotices]    Script Date: 9/3/2021 10:32:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetQCInsuranceExpiredNotices] 
(
	@lenderIds nvarchar(max),
	@coverageType nvarchar(max),
	@lastRunDate datetime = null
)
RETURNS @t TABLE 
	(LOAN_ID BIGINT, 
	 PROPERTY_ID BIGINT, 
	 REQUIRED_COVERAGE_ID BIGINT
	)  
AS
BEGIN
		
	DECLARE @lenderList TABLE (ID BIGINT)
	DECLARE @coverageList TABLE (TYPE_CD NVARCHAR(30))
	DECLARE @tmpList TABLE 
		(
			LOAN_ID BIGINT,
			PROPERTY_ID BIGINT,
			REQUIRED_COVERAGE_ID BIGINT,
			RC_TYPE_CD NVARCHAR(30),
			BIC_ID BIGINT,
			EXPIRATION_DT DATETIME
		)

	INSERT INTO @lenderList 
	SELECT ID FROM GetSelectedLenderIds(@lenderIds)

	INSERT INTO @coverageList 
	SELECT STRVALUE FROM SplitFunction(@coverageType, ',')

	DECLARE @expirationDateCheck as DATE = cast('12/31/9999' as DATE)

	INSERT INTO @tmpList
	SELECT DISTINCT ln.ID LOAN_ID, pr.ID PROPERTY_ID, rc.ID REQUIRED_COVERAGE_ID
		, rc.TYPE_CD, currCov.BIC_ID, currCov.EXPIRATION_DT
	FROM @lenderList ldrList
		JOIN LOAN ln ON ln.LENDER_ID = ldrList.ID AND ln.PURGE_DT IS NULL
		JOIN COLLATERAL col ON col.LOAN_ID = ln.ID AND col.PURGE_DT IS NULL
		JOIN PROPERTY pr ON pr.ID = col.PROPERTY_ID AND pr.PURGE_DT IS NULL
		JOIN REQUIRED_COVERAGE rc ON rc.PROPERTY_ID = pr.ID AND rc.PURGE_DT IS NULL
		JOIN @coverageList cvList ON cvList.TYPE_CD = rc.TYPE_CD
		CROSS APPLY (SELECT TOP 1 BIC_ID, EXPIRATION_DT FROM dbo.GetCurrentCoverage(pr.ID, rc.ID, rc.TYPE_CD)) currCov 			
	WHERE ln.RECORD_TYPE_CD = 'G'	
	AND ln.STATUS_CD IN ('A', 'B')
	AND col.STATUS_CD = 'A'
	AND pr.RECORD_TYPE_CD = 'G'		
	AND rc.RECORD_TYPE_CD = 'G'
	AND rc.STATUS_CD = 'A'
	AND rc.SUMMARY_SUB_STATUS_CD = 'D'
	AND rc.SUMMARY_STATUS_CD IN ('E', 'F')
	AND currCov.EXPIRATION_DT iS NOT NULL
	AND cast(currCov.EXPIRATION_DT as DATE) != @expirationDateCheck
	AND CAST(currCov.EXPIRATION_DT as DATE) BETWEEN @lastRunDate AND GETDATE()

	INSERT INTO @t (LOAN_ID, PROPERTY_ID, REQUIRED_COVERAGE_ID)
	SELECT DISTINCT tmp.LOAN_ID, tmp.PROPERTY_ID, tmp.REQUIRED_COVERAGE_ID
	FROM @tmpList tmp
		JOIN BORROWER_INSURANCE_COMPANY_OFFERING bico ON bico.BORROWER_INSURANCE_COMPANY_ID = tmp.BIC_ID AND bico.PURGE_DT IS NULL
	WHERE bico.CONTINUOUS_IN = 'Y' 
	AND bico.COVERAGE_TYPE_CD = tmp.RC_TYPE_CD

	RETURN			
END
GO

