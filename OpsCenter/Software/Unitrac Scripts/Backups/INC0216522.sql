-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID


SELECT *
INTO UniTracHDStorage..INC0216522
FROM    UniTrac..WORK_ITEM
WHERE  WORKFLOW_DEFINITION_ID = '8'
AND CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '7530'
--AND CONTENT_XML.value('(/Content/Coverage/Type)[1]', 'varchar (50)') = 'Equipment Loan'
AND STATUS_CD <> 'Withdrawn' AND STATUS_CD <> 'Complete' AND CURRENT_QUEUE_ID = '185'
AND PURGE_DT IS NULL



UPDATE dbo.WORK_ITEM
SET PURGE_DT = GETDATE()
--SELECT * FROM dbo.WORK_ITEM
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0216522)
--14417
