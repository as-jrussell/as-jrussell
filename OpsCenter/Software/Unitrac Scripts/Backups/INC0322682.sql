USE UniTrac;

SELECT DISTINCT RC.TYPE_CD ,
       --         RC1.DESCRIPTION_TX [Coverage Status] ,
       --         RC2.DESCRIPTION_TX [Loan Record Type] ,
       RC3.DESCRIPTION_TX [Loan Status] ,
       RC4.DESCRIPTION_TX [Loan Type] ,
       CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status] ,
       L.NUMBER_TX ,
       CONCAT(O.FIRST_NAME_TX, ' ', O.LAST_NAME_TX) AS [Name] ,
       OA.ID ,
       OA.LINE_1_TX ,
       OA.LINE_2_TX ,
       OA.CITY_TX ,
       OA.STATE_PROV_TX ,
       OA.COUNTRY_TX ,
       OA.POSTAL_CODE_TX
--SELECT OP.*
--INTO   JCs..INC0322682
FROM   LOAN L
       INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
       INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
       INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
       INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
       INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
       INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
       INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
       INNER JOIN dbo.LENDER_PRODUCT LP ON LP.ID = RC.LENDER_PRODUCT_ID
       INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
       INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
       INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
       INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.STATUS_CD
                                      AND RC1.DOMAIN_CD = 'RequiredCoverageStatus'
       INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                      AND RC2.DOMAIN_CD = 'RecordType'
       INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                      AND RC3.DOMAIN_CD = 'LoanStatus'
       LEFT JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                     AND RC4.DOMAIN_CD = 'LoanType'
       LEFT JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = RC.INSURANCE_STATUS_CD
                                     AND RC5.DOMAIN_CD = 'RequiredCoverageInsStatus'
       LEFT JOIN dbo.REF_CODE RC6 ON RC6.CODE_CD = RC.INSURANCE_SUB_STATUS_CD
                                     AND RC6.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
       LEFT JOIN dbo.REF_CODE RC7 ON RC7.CODE_CD = RC.SUB_STATUS_CD
                                     AND RC7.DOMAIN_CD = 'RequiredCoverageSubStatus'
       LEFT JOIN dbo.LENDER_ORGANIZATION LO ON LO.LENDER_ID = LL.ID
                                               AND LO.TYPE_CD = 'DIV'
                                               AND LO.CODE_TX = L.DIVISION_CODE_TX
WHERE  LL.CODE_TX IN ( '3000' )
       AND P.VIN_TX IS NOT NULL
       AND RC.TYPE_CD = 'PHYS-DAMAGE'
       AND L.RECORD_TYPE_CD IN ( 'G', 'A' )
       AND OP.CANCELLATION_DT IS NULL
       AND OP.EFFECTIVE_DT < '2017-08-13 '
       AND OP.STATUS_CD != 'F';
