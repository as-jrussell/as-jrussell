-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID


SELECT TOP 5 CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, * --INTO UniTracHDStorage..INC0214615
FROM    UniTrac..WORK_ITEM
WHERE ID IN (28235515)


--REPLACE XXXXXXX WITH THE THE WI ID
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Initial' ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0214615'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0214615 )
        AND WORKFLOW_DEFINITION_ID = 11
        AND ACTIVE_IN = 'Y'


