---UTL Match Setup Stuff!!!!!!!

------- Find the Lender ID
SELECT  *
FROM    UniTrac..LENDER
WHERE   CODE_TX = '3525'

----- Count the UTLs To Be Picked Up Initially
SELECT  *
FROM    UniTrac..UTL_QUEUE
WHERE   LENDER_ID = 2254 AND RECORD_TYPE_CD = 'U'

------ Count # of Loans (if want further review of Lender size)
----------- Loan Counts By Lender ----------
--Added AND ldr.CODE_TX = '2970' - (07/10/15) jcr
SELECT  ldr.ID AS UT_ID ,
        ldr.CODE_TX AS LENDER_ID ,
        ldr.NAME_TX AS LENDER_NAME ,
        COUNT(DISTINCT lon.ID) AS 'Loan Count'
--INTO    #ldr
FROM    LENDER ldr
        JOIN RELATED_DATA rd ON ldr.ID = rd.RELATE_ID
                                AND rd.VALUE_TX = 'UniTrac'
        JOIN RELATED_DATA_DEF rdd ON rd.DEF_ID = rdd.ID
                                     AND rdd.NAME_TX = 'TrackingSource'
                                     AND rdd.RELATE_CLASS_NM = 'Lender'
        JOIN dbo.LOAN lon ON ldr.ID = lon.LENDER_ID
WHERE   ldr.PURGE_DT IS NULL
        AND ldr.TEST_IN = 'N'
        AND ldr.CANCEL_DT IS NULL
        AND lon.STATUS_CD = 'A'
        AND lon.RECORD_TYPE_CD = 'G'
		AND ldr.CODE_TX = '4444'
GROUP BY ldr.ID ,
        ldr.CODE_TX ,
        ldr.NAME_TX

	SELECT * FROM dbo.PROCESS_DEFINITION
	WHERE UPDATE_USER_TX IN ('UBSMatchIn12', 'UBSMatchIn5', 'UBSMatchIn6')

	SELECT * FROM dbo.PROCESS_DEFINITION
	WHERE id = '3972'


	INSERT INTO PROCESS_DEFINITION (NAME_TX,DESCRIPTION_TX,EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,ONHOLD_IN,FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN)
SELECT 'UTLMatch Reprocess CAC','UTLMatch Reprocess CAC',EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,'N',GETDATE(),GETDATE(),'MsgSrvrEXTInfo',LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,'Y',FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN
FROM PROCESS_DEFINITION
WHERE ID = '266'


--UPDATE dbo.PROCESS_DEFINITION
--SET STATUS_CD = 'Complete'
SELECT * FROM dbo.PROCESS_DEFINITION
WHERE NAME_TX = 'UTLMatch Reprocess CAC'


SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID IN (258307, 38, 50)

SELECT * FROM dbo.WORK_ITEM
WHERE WORKFLOW_DEFINITION_ID = '8'


SELECT * FROM dbo.USERS
WHERE USER_NAME_TX LIKE 'UBSMatchIn%'


--UPDATE USERS
--SET SYSTEM_IN = 'Y', LOCK_ID = LOCK_ID + 1, PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg=='
----SELECT * FROM dbo.USERS
--WHERE ID = 2362


