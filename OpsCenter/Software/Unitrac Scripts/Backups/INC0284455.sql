USE UniTrac


--Finding WI via Number
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID IN (37488880)


--Process Log ID


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = '42109554'



SELECT * FROM dbo.WORK_QUEUE W
JOIN dbo.WORK_QUEUE_WORK_ITEM_RELATE WW ON WW.WORK_QUEUE_ID = W.ID
WHERE W.WORKFLOW_DEFINITION_ID = '9'



-------------- Work Item ID Number(s) should be provided on HDT
----Backup WI
SELECT  *
INTO UniTracHDStorage..INC0284455
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (37488880 )

--Pull up process log ID (in the relate id column)
SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (XXXXXXXX )


--Create a temp table for notices and certs 
select RELATE_ID INTO #tmpN from process_log_item PLI
where PLI.process_log_ID iN (42109554) and relate_type_cd IN ('Allied.UniTrac.Notice')

select RELATE_ID INTO #tmpFPC from process_log_item PLI
where PLI.process_log_ID iN (42109554) and relate_type_cd IN ('Allied.UniTrac.ForcePlacedCertificate')

---Check to see if there are any errors (as long as the tmp tables are created 
--from above the following queries will not need to be modified)
SELECT * FROM dbo.NOTICE
WHERE ID IN (SELECT * FROM #tmpN)  AND PDF_GENERATE_CD != 'COMP'

SELECT COUNT(*)  FROM dbo.FORCE_PLACED_CERTIFICATE
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD != 'COMP'

SELECT COUNT(*)  FROM dbo.NOTICE
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD != 'COMP'


SELECT * FROM dbo.NOTICE


---If any backup Notices
/*
select *
INTO UniTracHDStorage..INC0XXXXX_Notice
 from notice
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'ERR'


select *
INTO UniTracHDStorage..INC0XXXXX_FORCE_PLACED_CERTIFICATE
 from FORCE_PLACED_CERTIFICATE
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD = 'ERR'


*/

update N
set PDF_GENERATE_CD= 'PEND', lock_id = lock_id+1, update_dt = getdate(), update_user_tx = 'INC0284455', TEMPLATE_ID = '135'
--select *
 from notice N
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD != 'COMP'



