USE UniTrac


-------------- Work Item ID Number(s) should be provided on HDT
----Backup WI
SELECT  *
INTO UniTracHDStorage..INC0395358
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (52126231  )

--Pull up process log ID (in the relate id column)
SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (52126231  )


--Create a temp table for notices and certs 
select RELATE_ID INTO #tmpN from process_log_item PLI
where PLI.process_log_ID iN (69115431) and relate_type_cd IN ('Allied.UniTrac.Notice')

select RELATE_ID INTO #tmpFPC from process_log_item PLI
where PLI.process_log_ID iN (69115431) and relate_type_cd IN ('Allied.UniTrac.ForcePlacedCertificate')

---Check to see if there are any errors (as long as the tmp tables are created 
--from above the following queries will not need to be modified)
SELECT COUNT(*) FROM dbo.NOTICE
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'ERR'

SELECT COUNT(*)  FROM dbo.FORCE_PLACED_CERTIFICATE
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD = 'ERR'

---If any backup Notices
/*
select *
INTO UniTracHDStorage..INC0395358_Notice
 from notice
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'ERR'


select *
INTO UniTracHDStorage..INC0395358_FORCE_PLACED_CERTIFICATE
 from FORCE_PLACED_CERTIFICATE
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD = 'ERR'
*/


--purge them out

/*
update N
set purge_dt= getdate(), lock_id = lock_id+1, update_dt = getdate(), update_user_tx = 'INC0395358'
--select *
 from notice N
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'ERR'


update FPC
set purge_dt= getdate(), lock_id = lock_id+1, update_dt = getdate(), update_user_tx = 'INC0395358'
--select *
 from dbo.FORCE_PLACED_CERTIFICATE FPC
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD = 'ERR'

*/



UPDATE  WI
SET     STATUS_CD = 'Withdrawn' ,
        PURGE_DT = GETDATE() ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0395358'
--SELECT *
FROM Work_item WI
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0395358 )
		  AND WORKFLOW_DEFINITION_ID = 9