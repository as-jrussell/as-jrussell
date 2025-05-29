USE UniTrac


SELECT * FROM dbo.PROCESS_DEFINITION
WHERE NAME_TX LIKE '%1626%'


SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '13664'
AND UPDATE_DT >= '2017-01-01 '



SELECT RELATE_ID INTO #tmpN FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = '41117249' AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice'


SELECT DISTINCT
        L.NUMBER_TX [Loan Number], --ISNULL(RC.INSURANCE_STATUS_CD, 'No Issue')as [Owner Policy Status],
        RC2.DESCRIPTION_TX [Owner Policy Status] ,
        RC1.DESCRIPTION_TX [Coverage Insurance Status] ,
        N.EXPECTED_ISSUE_DT [Notice Expected Sent] ,
        N.NAME_TX [Type of Notice]
FROM    dbo.LOAN L
        JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
        JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
        JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
        JOIN dbo.NOTICE N ON N.LOAN_ID = L.ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
        LEFT JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        LEFT JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
        LEFT JOIN dbo.REF_CODE RC2 ON RC1.CODE_CD = RC.STATUS_CD
                                      AND RC1.DOMAIN_CD = 'OwnerPolicyStatus'
WHERE   N.ID IN ( SELECT    *
                  FROM      #tmpN )
