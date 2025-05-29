USE [UniTrac]
GO 
	
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT
        L.NUMBER_TX [Loan Number] ,
        RC1.DESCRIPTION_TX [Insurance Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX ,
        L.EFFECTIVE_DT ,
        L.ID ,
        L.LENDER_ID
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
WHERE   LL.CODE_TX IN ( '7150' ) --AND L.NUMBER_TX = '167676'
        AND SUMMARY_STATUS_CD IN ('A', 'C')
     

		--SELECT * FROM dbo.REF_CODE
		--WHERE DOMAIN_CD = 'RequiredCoverageInsStatus'