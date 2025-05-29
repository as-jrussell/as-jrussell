USE [UniTrac]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_EscrowEx_PDLCE]    Script Date: 9/3/2021 10:45:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--PDLCE -- Paid thru date < current Exp date
CREATE function [dbo].[fn_EscrowEx_PDLCE]
(
   @EscrowID bigint
)

RETURNS nvarchar(30)
AS
BEGIN

	DECLARE @reasonCode nvarchar(30)
	SET @reasonCode = null

	SELECT top 1 @reasonCode = 'PDLCE'
	FROM ESCROW esc
	   JOIN ESCROW_REQUIRED_COVERAGE_RELATE r on r.ESCROW_ID = esc.id and r.PURGE_DT is null
	   JOIN REQUIRED_ESCROW re ON re.REQUIRED_COVERAGE_ID = r.REQUIRED_COVERAGE_ID AND re.ACTIVE_IN = 'Y' 
				AND re.EXCESS_IN = esc.EXCESS_IN
				AND re.SUB_TYPE_CD = esc.SUB_TYPE_CD AND re.PURGE_DT IS NULL    
	WHERE re.PAID_THRU_DT >= esc.END_DT
	   AND esc.PREMIUM_NO > 0
	   AND esc.OTHER_NO = 0
	   AND esc.ID = @escrowId

	RETURN @reasonCode

END

GO

