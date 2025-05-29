USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT  L.CREATE_DT [Date Loan added to system] ,
        L.NUMBER_TX ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,RC1.DESCRIPTION_TX AS [Coverage Status],
        CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status]
		INTO   jcs..INC0280317
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
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
WHERE   L.LENDER_ID = '44'
        AND L.RECORD_TYPE_CD IN ( 'A', 'G' )
        AND L.CREATE_DT >= '2016-01-01 '
        AND L.CREATE_DT <= '2016-02-29 '
ORDER BY L.CREATE_DT ASC  

---DROP TABLE jcs..INC0280317
