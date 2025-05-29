USE [UniTrac]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_EscrowEx_PDAP]    Script Date: 9/3/2021 10:36:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- PDAP Exception Check
-- If not a supplemental payment and the new Allied Entered Escrow Record has a Paid Thru Date that would advance 
-- the Current HS Paid Thru date (Expiration Date)  by less than 60 days and there IS a change in Payee ï¿½ 

CREATE function [dbo].[fn_EscrowEx_PDAP]
(
   @EscrowID bigint
)

RETURNS nvarchar(30)
AS
BEGIN

	DECLARE @reasonCode nvarchar(30)
	SET @reasonCode = null

	SELECT top 1 @reasonCode = 'PDAP'
	FROM ESCROW esc
       JOIN ESCROW_REQUIRED_COVERAGE_RELATE r on r.ESCROW_ID = esc.id and r.PURGE_DT is null
       JOIN REQUIRED_ESCROW re ON re.REQUIRED_COVERAGE_ID = r.REQUIRED_COVERAGE_ID AND re.ACTIVE_IN = 'Y' 
				AND re.EXCESS_IN = esc.EXCESS_IN
				AND re.SUB_TYPE_CD = esc.SUB_TYPE_CD AND re.PURGE_DT IS NULL
       CROSS APPLY
         (
            Select top 1 ID
            from ESCROW pe
            where pe.PROPERTY_ID = esc.PROPERTY_ID and pe.PURGE_DT is null and pe.BIC_ID <> esc.BIC_ID and pe.ID <> esc.ID 
				AND (pe.STATUS_CD = 'CLSE' and pe.SUB_STATUS_CD in ('RPTD' , 'LNDRPAID', 'INHSPAID' , 'BWRPAID' ))
				AND pe.EXCESS_IN = esc.EXCESS_IN and pe.SUB_TYPE_CD = esc.SUB_TYPE_CD
				and pe.END_DT < esc.END_DT
            order by pe.END_DT desc
         ) prevEsc  
	WHERE DATEDIFF(DAY, re.PAID_THRU_DT, esc.END_DT) < 60
       AND esc.PREMIUM_NO > 0
       AND esc.OTHER_NO = 0
       AND esc.ID = @escrowId

	RETURN @reasonCode

END

GO

