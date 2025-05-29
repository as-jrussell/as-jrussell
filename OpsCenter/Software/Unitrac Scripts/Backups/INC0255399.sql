---------- Validate Work Item before making update
----REPLACE XXXXXXX WITH THE WI ID
----REPLACE INCXXXXXXX WITH TICKET NUMBER
SELECT * 
--INTO UniTracHDStorage..INCXXXXXXX
FROM UniTrac..WORK_ITEM
WHERE ID IN (34826586)


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
VALUES  ( 34826586 , -- WORK_ITEM_ID - bigint
          N'Complete' , -- ACTION_CD - nvarchar(30)
          N'Initial' , -- FROM_STATUS_CD - nvarchar(20)
          N'Complete' , -- TO_STATUS_CD - nvarchar(20)
          5 , -- CURRENT_QUEUE_ID - bigint
          738 , -- CURRENT_OWNER_ID - bigint
          N'Manual Close Request HDT' , -- ACTION_NOTE_TX - nvarchar(1000)
          '' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0255399' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        )


----Use Last WIA ID that was created for LAST_WORK_ITEM_ACTION_ID column 
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete', 
LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN ( 34826586 )),
UPDATE_DT = GETDATE(),LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0255399'
WHERE   ID IN ( 34826586 )
        AND ACTIVE_IN = 'Y'



		SELECT * FROM UniTracHDStorage..INC0255399