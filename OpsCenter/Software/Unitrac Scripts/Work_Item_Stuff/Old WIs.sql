
SELECT  CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, 
CONTENT_XML.value('(/Content/Collateral/Type)[1]', 'varchar (50)') Collateral,
CONTENT_XML.value('(/Content/Property/Description)[1]', 'varchar (50)') Property, * 
--INTO UniTracHDStorage..INCXXXXXXX
FROM    WORK_ITEM
WHERE   RELATE_TYPE_CD = 'Allied.UniTrac.UTLMatchResult'
        AND RELATE_ID IN (
        SELECT  UTL_MATCH_RESULT.ID
        FROM    LOAN
                INNER JOIN COLLATERAL ON LOAN.ID = COLLATERAL.LOAN_ID-- AND COLLATERAL.PURGE_DT IS NULL
                INNER JOIN PROPERTY ON COLLATERAL.PROPERTY_ID = PROPERTY.ID
                INNER JOIN dbo.UTL_MATCH_RESULT ON PROPERTY.ID = UTL_MATCH_RESULT.PROPERTY_ID
                INNER JOIN LENDER ON LOAN.LENDER_ID = LENDER.ID
        WHERE   LENDER.CODE_TX = '####' AND WORK_ITEM.STATUS_CD NOT IN ('Complete', 'Withdrawn')
			   )

---Checking Verify Data, Cancel Pending , and Outbound WIs
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, 
CONTENT_XML.value('(/Content/Collateral/Type)[1]', 'varchar (50)') Collateral,
CONTENT_XML.value('(/Content/Property/Description)[1]', 'varchar (50)') Property, * 
--INTO UniTracHDStorage..INCXXXXXXX
FROM WORK_ITEM
WHERE WORKFLOW_DEFINITION_ID IN (3,6,8)  AND RELATE_TYPE_CD = 'Allied.UniTrac.RequiredCoverage' AND RELATE_ID IN (SELECT REQUIRED_COVERAGE.ID
FROM LOAN
INNER JOIN COLLATERAL ON LOAN.ID = COLLATERAL.LOAN_ID-- AND COLLATERAL.PURGE_DT IS NULL
INNER JOIN PROPERTY ON COLLATERAL.PROPERTY_ID = PROPERTY.ID
INNER JOIN REQUIRED_COVERAGE ON PROPERTY.ID = REQUIRED_COVERAGE.PROPERTY_ID
WHERE WORK_ITEM.STATUS_CD NOT IN ('Complete', 'Withdrawn')) AND WORK_ITEM.LENDER_ID = ''
ORDER BY WORK_ITEM.STATUS_CD ASC 


SELECT 
CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, 
CONTENT_XML.value('(/Content/Collateral/Type)[1]', 'varchar (50)') Collateral,
CONTENT_XML.value('(/Content/Property/Description)[1]', 'varchar (50)') Property, * 
--INTO UniTracHDStorage..INCXXXXXXX
FROM UniTrac..WORK_ITEM
WHERE LENDER_ID = ''
AND WORKFLOW_DEFINITION_ID IN (2,3,6,8)
AND WORK_ITEM.STATUS_CD NOT IN ('Complete', 'Withdrawn')
ORDER BY WORKFLOW_DEFINITION_ID ASC