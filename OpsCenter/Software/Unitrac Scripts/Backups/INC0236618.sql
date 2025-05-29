--------- WORK_ITEM DEFINITIONS ------------
--NAME_TX		WORKFLOW_DEFINITION_ID
--LenderExtract			1
--UTLMatch				2
--CPICancelPending		3
--KeyImage				4
--InboundCall			5
--OutboundCall			6
--ActionRequest			7
--VerifyData			8
--Cycle					9
--BillingGroup			10
--Escrow				11
--EOMReporting			12
--InsuranceBackfeed		13

-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
SELECT  *
--INTO UniTracHDStorage..INC0236618
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (31286272, 31286273, 31418136,31596750, 31665530 )

-------------- Find Work Items By Update User, Definition Type Create Date, and Lender 'LIKE' Name
SELECT * FROM UniTrac..WORK_ITEM
WHERE UPDATE_USER_TX = 'kharris'
AND WORKFLOW_DEFINITION_ID = 10
AND CREATE_DT > '2013-12-03'
AND CONTENT_XML.value('(/Content/Lender/Name)[1]', 'varchar (50)') LIKE 'Kirtland%' 
ORDER BY UPDATE_DT DESC

-------------- Find Work Items By Status, Create Date, and Definition Type and Lender Code
----REPLACE #### WITH THE Lender Code ID
SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   STATUS_CD = 'Complete'
        AND CREATE_DT > '2013-12-02'
        AND WORKFLOW_DEFINITION_ID = 10
        AND CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '####' 

-------------- Complete CPI Cancel Pending Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete'
--WHERE   ID IN ( XXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 3
--        AND ACTIVE_IN = 'Y'

-------------- Complete Key Image Work Items
UPDATE  dbo.WORK_ITEM
SET     STATUS_CD = 'Withdrawn' ,
        PURGE_DT = GETDATE() ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0236618'
WHERE   WORKFLOW_DEFINITION_ID = 4
		  AND ID IN (31286272, 31286273, 31418136,31596750, 31665530 )


---------- Clear OBC (- rows)
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        UPDATE_USER_TX = 'INC0######'
--WHERE   ID IN ( XXXXXXX, XXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 6
--        AND ACTIVE_IN = 'Y'


-------------- Complete Cycle Processing Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete'
--WHERE   ID IN ( XXXXXXX, XXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 9
--        AND ACTIVE_IN = 'Y'

------ Reopen Example for Cycle Process Work Item
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Initial' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'Admin'
--WHERE   ID = XXXXXXX
--        AND WORKFLOW_DEFINITION_ID = 9
--        AND ACTIVE_IN = 'Y'

-------------- Complete Billing Process Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete'
--WHERE   ID IN ( XXXXXXX, XXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 10
--        AND ACTIVE_IN = 'Y'

------ Reopen Example for Billing Work Item
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Initial' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'Admin'
--WHERE   ID IN ( XXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 10
--        AND ACTIVE_IN = 'Y'





SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID IN (31286272, 31286273, 31418136,31596750, 31665530 )



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
VALUES  ( 31286272 , -- WORK_ITEM_ID - bigint
          N'Withdrawn' , -- ACTION_CD - nvarchar(30)
          N'Initial' , -- FROM_STATUS_CD - nvarchar(20)
          N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
          5 , -- CURRENT_QUEUE_ID - bigint
          738 , -- CURRENT_OWNER_ID - bigint
          N'Manual Withdrawn Request HDT' , -- ACTION_NOTE_TX - nvarchar(1000)
          '' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0236618' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        ),

		( 31286273 , -- WORK_ITEM_ID - bigint
          N'Withdrawn' , -- ACTION_CD - nvarchar(30)
          N'Initial' , -- FROM_STATUS_CD - nvarchar(20)
          N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
          5 , -- CURRENT_QUEUE_ID - bigint
          738 , -- CURRENT_OWNER_ID - bigint
          N'Manual Withdrawn Request HDT' , -- ACTION_NOTE_TX - nvarchar(1000)
          '' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0236618' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        ),
		( 31418136, -- WORK_ITEM_ID - bigint
          N'Withdrawn' , -- ACTION_CD - nvarchar(30)
          N'Initial' , -- FROM_STATUS_CD - nvarchar(20)
          N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
          5 , -- CURRENT_QUEUE_ID - bigint
          738 , -- CURRENT_OWNER_ID - bigint
          N'Manual Withdrawn Request HDT' , -- ACTION_NOTE_TX - nvarchar(1000)
          '' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0236618' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        ),
		( 31596750, -- WORK_ITEM_ID - bigint
          N'Withdrawn' , -- ACTION_CD - nvarchar(30)
          N'Initial' , -- FROM_STATUS_CD - nvarchar(20)
          N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
          5 , -- CURRENT_QUEUE_ID - bigint
          738 , -- CURRENT_OWNER_ID - bigint
          N'Manual Withdrawn Request HDT' , -- ACTION_NOTE_TX - nvarchar(1000)
          '' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0236618' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        ),
		(31665530 , -- WORK_ITEM_ID - bigint
          N'Withdrawn' , -- ACTION_CD - nvarchar(30)
          N'Initial' , -- FROM_STATUS_CD - nvarchar(20)
          N'Withdrawn' , -- TO_STATUS_CD - nvarchar(20)
          5 , -- CURRENT_QUEUE_ID - bigint
          738 , -- CURRENT_OWNER_ID - bigint
          N'Manual Withdrawn Request HDT' , -- ACTION_NOTE_TX - nvarchar(1000)
          '' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0236618' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        )


	