USE [UniTrac]
GO 

SELECT DISTINCT L.NUMBER_TX [Loan Number], P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Property Retain],
  P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [2]', 'varchar (max)') [Property Retain 2],
   P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [3]', 'varchar (max)') [Property Retain 3],
    c.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Collateral Retain 1],
	 c.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [2]', 'varchar (max)') [Collateral Retain 2] 
INTO    JCs..INC0302934
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
WHERE   LL.CODE_TX IN ( '2300' ) AND (P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') IS NOT NULL
OR C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') IS NOT NULL) 





SELECT * FROM  JCs..INC0302934