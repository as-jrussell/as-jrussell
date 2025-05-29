---------- Validate Work Item before making update
----REPLACE XXXXXXX WITH THE WI ID
----REPLACE INCXXXXXXX WITH TICKET NUMBER
SELECT * 
INTO UniTracHDStorage..INC0285289
FROM UniTrac..WORK_ITEM
WHERE ID IN (37566050)


--------- Insert New Row in Work Item Action (for History Tracking)
----REPLACE XXXXXXX WITH THE THE WI ID

INSERT INTO dbo.WORK_ITEM_ACTION
        ( WORK_ITEM_ID ,
          ACTION_CD ,
          FROM_STATUS_CD ,
          TO_STATUS_CD ,
          CURRENT_QUEUE_ID ,
          CURRENT_OWNER_ID ,
          ACTION_NOTE_TX ,
          ACTIVE_IN ,
          CREATE_DT ,
          PURGE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          ACTION_USER_ID
        )
VALUES  ( 37566050 , -- WORK_ITEM_ID - bigint
          N'Complete' , -- ACTION_CD - nvarchar(30)
          N'Initial' , -- FROM_STATUS_CD - nvarchar(20)
          N'Complete' , -- TO_STATUS_CD - nvarchar(20)
          5 , -- CURRENT_QUEUE_ID - bigint
          738 , -- CURRENT_OWNER_ID - bigint
          N'Manual Close Request HDT' , -- ACTION_NOTE_TX - nvarchar(1000)
          'Y' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0285289' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        )

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN (SELECT ID FROM UniTracHDStorage..INC0285289)






---Verification

SELECT * 
FROM UniTrac..WORK_ITEM
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INCXXXXXXX)
