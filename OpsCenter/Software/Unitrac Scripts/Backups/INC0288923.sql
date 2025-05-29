USE UniTrac


-------------- Work Item ID Number(s) should be provided on HDT
----Backup WI
SELECT  *
INTO UniTracHDStorage..INC0288923
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (38101021  )

--Pull up process log ID (in the relate id column)
SELECT  *
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (38101021 )


--Create a temp table for notices and certs 
select RELATE_ID INTO #tmpN from process_log_item PLI
where PLI.process_log_ID iN (42998115) and relate_type_cd IN ('Allied.UniTrac.Notice')

select RELATE_ID INTO #tmpFPC from process_log_item PLI
where PLI.process_log_ID iN (42998115) and relate_type_cd IN ('Allied.UniTrac.ForcePlacedCertificate')

---Check to see if there are any errors (as long as the tmp tables are created 
--from above the following queries will not need to be modified)
SELECT COUNT(*) FROM dbo.NOTICE
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD = 'ERR'

SELECT COUNT(*)  FROM dbo.FORCE_PLACED_CERTIFICATE
WHERE ID IN (SELECT * FROM #tmpFPC) AND PDF_GENERATE_CD = 'ERR'

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
        UPDATE_USER_TX = 'INC0288923'
--SELECT *
FROM Work_item WI
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0288923 )
		  AND WORKFLOW_DEFINITION_ID = 9


		  
	SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
        CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,LAST_SCHEDULED_DT, LAST_RUN_DT, * FROM dbo.PROCESS_DEFINITION
		  WHERE NAME_TX LIKE '%3035%' AND PROCESS_TYPE_CD = 'CYCLEPRC'
		  AND EXECUTION_FREQ_CD <> 'RUNONCE'


		  SELECT * FROM dbo.PROCESS_LOG
		  WHERE PROCESS_DEFINITION_ID IN (14557,14558,14560)
		  AND UPDATE_DT >= '2017-03-22 ' AND STATUS_CD = 'Complete'

		  --,14558,14559,14560
		  
		  SELECT * FROM dbo.PROCESS_DEFINITION
		  WHERE NAME_TX LIKE '%5350%' AND PROCESS_TYPE_CD = 'CYCLEPRC'
		  AND EXECUTION_FREQ_CD <> 'RUNONCE'

		   
		  SELECT * FROM dbo.PROCESS_DEFINITION
		  WHERE NAME_TX NOT LIKE '%3035%' AND PROCESS_TYPE_CD = 'CYCLEPRC'
		  AND EXECUTION_FREQ_CD <> 'RUNONCE' AND DAYS_OF_WEEK_XML IS NOT NULL
		  AND ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N'


		  		  
	SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,LAST_RUN_DT,
        CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] , *
								   --INTO UniTracHDStorage..INC0288923_2
								    FROM dbo.PROCESS_DEFINITION
		  WHERE NAME_TX LIKE '%3035%' AND PROCESS_TYPE_CD = 'CYCLEPRC'
		  AND EXECUTION_FREQ_CD <> 'RUNONCE'

UPDATE PD
SET PD.LAST_RUN_DT = PS.LAST_RUN_DT
--SELECT PD.LAST_RUN_DT, PS.LAST_RUN_DT, * 
FROM dbo.PROCESS_DEFINITION PD
JOIN UniTracHDStorage..INC0288923_2 PS ON PD.ID = PS.ID 




SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (43403047,43426862,43403148,43426969,43403048,43427129)



SELECT * FROM dbo.OUTPUT_BATCH
WHERE id IN (1292933, 1294415)