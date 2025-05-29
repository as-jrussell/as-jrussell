SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.fn_FilterCollateralByDivisionCd2') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION dbo.fn_FilterCollateralByDivisionCd2


GO

create FUNCTION [dbo].[fn_FilterCollateralByDivisionCd2] (
@COLLATERAL_ID bigint,
@DIVISION nvarchar(10)
)
RETURNS @result TABLE ( loanType nvarchar(30))
AS
BEGIN
INSERT INTO @result ( loanType )
 SELECT loanType = convert(nvarchar(30),
            CASE
            WHEN isnull(@DIVISION,'') IN ('','1') THEN CASE
                                                                WHEN CC.VEHICLE_LOOKUP_IN = 'Y' THEN 'Vehicle'
                                                                WHEN CC.ADDRESS_LOOKUP_IN = 'Y' THEN 'Mortgage'

                                                                WHEN CC.VEHICLE_LOOKUP_IN = 'N' AND CC.ADDRESS_LOOKUP_IN = 'N' THEN 'Equipment'
                                                END
            WHEN @DIVISION IN ('3','8','99') AND CC.VEHICLE_LOOKUP_IN = 'Y' THEN 'Vehicle'
            WHEN @DIVISION IN ('4','10','99') AND CC.ADDRESS_LOOKUP_IN = 'Y' THEN 'Mortgage'
            WHEN @DIVISION IN ('7','9','99') AND CC.VEHICLE_LOOKUP_IN = 'N' AND CC.ADDRESS_LOOKUP_IN = 'N' THEN 'Equipment' END
            )
         FROM COLLATERAL CL with (index = PK_COLLATERAL)
		 inner loop JOIN COLLATERAL_CODE CC ON CL.COLLATERAL_CODE_ID=CC.ID
			and CC.PURGE_DT is null
         INNER LOOP JOIN LOAN with (index = PK_LOAN)
		 ON LOAN.ID = CL.LOAN_ID
         WHERE CL.ID= @COLLATERAL_ID AND
         (
            LOAN.DIVISION_CODE_TX =  @DIVISION  ----- this will also include if loan division & rpt division = 99
            ---- given code below also handles UTL's with no division, apart from 99
            OR (ISNULL(LOAN.DIVISION_CODE_TX,'') not in ('3','8') AND CC.VEHICLE_LOOKUP_IN = 'Y' AND @DIVISION IN ('3') AND LOAN.TYPE_CD <> 'LEAS')
            OR (ISNULL(LOAN.DIVISION_CODE_TX,'') not in ('3','8') AND CC.VEHICLE_LOOKUP_IN = 'Y' AND @DIVISION IN ('8') AND LOAN.TYPE_CD = 'LEAS')
            OR (ISNULL(LOAN.DIVISION_CODE_TX,'') not in ('4','10') AND CC.ADDRESS_LOOKUP_IN = 'Y' AND @DIVISION IN ('4') AND CC.PRIMARY_CLASS_CD <> 'COM')
            OR (ISNULL(LOAN.DIVISION_CODE_TX,'') not in ('4','10') AND CC.ADDRESS_LOOKUP_IN = 'Y' AND @DIVISION IN ('10') AND CC.PRIMARY_CLASS_CD = 'COM')
            OR (ISNULL(LOAN.DIVISION_CODE_TX,'') not in ('7','9') AND CC.VEHICLE_LOOKUP_IN = 'N' AND CC.ADDRESS_LOOKUP_IN = 'N' AND @DIVISION IN ('7','9'))
            OR (isnull(@DIVISION,'') in ('','1')
            )
         )
return
END
