--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX ,
        C.*
		--INTO UniTracHDStorage..INC0214115
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
WHERE   C. ID IN (SELECT DISTINCT ID FROM UniTracHDStorage..INC0214115)
AND C.STATUS_CD <> 'A'  --AND L.STATUS_CD = 'U' 
        AND L.LENDER_ID IN ( 1863 )











SELECT DISTINCT RC.SUMMARY_STATUS_CD FROM REQUIRED_COVERAGE RC

SELECT * FROM dbo.REF_CODE WHERE CODE_CD IN  (
SELECT DISTINCT RC.SUMMARY_STATUS_CD FROM REQUIRED_COVERAGE RC) 
AND DOMAIN_CD = 'RequiredCoverageInsStatus'
ORDER BY DOMAIN_CD

SELECT *
FROM WORK_ITEM
WHERE id = 28085560  


SELECT T.ID
FROM
      dbo.[TRANSACTION] T
      JOIN dbo.DOCUMENT D ON T.document_id = D.id
WHERE D.message_id = 4936816 

SELECT LoanNumber_TX INTO UniTracHDStorage..TMPINC0214115
FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = 125733738 




SELECT * FROM dbo.LENDER
WHERE CODE_TX IN ('2268') 
 


 SELECT * FROM dbo.LOAN
 WHERE NUMBER_TX = '8471070-70'


SELECT TOP 5 CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    UniTrac..WORK_ITEM
WHERE  --RELATE_ID = '126618340'

SELECT * FROM  UniTrac..WORK_ITEM
  WHERE CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '2268'  AND WORKFLOW_DEFINITION_ID = '1'
AND STATUS_CD NOT LIKE 'Complete' AND STATUS_CD NOT LIKE 'Withdrawn' AND STATUS_CD NOT LIKE 'ImportCompleted'


 SELECT DATA.value('(/Transaction/@RelateId) [1]', 'varchar (50)')[ID for tblQueue],* FROM dbo.[TRANSACTION]
 WHERE DOCUMENT_ID IN (SELECT ID FROM dbo.DOCUMENT WHERE MESSAGE_ID IN (SELECT ID FROM dbo.MESSAGE  WHERE ID IN (4966960,
4966962,
4999120,
4999122)))

SELECT * FROM dbo.DOCUMENT
WHERE ID IN (11462065, 11462111, 11549272, 11549384)


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE ID IN (126618340,
126618361)


		SELECT * FROM dbo.LENDER_COLLATERAL_CODE_GROUP
		WHERE PURGE_DT IS NULL	AND LENDER_ID IN (1863)



		SELECT * FROM dbo.LENDER_COLLATERAL_GROUP_COVERAGE_TYPE
		WHERE LENDER_PRODUCT_ID IN (1832,
1833)


SELECT * FROM dbo.REF_CODE
WHERE DESCRIPTION_TX IN ('Archive', 'Deleted')
ORDER BY DOMAIN_CD


SELECT  C.STATUS_CD, RC.STATUS_CD, RC.SUMMARY_STATUS_CD, L.STATUS_CD, L.Id, L.NUMBER_TX,* from LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
WHERE L.LENDER_ID IN (1863) AND L.NUMBER_TX IN ('734600-46')








UPDATE dbo.COLLATERAL
SET STATUS_CD = 'A'
--SELECT COUNT(*) FROM dbo.COLLATERAL
WHERE ID IN (SELECT DISTINCT ID FROM UniTracHDStorage..INC0214115)
--7087