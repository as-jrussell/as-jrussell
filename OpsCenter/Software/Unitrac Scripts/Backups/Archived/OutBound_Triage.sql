------- What Status Codes Are Out There (Non-Purged)
SELECT DISTINCT
        APPLY_STATUS_CD AS 'Apply Status' ,
        COUNT(*) AS 'Count'
FROM    UniTrac..UTL_MATCH_RESULT
WHERE PURGE_DT IS NULL
GROUP BY APPLY_STATUS_CD

-------- Check the status of Process Definition
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'UTLMTCHOB'

------ Increase Outbound frequency (from 10MINUTE to MINUTE)
--UPDATE  UniTrac..PROCESS_DEFINITION
--SET     EXECUTION_FREQ_CD = 'MINUTE'
--WHERE   ID = 36
--        AND NAME_TX = 'UTLMatch OutBound'
--        AND PROCESS_TYPE_CD = 'UTLMTCHOB'

--10MINUTE

------ Turn off all InBound Services (for quiet)
------ and see Pend burn down to find culprit(s)
SELECT * FROM UniTrac..UTL_MATCH_RESULT
WHERE APPLY_STATUS_CD = 'PEND'
ORDER BY CREATE_DT DESC

------- See where the pendings are coming from (which service/source)
SELECT DISTINCT
        UPDATE_USER_TX ,
        MATCH_RESULT_CD,
        APPLY_STATUS_CD ,
        COUNT(*) AS 'Row Count'
FROM    UniTrac..UTL_MATCH_RESULT
WHERE   PURGE_DT IS NULL
AND APPLY_STATUS_CD IN ('PEND')
GROUP BY UPDATE_USER_TX ,
		MATCH_RESULT_CD,
        APPLY_STATUS_CD

-------- What are the current Match Result Codes (and corresponding Apply Status Codes)
SELECT DISTINCT
        MATCH_RESULT_CD ,
        APPLY_STATUS_CD ,
        COUNT(*)
FROM    UniTrac..UTL_MATCH_RESULT
WHERE   PURGE_DT IS NULL
GROUP BY MATCH_RESULT_CD ,
        APPLY_STATUS_CD

----------- Isolate Culprits
--UPDATE  UniTrac..UTL_MATCH_RESULT
--SET     APPLY_STATUS_CD = 'RHOLD'
--WHERE   ID IN (42647604, 42647603 ) 

SELECT * FROM UniTrac..UTL_MATCH_RESULT
WHERE ID IN (42647604, 42647603 )

SELECT * FROM UniTrac..PROPERTY
WHERE ID = 57114846





