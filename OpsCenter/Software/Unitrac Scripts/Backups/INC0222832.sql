USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT
        L.NUMBER_TX ,
        L.RETAIN_IN ,
		L.EFFECTIVE_DT,
		RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type],
		        L.ORIGINAL_BALANCE_AMOUNT_NO ,
		        L.ORIGINAL_PAYMENT_AMOUNT_NO ,
		        L.APR_AMOUNT_NO ,
		        L.PAYMENT_AMOUNT_NO ,
		        L.PAYMENT_FREQUENCY_CD ,
		        L.NEXT_SCHEDULED_PAYMENT_DT ,
		        L.PAYOFF_DT ,
		        L.BRANCH_CODE_TX ,
		        L.DIVISION_CODE_TX ,
		        L.SERVICECENTER_CODE_TX, 
		        L.NOTE_TX 
		         --INTO UniTracHDStorage..zINC0222832
FROM    LOAN L
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   L.RETAIN_IN = 'Y'
        AND LL.CODE_TX = '4192'

SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'LoanStatus'

SELECT * FROM dbo.LOAN



SELECT * FROM dbo.LENDER
WHERE id = '755'