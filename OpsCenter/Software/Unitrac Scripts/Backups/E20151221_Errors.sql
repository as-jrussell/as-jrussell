-------- Check for Process Definitions With Status Code Equal To Error
SELECT * --INTO UniTracHDStorage..E20151221_Errors
FROM UniTrac..PROCESS_DEFINITION
WHERE STATUS_CD = 'Error'

-------- Reset Process Definitions (All)
UPDATE  UniTrac..PROCESS_DEFINITION
SET     LAST_RUN_DT = GETDATE() ,
        LAST_SCHEDULED_DT = GETDATE() ,
        LOCK_ID = CASE WHEN LOCK_ID < 255 THEN LOCK_ID + 1
                       ELSE 1
                  END ,
        STATUS_CD = 'Complete'
--SELECT COUNT(*) FROM UniTrac..PROCESS_DEFINITION
WHERE   ACTIVE_IN = 'Y'
        AND STATUS_CD = 'Error'
		AND ID IN (XXXXX)

--------- Reset Process Definitions (Except Cycle)
UPDATE  UniTrac..PROCESS_DEFINITION
SET     LAST_RUN_DT = GETDATE() ,
        LAST_SCHEDULED_DT = GETDATE() ,
        LOCK_ID = CASE WHEN LOCK_ID < 255 THEN LOCK_ID + 1
                       ELSE 1
                  END ,
        STATUS_CD = 'Complete'
WHERE   ACTIVE_IN = 'Y'
        AND STATUS_CD = 'Error'
        and PROCESS_TYPE_CD <> 'CYCLEPRC'
