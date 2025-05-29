--DROP TABLE #tmpRC

SELECT C.ID INTO #tmpC FROM dbo.COLLATERAL C 
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
WHERE L.LENDER_ID = '1084'


SELECT 
 ENTITY_ID, TO_VALUE_TX, FROM_VALUE_TX INTO #tmpCC 
FROM dbo.PROPERTY_CHANGE PC
JOIN dbo.COLLATERAL C ON C.ID = PC.ENTITY_ID AND PC.ENTITY_NAME_TX = 'Allied.UniTrac.Collateral'
LEFT JOIN dbo.PROPERTY_CHANGE_UPDATE PCU ON PC.ID = PCU.CHANGE_ID
WHERE PC.ENTITY_ID IN (SELECT * FROM #tmpC) AND PCU.COLUMN_NM = 'STATUS_CD' AND TO_VALUE_TX = 'A'

SELECT * INTO #tmpCCC
 FROM #tmpCC
WHERE FROM_VALUE_TX = 'Z'


SELECT DISTINCT
        L.NUMBER_TX [Loan Number] ,
        RC4.DESCRIPTION_TX [Collateral Status Old] ,
        RC3.DESCRIPTION_TX [Collateral Current Status] ,
		  RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC5.DESCRIPTION_TX [Loan Status] ,
        RC1.DESCRIPTION_TX [Loan Type] ,
		 LL.CODE_TX [Lender Code] ,
        LL.NAME_TX [Lender Name] ,LO.NAME_TX [Division] 
		INTO jcs..INC0274295
--SELECT COUNT(*)
FROM    #tmpCCC T
        JOIN dbo.COLLATERAL C ON T.ENTITY_ID = C.ID
        JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
        JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        JOIN dbo.LENDER_ORGANIZATION LO ON LO.CODE_TX = L.DIVISION_CODE_TX
                                           AND LO.TYPE_CD = 'DIV'
                                           AND LO.LENDER_ID = L.LENDER_ID
        JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = T.TO_VALUE_TX
                                 AND RC3.DOMAIN_CD = 'CollateralStatus'
        JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = T.FROM_VALUE_TX
                                 AND RC4.DOMAIN_CD = 'CollateralStatus'
		 INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = L.STATUS_CD
                                       AND RC5.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = L.TYPE_CD
                                       AND RC1.DOMAIN_CD = 'LoanType' 





