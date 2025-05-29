---------- Validate Work Item before making update
----REPLACE XXXXXXX WITH THE THE WI ID
SELECT * FROM UniTrac..WORK_ITEM
WHERE ID IN (XXXXXXX)

---------- Run the update on specified Work Item IDs from HDT
----REPLACE XXXXXXX WITH THE THE WI ID
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Withdrawn'
WHERE   ID IN ( 26937362 )
       -- AND WORKFLOW_DEFINITION_ID = 7
        -- AND ACTIVE_IN = 'Y'

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
VALUES  ( 26937362 , -- WORK_ITEM_ID - bigint
          N'Withdrawn' , -- ACTION_CD - nvarchar(30)
          N'Withdrawn File' , -- FROM_STATUS_CD - nvarchar(20)
          N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
          5 , -- CURRENT_QUEUE_ID - bigint
          738 , -- CURRENT_OWNER_ID - bigint
          N'Manual Withdrawn Request team' , -- ACTION_NOTE_TX - nvarchar(1000)
          '' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'admin' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        )




		SELECT  * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN ( 26937362 )



UPDATE dbo.WORK_ITEM_ACTION
SET FROM_STATUS_CD = 'Withdrawn File', LOCK_ID = LOCK_ID+1
WHERE ID = '57243010'