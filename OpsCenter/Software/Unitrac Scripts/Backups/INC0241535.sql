USE [UniTrac]
GO 



--  add owner,  date CPI funded 
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT 
		DISTINCT p.ID
INTO #tmp
--SELECT COUNT(*)
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
		INNER JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
		INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX = '1937'




SELECT DISTINCT 
        L.NUMBER_TX ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
		IH.SPECIAL_HANDLING_XML.value('(/SH/Status)[1]', 'varchar (50)') [CPI Status] ,
		IH.SPECIAL_HANDLING_XML.value('(/SH/EffDate)[1]', 'varchar (50)') [CPI Effective Date] ,
		IH.SPECIAL_HANDLING_XML.value('(/SH/StatusDate)[1]', 'varchar (50)') [CPI Status Date] ,
        L.EFFECTIVE_DT [Loan Effective Date]     
--INTO INC0241535
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
WHERE   L.LENDER_ID = '440'
        AND ih.TYPE_CD = 'cpI'
        AND P.ID IN ( SELECT   * FROM #tmp )



SELECT TOP 1 * FROM dbo.INTERACTION_HISTORY
WHERE PROPERTY_ID IN ( SELECT  * FROM #tmp )
AND TYPE_CD = 'CPI'


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'ExDate'

