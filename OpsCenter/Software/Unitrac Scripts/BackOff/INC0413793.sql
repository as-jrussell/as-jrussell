use unitrac


SELECT  RC.TYPE_CD [Coverage type] ,
        RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
		CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status],
        L.EFFECTIVE_DT ,
        L.NUMBER_TX ,
        L.BRANCH_CODE_TX [Branch Code] 
	--	,RC.ID [RC_ID] ,        L.ID [LoanID], RC.*
--INTO    UniTracHDStorage..AAAINC0230023
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
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
where LL.CODE_TX = '1987' and L.RECORD_TYPE_CD = 'A' 
and L.STATUS_CD = 'U' and l.PURGE_DT is null  and cpi_status_cd = 'E' and cpi_sub_status_cd = 'C'