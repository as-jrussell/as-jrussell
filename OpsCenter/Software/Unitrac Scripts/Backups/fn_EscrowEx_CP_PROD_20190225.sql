USE [UniTrac]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_EscrowEx_CP]    Script Date: 2/25/2019 8:51:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- CP Exception Check
-- Change in Payee  
CREATE function [dbo].[fn_EscrowEx_CP]
(
   @EscrowID bigint
)

RETURNS nvarchar(30)
AS
BEGIN

	DECLARE @reasonCode nvarchar(30)
	SET @reasonCode = null

	SELECT top 1 @reasonCode = 'CP'
	FROM ESCROW esc
	CROSS APPLY
	(
	   Select top 1 ID
	   from ESCROW pe 
	   where pe.PROPERTY_ID = esc.PROPERTY_ID and pe.PURGE_DT is null and pe.BIC_ID <> esc.BIC_ID and pe.ID <> esc.ID and pe.CREATE_DT < esc.CREATE_DT
	   order by pe.id desc
	) prevEsc
	WHERE  esc.ID = @escrowId 

	RETURN @reasonCode

END


GO

