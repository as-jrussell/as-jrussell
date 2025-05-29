USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[PopulateDatasourceCacheStaging]    Script Date: 2/2/2016 2:10:56 PM ******/
DROP PROCEDURE [dbo].[PopulateDatasourceCacheStaging]
GO

/****** Object:  StoredProcedure [dbo].[PopulateDatasourceCacheStaging]    Script Date: 2/2/2016 2:10:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PopulateDatasourceCacheStaging] 
AS
BEGIN

   SET ANSI_PADDING ON

   BEGIN TRANSACTION

	BEGIN TRY

		TRUNCATE TABLE [DATASOURCE_CACHE_STAGING]

		INSERT INTO [DATASOURCE_CACHE_STAGING] (CREATE_DT
											,	LENDER_ID
											,	LENDER_CD
											,	LENDER_NAME
											,	LOAN_ID
											,	L_BRANCH_CODE_TX
											,	L_DIVISION_CODE_TX
											,	RC_ID
											,	RC_TYPE_CD
											,	RC_RECORD_TYPE_CD
											,	RC_STATUS_CD
											,	RC_SUMMARY_SUB_STATUS_CD
											,	RC_SUMMARY_STATUS_CD
											,	RC_EXPOSURE_DT
											,	RC_INSURANCE_SUB_STATUS_CD
											,	C_ID
											,	C_PRIMARY_LOAN_IN
											,	C_PROPERTY_ID
											,	C_STATUS_CD
											,	LOAN_TYPE)
		  SELECT
			getdate() as CREATE_DT
		,	ldr.ID as LENDER_ID
		,	ldr.CODE_TX AS 'LENDER_CD'
		,	ldr.NAME_TX AS 'LENDER_NAME'
		,	l.ID AS 'LOAN_ID'
 		,	l.BRANCH_CODE_TX AS L_BRANCH_CODE_TX
		,   l.DIVISION_CODE_TX as L_DIVISION_CODE_TX
		,	rc.ID as RC_ID
		,	rc.TYPE_CD as RC_TYPE_CD
		,	rc.RECORD_TYPE_CD as RC_RECORD_TYPE_CD
		,	rc.STATUS_CD as RC_STATUS_CD
		,	rc.SUMMARY_SUB_STATUS_CD as RC_SUMMARY_SUB_STATUS_CD
		,	rc.SUMMARY_STATUS_CD as RC_SUMMARY_STATUS_CD
		,	rc.EXPOSURE_DT as RC_EXPOSURE_DT
		,	rc.INSURANCE_SUB_STATUS_CD
		,   c.ID as C_ID
		,   c.PRIMARY_LOAN_IN as C_PRIMARY_LOAN_IN
		,	c.PROPERTY_ID as C_PROPERTY_ID
		,	c.STATUS_CD as C_STATUS_CD
		,   LOAN_TYPE =
			CASE
				WHEN CC.VEHICLE_LOOKUP_IN = 'Y' THEN 'Vehicle'
				WHEN CC.ADDRESS_LOOKUP_IN = 'Y' AND CC.PRIMARY_CLASS_CD <> 'COM' THEN 'Mortgage'
				WHEN CC.ADDRESS_LOOKUP_IN = 'Y' AND CC.PRIMARY_CLASS_CD = 'COM' THEN 'Commercial Mortgage'
				WHEN CC.VEHICLE_LOOKUP_IN = 'N' AND CC.ADDRESS_LOOKUP_IN = 'N' THEN 'Equipment'
			END
		FROM dbo.LENDER ldr (NOLOCK)
			inner merge JOIN  dbo.LOAN l (NOLOCK) ON ldr.ID = l.LENDER_ID
			inner merge JOIN  dbo.COLLATERAL c (NOLOCK) ON l.ID = c.LOAN_ID
					AND c.PURGE_DT IS NULL
			inner merge JOIN  dbo.REQUIRED_COVERAGE rc (NOLOCK) ON rc.PROPERTY_ID = C.PROPERTY_ID
					AND rc.PURGE_DT IS NULL
			left outer join  dbo.COLLATERAL_CODE CC	ON CC.ID = C.COLLATERAL_CODE_ID
					AND CC.PURGE_DT IS NULL
		WHERE ldr.CODE_TX IN ('3400', '1771', '4286', '4035', '012800', '13100', '5350')
			and l.RECORD_TYPE_CD IN ('G')
			AND l.PURGE_DT IS NULL
			AND l.STATUS_CD IN ('A', 'B')


	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH

	COMMIT TRANSACTION


END

GO

