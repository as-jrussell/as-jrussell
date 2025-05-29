use UniTrac

--Work Item query to get process log IDs
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM WORK_ITEM
WHERE ID IN (XXXXXXX)
--WIA query to obtain Process Definition ID (In the ACTION_NOTE_TX)
SELECT *
FROM WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN (XXXXXXX) and ACTION_CD = 'Release For Billing'
--New Billing Processes
SELECT *
FROM PROCESS_DEFINITION
WHERE ID in (XXXXXXX)

--New Process Log IDs
SELECT *
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID in (XXXXXXX)

--PLI Table
SELECT *
FROM PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (XXXXXXX)

--Billing Group WIs

SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID = 'XXXXXXX'

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 'XXXXXXX'


update  dbo.WORK_ITEM 
set status_cd= 'Withdrawn'
--SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID = 'XXXXXXX'
and workflow_definition_id = 10

