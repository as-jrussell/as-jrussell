USE [UniTrac]
GO 





SELECT --COUNT(*)
       -- DISTINCT L.NUMBER_TX ,
       -- BIC_NAME_TX ,
       -- RC1.DESCRIPTION_TX [Coverage Status] ,
       -- RC2.DESCRIPTION_TX [Loan Record Type] ,
       -- RC3.DESCRIPTION_TX [Loan Status] ,
       -- RC4.DESCRIPTION_TX [Loan Type] ,  IH.TYPE_CD, IH.EFFECTIVE_DT,
       --N.NAME_TX , N.REFERENCE_ID_TX,
	   TOP 65000 N.ID INTO #tmp1
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
		INNER JOIN dbo.NOTICE N ON N.LOAN_ID = L.ID
        LEFT JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
                                                AND IH.TYPE_CD = 'NOTICE'
        INNER JOIN REQUIRED_COVERAGE RC ON IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]',
                                                              'varchar (50)') = RC.ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
		
WHERE   OP.BIC_NAME_TX LIKE '%GEICO%'
        AND RC.INSURANCE_STATUS_CD <> 'F'
		AND IH.EFFECTIVE_DT >= '2016-03-28 '



SELECT --COUNT(*)
       -- DISTINCT L.NUMBER_TX ,
       -- BIC_NAME_TX ,
       -- RC1.DESCRIPTION_TX [Coverage Status] ,
       -- RC2.DESCRIPTION_TX [Loan Record Type] ,
       -- RC3.DESCRIPTION_TX [Loan Status] ,
       -- RC4.DESCRIPTION_TX [Loan Type] ,  IH.TYPE_CD, IH.EFFECTIVE_DT,
       --N.NAME_TX , N.REFERENCE_ID_TX, 
	   TOP 65000 N.ID INTO #tmp2
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
		INNER JOIN dbo.NOTICE N ON N.LOAN_ID = L.ID
        LEFT JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
                                                AND IH.TYPE_CD = 'NOTICE'
        INNER JOIN REQUIRED_COVERAGE RC ON IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]',
                                                              'varchar (50)') = RC.ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
		
WHERE   OP.BIC_NAME_TX LIKE '%GEICO%'
        AND RC.INSURANCE_STATUS_CD <> 'F'
		AND IH.EFFECTIVE_DT >= '2016-03-28 ' AND N.ID NOT IN (SELECT ID FROM #tmp1)



SELECT --COUNT(*)
       -- DISTINCT L.NUMBER_TX ,
       -- BIC_NAME_TX ,
       -- RC1.DESCRIPTION_TX [Coverage Status] ,
       -- RC2.DESCRIPTION_TX [Loan Record Type] ,
       -- RC3.DESCRIPTION_TX [Loan Status] ,
       -- RC4.DESCRIPTION_TX [Loan Type] ,  IH.TYPE_CD, IH.EFFECTIVE_DT,
       --N.NAME_TX , N.REFERENCE_ID_TX,
	 TOP 65000   N.ID INTO #tmp3
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
		INNER JOIN dbo.NOTICE N ON N.LOAN_ID = L.ID
        LEFT JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
                                                AND IH.TYPE_CD = 'NOTICE'
        INNER JOIN REQUIRED_COVERAGE RC ON IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]',
                                                              'varchar (50)') = RC.ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
		
WHERE   OP.BIC_NAME_TX LIKE '%GEICO%'
        AND RC.INSURANCE_STATUS_CD <> 'F' AND N.ID NOT IN (SELECT ID FROM #tmp1)
		AND IH.EFFECTIVE_DT >= '2016-03-28 ' AND N.ID NOT IN (SELECT ID FROM #tmp2)
	



SELECT --COUNT(*)
       -- DISTINCT L.NUMBER_TX ,
       -- BIC_NAME_TX ,
       -- RC1.DESCRIPTION_TX [Coverage Status] ,
       -- RC2.DESCRIPTION_TX [Loan Record Type] ,
       -- RC3.DESCRIPTION_TX [Loan Status] ,
       -- RC4.DESCRIPTION_TX [Loan Type] ,  IH.TYPE_CD, IH.EFFECTIVE_DT,
       --N.NAME_TX , N.REFERENCE_ID_TX,
	 TOP 65000   N.ID INTO #tmp4
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
		INNER JOIN dbo.NOTICE N ON N.LOAN_ID = L.ID
        LEFT JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
                                                AND IH.TYPE_CD = 'NOTICE'
        INNER JOIN REQUIRED_COVERAGE RC ON IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]',
                                                              'varchar (50)') = RC.ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
		
