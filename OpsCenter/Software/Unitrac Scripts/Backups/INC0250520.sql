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
--INTO UniTracHDStorage..INCXXXXXX
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( XXXXXXX, XXXXXXX )

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
SELECT  * into UniTracHDStorage..INC0250520
FROM    UniTrac..WORK_ITEM
WHERE   CREATE_DT < '2016-08-01'
        AND WORKFLOW_DEFINITION_ID = 6 AND STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')


select * from UniTracHDStorage..INC0250520     
*/

-------------- Complete CPI Cancel Pending Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INCXXXXXX'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 3
--        AND ACTIVE_IN = 'Y'

-------------- Complete Key Image Work Items
--UPDATE  dbo.WORK_ITEM
--SET     STATUS_CD = 'Withdrawn' ,
--        PURGE_DT = GETDATE() ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INCXXXXXX'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXX )
--		  AND WORKFLOW_DEFINITION_ID = 4



-------- Clear OBC (- rows)
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INC0250520'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0250520)
--        AND WORKFLOW_DEFINITION_ID = 6
--        AND ACTIVE_IN = 'Y'


-------------- Complete Cycle Processing Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INCXXXXXX'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 9
--        AND ACTIVE_IN = 'Y'

------ Reopen Example for Cycle Process Work Item
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Initial' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INCXXXXXX'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 9
--        AND ACTIVE_IN = 'Y'

-------------- Complete Billing Process Work Items
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Complete' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INCXXXXXX'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 10
--        AND ACTIVE_IN = 'Y'

------ Reopen Example for Billing Work Item
----REPLACE XXXXXXX WITH THE THE WI ID
--UPDATE  UniTrac..WORK_ITEM
--SET     STATUS_CD = 'Initial' ,
--        LOCK_ID = LOCK_ID + 1 ,
--        UPDATE_DT = GETDATE() ,
--        UPDATE_USER_TX = 'INCXXXXXX'
--WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INCXXXXXX )
--        AND WORKFLOW_DEFINITION_ID = 10
--        AND ACTIVE_IN = 'Y'


SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0250520 )




SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   CREATE_DT >= '2016-08-01'
        AND WORKFLOW_DEFINITION_ID = 6 AND STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')



		SELECT * FROM dbo.WORK_ITEM
		WHERE ID IN (33481885)


		SELECT * FROM dbo.WORK_ITEM_ACTION
		WHERE WORK_ITEM_ID = '33481885'


		SELECT * FROM dbo.INTERACTION_HISTORY
		WHERE RELATE_ID = '250297112'
		AND RELATE_CLASS_TX = 'Allied.UniTrac.OutboundCallInteraction'


		SELECT IH.* FROM dbo.LOAN L
		JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
		JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = C.PROPERTY_ID
		WHERE NUMBER_TX = '800369715'


		SELECT * FROM dbo.WORK_ITEM
		WHERE ID = '33008584'

		SELECT SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar (50)'), * 
		--SELECT COUNT(*)
		FROM dbo.INTERACTION_HISTORY
		WHERE SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar (50)') = 'Reject' AND 
		CREATE_DT <= '2016-08-01 ' AND TYPE_CD = 'OUTBNDCALL'




	SELECT ID INTO #TMP
		--SELECT COUNT(*)
		FROM dbo.INTERACTION_HISTORY 
		WHERE  TYPE_CD = 'OUTBNDCALL' AND CREATE_DT >= '2016-08-01 ' AND  SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar (50)') = 'Reject'
		--2094


		SELECT *
		--INTO UniTracHDStorage..INC0250520_2
		 FROM dbo.WORK_ITEM
		WHERE RELATE_ID IN (SELECT * FROM #TMP)
		AND WORKFLOW_DEFINITION_ID = '6' AND STATUS_CD = 'Initial'
		--1076


	SELECT * FROM dbo.WORK_ITEM
	WHERE ID IN (33008543,33008544,33008546,33008547,33008548,33008551,33008553,33008568,33008569)



		SELECT SPECIAL_HANDLING_XML.value('(/SH/ReviewStatus)[1]', 'varchar (50)'), * 
		--SELECT COUNT(*)
		FROM dbo.INTERACTION_HISTORY
		WHERE ID IN (244905209244905216,
244905262,
244905285,
244905291,
244905326,
244905346,
244905522,
244905531)



SELECT * FROM UniTracHDStorage..INC0250520_2



UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0250520'
--SELECT * FROM UniTrac..WORK_ITEM
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0250520_2)
        AND WORKFLOW_DEFINITION_ID = 6
        AND ACTIVE_IN = 'Y'