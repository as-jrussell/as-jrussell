---------- Validate Work Item before making update
----REPLACE XXXXXXX WITH THE WI ID
----REPLACE INCXXXXXXX WITH TICKET NUMBER
SELECT * 
INTO UniTracHDStorage..INC0404797
FROM UniTrac..WORK_ITEM
WHERE ID IN (52797034 )

SELECT * FROM dbo.WORK_ITEM
WHERE  WORKFLOW_DEFINITION_ID = 7
AND UPDATE_DT >= '2017-06-27' AND STATUS_CD NOT IN ('Complete', 'Initial')

--------- Insert New Row in Work Item Action (for History Tracking)
----REPLACE XXXXXXX WITH THE THE WI ID

INSERT INTO dbo.WORK_ITEM_ACTION  ( WORK_ITEM_ID ,           ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        )
VALUES  ( 52797055  , N'Complete' , N'Initial' , N'Complete' , 5 , 738 ,  N'Manual Close Request HDT' , 'Y' ,  GETDATE() , NULL ,  GETDATE() , N'INC0404797' , 1 , 1 )


SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN (SELECT ID FROM UniTracHDStorage..INC0404797)


----Use Last WIA ID that was created for LAST_WORK_ITEM_ACTION_ID column 
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete', 
LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN ( 52797055  )),
UPDATE_DT = GETDATE(),LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0404797'
WHERE   ID IN (SELECT ID FROM UniTracHDStorage..INC0404797)
        AND WORKFLOW_DEFINITION_ID = 7
        AND ACTIVE_IN = 'Y'




---Verification

SELECT * 
FROM UniTrac..WORK_ITEM
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0404797)



/*
For Multiple work items if you accidentally update and then last WIA ID is the same this is easiest fix

UPDATE WI
SET WI.LAST_WORK_ITEM_ACTION_ID = WIA.ID
--SELECT WI.LAST_WORK_ITEM_ACTION_ID, WIA.ID, * 
FROM dbo.WORK_ITEM WI
JOIN dbo.WORK_ITEM_ACTION WIA ON WIA.WORK_ITEM_ID = WI.ID
WHERE WORK_ITEM_ID IN (SELECT ID FROM UniTracHDStorage..INCXXXXXXX)
AND ACTION_CD = 'Complete'

*/