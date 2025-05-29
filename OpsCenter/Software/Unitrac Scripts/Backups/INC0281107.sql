USE UniTrac

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
--INTO UniTracHDStorage..INC0281107
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (36804398, 36804460, 36804468, 36804471 )

SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (41360973,
41361172,
41361197,
41361206) --AND STATUS_CD <> 'err'
AND RELATE_TYPE_CD ='Allied.UniTrac.ForcePlacedCertificate'


SELECT PDF_GENERATE_CD, * FROM dbo.NOTICE
WHERE id IN (21017262,21017264,21017265,21017266)


UPDATE dbo.NOTICE
SET PDF_GENERATE_CD = 'PEND', MSG_LOG_TX = NULL
WHERE id IN (21017262,
21017264,
21017265,
21017266)

SELECT PDF_GENERATE_CD,* FROM dbo.FORCE_PLACED_CERTIFICATE
WHERE ID IN (6136323,6136328,6136329)


UPDATE  dbo.FORCE_PLACED_CERTIFICATE
SET PDF_GENERATE_CD = 'PEND', MSG_LOG_TX = NULL
WHERE ID IN (6136323,6136328,6136329)






/*
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
*/

-------------- Complete CPI Cancel Pending Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INC0281107'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0281107 )
--        AND WORKFLOW_DEFINITION_ID = 3
--        AND ACTIVE_IN = 'Y'

-------------- Complete Key Image Work Items
--UPDATE  dbo.WORK_ITEM
--SET     STATUS_CD = 'Withdrawn' ,
--        PURGE_DT = GETDATE() ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INC0281107'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0281107 )
--		  AND WORKFLOW_DEFINITION_ID = 4



---------- Clear OBC (- rows)
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INC0281107'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0281107 )
--        AND WORKFLOW_DEFINITION_ID = 6
--        AND ACTIVE_IN = 'Y'


-------------- Complete Cycle Processing Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0281107'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0281107 )
        AND WORKFLOW_DEFINITION_ID = 9
        AND ACTIVE_IN = 'Y'

------ Reopen Example for Cycle Process Work Item
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Initial' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INC0281107X'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0281107 )
--        AND WORKFLOW_DEFINITION_ID = 9
--        AND ACTIVE_IN = 'Y'

-------------- Complete Billing Process Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INC0281107'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0281107 )
--        AND WORKFLOW_DEFINITION_ID = 10
--        AND ACTIVE_IN = 'Y'

------ Reopen Example for Billing Work Item
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Initial' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INC0281107'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0281107 )
--        AND WORKFLOW_DEFINITION_ID = 10
--        AND ACTIVE_IN = 'Y'


SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0281107 )