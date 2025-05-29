--DROP TABLE #tmpRC
USE UniTrac

   IF OBJECT_ID('jcs..[InsuranceStatusChange20161220]') IS NOT NULL
	            DROP TABLE jcs..[InsuranceStatusChange]   
				
   IF OBJECT_ID('tempdb..#tmpRC') IS NOT NULL
	            DROP TABLE  #tmpRC



SELECT  ENTITY_ID, TO_VALUE_TX, FROM_VALUE_TX INTO #tmpRC FROM dbo.PROPERTY_CHANGE PC
LEFT JOIN dbo.PROPERTY_CHANGE_UPDATE PCU ON PC.ID = PCU.CHANGE_ID
WHERE PC.ENTITY_NAME_TX = 'Allied.UniTrac.RequiredCoverage' AND PCU.COLUMN_NM =	'INSURANCE_SUB_STATUS_CD' 
AND TO_VALUE_TX= 'R' AND PCU.CREATE_DT >= '2016-11-16 '
AND PCU.CREATE_DT <= '2016-11-23 '


SELECT DISTINCT
        LL.CODE_TX [Lender Code] ,
        LL.NAME_TX [Lender Name] ,
        L.NUMBER_TX ,
        OP.MOST_RECENT_MAIL_DT ,
        LO.NAME_TX [Division] ,
        RC4.DESCRIPTION_TX [Insurance Substatus Prior to Deployment] ,
        RC3.DESCRIPTION_TX [Insurance Substatus Post to Deployment] ,
        CONCAT(RC2.DESCRIPTION_TX, ' ', RC1.DESCRIPTION_TX) AS [Current Live Status]
		INTO jcs..[InsuranceStatusChange]
--SELECT COUNT(*)
FROM    #tmpRC T
        JOIN dbo.REQUIRED_COVERAGE RC ON T.ENTITY_ID = RC.ID
        JOIN dbo.PROPERTY P ON P.ID = RC.PROPERTY_ID
        JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
        JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
        JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
        JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        JOIN dbo.LENDER_ORGANIZATION LO ON LO.CODE_TX = L.DIVISION_CODE_TX
                                           AND LO.TYPE_CD = 'DIV'
                                           AND LO.LENDER_ID = L.LENDER_ID
        JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD
                                 AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
        JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = RC.INSURANCE_SUB_STATUS_CD
                                 AND RC2.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
        JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = T.TO_VALUE_TX
                                 AND RC3.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
        JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = T.FROM_VALUE_TX
                                 AND RC4.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
WHERE   OP.MOST_RECENT_MAIL_DT >= '2015-10-16 '
ORDER BY LO.NAME_TX ASC, op.MOST_RECENT_MAIL_DT ASC 




