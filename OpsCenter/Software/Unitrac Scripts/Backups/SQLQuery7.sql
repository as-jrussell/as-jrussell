SELECT lender.CODE_TX AS 'Lender' ,
       lender.NAME_TX AS 'LenderName' ,
       loan.number_tx AS 'AccountNumber' ,
       ISNULL(PROPERTY.YEAR_TX, '') AS 'Year' ,
       ISNULL(PROPERTY.MAKE_TX, '') AS 'Make' ,
       ISNULL(PROPERTY.MODEL_TX, '') AS 'Model' ,
       ISNULL(PROPERTY.VIN_TX, '') AS 'VIN' ,
       ISNULL(CONVERT(CHAR(10), REQUIRED_COVERAGE.EXPOSURE_DT, 101), '') AS 'IssueDate' ,
       RTRIM(ISNULL([OWNER_ADDRESS].LINE_1_TX, '') + ' '
             + ISNULL([OWNER_ADDRESS].LINE_2_TX, '')
            ) AS [Address] ,
       [OWNER_ADDRESS].CITY_TX AS City ,
       [OWNER_ADDRESS].STATE_PROV_TX AS [State] ,
       [OWNER_ADDRESS].POSTAL_CODE_TX AS ZipCode ,
       '' AS [LicensePlate] ,
       '' AS [PlateState] ,
       '' AS [Delinquent] ,
       '' AS Color ,
       'Open' AS [Action]
FROM   LENDER
       INNER JOIN LOAN ON loan.LENDER_ID = lender.ID
                          AND loan.purge_dt IS NULL
       INNER JOIN OWNER_LOAN_RELATE ON OWNER_LOAN_RELATE.loan_id = loan.ID
                                       AND OWNER_LOAN_RELATE.PRIMARY_IN = 'Y'
                                       AND OWNER_LOAN_RELATE.purge_dt IS NULL
       INNER JOIN OWNER ON OWNER.ID = OWNER_LOAN_RELATE.OWNER_ID
                           AND OWNER.purge_dt IS NULL
       INNER JOIN owner_address ON OWNER_ADDRESS.id = OWNER.address_id
       INNER JOIN COLLATERAL ON loan.ID = COLLATERAL.LOAN_ID
                                AND COLLATERAL.purge_dt IS NULL
       INNER JOIN PROPERTY ON COLLATERAL.PROPERTY_ID = PROPERTY.ID
                              AND PROPERTY.purge_dt IS NULL
                              AND PROPERTY.RECORD_TYPE_CD = 'G'
       INNER JOIN REQUIRED_COVERAGE ON REQUIRED_COVERAGE.PROPERTY_ID = PROPERTY.id
                                       AND REQUIRED_COVERAGE.purge_dt IS NULL
       INNER JOIN COLLATERAL_CODE ON COLLATERAL.COLLATERAL_CODE_ID = COLLATERAL_CODE.ID
       LEFT OUTER JOIN owner_address AS padd ON padd.id = PROPERTY.address_id
       LEFT OUTER JOIN ref_code AS coverstat ON REQUIRED_COVERAGE.Status_cd = coverstat.CODE_CD
                                                AND coverstat.DOMAIN_CD = 'RequiredCoverageStatus'
       LEFT OUTER JOIN ref_code AS summarystat ON REQUIRED_COVERAGE.SUMMARY_STATUS_CD = summarystat.CODE_CD
                                                  AND summarystat.DOMAIN_CD = 'RequiredCoverageInsStatus'
       LEFT OUTER JOIN ref_code AS summarysubstat ON REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = summarysubstat.CODE_CD
                                                     AND summarysubstat.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
       LEFT OUTER JOIN ref_code AS Loanstat ON loan.Status_cd = Loanstat.CODE_CD
                                               AND Loanstat.DOMAIN_CD = 'LoanStatus'
       LEFT OUTER JOIN ref_code AS collateralstat ON COLLATERAL.Status_cd = collateralstat.CODE_CD
                                                     AND collateralstat.DOMAIN_CD = 'CollateralStatus'
       LEFT OUTER JOIN lender_organization ON lender_organization.lender_id = loan.lender_id
                                              AND lender_organization.Type_cd = 'DPRT'
                                              AND loan.department_code_tx = lender_organization.code_tx
                                              AND lender_organization.purge_dt IS NULL
WHERE  1 = 1
       AND loan.RECORD_TYPE_CD = 'G'
       AND loan.EXTRACT_UNMATCH_COUNT_NO = 0
       AND loan.Status_cd != 'U'
       AND COLLATERAL.EXTRACT_UNMATCH_COUNT_NO = 0
       AND COLLATERAL.STATUS_CD != 'U'
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'F'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'D'
               )
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'P'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'D'
               )
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'F'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'B'
               )
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'P'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'B'
               )
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'B'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'C'
               )
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'U'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'C'
               )
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'F'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'C'
               )
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'F'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'P'
               )
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'F'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'I'
               )
       AND NOT (   REQUIRED_COVERAGE.SUMMARY_STATUS_CD = 'P'
                   AND REQUIRED_COVERAGE.SUMMARY_SUB_STATUS_CD = 'I'
               )
       AND lender.ID = @lid
       AND LEN(PROPERTY.VIN_TX) = 17;
