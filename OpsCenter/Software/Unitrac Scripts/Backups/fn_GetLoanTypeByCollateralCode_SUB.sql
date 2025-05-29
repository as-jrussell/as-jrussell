USE [Unitrac_Reports]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetLoanTypeByCollateralCode]    Script Date: 12/29/2015 3:42:46 PM ******/
DROP FUNCTION [dbo].[fn_GetLoanTypeByCollateralCode]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetLoanTypeByCollateralCode]    Script Date: 12/29/2015 3:42:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<returns the type of loan (Vehicle/ Mortgage/ Equipment)>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetLoanTypeByCollateralCode] (@COLLATERAL_ID bigint)

RETURNS nvarchar(max)

BEGIN

DECLARE @loanType        nvarchar(max)=NULL

-- Get the Property Type to decide if address need to be returned or the Vehicle YMM and VIN
-- Note. There shouldn't be no CollateralCode with both VehicleLookup and AddressLookup set to 'Y'
-- Logic: if collateral code tied to that collateral is set to do vehicle lookup then loantype would be Vehicle
--		  if collateral code tied to that loan is set to do address lookup then loantype would be Mortgage
--		  if Division is 7,9,99 and collateral code tied to that loan is not set to do neither address lookup nor vehicle lookup then loan type is equipment.
	
	SELECT
		@loanType = 
			CASE 
				WHEN CC.VEHICLE_LOOKUP_IN = 'Y' THEN 'Vehicle'
				WHEN CC.ADDRESS_LOOKUP_IN = 'Y' THEN 'Mortgage'
				WHEN CC.VEHICLE_LOOKUP_IN = 'N' AND CC.ADDRESS_LOOKUP_IN = 'N' THEN 'Equipment'
			END
	FROM
		COLLATERAL C
		JOIN COLLATERAL_CODE CC	ON C.COLLATERAL_CODE_ID=CC.ID
	WHERE 
		C.ID= @COLLATERAL_ID 
		AND C.PURGE_DT IS NULL
		AND CC.PURGE_DT IS NULL

    RETURN @loanType
END

GO

