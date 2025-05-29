-------- Check for Process Definitions With Status Code Equal To Error
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE STATUS_CD = 'Error'

-------- Reset Process Definitions (All)
UPDATE  UniTrac..PROCESS_DEFINITION
SET     LAST_RUN_DT = GETDATE() ,
        LAST_SCHEDULED_DT = GETDATE() ,
        LOCK_ID = CASE WHEN LOCK_ID < 255 THEN LOCK_ID + 1
                       ELSE 1
                  END ,
        STATUS_CD = 'Complete'
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


		SELECT * FROM UniTrac..PROCESS_LOG
		WHERE PROCESS_DEFINITION_ID = 30 AND UPDATE_DT >= '2016-05-04 03:00:00'
		AND UPDATE_DT <= '2016-05-04 03:15:00'


				SELECT * FROM UniTrac..PROCESS_LOG
		WHERE PROCESS_DEFINITION_ID = 30 AND UPDATE_DT >= '2016-05-10 20:00:00'



		SELECT * FROM dbo.PROCESS_LOG
		WHERE ID = '33608626'


		SELECT * FROM dbo.PROCESS_DEFINITION
		WHERE id = '30'

		SELECT * FROM UniTracHDStorage..[RPTGEN_backup2016_0510] 


		UPDATE PD
		SET PD.LOCK_ID = PD.LOCK_ID+1, PD.UPDATE_DT = GETDATE(), PD.SETTINGS_XML_IM = P.SETTINGS_XML_IM
		--SELECT * 
		FROM dbo.PROCESS_DEFINITION PD
		INNER JOIN UniTracHDStorage..[RPTGEN_backup2016_0510] p ON P.ID =Pd.ID 