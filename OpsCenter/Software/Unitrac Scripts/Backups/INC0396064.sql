USE UniTrac

--52014521    in all places is the WORK_ITEM_ID

-----Insert work item action 
INSERT dbo.WORK_ITEM_ACTION
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
VALUES  ( 52014521    , -- WORK_ITEM_ID - bigint
          N'Withdraw File' , -- ACTION_CD - nvarchar(30)
          N'Initial' , -- FROM_STATUS_CD - nvarchar(20)
          N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
         1 , -- CURRENT_QUEUE_ID - bigint
          142 , -- CURRENT_OWNER_ID - bigint
          N'per user ' , -- ACTION_NOTE_TX - nvarchar(1000)
          'Y' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
         NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'admin' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1 -- ACTION_USER_ID - bigint
        )





----Use Last WIA ID that was created for LAST_WORK_ITEM_ACTION_ID column 
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Withdrawn', PURGE_DT = GETDATE(),
LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN ( 52014521    )),
UPDATE_DT = GETDATE(),LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'admin'
--SELECT * FROM dbo.WORK_ITEM
WHERE   ID IN ( 52014521    )
        AND WORKFLOW_DEFINITION_ID = 1
        AND ACTIVE_IN = 'Y'