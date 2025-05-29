USE [UniTrac]
GO 




--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX ,
        IH.ISSUE_DT [CPI Issue Date] ,
        P.MAKE_TX ,
        P.MODEL_TX ,
        IH.SPECIAL_HANDLING_XML.value('(/SH/Premium)[1]', 'varchar (50)') [Premium] ,
        RC1.DESCRIPTION_TX [Sub Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        RC5.DESCRIPTION_TX [Collateral Status] ,
        O.LAST_NAME_TX ,
        O.FIRST_NAME_TX ,
        OA.CITY_TX ,
        OA.STATE_PROV_TX ,
        OA.COUNTRY_TX ,
        OA.POSTAL_CODE_TX 
INTO #tmp
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON C.PROPERTY_ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
                                                 AND IH.TYPE_CD = 'CPI'
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.REF_CODE RC0 ON RC0.CODE_CD = RC.SUMMARY_STATUS_CD
                                       AND RC0.DOMAIN_CD = 'RequiredCoverageInsStatus'
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.SUMMARY_SUB_STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
        INNER JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = C.STATUS_CD
                                       AND RC5.DOMAIN_CD = 'CollateralStatus'
WHERE   LL.CODE_TX IN ( '6546' )
        AND RC.SUMMARY_SUB_STATUS_CD = 'C'
        AND IH.ISSUE_DT >= '2014-01-01 '
        AND C.STATUS_CD = 'Z'
        AND IH.SPECIAL_HANDLING_XML.value('(/SH/Reason)[1]', 'varchar (50)') = 'Repossessed'
ORDER BY IH.ISSUE_DT ASC




SELECT * INTO uniTracHDStorage..zINC0233315 FROM #tmp
