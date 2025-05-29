USE UniTrac


 SELECT * FROM dbo.WORK_ITEM
 WHERE ID IN (31076773,30703147,30694205 )


 UPDATE dbo.WORK_ITEM
 SET STATUS_CD = 'Withdrawn', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0237080', PURGE_DT = GETDATE()
 WHERE ID IN (31076773,30703147,30694205 )


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
 VALUES  ( 31076773 , -- WORK_ITEM_ID - bigint
           N'Withdrawn' , -- ACTION_CD - nvarchar(30)
           N'Approve' , -- FROM_STATUS_CD - nvarchar(20)
           N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
           1 , -- CURRENT_QUEUE_ID - bigint
           142 , -- CURRENT_OWNER_ID - bigint
           N'Withdrawn per request INC0237080' , -- ACTION_NOTE_TX - nvarchar(1000)
           'Y' , -- ACTIVE_IN - char(1)
           GETDATE() , -- CREATE_DT - datetime
           NULL , -- PURGE_DT - datetime
           GETDATE() , -- UPDATE_DT - datetime
           N'INC0237080' , -- UPDATE_USER_TX - nvarchar(15)
           1 , -- LOCK_ID - tinyint
           1  -- ACTION_USER_ID - bigint
         ), ( 30703147 , -- WORK_ITEM_ID - bigint
           N'Withdrawn' , -- ACTION_CD - nvarchar(30)
           N'Approve' , -- FROM_STATUS_CD - nvarchar(20)
           N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
           1 , -- CURRENT_QUEUE_ID - bigint
           142 , -- CURRENT_OWNER_ID - bigint
           N'Withdrawn per request INC0237080' , -- ACTION_NOTE_TX - nvarchar(1000)
           'Y' , -- ACTIVE_IN - char(1)
           GETDATE() , -- CREATE_DT - datetime
           NULL , -- PURGE_DT - datetime
           GETDATE() , -- UPDATE_DT - datetime
           N'INC0237080' , -- UPDATE_USER_TX - nvarchar(15)
           1 , -- LOCK_ID - tinyint
           1  -- ACTION_USER_ID - bigint
         ), ( 30694205 , -- WORK_ITEM_ID - bigint
           N'Withdrawn' , -- ACTION_CD - nvarchar(30)
           N'Approve' , -- FROM_STATUS_CD - nvarchar(20)
           N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
           1 , -- CURRENT_QUEUE_ID - bigint
           142 , -- CURRENT_OWNER_ID - bigint
           N'Withdrawn per request INC0237080' , -- ACTION_NOTE_TX - nvarchar(1000)
           'Y' , -- ACTIVE_IN - char(1)
           GETDATE() , -- CREATE_DT - datetime
           NULL , -- PURGE_DT - datetime
           GETDATE() , -- UPDATE_DT - datetime
           N'INC0237080' , -- UPDATE_USER_TX - nvarchar(15)
           1 , -- LOCK_ID - tinyint
           1  -- ACTION_USER_ID - bigint
         )



		 SELECT * FROM dbo.WORK_ITEM_ACTION
		 WHERE WORK_ITEM_ID IN (31076773,30703147,30694205 )
		 ORDER BY WORK_ITEM_ID ASC  