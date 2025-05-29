SELECT  lender.CODE_TX AS 'Lender Code' ,
        LENDER.NAME_TX AS 'Lender Name' ,
        ISNULL(ContractType.Meaning_tx, '') AS 'Contract Type' ,
        loan.number_tx AS 'Loan Number' ,
        loan.Branch_code_tx AS 'Branch' ,
        loan.BALANCE_AMOUNT_NO AS 'Balance' ,
        ISNULL(Loanstat.MEANING_TX, '') AS 'Loan Status' ,
        ISNULL(LoanType.Meaning_tx, '') AS 'Loan Type' ,
        ISNULL(owner.LAST_NAME_TX, '') AS 'Last Name' ,
        ISNULL(owner.FIRST_NAME_TX, '') AS 'First Name' ,
        ISNULL(collateralstat.Meaning_tx, '') AS 'Collateral Status' ,
        collateral.loan_balance_no AS 'Collateral Balance' ,
        Property.Replacement_cost_value_no AS 'Property RCV' ,
        ISNULL(padd.line_1_tx, '') AS 'Property Address Line 1' ,
        ISNULL(padd.city_tx, '') AS 'Property Address City' ,
        ISNULL(padd.STATE_PROV_TX, '') AS 'Property Address State' ,
        ISNULL(padd.Postal_code_tx, '') AS 'Property Zip' ,
        ISNULL(property.Flood_zone_tx, '') AS 'Flood Zone' ,
        collateral_code.code_tx AS 'Collateral Code' ,
        COLLATERAL_CODE.PRIMARY_CLASS_CD AS 'Primary Class' ,
        COLLATERAL_CODE.SECONDARY_CLASS_CD AS 'Secondary Class' ,
        REQUIRED_COVERAGE.TYPE_CD AS 'Coverage Type' ,
        coverstat.MEANING_TX AS 'Coverage Status' ,
        summarystat.MEANING_TX AS 'Coverage Summary Status' ,
        ISNULL(summarysubstat.MEANING_TX, '') AS 'Coverage Summary Sub Status' ,
        Required_coverage.REQUIRED_AMOUNT_NO AS 'Required Coverage Amount' ,
        ISNULL(BasePropertyType.Meaning_tx, '') AS 'Base Policy Type' ,
        ISNULL(owner_policy.BIC_NAME_TX, '') AS 'Insurance Company' ,
        ISNULL(owner_policy.POLICY_NUMBER_TX, '') AS 'Policy Number' ,
        ISNULL(CONVERT(CHAR(10), owner_policy.EFFECTIVE_DT, 101), '') AS 'Policy Effective Date' ,
        ISNULL(CONVERT(CHAR(10), owner_policy.EXPIRATION_DT, 101), '') AS 'Policy Expiration Date' ,
        ISNULL(CONVERT(CHAR(10), owner_policy.Cancellation_dt, 101), '') AS 'Policy Cancel Date' ,
        ( SELECT    policy_coverage.Amount_no
          FROM      policy_coverage
                    INNER JOIN ( SELECT TOP 1
                                        PC.ID ,
                                        PC.end_dt
                                 FROM   policy_coverage AS pc
                                 WHERE  pc.owner_policy_id = owner_policy.id
                                        AND PC.sub_Type_cd = 'CADW'
                                 ORDER BY PC.end_dt DESC
                               ) AS pcmax ON pcmax.id = policy_coverage.id
          WHERE     policy_coverage.owner_policy_id = owner_policy.ID
        ) AS 'Coverage A Amount' ,
        owner_policy.special_handling_xml.value('(//SH/LienHolderName)[1]',
                                                'varchar(50)') AS 'Mortgagee Name'
FROM    LENDER
        INNER JOIN LOAN ON LOAN.LENDER_ID = LENDER.ID
                           AND loan.purge_dt IS NULL
        INNER JOIN OWNER_LOAN_RELATE ON OWNER_LOAN_RELATE.loan_id = loan.ID
                                        AND OWNER_LOAN_RELATE.PRIMARY_IN = 'Y'
                                        AND OWNER_LOAN_RELATE.purge_dt IS NULL
        INNER JOIN OWNER ON OWNER.ID = OWNER_LOAN_RELATE.OWNER_ID
                            AND OWNER.purge_dt IS NULL
        INNER JOIN COLLATERAL ON LOAN.ID = COLLATERAL.LOAN_ID
                                 AND collateral.purge_dt IS NULL
        INNER JOIN PROPERTY ON COLLATERAL.PROPERTY_ID = PROPERTY.ID
                               AND property.purge_dt IS NULL
        INNER JOIN REQUIRED_COVERAGE ON required_coverage.PROPERTY_ID = PROPERTY.id
                                        AND required_coverage.purge_dt IS NULL
        INNER JOIN COLLATERAL_CODE ON COLLATERAL.COLLATERAL_CODE_ID = COLLATERAL_CODE.ID
        INNER JOIN owner_address AS padd ON padd.id = property.address_id
        OUTER  APPLY GetCurrentCoverage(PROPERTY.ID, REQUIRED_COVERAGE.ID,
                                        REQUIRED_COVERAGE.TYPE_CD) OP
        LEFT OUTER JOIN owner_policy ON owner_policy.ID = OP.ID
        LEFT OUTER JOIN ref_code AS coverstat ON required_coverage.Status_cd = coverstat.CODE_CD
                                                 AND coverstat.DOMAIN_CD = 'RequiredCoverageStatus'
        LEFT OUTER JOIN ref_code AS summarystat ON required_coverage.SUMMARY_STATUS_CD = summarystat.CODE_CD
                                                   AND summarystat.DOMAIN_CD = 'RequiredCoverageInsStatus'
        LEFT OUTER JOIN ref_code AS summarysubstat ON required_coverage.SUMMARY_SUB_STATUS_CD = summarysubstat.CODE_CD
                                                      AND summarysubstat.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
        LEFT OUTER JOIN ref_code AS Loanstat ON loan.Status_cd = Loanstat.CODE_CD
                                                AND Loanstat.DOMAIN_CD = 'LoanStatus'
        LEFT OUTER JOIN ref_code AS collateralstat ON collateral.Status_cd = collateralstat.CODE_CD
                                                      AND collateralstat.DOMAIN_CD = 'CollateralStatus'
        LEFT OUTER JOIN ref_code AS LoanType ON loan.Type_cd = LoanType.Code_cd
                                                AND LoanType.Domain_cd = 'LoanType'
        LEFT OUTER JOIN ref_code AS ContractType ON loan.Division_code_tx = ContractType.Code_cd
                                                    AND ContractType.domain_cd = 'ContractType'
        LEFT OUTER JOIN ref_code AS BasePropertyType ON owner_policy.BASE_PROPERTY_TYPE_CD = BasePropertyType.Code_cd
                                                        AND BasePropertyType.domain_cd = 'OwnerPolicyBasePropertyType'
WHERE   loan.RECORD_TYPE_CD = 'G'
        AND lender.purge_dt IS NULL
        AND LOAN.EXTRACT_UNMATCH_COUNT_NO = 0
        AND loan.Status_cd <> 'U'
        AND collateral.EXTRACT_UNMATCH_COUNT_NO = 0
        AND collateral.status_cd <> 'U'
        AND lender.code_tx = '7400'
        AND required_coverage.Status_cd <> 'I'