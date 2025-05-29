USE UniTrac


-------------- Work Item ID Number(s) should be provided on HDT
----Backup WI
SELECT  *
INTO UniTracHDStorage..INC0XXXXX
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (XXXXXXXX )

--Pull up process log ID (in the relate id column)
SELECT  RELATE_ID INTO #tmpPL
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (56358079  )


--Create a temp table for notices and certs 
select RELATE_ID INTO #tmpN from process_log_item PLI
where PLI.process_log_ID iN (SELECT * FROM #tmpPL) and relate_type_cd IN ('Allied.UniTrac.Notice')

select RELATE_ID INTO #tmpFPC from process_log_item PLI
where PLI.process_log_ID iN (SELECT * FROM #tmpPL) and relate_type_cd IN ('Allied.UniTrac.ForcePlacedCertificate')

---Check to see if there are any errors (as long as the tmp tables are created 
--from above the following queries will not need to be modified)
SELECT *FROM dbo.NOTICE
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD IN ('NT' , 'ERR')

SELECT COUNT(*)  FROM dbo.FORCE_PLACED_CERTIFICATE
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD IN ('NT' , 'ERR')
 
---If any backup Notices

select *
--INTO UniTracHDStorage..INC0346738_Notice
 from notice
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD IN ('NT' , 'ERR')


select *
INTO UniTracHDStorage..INC0346738_FORCE_PLACED_CERTIFICATE
 from FORCE_PLACED_CERTIFICATE
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD IN ('NT' , 'ERR')


--update to the appropriate template them out


update N
set template_id = '135', lock_id = lock_id+1, update_dt = getdate(), update_user_tx = 'INC0443450', PDF_GENERATE_CD ='PEND'
--select *
 from notice N
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'NT'


update FPC
set template_id = '', lock_id = lock_id+1, update_dt = getdate(), update_user_tx = 'INC0XXXXX', PDF_GENERATE_CD ='PEND'
--select *
 from dbo.FORCE_PLACED_CERTIFICATE FPC
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD = 'ERR'




select PDF_GENERATE_CD,*
 from notice N
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'PEND'
