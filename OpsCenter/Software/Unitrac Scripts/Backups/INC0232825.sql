-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
--Finding WI via CODE_TX
----REPLACE #### WITH THE THE Lender ID
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
--INTO UniTracHDStorage..INC0232825
FROM    UniTrac..WORK_ITEM
WHERE    --CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '####' 
 STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted', 'Error') AND PURGE_DT IS NULL
AND  WORKFLOW_DEFINITION_ID = '6' AND CHECKED_OUT_DT IS NOT NULL
 AND UPDATE_DT >= '2016-05-11 '



SELECT TOP 5 * FROM UniTracHDStorage..INC0232825



UPDATE dbo.WORK_ITEM
SET CHECKED_OUT_OWNER_ID = '0', CHECKED_OUT_DT = NULL, LOCK_ID = LOCK_ID+1,
UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0232825'
--SELECT * FROM dbo.WORK_ITEM
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0232825)


SELECT * FROM dbo.WORK_QUEUE
WHERE ID IN (231)