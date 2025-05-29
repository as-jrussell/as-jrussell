USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ACCOUNTING_PERIOD'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ACCOUNTING_PERIOD] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ADDRESS'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ADDRESS] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'AGENCY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [AGENCY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BIC_CLEAN_NAME'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BIC_CLEAN_NAME] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BIC_MAPPED_NAME'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BIC_MAPPED_NAME] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BILLING_GROUP'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BILLING_GROUP] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BLOB'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BLOB] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BORROWER_INSURANCE_AGENCY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BORROWER_INSURANCE_AGENCY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BORROWER_INSURANCE_COMPANY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BORROWER_INSURANCE_COMPANY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BORROWER_INSURANCE_COMPANY_ADDRESS_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BORROWER_INSURANCE_COMPANY_ADDRESS_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BORROWER_INSURANCE_COMPANY_OFFERING'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BORROWER_INSURANCE_COMPANY_OFFERING] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BORROWER_INSURANCE_EXTRACT_TRANSACTION_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BORROWER_INSURANCE_EXTRACT_TRANSACTION_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BUSINESS_OPTION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BUSINESS_OPTION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BUSINESS_OPTION_GROUP'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BUSINESS_OPTION_GROUP] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'BUSINESS_RULE_BASE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [BUSINESS_RULE_BASE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'CARRIER'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [CARRIER] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'CARRIER_PRODUCT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [CARRIER_PRODUCT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Category'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [Category] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'CERTIFICATE_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [CERTIFICATE_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'CHANGE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [CHANGE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'CHANGE_UPDATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [CHANGE_UPDATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'COLLATERAL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [COLLATERAL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'COLLATERAL_CODE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [COLLATERAL_CODE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'COLLATERAL_EXTRACT_TRANSACTION_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [COLLATERAL_EXTRACT_TRANSACTION_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'COMMISSION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [COMMISSION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'COMMISSION_RATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [COMMISSION_RATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'CoverageList'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [CoverageList] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'CPI_ACTIVITY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [CPI_ACTIVITY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'CPI_QUOTE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [CPI_QUOTE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'DELIVERY_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [DELIVERY_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'DELIVERY_INFO'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [DELIVERY_INFO] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'DELIVERY_INFO_EXTRACT_CONFIG_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [DELIVERY_INFO_EXTRACT_CONFIG_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'DELIVERY_INFO_GROUP'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [DELIVERY_INFO_GROUP] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'DOCUMENT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [DOCUMENT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'DOCUMENT_CONTAINER'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [DOCUMENT_CONTAINER] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'EMAIL_REQUESTS'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [EMAIL_REQUESTS] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ESCROW'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ESCROW] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ESCROW_EVENT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ESCROW_EVENT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ESCROW_EXCEPTION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ESCROW_EXCEPTION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ESCROW_REQUIRED_COVERAGE_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ESCROW_REQUIRED_COVERAGE_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ESCROW_VERIFICATION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ESCROW_VERIFICATION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'EVALUATION_EVENT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [EVALUATION_EVENT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'EVENT_SEQ_CONTAINER'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [EVENT_SEQ_CONTAINER] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'EVENT_SEQUENCE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [EVENT_SEQUENCE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'FILE_IMPORT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [FILE_IMPORT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'FINANCIAL_REPORT_TXN'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [FINANCIAL_REPORT_TXN] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'FINANCIAL_REPORT_TXN_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [FINANCIAL_REPORT_TXN_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'FINANCIAL_TXN'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [FINANCIAL_TXN] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'FINANCIAL_TXN_APPLY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [FINANCIAL_TXN_APPLY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'FINANCIAL_TXN_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [FINANCIAL_TXN_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'FORCE_PLACED_CERTIFICATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [FORCE_PLACED_CERTIFICATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'HOLIDAY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [HOLIDAY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'IMPAIRMENT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [IMPAIRMENT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'INSURANCE_EXTRACT_TRANSACTION_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [INSURANCE_EXTRACT_TRANSACTION_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'INTERACTION_HISTORY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [INTERACTION_HISTORY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ISSUE_PROC_RULE_CALC_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ISSUE_PROC_RULE_CALC_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ISSUE_PROCEDURE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ISSUE_PROCEDURE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ISSUE_RULE_CALC'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ISSUE_RULE_CALC] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LCCG_COLLATERAL_CODE_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LCCG_COLLATERAL_CODE_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_ALIAS'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_ALIAS] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_COLLATERAL_CODE_GROUP'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_COLLATERAL_CODE_GROUP] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_COLLATERAL_GROUP_COVERAGE_TYPE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_COLLATERAL_GROUP_COVERAGE_TYPE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_FINANCIAL_TXN'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_FINANCIAL_TXN] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_GROUP'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_GROUP] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_GROUP_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_GROUP_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_ORGANIZATION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_ORGANIZATION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_PAYEE_CODE_FILE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_PAYEE_CODE_FILE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_PAYEE_CODE_MATCH'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_PAYEE_CODE_MATCH] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_PRODUCT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_PRODUCT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LOAN'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LOAN] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LOAN_EXTRACT_TRANSACTION_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LOAN_EXTRACT_TRANSACTION_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LOAN_NUMBER'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LOAN_NUMBER] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Log'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [Log] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'MASTER_POLICY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [MASTER_POLICY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'MASTER_POLICY_ASSIGNMENT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [MASTER_POLICY_ASSIGNMENT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'MASTER_POLICY_ENDORSEMENT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [MASTER_POLICY_ENDORSEMENT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'MASTER_POLICY_LENDER_PRODUCT_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [MASTER_POLICY_LENDER_PRODUCT_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'MESSAGE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [MESSAGE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'NOTICE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [NOTICE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'NOTICE_REQUIRED_COVERAGE_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [NOTICE_REQUIRED_COVERAGE_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'OFFICE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [OFFICE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'OUTPUT_BATCH'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [OUTPUT_BATCH] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'OUTPUT_BATCH_LOG'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [OUTPUT_BATCH_LOG] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'OUTPUT_CONFIGURATION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [OUTPUT_CONFIGURATION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'OWNER'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [OWNER] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'OWNER_ADDRESS'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [OWNER_ADDRESS] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'OWNER_LOAN_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [OWNER_LOAN_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'OWNER_POLICY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [OWNER_POLICY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PERSON'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PERSON] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'POLICY_COVERAGE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [POLICY_COVERAGE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'POLICY_ENDORSEMENT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [POLICY_ENDORSEMENT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PPDATTRIBUTE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PPDATTRIBUTE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PREPROCESSING_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PREPROCESSING_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PRIOR_CARRIER_POLICY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PRIOR_CARRIER_POLICY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROCESS_DEFINITION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROCESS_DEFINITION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROCESS_LOG'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROCESS_LOG] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROCESS_LOG_ITEM'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROCESS_LOG_ITEM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROPERTY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROPERTY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROPERTY_ASSOCIATION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROPERTY_ASSOCIATION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROPERTY_CHANGE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROPERTY_CHANGE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROPERTY_CHANGE_UPDATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROPERTY_CHANGE_UPDATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROPERTY_OWNER_POLICY_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROPERTY_OWNER_POLICY_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QUALITY_CONTROL_ITEM'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [QUALITY_CONTROL_ITEM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REF_CODE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REF_CODE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REF_CODE_ATTRIBUTE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REF_CODE_ATTRIBUTE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REF_DOMAIN'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REF_DOMAIN] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'RELATED_DATA'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [RELATED_DATA] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'RELATED_DATA_DEF'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [RELATED_DATA_DEF] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REPORT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REPORT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REPORT_CONFIG'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REPORT_CONFIG] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REPORT_CONFIG_ATTRIBUTE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REPORT_CONFIG_ATTRIBUTE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REPORT_HISTORY'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REPORT_HISTORY] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REQUIRED_COVERAGE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REQUIRED_COVERAGE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REQUIRED_ESCROW'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REQUIRED_ESCROW] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'RULE_CONDITION_BASE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [RULE_CONDITION_BASE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'SERVICE_CENTER'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [SERVICE_CENTER] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'SERVICE_CENTER_FUNCTION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [SERVICE_CENTER_FUNCTION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'SERVICE_CENTER_FUNCTION_LENDER_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [SERVICE_CENTER_FUNCTION_LENDER_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'SERVICE_FEE_INVOICE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [SERVICE_FEE_INVOICE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'SERVICE_FEE_INVOICE_CONFIG'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [SERVICE_FEE_INVOICE_CONFIG] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'SERVICE_FEE_INVOICE_ITEM'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [SERVICE_FEE_INVOICE_ITEM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'SERVICE_FEE_INVOICE_ITEM_CONFIG'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [SERVICE_FEE_INVOICE_ITEM_CONFIG] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'SERVICE_FEE_INVOICE_ITEM_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [SERVICE_FEE_INVOICE_ITEM_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'SERVICE_FEE_RATE_CONFIG'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [SERVICE_FEE_RATE_CONFIG] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'TEMPLATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [TEMPLATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'TRADING_PARTNER'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [TRADING_PARTNER] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'TRANSACTION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [TRANSACTION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'UNITRAC_TO_LATEST_LENDER_DATA_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [UNITRAC_TO_LATEST_LENDER_DATA_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'USER_WORK_QUEUE_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [USER_WORK_QUEUE_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'USERS'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [USERS] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'UTL_MATCH_RESULT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [UTL_MATCH_RESULT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'WAIVE_TRACK'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [WAIVE_TRACK] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'WORK_ITEM'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [WORK_ITEM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'WORK_ITEM_ACTION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [WORK_ITEM_ACTION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'WORK_ITEM_PROCESS_LOG_ITEM_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [WORK_ITEM_PROCESS_LOG_ITEM_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ForcePlacedCertificateView'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ForcePlacedCertificateView] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'WORK_QUEUE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [WORK_QUEUE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'WORK_QUEUE_WORK_ITEM_RELATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [WORK_QUEUE_WORK_ITEM_RELATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'WORKFLOW_DEFINITION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [WORKFLOW_DEFINITION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LOAN_OIC'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LOAN_OIC] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REPORT_HISTORY_NOXML'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REPORT_HISTORY_NOXML] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'CheckSumDigit'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [CheckSumDigit] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'fn_GetPropertyDescription'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [fn_GetPropertyDescription] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'fn_GetPropertyDescriptionForReports'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [fn_GetPropertyDescriptionForReports] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetCommissions'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [GetCommissions] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetLenderExtractProcessedDate'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [GetLenderExtractProcessedDate] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetLenders'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [GetLenders] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetLoanNumbers'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [GetLoanNumbers] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetLoans'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [GetLoans] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetPastDueDays'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [GetPastDueDays] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetPastDueDaysDaysAndDate'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [GetPastDueDaysDaysAndDate] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetProperty'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [GetProperty] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetWorkItem'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [GetWorkItem] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Login'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Login] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_BillingStatements'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_BillingStatements] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_CallResolution'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_CallResolution] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_CPIFundRefundImportFileLogs'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_CPIFundRefundImportFileLogs] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_EOM'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_EOM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_Escrow'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_Escrow] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_EscrowNewCarrier'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_EscrowNewCarrier] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_LoanStatus'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_LoanStatus] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_PaymentChanges'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_PaymentChanges] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_PreEscrow'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_PreEscrow] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'Report_WorkItem'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [Report_WorkItem] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END


USE Unitrac

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ReportBSS_TranStats'
                      AND TYPE = 'EX'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT EXECUTE ON [dbo]. [ReportBSS_TranStats] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT EXECUTE was issued to PIMS_APP_ACCESS on Unitrac'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROCESS_DEFINITION'
                      AND TYPE = 'in'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT INSERT ON [dbo]. [PROCESS_DEFINITION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT INSERT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROCESS_LOG'
                      AND TYPE = 'in'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT INSERT ON [dbo]. [PROCESS_LOG] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT INSERT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QC_BATCH_DEFINITION'
                      AND TYPE = 'in'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT INSERT ON [dbo]. [QC_BATCH_DEFINITION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT INSERT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QC_BATCH_ITEM'
                      AND TYPE = 'in'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT INSERT ON [dbo]. [QC_BATCH_ITEM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT INSERT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QC_BATCH'
                      AND TYPE = 'in'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT INSERT ON [dbo]. [QC_BATCH] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT INSERT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROCESS_DEFINITION'
                      AND TYPE = 'UP'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT UPDATE ON [dbo]. [PROCESS_DEFINITION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT UPDATE was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROCESS_LOG'
                      AND TYPE = 'UP'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT UPDATE ON [dbo]. [PROCESS_LOG] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT UPDATE was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QC_BATCH_DEFINITION'
                      AND TYPE = 'UP'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT UPDATE ON [dbo]. [QC_BATCH_DEFINITION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT UPDATE was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QC_BATCH_ITEM'
                      AND TYPE = 'UP'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT UPDATE ON [dbo]. [QC_BATCH_ITEM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT UPDATE was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QC_BATCH'
                      AND TYPE = 'UP'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT UPDATE ON [dbo]. [QC_BATCH] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT UPDATE was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROCESS_DEFINITION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROCESS_DEFINITION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'PROCESS_LOG'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [PROCESS_LOG] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QC_BATCH_DEFINITION'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [QC_BATCH_DEFINITION] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QC_BATCH_ITEM'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [QC_BATCH_ITEM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE QCModule

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'QC_BATCH'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [QC_BATCH] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on QCModule'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'DATE_DIM'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [DATE_DIM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'EDI_FACT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [EDI_FACT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'GetWeeklyDimension'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [GetWeeklyDimension] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'ININ_CALL_DETAIL'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [ININ_CALL_DETAIL] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'LENDER_SUMMARY_FACT'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [LENDER_SUMMARY_FACT] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'MONTH_DIM'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [MONTH_DIM] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'OPEN_CERTIFICATE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [OPEN_CERTIFICATE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REF_CODE_ATTRIBUTE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REF_CODE_ATTRIBUTE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REF_CODE'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REF_CODE] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REF_DOMAIN'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REF_DOMAIN] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END

USE UniTrac_DW

IF NOT EXISTS (SELECT 1
               FROM   sys.database_permissions
               WHERE  Object_name(major_id) = 'REQUIRED_COVERAGE_STATUS'
                      AND TYPE = 'SL'
                      AND User_name(grantee_principal_id) = 'PIMS_APP_ACCESS')
  BEGIN
      GRANT SELECT ON [dbo]. [REQUIRED_COVERAGE_STATUS] TO [PIMS_APP_ACCESS]

      PRINT 'SUCCESS: GRANT SELECT was issued to PIMS_APP_ACCESS on UniTrac_DW'
  END
ELSE
  BEGIN
      PRINT 'WARNING: GRANTS ALREADY EXISTS'
  END 



