USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetLCCGCollateralCodeRelates]    Script Date: 6/15/2017 8:15:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetLCCGCollateralCodeRelates]
(
    @id BIGINT = NULL,
    @collateralCodeId BIGINT = NULL,
    @lccgId BIGINT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	IF @id = 0
		SET @id = NULL
	
	IF @collateralCodeId = 0
		SET @collateralCodeId = NULL
		
	IF @lccgId = 0
		SET @lccgId = NULL

	SELECT ID
		 , COLLATERAL_CODE_ID
		 , LCCG_ID
		 , LOCK_ID
	FROM
		LCCG_COLLATERAL_CODE_RELATE
	WHERE
		ID = isnull(@id, ID)
		AND COLLATERAL_CODE_ID = isnull(@collateralCodeId, COLLATERAL_CODE_ID)
		AND LCCG_ID = isnull(@lccgId, LCCG_ID)
      and PURGE_DT is null
END

GO