WHERE   OP.BIC_NAME_TX LIKE '%GEICO%'  AND N.ID NOT IN (SELECT ID FROM #tmp1)
        AND RC.INSURANCE_STATUS_CD <> 'F'  AND N.ID NOT IN (SELECT ID FROM #tmp2)
		AND IH.EFFECTIVE_DT >= '2016-03-28 ' AND N.ID NOT IN (SELECT ID FROM #tmp3)




SELECT --COUNT(*)
       -- DISTINCT L.NUMBER_TX ,
       -- BIC_NAME_TX ,
       -- RC1.DESCRIPTION_TX [Coverage Status] ,
       -- RC2.DESCRIPTION_TX [Loan Record Type] ,
       -- RC3.DESCRIPTION_TX [Loan Status] ,
       -- RC4.DESCRIPTION_TX [Loan Type] ,  IH.TYPE_CD, IH.EFFECTIVE_DT,
       --N.NAME_TX , N.REFERENCE_ID_TX,
	 TOP 65000   N.ID INTO #tmp5
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
		INNER JOIN dbo.NOTICE N ON N.LOAN_ID = L.ID
        LEFT JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
                                                AND IH.TYPE_CD = 'NOTICE'
        INNER JOIN REQUIRED_COVERAGE RC ON IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]',
                                                              'varchar (50)') = RC.ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
		
WHERE   OP.BIC_NAME_TX LIKE '%GEICO%'  AND N.ID NOT IN (SELECT ID FROM #tmp1)
        AND RC.INSURANCE_STATUS_CD <> 'F'  AND N.ID NOT IN (SELECT ID FROM #tmp2)
		AND IH.EFFECTIVE_DT >= '2016-03-28 ' AND N.ID NOT IN (SELECT ID FROM #tmp3)
		AND N.ID NOT IN (SELECT ID FROM #tmp4)
		


		--DROP TABLE tmp1
		--DROP TABLE tmp2
		--DROP TABLE #tmp3
		--DROP TABLE #tmp4
		--DROP TABLE #tmp5



SELECT * 
INTO JCs..INC0246925_Notice1
FROM #tmp1


SELECT * 
INTO JCs..INC0246925_Notice2
FROM #tmp2


SELECT * 
INTO JCs..INC0246925_Notice3
FROM #tmp3


SELECT * 
INTO JCs..INC0246925_Notice4
FROM #tmp4


SELECT * 
INTO JCs..INC0246925_Notice5
FROM #tmp5





SELECT --COUNT(*)
        DISTINCT L.NUMBER_TX ,
        BIC_NAME_TX ,
        RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,  IH.TYPE_CD, IH.EFFECTIVE_DT,
       N.NAME_TX , N.REFERENCE_ID_TX
	--   TOP 65000 N.ID INTO #tmp1
INTO JCs..INC0246925_NOTICE
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
		INNER JOIN dbo.NOTICE N ON N.LOAN_ID = L.ID
        LEFT JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
                                                AND IH.TYPE_CD = 'NOTICE'
        INNER JOIN REQUIRED_COVERAGE RC ON IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]',
                                                              'varchar (50)') = RC.ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
		
WHERE   OP.BIC_NAME_TX LIKE '%GEICO%'
        AND RC.INSURANCE_STATUS_CD <> 'F'
		AND op.EFFECTIVE_DT >= '2016-03-28 '