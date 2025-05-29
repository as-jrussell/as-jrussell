CREATE TABLE #tmpWI
    (
      RC_ID NVARCHAR(255) ,
      WI_ID NVARCHAR(255) ,
      RC_reason NVARCHAR(4000)
    )
INSERT INTO #tmpWI
        SELECT  RELATE_ID ,
                ID ,
                CONTENT_XML.value('(/Content/CancelCPIWorkflow/CancelReason/@meaning)[1]',
                                  'varchar (50)')
        FROM    dbo.WORK_ITEM
        WHERE   WORKFLOW_DEFINITION_ID = '3'
                AND LENDER_ID = '344'


CREATE TABLE #tmpIH
    (
      RC_ID NVARCHAR(255) ,
      RC_reason NVARCHAR(4000)
    )
INSERT INTO #tmpIH
SELECT IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'varchar (50)'), IH.SPECIAL_HANDLING_XML.value('(/SH/Status)[1]', 'varchar (50)')
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('1756') AND IH.TYPE_CD = 'CPI' AND 
IH.SPECIAL_HANDLING_XML.value('(/SH/Status)[1]', 'varchar (50)') LIKE '%cancel%'


SELECT T.*
INTO #tmpCPI
 FROM #tmpIH T
LEFT JOIN #tmpWI TT ON TT.RC_ID = T.RC_ID
WHERE TT.WI_ID IS NULL



SELECT  DISTINCT RC.TYPE_CD ,
        RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        L.EFFECTIVE_DT ,
        L.NUMBER_TX ,
        T.RC_reason
INTO    JCs..INC0271162
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
		INNER JOIN #tmpCPI T ON T.RC_ID = RC.ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.LENDER_PRODUCT LP ON LP.ID = RC.LENDER_PRODUCT_ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
