USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  L.NUMBER_TX ,
 C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [First Retain],
C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [2]', 'varchar (max)') [Second Retain],
C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [3]', 'varchar (max)') [Third Retain],
C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [4]', 'varchar (max)') [Fourth Retain],
C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [5]', 'varchar (max)') [Fifth Retain],
C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [6]', 'varchar (max)') [Sixth Retain],
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type]
INTO JCs..INC0248883_CollateralRetain
--SELECT COUNT(*)
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
WHERE   LL.CODE_TX IN ( '2324' ) AND C.FIELD_PROTECTION_XML.value('(/FP) [1]', 'varchar (max)') IS NOT NULL
      



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  L.NUMBER_TX ,
  L.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [First Retain],
L.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [2]', 'varchar (max)') [Second Retain],
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type]
INTO JCs..INC0248883_LoanRetain
--SELECT COUNT(*)
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
WHERE   LL.CODE_TX IN ( '2324' ) AND L.FIELD_PROTECTION_XML.value('(/FP) [1]', 'varchar (max)') IS NOT NULL
      


