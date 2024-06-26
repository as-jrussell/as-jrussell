SELECT * FROM dbo.LENDER
WHERE CODE_TX IN ('2217', '3140')
				  

		SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    UniTrac..WORK_ITEM
WHERE    CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '2217'  AND WORKFLOW_DEFINITION_ID = '11'
--AND STATUS_CD NOT LIKE 'Complete' AND STATUS_CD NOT LIKE 'Withdrawn' AND STATUS_CD NOT LIKE 'ImportCompleted'
AND   CAST(UPDATE_DT AS DATE) > CAST(GETDATE()-5 AS DATE)


SELECT STATUS_CD,* FROM dbo.PROCESS_DEFINITION
WHERE ID IN (24008, 174959)



SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (24008, 174959)
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)




SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (28981841,28981861) 


SELECT * FROM dbo.ESCROW
WHERE ID IN (
SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (28981841,28981861) )

--UPDATE dbo.PROCESS_DEFINITION
--SET LOCK_ID = LOCK_ID +1, OVERRIDE_DT = '2015-12-04 00:00:00.000'
--WHERE ID IN (24008, 174959)


SELECT * FROM dbo.WORK_ITEM
WHERE WORKFLOW_DEFINITION_ID = '11' AND STATUS_CD = 'Initial'
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)


SELECT  CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)'), * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (SELECT PROCESS_LOG_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (28981841,28981861) )


SELECT * FROM dbo.USERS
WHERE ID IN (925,
925)

SELECT * FROM dbo.WORK_QUEUE
WHERE ID IN (158)