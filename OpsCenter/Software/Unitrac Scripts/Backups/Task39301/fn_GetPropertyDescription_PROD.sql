USE [UniTrac]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPropertyDescription]    Script Date: 10/23/2016 6:46:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[fn_GetPropertyDescription] (

@COLLATERAL_ID bigint, 
@DISPLAY_BORROWER_ADDR_IN char(1) = 'Y'
)
RETURNS nvarchar(max)

BEGIN

	DECLARE 
		@propertyDesc nvarchar(max), 
		@propertyType nvarchar(15), 
		@vehicleLookupIn char(1), 
		@addressLookupIn char(1)

	-- Get the Property Type to decide if address need to be returned or the Vehicle YMM
	SELECT
		@propertyType=VALUE_TX,
		@vehicleLookupIn=CC.VEHICLE_LOOKUP_IN,
		@addressLookupIn=CC.ADDRESS_LOOKUP_IN
	FROM
		COLLATERAL C
		JOIN COLLATERAL_CODE CC
			ON C.COLLATERAL_CODE_ID=CC.ID
		LEFT JOIN REF_CODE RC_SC WITH (NOLOCK)
			ON RC_SC.DOMAIN_CD='SecondaryClassification'
			AND CC.SECONDARY_CLASS_CD=RC_SC.CODE_CD
		LEFT JOIN REF_CODE_ATTRIBUTE RCA_PROP WITH (NOLOCK)
			ON RC_SC.DOMAIN_CD=RCA_PROP.DOMAIN_CD
			AND RC_SC.CODE_CD=RCA_PROP.REF_CD
			AND RCA_PROP.ATTRIBUTE_CD='PropertyType'
	WHERE
		C.ID=@COLLATERAL_ID

    -- Get the Property Description based on Property Type.
	SELECT
		@propertyDesc=
		CASE
			WHEN @vehicleLookupIn='Y' 
				THEN COALESCE ( P.YEAR_TX, '' )+' '+
					 COALESCE ( P.MAKE_TX, '' )+
					 (CASE 
						WHEN ISNULL(P.MODEL_TX,'') = '' THEN ' ' 
						ELSE ' / ' 
					 END)+ 
					 COALESCE ( P.MODEL_TX, '' )
			WHEN @addressLookupIn='Y' AND ISNULL(P.ADDRESS_ID,0) <> 0 
				THEN ISNULL ( AM.LINE_1_TX, '' )+CHAR ( 13 )+CHAR ( 10 )+
					 ISNULL ( AM.LINE_2_TX, '' )+CHAR ( 13 )+CHAR ( 10 )+
					 ISNULL ( AM.CITY_TX, '' )+', '+
					 ISNULL ( AM.STATE_PROV_TX, '' )+' '+
					 ISNULL ( AM.POSTAL_CODE_TX, '' )
			WHEN @addressLookupIn = 'Y' AND ISNULL(P.ADDRESS_ID,0) = 0 
			    AND @DISPLAY_BORROWER_ADDR_IN = 'Y'
				THEN ISNULL ( OA.LINE_1_TX, '' )+CHAR ( 13 )+CHAR ( 10 )+
					 ISNULL ( OA.LINE_2_TX, '' )+CHAR ( 13 )+CHAR ( 10 )+
					 ISNULL ( OA.CITY_TX, '' )+', '+
					 ISNULL ( OA.STATE_PROV_TX, '' )+' '+
					 ISNULL ( OA.POSTAL_CODE_TX, '' )
			WHEN @addressLookupIn = 'Y' AND ISNULL(P.ADDRESS_ID,0) = 0 
			    AND @DISPLAY_BORROWER_ADDR_IN = 'N'
			    THEN ''
			ELSE P.DESCRIPTION_TX
		END
	FROM
		LOAN L
		JOIN COLLATERAL C
			ON C.LOAN_ID=L.ID
		JOIN PROPERTY P
			ON C.PROPERTY_ID=P.ID
		JOIN OWNER_LOAN_RELATE OLR 
			ON OLR.LOAN_ID = L.ID
		JOIN OWNER O 
			ON O.ID = OLR.OWNER_ID
		LEFT JOIN [OWNER_ADDRESS] AM WITH (NOLOCK)
			ON AM.ID=P.ADDRESS_ID
			AND AM.PURGE_DT IS NULL
		LEFT JOIN [OWNER_ADDRESS] OA WITH (NOLOCK)
			ON OA.ID=O.ADDRESS_ID
			AND OA.PURGE_DT IS NULL
	WHERE
		C.ID = @COLLATERAL_ID 
	
	-- if property description is still empty then check for property Type if that is 'MH' then check if the collateralcode Address_Lookup is set and AddressId on property is 0 then 
	-- display Year/Make/Model
	IF  ISNULL(LTRIM(RTRIM(REPLACE(@propertyDesc,',',''))),'')='' AND @propertyType='MH'
	BEGIN
		SELECT
			@propertyDesc=
				CASE
					WHEN CC.ADDRESS_LOOKUP_IN='Y' AND ISNULL ( P.ADDRESS_ID, 0 )=0 
						THEN COALESCE ( P.YEAR_TX, '' )+' '+
							 COALESCE ( P.MAKE_TX, '' )+' '+
							 COALESCE ( P.MODEL_TX, '' )
					ELSE ''
				END
		FROM
			COLLATERAL C
			JOIN PROPERTY P
				ON P.ID=C.PROPERTY_ID
			JOIN COLLATERAL_CODE CC
				ON CC.ID=C.COLLATERAL_CODE_ID
		WHERE
			C.ID=@COLLATERAL_ID
	END

	-- return property description
	RETURN @propertyDesc
END
