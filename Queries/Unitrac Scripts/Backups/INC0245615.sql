 SELECT RC.ID INTO #tmp FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('3155') AND RC.STATUS_CD = 'W'
AND RC.UPDATE_DT >= '2015-01-01 '
 
 
 
 
 
 SELECT L.NUMBER_TX ,
        L.BALANCE_AMOUNT_NO ,
        IH.ISSUE_DT ,
        RD.DESCRIPTION_TX [Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type], RC.TYPE_CD
		INTO JCs..INC0245615
 FROM   LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
        INNER JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
        LEFT JOIN dbo.REF_CODE RD ON RD.CODE_CD = RC.STATUS_CD
                                     AND RD.DOMAIN_CD = 'RequiredCoverageStatus'
        LEFT JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                      AND RC2.DOMAIN_CD = 'RecordType'
        LEFT JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                      AND RC3.DOMAIN_CD = 'LoanStatus'
        LEFT JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                      AND RC4.DOMAIN_CD = 'LoanType'
 WHERE  RC.ID IN (SELECT * FROM #tmp) AND 
       RC.STATUS_CD = 'W' AND IH.TYPE_CD = 'STATUSACTION'
        AND BALANCE_AMOUNT_NO <= '10000.01' 
		AND IH.ISSUE_DT >= '2015-01-01 ' --AND l.NUMBER_TX = '1146970300'
	 ORDER BY ih.ISSUE_DT DESC 
 


 