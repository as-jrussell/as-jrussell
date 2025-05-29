SELECT TOP 1
        0 AS BILimit ,
        0 AS CollDeductible ,
        0 AS CompDeductible ,
        0 AS PDLimit ,
        GETDATE() AS Date ,
        '' AS InactiveDate ,
        LA.LINE_1_TX AS LenderAddress1 ,
        LA.LINE_2_TX AS LenderAddress2 ,
        LA.CITY_TX AS LenderCity ,
        '' AS LenderInterestType ,
        LENDER.NAME_TX AS LenderName ,
        LENDER.CODE_TX AS LenderCode ,
        LA.STATE_PROV_TX AS LenderState ,
        LA.POSTAL_CODE_TX AS LenderZip ,
        OWNER.FIRST_NAME_TX ,
        OWNER.LAST_NAME_TX ,
        OWNER.MIDDLE_INITIAL_TX ,
        OWNER_ADDRESS.LINE_1_TX AS PolicyholderAddress1 ,
        OWNER_ADDRESS.LINE_2_TX AS PolicyholderAddress2 ,
        OWNER_ADDRESS.CITY_TX AS PolicyholderCity ,
        '' AS PolicyholderInterestType ,
        OWNER_ADDRESS.STATE_PROV_TX AS PolicyholderState ,
        OWNER_ADDRESS.POSTAL_CODE_TX AS PolicyholderZip ,
        OWNER_POLICY.EFFECTIVE_DT AS EffectiveDate ,
        OWNER_POLICY.EXPIRATION_DT AS ExpirationDate ,
        '' AS LineOfBusiness ,
        '' AS Status ,
        PROPERTY.MAKE_TX AS Make ,
        PROPERTY.MODEL_TX AS Model ,
        '' AS VehType ,
        PROPERTY.VIN_TX AS VIN ,
        PROPERTY.YEAR_TX AS Year ,
        OWNER_POLICY.POLICY_NUMBER_TX AS PolicyNumber ,
        '' AS ProcessResult ,
        '' AS ProcessReason ,
        PROPERTY.ID AS PropertyID ,
        OWNER_POLICY.ID AS OwnerPolicyID ,
        COLLATERAL.LOAN_ID AS LoanID ,
        REQUIRED_COVERAGE.ID AS RequiredCoverageID ,
        COLLATERAL.ID AS CollateralID ,
        LENDER.TAX_ID_TX AS LenderID ,
        REQUIRED_COVERAGE.TYPE_CD AS RequiredCoverageType ,
        OWNER_POLICY.STATUS_CD AS PolicyStatusCode ,
        OWNER_POLICY.SUB_STATUS_CD AS PolicySubStatusCode
FROM    REQUIRED_COVERAGE
        INNER JOIN PROPERTY ON PROPERTY.ID = REQUIRED_COVERAGE.PROPERTY_ID
                               AND REQUIRED_COVERAGE.PURGE_DT IS NULL
        INNER JOIN COLLATERAL ON PROPERTY.ID = COLLATERAL.PROPERTY_ID
                                 AND COLLATERAL.PURGE_DT IS NULL
        INNER JOIN LENDER ON PROPERTY.LENDER_ID = LENDER.ID
                             AND LENDER.PURGE_DT IS NULL
        INNER JOIN LOAN ON COLLATERAL.LOAN_ID = LOAN.ID
                           AND LENDER.ID = LOAN.LENDER_ID
                           AND LOAN.PURGE_DT IS NULL
        INNER JOIN OWNER_LOAN_RELATE ON LOAN.ID = OWNER_LOAN_RELATE.LOAN_ID
                                        AND OWNER_LOAN_RELATE.OWNER_TYPE_CD = 'B'
                                        AND OWNER_LOAN_RELATE.PRIMARY_IN = 'Y'
                                        AND OWNER_LOAN_RELATE.PURGE_DT IS NULL
        LEFT OUTER JOIN PROPERTY_OWNER_POLICY_RELATE ON PROPERTY.ID = PROPERTY_OWNER_POLICY_RELATE.PROPERTY_ID
                                                        AND PROPERTY_OWNER_POLICY_RELATE.PURGE_DT IS NULL
        LEFT OUTER JOIN OWNER_POLICY ON PROPERTY_OWNER_POLICY_RELATE.OWNER_POLICY_ID = OWNER_POLICY.ID
                                        AND OWNER_POLICY.PURGE_DT IS NULL
        LEFT OUTER JOIN OWNER ON OWNER_LOAN_RELATE.OWNER_ID = OWNER.ID
                                 AND OWNER.PURGE_DT IS NULL
        LEFT OUTER JOIN ADDRESS LA ON LENDER.MAILING_ADDRESS_ID = LA.ID
                                      AND LA.PURGE_DT IS NULL
        LEFT OUTER JOIN OWNER_ADDRESS ON OWNER.ADDRESS_ID = OWNER_ADDRESS.ID
                                         AND OWNER_ADDRESS.PURGE_DT IS NULL 
  WHERE '7' + CAST(REQUIRED_COVERAGE.ID AS nvarchar(max)) + 
  ( RIGHT(@PAD + CONVERT(nvarchar(max),COLLATERAL.ID),4)) + (CAST((select dbo.CheckSumDigit(REQUIRED_COVERAGE.ID)) 
  AS nvarchar(1)) ) 