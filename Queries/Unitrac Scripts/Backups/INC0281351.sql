USE UniTrac


SELECT * FROM dbo.PROCESS_LOG
WHERE ID = '41373613'

SELECT * FROM dbo.PROCESS_LOG
WHERE ID = '41373821'



SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID  = '41373613'

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID  = '41373821'

SELECT * --INTO UniTracHDStorage..INC0281351
FROM dbo.UTL_MATCH_RESULT
WHERE ID IN (95525110)

SELECT * 
FROM dbo.UTL_MATCH_RESULT UTL
WHERE ID IN (95525110)



SELECT * FROM dbo.UTL_MATCH_RESULT
WHERE ID IN(100701315)


SELECT * FROM dbo.OWNER_POLICY
WHERE ID = 4288548201

SELECT * FROM loan
WHERE NUMBER_TX = 'IDR??184737558'

SELECT * FROM dbo.LENDER
WHERE ID = '3'