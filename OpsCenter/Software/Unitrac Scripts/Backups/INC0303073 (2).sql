USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT 
        CONCAT(LL.CODE_TX, ' ', LL.NAME_TX) [Lender] ,
        VIN_TX [Vin],
        YEAR_TX [Year] ,
        MAKE_TX [Make],
        MODEL_TX [Model],
	--	'Chargeable Damage'[Chargeable Damage], 'Vehicle Grade'[Vehicle Grade],
        CONCAT(O.FIRST_NAME_TX, ' ', O.LAST_NAME_TX) [Owner] ,
        OA.LINE_1_TX [Line 1] ,
        OA.LINE_2_TX [Line 2] ,
        OA.CITY_TX [City] ,
        OA.STATE_PROV_TX [State] ,
        OA.POSTAL_CODE_TX [Zip Code],
		L.EFFECTIVE_DT [Contract Effective Date]
		--,		'Secured Date' [Secured Date]
		INTO jcs..INC0303073
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        --INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        --INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
        --INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
WHERE   LL.CODE_TX IN ( '5044' )
        AND rc.INSURANCE_STATUS_CD IN ( 'N', 'A' )

		SELECT * FROM dbo.REF_CODE
		WHERE CODE_CD IN ( 'N', 'A' ) AND DOMAIN_CD = 'RequiredCoverageInsStatus'

		SELECT * FROM jcs..INC0303073