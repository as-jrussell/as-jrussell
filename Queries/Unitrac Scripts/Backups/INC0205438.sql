--Loan Search Details
SELECT TOP 10 *
FROM SEARCH_FULLTEXT

select TOP 10 *
from LOAN
WHERE LENDER_ID = 92 AND RECORD_TYPE_CD = 'G' AND CREATE_DT >= '2015-04-01'

SELECT *
FROM LENDER
WHERE ID = 968


SELECT TOP 5 * FROM dbo.CPI_QUOTE
SELECT TOP 5 * FROM dbo.CPI_ACTIVITY

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
select COLLATERAL.PROPERTY_ID, REQUIRED_COVERAGE.PROPERTY_ID, * from LOAN
INNER JOIN COLLATERAL ON LOAN.ID = COLLATERAL.LOAN_ID
INNER JOIN PROPERTY ON COLLATERAL.PROPERTY_ID = PROPERTY.ID
INNER JOIN REQUIRED_COVERAGE ON PROPERTY.ID = REQUIRED_COVERAGE.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE ON LOAN.ID = OWNER_LOAN_RELATE.LOAN_ID
INNER JOIN OWNER ON OWNER_LOAN_RELATE.OWNER_ID = OWNER.ID
INNER JOIN OWNER_ADDRESS ON OWNER.ADDRESS_ID = OWNER_ADDRESS.ID
WHERE LOAN.NUMBER_TX = '2179998' --AND LENDER_ID = 968


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'RecordType' AND CODE_CD IN ('D', 'G')

--LOAN HISTORY SEARCH INFORMATION
SELECT  *
FROM    INTERACTION_HISTORY
WHERE   PROPERTY_ID IN (29102754, 29102754, 29102754)


        --AND RELATE_CLASS_TX NOT LIKE 'Allied.UniTrac.Notice' 


SELECT  *
FROM    INTERACTION_HISTORY
WHERE   PROPERTY_ID IN (11794861, 11794861, 11794861, 11794861, 11794861, 11794861,  37700074 )


SELECT * FROM dbo.CPI_QUOTE
INNER JOIN dbo.CPI_ACTIVITY ON CPI_ACTIVITY.CPI_QUOTE_ID = CPI_QUOTE.ID
WHERE CPI_QUOTE.ID = '35344475'

SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID = '28394967'


 SELECT * FROM dbo.EVENT_SEQUENCE
WHERE EVENT_SEQ_CONTAINER_ID IN (SELECT ID FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '92' AND LENDER_PRODUCT_ID IN (2530,
2531))
AND EVENT_SEQUENCE.PURGE_DT IS NULL AND NOTICE_TYPE_CD IS NULL


SELECT * FROM dbo.EVENT_SEQUENCE
WHERE EVENT_SEQ_CONTAINER_ID IN (SELECT ID FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '92' AND LENDER_PRODUCT_ID IN (2530,
2531))
AND EVENT_SEQUENCE.PURGE_DT IS NULL AND EVENT_TYPE_CD NOT LIKE 'OBCL' --AND EVENT_TYPE_CD NOT LIKE 'NTC' 
AND NOTICE_TYPE_CD = 'CE'

SELECT * FROM dbo.REF_CODE
WHERE --DOMAIN_CD = 'EventSequenceEventType'

DOMAIN_CD = 'NoticeType'


SELECT * FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '92' AND LENDER_PRODUCT_ID IN (2530,
2531)

SELECT * FROM dbo.LENDER_PRODUCT
WHERE LENDER_ID = '92'


SELECT TOP 10 * FROM dbo.LENDER_PRODUCT
WHERE BASIC_TYPE_CD = 'TRKONLY'

SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'WNTC'

SELECT * FROM dbo.TEMPLATE
WHERE ID = '41'

SELECT * FROM dbo.LENDER_PRODUCT_CHANGE LP
INNER JOIN dbo.LENDER_PRODUCT_CHANGE LPC ON LPC.ID = LP.ID
INNER JOIN dbo.EVENT_SEQ_CONTAINER ESC ON ESC.LENDER_PRODUCT_ID = LP.ID
INNER JOIN dbo.EVENT_SEQUENCE ES ON ES.EVENT_SEQ_CONTAINER_ID = ESC.ID
WHERE LENDER_ID = '92' AND LENDER_PRODUCT_ID IN (2530,2531) AND ES.PURGE_DT IS NOT NULL





