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
----Backup WI
SELECT  *
INTO UniTracHDStorage..INC0281925
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (36818749 )

--Pull up process log ID (in the relate id column)
SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (36818749 )



--Create a temp table for notices and certs 
select RELATE_ID INTO #tmpN from process_log_item PLI
where PLI.process_log_ID iN (41401098) and relate_type_cd IN ('Allied.UniTrac.Notice')

select RELATE_ID INTO #tmpFPC from process_log_item PLI
where PLI.process_log_ID iN (41401098) and relate_type_cd IN ('Allied.UniTrac.ForcePlacedCertificate')

---Check to see if there are any errors (as long as the tmp tables are created 
--from above the following queries will not need to be modified)
SELECT COUNT(*) FROM dbo.NOTICE
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'ERR'

SELECT COUNT(*)  FROM dbo.FORCE_PLACED_CERTIFICATE
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD = 'ERR'

---If any backup Notices
/*
select *
INTO UniTracHDStorage..INC0280585_Notice
 from notice
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'ERR'


select *
INTO UniTracHDStorage..INC0280585_FORCE_PLACED_CERTIFICATE
 from FORCE_PLACED_CERTIFICATE
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD = 'ERR'
*/


--purge them out

/*
update N
set purge_dt= getdate(), lock_id = lock_id+1, update_dt = getdate(), update_user_tx = 'INC0XXXXX'
--select *
 from notice N
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'ERR'


update FPC
set purge_dt= getdate(), lock_id = lock_id+1, update_dt = getdate(), update_user_tx = 'INC0XXXXX'
--select *
 from dbo.FORCE_PLACED_CERTIFICATE FPC
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD = 'ERR'

*/



UPDATE  WI
SET     STATUS_CD = 'Withdrawn' ,
        PURGE_DT = GETDATE() ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0281925'
--SELECT *
FROM Work_item WI
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0281925 )
		  AND WORKFLOW_DEFINITION_ID = 9