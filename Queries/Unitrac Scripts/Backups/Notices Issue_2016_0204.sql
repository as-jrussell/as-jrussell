USE UniTrac

SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '6'
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY UPDATE_DT DESC

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID = '6'

EXEC sp_who2 242


SELECT COUNT(*) FROM dbo.REPORT_HISTORY
WHERE STATUS_CD = 'PEND'
--503

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (30754470,30754334)

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE UPDATE_USER_TX = 'UBSDefault'


SELECT * FROM dbo.WORK_ITEM
WHERE ID IN (29359254 )

SELECT * FROM dbo.PROCESS_LOG
WHERE ID IN (30746046)

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (30763404)
AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice'


SELECT * FROM dbo.DOCUMENT_CONTAINER
WHERE RELATE_ID IN (
SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (30746046)
AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice')



SELECT * FROM dbo.DOCUMENT_CONTAINER
WHERE ID IN (52889397)


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE RELATE_ID IN (16237470)

SELECT * FROM dbo.PROCESS_LOG
WHERE ID IN (30754263)

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID IN (44791)



SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID IN (34, 35)


SELECT ID, PROCESS_DEFINITION_ID, START_DT, END_DT, STATUS_CD,UPDATE_USER_TX FROM dbo.PROCESS_LOG
WHERE UPDATE_USER_TX = 'UBSCycle3'
AND UPDATE_DT > '2016-02-03 16:00:00'
ORDER BY UPDATE_DT DESC


SELECT PROCESS_DEFINITION_ID, ID FROM dbo.PROCESS_LOG
WHERE ID IN (
SELECT DISTINCT PROCESS_LOG_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (SELECT ID FROM dbo.PROCESS_LOG
WHERE UPDATE_USER_TX = 'UBSCycle3'
AND UPDATE_DT > '2016-02-03 16:00:00')
AND PROCESS_LOG_ITEM.STATUS_CD = 'ERR')



SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (SELECT ID FROM dbo.PROCESS_LOG
WHERE UPDATE_USER_TX = 'UBSCycle3'
AND UPDATE_DT > '2016-02-03 16:00:00')
AND PROCESS_LOG_ITEM.STATUS_CD = 'ERR' AND PROCESS_LOG_ID = '30733042'


SELECT * FROM dbo.WORK_ITEM
WHERE ID IN (29349038)

SELECT * FROM dbo.BILLING_GROUP
WHERE ID IN (1448006)

SELECT * FROM dbo.LENDER
WHERE CODE_TX = '1913'


SELECT * FROM dbo.USERS
where ID IN (20, 1053)


SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)


SELECT *
FROM NOTICE
WHERE REFERENCE_ID_TX = '75040949030113' 



update NOTICE
set PDF_GENERATE_CD = 'PEND', MSG_LOG_TX = NULL,LOCK_ID = LOCK_ID + 1, UPDATE_DT = GETDATE()
WHERE id = '16237525'


SELECT * FROM UniTracHDStorage..PD6_20160203

SELECT * FROM dbo.PROCESS_LOG
WHERE UPDATE_USER_TX = 'UBSDefault'
AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY UPDATE_DT DESC

SELECT * FROM dbo.DOCUMENT_CONTAINER
WHERE UPDATE_DT > '2016-02-04 16:30:00' AND 
RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice'