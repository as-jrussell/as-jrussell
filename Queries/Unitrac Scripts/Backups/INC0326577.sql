USE UniTrac

SELECT  CONTENT_XML.value('(/Content/ProcessLog/Id)[1]', 'varchar (50)'), * FROM  dbo.WORK_ITEM
WHERE WORKFLOW_DEFINITION_ID = 13
AND RELATE_ID = 571446
ORDER BY ID DESC 

--SELECT * FROM dbo.PROCESS_LOG
--WHERE ID = 51304282

SELECT  CONTENT_XML.value('(/Content/ProcessLog/Id)[1]', 'varchar (50)'),* FROM dbo.WORK_ITEM
WHERE ID IN (41648633, 41634646, 41588589)

SELECT TOP 5 * FROM dbo.BORROWER_INSURANCE_COMPANY

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (51343085,
51342984,
51332339,
51307109,
51307014,
51304282,
51304282,51051053,
51236113,
51299262)
ORDER BY PROCESS_LOG_ID ASC 


SELECT * FROM dbo.DB_LOG