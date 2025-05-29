---------- Validate Work Item before making update
----REPLACE XXXXXXX WITH THE WI ID
----REPLACE INCXXXXXXX WITH TICKET NUMBER


SELECT  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)')[Lender], * 
INTO UniTracHDStorage..INC0250727
FROM dbo.WORK_ITEM WI
WHERE WORKFLOW_DEFINITION_ID = '7'
AND  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') IN ('6485' , '2815')
AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')

--------- Insert New Row in Work Item Action (for History Tracking)
----REPLACE XXXXXXX WITH THE THE WI ID

INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34228262 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34228044 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34227762 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34228005 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34273146 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34227812 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34228271 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34228071 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34228155 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34227732 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34227680 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)
INSERT INTO dbo.WORK_ITEM_ACTION        ( WORK_ITEM_ID ,          ACTION_CD ,          FROM_STATUS_CD ,          TO_STATUS_CD ,          CURRENT_QUEUE_ID ,          CURRENT_OWNER_ID ,          ACTION_NOTE_TX ,          ACTIVE_IN ,          CREATE_DT ,          PURGE_DT ,          UPDATE_DT ,          UPDATE_USER_TX ,          LOCK_ID ,          ACTION_USER_ID        ) VALUES (34227927 , N'Complete' , N'Initial' , N'Complete' , 5 , 738 , N'Manual Close Request HDT' , 'Y' , GETDATE() , NULL , GETDATE() , N'INC0250727' ,1 ,1)


SELECT ID FROM UniTracHDStorage..INC0250727

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID = 'XXXXXXX'


----Use Last WIA ID that was created for LAST_WORK_ITEM_ACTION_ID column 
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete', 
LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN ( SELECT ID FROM UniTracHDStorage..INC0250727 )),
UPDATE_DT = GETDATE(),LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0250727'
--SELECT * FROM dbo.WORK_ITEM
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0250727 )
        AND WORKFLOW_DEFINITION_ID = 7
        AND ACTIVE_IN = 'Y'

UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34228262)) WHERE   ID IN (34228262)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34228044)) WHERE   ID IN (34228044)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34227762)) WHERE   ID IN (34227762)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34228005)) WHERE   ID IN (34228005)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34273146)) WHERE   ID IN (34273146)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34227812)) WHERE   ID IN (34227812)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34228271)) WHERE   ID IN (34228271)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34228071)) WHERE   ID IN (34228071)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34228155)) WHERE   ID IN (34228155)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34227732)) WHERE   ID IN (34227732)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34227680)) WHERE   ID IN (34227680)
UPDATE UniTrac..WORK_ITEM SET LAST_WORK_ITEM_ACTION_ID = (SELECT MAX(ID) FROM dbo.WORK_ITEM_ACTION WHERE   WORK_ITEM_ID IN (34227927)) WHERE   ID IN (34227927)



SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE ID IN (71394087,
71394086,
71394079,
71394082,
71394088,
71394080,
71394078,
71394084,
71394085,
71394077,
71394083,
71394081)