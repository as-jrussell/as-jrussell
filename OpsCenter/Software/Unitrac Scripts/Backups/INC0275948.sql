USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  L.NUMBER_TX ,
        C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Status Retain] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        L.ID [LoanID]
INTO    #tmpA
--INTO JCs..INC0248883_CollateralRetain
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
WHERE   LL.CODE_TX IN ( '2375' )
        AND C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]',
                                         'varchar (max)') = 'StatusCode'
      



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  L.NUMBER_TX ,
        L.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Status Retain] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        L.ID [LoanID]
INTO    #tmpB
--INTO JCs..INC0248883_LoanRetain
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
WHERE   LL.CODE_TX IN ( '2375' )
        AND L.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]',
                                         'varchar (max)') = 'StatusCode'
      
      

CREATE TABLE #tmp (LoanNumber NVARCHAR(1000), [Status Retain] NVARCHAR(1000), [Loan Record Type] NVARCHAR(1000), [Loan Status] NVARCHAR(1000), [Loan Type] NVARCHAR(1000), [LoanID] NVARCHAR(1000))
INSERT INTO #tmp
  SELECT  NUMBER_TX ,
                [Status Retain] ,
                [Loan Record Type] ,
                [Loan Status] ,
                [Loan Type] ,
                LoanID FROM #tmpA
INSERT INTO #tmp
  SELECT  NUMBER_TX ,
                [Status Retain] ,
                [Loan Record Type] ,
                [Loan Status] ,
                [Loan Type] ,
                LoanID FROM #tmpB



SELECT LoanID, COUNT(LoanID) [Count]
--INTO #tmpC
FROM #tmp
GROUP BY LoanID
HAVING COUNT(LoanID) = '2'




SELECT T.*, LO.NAME_TX [Division] FROM #tmp T
JOIN dbo.LOAN L ON L.ID = T.LoanID
JOIN dbo.LENDER_ORGANIZATION LO ON L.DIVISION_CODE_TX = LO.CODE_TX AND LO.LENDER_ID = L.LENDER_ID


