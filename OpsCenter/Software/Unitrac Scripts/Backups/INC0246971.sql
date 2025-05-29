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
--INTO UniTracHDStorage..INC0246971 
FROM    UniTrac..WORK_ITEM
WHERE   ID  IN (33566109 )


SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE ID = '70223301'
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
--UPDATE  dbo.WORK_ITEM
--SET     STATUS_CD = 'Withdrawn' ,
--        PURGE_DT = GETDATE() ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'CLEANUP'
--WHERE   WORKFLOW_DEFINITION_ID = 4
--		  AND ID IN (XXXXXXX )


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
--SET     STATUS_CD = 'Initial' Initial,
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
--WHERE   ID IN IN (33568384 , 33566183 )
--        AND WORKFLOW_DEFINITION_ID = 10
--        AND ACTIVE_IN = 'Y'



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
VALUES  ( 33566109 , -- WORK_ITEM_ID - bigint
          N'Initial' , -- ACTION_CD - nvarchar(30)
          N'Error' , -- FROM_STATUS_CD - nvarchar(20)
          N'Initial' , -- TO_STATUS_CD - nvarchar(20)
          5 , -- CURRENT_QUEUE_ID - bigint
          738 , -- CURRENT_OWNER_ID - bigint
          N'Moved back to Initial' , -- ACTION_NOTE_TX - nvarchar(1000)
          '' , -- ACTIVE_IN - char(1)
          GETDATE() , -- CREATE_DT - datetime
          NULL , -- PURGE_DT - datetime
          GETDATE() , -- UPDATE_DT - datetime
          N'INC0246971 ' , -- UPDATE_USER_TX - nvarchar(15)
          1 , -- LOCK_ID - tinyint
          1  -- ACTION_USER_ID - bigint
        )




----Use Last WIA ID that was created for LAST_WORK_ITEM_ACTION_ID column 
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Initial', 
LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN ( 33566109 )),
UPDATE_DT = GETDATE(),LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0246971'
WHERE   ID IN ( 33566109 )
        AND ACTIVE_IN = 'Y'


SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID = '33566109'


				UPDATE dbo.PROCESS_LOG
		SET PURGE_DT = GETDATE(), LOCK_ID = LOCK_ID+1
		--SELECT * FROM dbo.PROCESS_LOG
		WHERE PROCESS_DEFINITION_ID IN (351706)

		UPDATE dbo.PROCESS_DEFINITION 
		SET STATUS_CD = 'Complete', LOCK_ID = LOCK_ID+1
		--SELECT * FROM dbo.PROCESS_DEFINITION
		WHERE ID IN (351706)



		SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (
SELECT DISTINCT RELATE_ID FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (36991358) 
AND RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup') AND WORKFLOW_DEFINITION_ID = '10'