USE [UniTrac];
GO

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT L.NUMBER_TX [Loan] ,
       P.VIN_TX [Loan VIN] ,
       CR.MEANING_TX [Loan Status] ,
       OP.POLICY_NUMBER_TX [Policy Number] ,
       OP.BIC_NAME_TX [Outside Insurance ] ,
       CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status]
FROM   JCs..[JDCPI] D
       LEFT JOIN PROPERTY P ON D.VehicleIdentificationNumber = P.VIN_TX
       LEFT JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
       LEFT JOIN LOAN L ON L.ID = C.LOAN_ID
       LEFT JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
       LEFT JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
       LEFT JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
       LEFT JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
       LEFT JOIN dbo.REF_CODE CR ON CR.CODE_CD = L.RECORD_TYPE_CD
                                     AND CR.DOMAIN_CD = 'RecordType'
       LEFT JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = OP.STATUS_CD
                                     AND RC5.DOMAIN_CD = 'RequiredCoverageInsStatus'
       LEFT JOIN dbo.REF_CODE RC6 ON RC6.CODE_CD = OP.SUB_STATUS_CD
                                     AND RC6.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
WHERE  LL.CODE_TX IN ( '4804' )
       AND L.RECORD_TYPE_CD IN ( 'A', 'G' )
--  AND OP.BIC_NAME_TX <> 'CPI'
-- AND OP.EXPIRATION_DT >= '2017-12-17'
-- AND OP.CANCELLATION_DT IS NULL;

SELECT * FROM JCs..[JDCPI]

