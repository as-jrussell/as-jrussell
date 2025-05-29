USE [UniTrac]
GO

/****** Object:  UserDefinedFunction [dbo].[GetQCWarehouseStatus]    Script Date: 4/27/2018 8:27:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetQCWarehouseStatus]

(
	@lenderIds nvarchar(max),
	@coverageType nvarchar(max),
   @collateralBalance int = 0,
   @lastRunDate datetime = null
)
RETURNS @t TABLE 
	(LOAN_ID BIGINT, 
	 PROPERTY_ID BIGINT, 
	 REQUIRED_COVERAGE_ID BIGINT
	)  
AS
BEGIN

	DECLARE @startDate DATETIME
	
   IF @lastRunDate IS NULL
	   SET @startDate = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE())-1, 0)
   ELSE
      SET @startDate = @lastRunDate

	DECLARE @lenderList TABLE (ID BIGINT)
	DECLARE @coverageList TABLE (TYPE_CD NVARCHAR(30))
	
	INSERT INTO @lenderList 
	SELECT ID FROM GetSelectedLenderIds(@lenderIds)

	INSERT INTO @coverageList 
	SELECT STRVALUE FROM SplitFunction(@coverageType, ',')

	INSERT INTO @t (LOAN_ID, PROPERTY_ID, REQUIRED_COVERAGE_ID)
	SELECT ln.ID LOAN_ID, pr.ID PROPERTY_ID, rc.ID REQUIRED_COVERAGE_ID
	FROM @lenderList ldr 
		JOIN LOAN ln ON ln.LENDER_ID = ldr.ID AND ln.PURGE_DT IS NULL
		JOIN COLLATERAL col ON col.LOAN_ID = ln.ID AND col.PURGE_DT IS NULL
		JOIN PROPERTY pr ON pr.ID = col.PROPERTY_ID AND pr.PURGE_DT IS NULL
		JOIN REQUIRED_COVERAGE rc ON rc.PROPERTY_ID = pr.ID AND rc.PURGE_DT IS NULL
      JOIN @coverageList cvg ON cvg.TYPE_CD = rc.TYPE_CD
		JOIN LENDER_PRODUCT lp ON lp.ID = rc.LENDER_PRODUCT_ID AND lp.PURGE_DT IS NULL			   
      OUTER APPLY
      (
         SELECT   -- Determine total number of collaterals
                  COUNT(*) AS TOTAL_COLLATERALS_FOR_LOAN,

                  -- Determine if the collateral is a "boat"
                  CASE WHEN SUM(CASE WHEN ISNULL(CC.CODE_TX, '') = 'BOAT' THEN 1 ELSE 0 END) >= 1 THEN 1 ELSE 0 END AS HAS_BOAT,

                  -- Determine if the status of a collateral is "warehouse"
                  CASE WHEN SUM(CASE WHEN STATUS_CD = 'X' THEN 1 ELSE 0 END) >= 1 THEN 1 ELSE 0 END AS HAS_WAREHOUSE,

                  -- Determine if the ACV has a balance
                  CASE WHEN 
                     (
                        SELECT   MAX(P.ACV_NO) 
                        FROM     COLLATERAL CHW
                                 INNER JOIN PROPERTY P on CHW.PROPERTY_ID = P.ID AND P.PURGE_DT IS NULL 
                        WHERE    LOAN_ID = C.LOAN_ID
                                 AND STATUS_CD = 'X'
                                 AND ISNULL(P.ACV_NO, 0) > 0
                     ) > 0 THEN 1 ELSE 0 END         
                  AS HAS_VALID_ACV,

                  MAX(pcu.CREATE_DT) AS DATE_BASIS
         FROM     COLLATERAL C
                  INNER JOIN COLLATERAL_CODE CC on CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
                  JOIN PROPERTY_CHANGE_UPDATE pcu ON pcu.TABLE_ID = col.ID 
                     AND pcu.TABLE_NAME_TX = 'COLLATERAL' AND COLUMN_NM = 'STATUS_CD' AND TO_VALUE_TX = 'X'
         WHERE    LOAN_ID = LN.ID
                  AND pcu.CREATE_DT >= @startDate 
         GROUP BY LOAN_ID
      )  COLLATERAL_INFO
	WHERE 
      ln.RECORD_TYPE_CD = 'G' -- Active Loans	
	   AND pr.RECORD_TYPE_CD = 'G' -- Active Properties
	   AND rc.RECORD_TYPE_CD = 'G' -- Active Required Coverage
      AND lp.BASIC_TYPE_CD = 'FLTRK' -- Full Tracking
	   AND lp.BASIC_SUB_TYPE_CD = 'WNTC' --- With Notices
      AND COLLATERAL_INFO.TOTAL_COLLATERALS_FOR_LOAN >= 2
      AND COLLATERAL_INFO.HAS_BOAT = 1
      AND COLLATERAL_INFO.HAS_WAREHOUSE = 1
      AND COLLATERAL_INFO.HAS_VALID_ACV = 1
      AND col.LOAN_BALANCE_NO > @collateralBalance

   RETURN
END

GO

