USE UniTrac	

SELECT *
INTO UniTracHDStorage..INC0274282
 FROM dbo.WORK_ITEM
WHERE ID = '35561442'




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
VALUES  ( 35561442 , -- WORK_ITEM_ID - bigint
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
          N'INC0274282' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        )

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN (SELECT ID FROM UniTracHDStorage..INC0274282)


----Use Last WIA ID that was created for LAST_WORK_ITEM_ACTION_ID column 
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete', 
LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN ( 35561442 )),
UPDATE_DT = GETDATE(),LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0274282'
WHERE   ID IN (SELECT ID FROM UniTracHDStorage..INC0274282)
       AND ACTIVE_IN = 'Y'




---Verification

SELECT * 
FROM UniTrac..WORK_ITEM
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0274282)


SELECT L.NUMBER_TX, utl.* FROM dbo.UTL_MATCH_RESULT UTL 
JOIN dbo.LOAN L ON L.ID = UTL.LOAN_ID
JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE  LL.CODE_TX = '3769' AND 

UTL.ID = '91099329' 