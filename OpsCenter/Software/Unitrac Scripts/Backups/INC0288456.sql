USE UniTrac

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE

 SELECT DISTINCT P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [FloodZone] ,
        L.NUMBER_TX [Loan Number],
		   RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,		
		CONCAT(RC3.DESCRIPTION_TX, ' ', RC4.DESCRIPTION_TX) AS [Loan Type and Status],
		CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status], C.RETAIN_IN, L.RETAIN_In
		--INTO jcs..INC0288456
 FROM   LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
        INNER JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
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
 WHERE  LL.CODE_TX IN ( '7100' )
        AND P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]',
                                         'varchar (max)') = 'FloodZone'
ORDER BY  RC2.DESCRIPTION_TX  ASC 