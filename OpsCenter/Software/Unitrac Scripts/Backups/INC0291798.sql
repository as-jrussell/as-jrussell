USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT
        L.NUMBER_TX ,
        CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status] ,
        P.ACV_NO ,
        P.ACV_DT ,
        P.ACV_VALUATION_REQUIRED_IN ,
        P.RECORD_TYPE_CD ,
        P.YEAR_TX ,
        P.MAKE_TX ,
        P.MODEL_TX ,
        P.BODY_TX ,
        P.VIN_TX ,
        P.VACANT_IN ,
        P.TIED_DOWN_IN ,
        P.IN_PARK_IN ,
        P.ACV_INCLUDES_LAND_IN ,
        P.IN_CONSTRUCTION_IN ,
        P.ZONE_ASSUMED_IN ,
        P.COASTAL_BARRIER_IN ,
        P.PARTICIPATING_COMMUNITY_IN ,
        P.CALCULATED_COLL_BALANCE_NO ,
        OP.POLICY_NUMBER_TX ,
        OP.EFFECTIVE_DT ,
        OP.EXPIRATION_DT ,
        OP.CANCELLATION_DT ,
        OP.CANCEL_REASON_CD ,
        OP.BIC_ID ,
        OP.BIC_NAME_TX ,
        OP.MOST_RECENT_MAIL_DT ,
        OP.MOST_RECENT_EFFECTIVE_DT
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
        INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
        LEFT JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = RC.INSURANCE_STATUS_CD
                                      AND RC5.DOMAIN_CD = 'RequiredCoverageInsStatus'
        LEFT JOIN dbo.REF_CODE RC6 ON RC6.CODE_CD = RC.INSURANCE_SUB_STATUS_CD
                                      AND RC6.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
WHERE   LL.CODE_TX IN ( '3170' )
        AND L.DIVISION_CODE_TX = '3'




    SELECT  L.NUMBER_TX ,
            CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage
Status] ,
            L.Payment_amount_NO ,
            L.ORIGINAL_BALANCE_AMOUNT_NO ,
            L.ORIGINAL_PAYMENT_AMOUNT_NO ,
            P.ACV_NO ,
            P.ACV_DT ,
            P.ACV_VALUATION_REQUIRED_IN ,
            P.RECORD_TYPE_CD ,
            P.YEAR_TX ,
            P.MAKE_TX ,
            P.MODEL_TX ,
            P.BODY_TX ,
            P.VIN_TX ,
            P.VACANT_IN ,
            P.TIED_DOWN_IN ,
            P.IN_PARK_IN ,
            P.ACV_INCLUDES_LAND_IN ,
            P.IN_CONSTRUCTION_IN ,
            P.ZONE_ASSUMED_IN ,
            P.COASTAL_BARRIER_IN ,
            P.PARTICIPATING_COMMUNITY_IN ,
            P.CALCULATED_COLL_BALANCE_NO ,
            OP.POLICY_NUMBER_TX ,
            OP.EFFECTIVE_DT ,
            OP.EXPIRATION_DT ,
            OP.CANCELLATION_DT ,
            OP.CANCEL_REASON_CD ,
            OP.BIC_ID ,
            OP.BIC_NAME_TX ,
            OP.MOST_RECENT_MAIL_DT ,
            OP.MOST_RECENT_EFFECTIVE_DT
    FROM    LOAN L
            INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
            INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
            INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
            INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
            INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
            INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
            INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
            LEFT JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = RC.INSURANCE_STATUS_CD
                                          AND RC5.DOMAIN_CD = 'RequiredCoverageInsStatus'
            LEFT JOIN dbo.REF_CODE RC6 ON RC6.CODE_CD = RC.INSURANCE_SUB_STATUS_CD
                                          AND RC6.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
    WHERE   LL.CODE_TX IN ( '3170' )
            AND L.DIVISION_CODE_TX = '3'