SELECT ESC.*, ES.*, LPC.* FROM dbo.LENDER_PRODUCT_CHANGE LPC 
INNER JOIN dbo.EVENT_SEQ_CONTAINER ESC ON ESC.LENDER_PRODUCT_ID = LPC.ID
INNER JOIN dbo.EVENT_SEQUENCE ES ON ES.EVENT_SEQ_CONTAINER_ID = ESC.ID
WHERE LENDER_ID = '92' AND LENDER_PRODUCT_ID IN (2530,2531) AND ES.PURGE_DT IS NULL


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'NoticeType'





SELECT TOP 10 * FROM dbo.LENDER_PRODUCT
WHERE BASIC_TYPE_CD = 'TRKONLY' AND UPDATE_DT >= GETDATE() - 15



SELECT * FROM dbo.EVENT_SEQUENCE
WHERE EVENT_SEQ_CONTAINER_ID IN (SELECT ID FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '593' AND LENDER_PRODUCT_ID IN (747, 754,744))

SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'NoticeType'


AND EVENT_SEQUENCE.PURGE_DT IS NOT NULL

SELECT * FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '593' AND LENDER_PRODUCT_ID IN (747, 754,744)




SELECT * FROM dbo.EVENT_SEQUENCE
WHERE EVENT_SEQ_CONTAINER_ID IN (SELECT ID FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '92' AND LENDER_PRODUCT_ID IN (2530,
2531))
AND EVENT_SEQUENCE.PURGE_DT IS NULL AND EVENT_TYPE_CD NOT LIKE 'OBCL' --AND EVENT_TYPE_CD NOT LIKE 'NTC' 
AND NOTICE_TYPE_CD = 'CE'



SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'NoticeType'


SELECT * FROM dbo.EVENT_SEQUENCE
WHERE EVENT_SEQ_CONTAINER_ID IN (SELECT ID FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '92' AND LENDER_PRODUCT_ID IN (2530,
2531)) AND NOTICE_TYPE_CD = 'CE'



SELECT * FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '92' AND LENDER_PRODUCT_ID IN (2530,
2531)


SELECT * FROM dbo.LENDER_PRODUCT
WHERE ID IN (2530,
2531)


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'TRKONLY'


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'Login_Count_NO'

SELECT * FROM dbo.USERS
WHERE USER_NAME_TX = 'jrussell'


SELECT DISTINCT NOTICE_TYPE_CD FROM dbo.EVENT_SEQUENCE
WHERE EVENT_SEQ_CONTAINER_ID IN (SELECT ID FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '92' AND LENDER_PRODUCT_ID IN (2530,
2531)) AND NOTICE_TYPE_CD = 'CE'



SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'NoticeType'





SELECT TOP 10 * FROM dbo.CPI_QUOTE



SELECT * FROM dbo.LOAN
WHERE NUMBER_TX IN ('2179998')

SELECT * FROM dbo.LENDER
WHERE ID = '92'



select P.ID,* from LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
WHERE L.NUMBER_TX = '2179998' AND L.LENDER_ID = 92


SELECT * FROM dbo.NOTICE WHERE ID IN (
SELECT RELATE_ID FROM dbo.INTERACTION_HISTORY
WHERE PROPERTY_ID IN (
11794861,
29102754,
37700074) AND RELATE_CLASS_TX = 'Allied.UniTrac.Notice')



SELECT * FROM dbo.CPI_QUOTE
WHERE ID IN (35344475)

SELECT TOP  5 * FROM dbo.EVENT_SEQUENCE



SELECT * FROM dbo.EVENT_SEQ_CONTAINER
WHERE LENDER_ID = '92'


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'R'


SELECT * FROM dbo.LENDER_PRODUCT_CHANGE LP
INNER JOIN dbo.LENDER_PRODUCT_CHANGE LPC ON LPC.ID = LP.ID
INNER JOIN dbo.EVENT_SEQ_CONTAINER ESC ON ESC.LENDER_PRODUCT_ID = LP.ID
INNER JOIN dbo.EVENT_SEQUENCE ES ON ES.EVENT_SEQ_CONTAINER_ID = ESC.ID
WHERE ESC.LENDER_ID = '92'