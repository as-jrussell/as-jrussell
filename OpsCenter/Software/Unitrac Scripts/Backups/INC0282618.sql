USE [UniTrac]
GO 

SELECT DISTINCT P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [First Retain],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [2]', 'varchar (max)') [Second Retain],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [3]', 'varchar (max)') [Third Retain],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [4]', 'varchar (max)') [Fourth Retain],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [5]', 'varchar (max)') [Fifth Retain],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [6]', 'varchar (max)') [Sixth Retain],

P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [7]', 'varchar (max)') [Seventh Retain],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [8]', 'varchar (max)') [Eighth Retain],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [9]', 'varchar (max)') [Ninth Retain],
        RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        L.NUMBER_TX ,
        L.BRANCH_CODE_TX [Branch Code] ,
        O.LAST_NAME_TX ,
        O.FIRST_NAME_TX ,
        O.MIDDLE_INITIAL_TX ,
        OA.LINE_1_TX ,
        OA.CITY_TX ,
        OA.STATE_PROV_TX ,
        OA.COUNTRY_TX ,
        OA.POSTAL_CODE_TX--, p.FIELD_PROTECTION_XML
--INTO    UniTracHDStorage..AAAINC0230023
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.LENDER_PRODUCT LP ON LP.ID = RC.LENDER_PRODUCT_ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
WHERE   LL.CODE_TX IN ( '4422' ) AND P.ADDRESS_ID IS NOT NULL
        AND P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]',
                                         'varchar (max)') IS NOT NULL