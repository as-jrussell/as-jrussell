-- GET THE WORK ITEM TO BE RE-OPENED
--- CHECK IF THE WI IS CLOSED AND IT RETURNS COUNT > 0
---- REPLACE XXXXXX WITH THE WORK ITEM ID
--REPLACE INC0xxxxx with ticket #
IF OBJECT_ID(N'tempdb..#TMPWI',N'U') IS NOT NULL
       DROP TABLE #TMPWI 

--- DROP TABLE #TMPWI
SELECT * INTO #TMPWI 
FROM WORK_ITEM
WHERE WORKFLOW_DEFINITION_ID = 11
AND STATUS_CD = 'Complete'
AND ID IN (XXXXXX)
AND PURGE_DT IS NULL
---- 1

--- GET THE ESCROW TXN FOR THE GIVEN WI
---- DROP TABLE #TMPWI
IF OBJECT_ID(N'tempdb..#TMPWI_01',N'U') IS NOT NULL
       DROP TABLE #TMPWI_01 

SELECT #TMPWI.ID AS WI_ID ,  ESC.REPORTED_DT , PLI.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]' , 'varchar(100)' ) AS USER_ACTION , 
 PLI.* , ESC.ID AS ESC_ID , ESC.STATUS_CD AS ESC_STATUS_CD , ESC.SUB_STATUS_CD AS ESC_SUB_STATUS_CD
 INTO #TMPWI_01
FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR 
 JOIN #TMPWI ON #TMPWI.id = WIPLIR.WORK_ITEM_ID			 
 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID	
 AND PLI.PURGE_DT IS NULL AND WIPLIR.PURGE_DT IS NULL	 
 JOIN ESCROW ESC  ON ESC.ID = PLI.RELATE_ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Escrow'	
 AND ESC.PURGE_DT IS NULL
ORDER BY ESC.REPORTED_DT
----32

--- GET THE TXN THAT ARE APPROVED/NO USER ACTION TAKEN TO 
IF OBJECT_ID(N'tempdb..#TMPWI_02',N'U') IS NOT NULL
       DROP TABLE #TMPWI_02 

---- DROP TABLE #TMPWI_02      
SELECT * 
INTO #TMPWI_02
FROM #TMPWI_01 WHERE ISNULL(USER_ACTION,'') IN ('APPROVE' , '')
----32

--- GET THE DATA IN PERM TEMP TABLE, AS REPORTED DATE NEEDS TO BE RESET BACK
---- replace xxxxx with WI ID
SELECT * 
INTO UnitracHDStorage.dbo.INC0xxxxx
FROM #TMPWI_02


---GET THE REPORTED DATE TO BE UPDATED
IF OBJECT_ID(N'tempdb..#TMPWI_03',N'U') IS NOT NULL
       DROP TABLE #TMPWI_03 

SELECT WI_ID ,  PROCESS_LOG_ID ,   MIN(CREATE_DT) AS NEW_REPORTED_DT
INTO #TMPWI_03
FROM #TMPWI_02
GROUP BY WI_ID , PROCESS_LOG_ID
---- 1

----- UPDATES
UPDATE WI SET STATUS_CD = 'Initial',
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'ESCWIREOPEN' , 
LOCK_ID = WI.LOCK_ID % 255 + 1
--- SELECT *
FROM WORK_ITEM  WI JOIN #TMPWI TMP ON TMP.ID = WI.ID
---- 1


UPDATE ESC SET REPORTED_DT = WI1.NEW_REPORTED_DT,
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'ESCWIREOPEN' , 
LOCK_ID = ESC.LOCK_ID % 255 + 1
--- SELECT  WI1.NEW_REPORTED_DT ,  *
FROM ESCROW ESC JOIN #TMPWI_02 WI ON 
WI.ESC_ID = ESC.ID
JOIN #TMPWI_03 WI1 ON WI1.WI_ID = WI.WI_ID
AND WI1.PROCESS_LOG_ID = WI.PROCESS_LOG_ID
----32
