USE UniTrac


--Finding WI via Number
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
--INTO UniTracHDStorage..INC0245542
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID IN (33390394)


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
VALUES  ( 33390394 , -- WORK_ITEM_ID - bigint
          N'Withdraw' , -- ACTION_CD - nvarchar(30)
          N'Initial' , -- FROM_STATUS_CD - nvarchar(20)
          N'Withdraw' , -- TO_STATUS_CD - nvarchar(20)
          215 , -- CURRENT_QUEUE_ID - bigint
          924 , -- CURRENT_OWNER_ID - bigint
          N'Withdraw per HDT' , -- ACTION_NOTE_TX - nvarchar(1000)
          'Y' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0245542' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        )



UPDATE dbo.WORK_ITEM
SET STATUS_CD = 'Withdrawn', UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1,
UPDATE_USER_TX = 'INC0245542', LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE WORK_ITEM_ID = '33390394')
WHERE ID = '33390394'


UPDATE dbo.WORK_ITEM_ACTION
SET ACTION_CD = 'Withdrawn', TO_STATUS_CD = 'Withdrawn'
--SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE ID = '70446319'
