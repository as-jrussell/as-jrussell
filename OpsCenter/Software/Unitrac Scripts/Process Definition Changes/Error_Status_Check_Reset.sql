
USE UniTrac 
-------- Reset Process Definitions (All)
--UPDATE PROCESS_DEFINITION
SET     LAST_RUN_DT = GETDATE() ,
        LAST_SCHEDULED_DT = GETDATE() ,
        LOCK_ID = CASE WHEN LOCK_ID < 255 THEN LOCK_ID + 1
                       ELSE 1
                  END ,
        STATUS_CD = 'Complete'
	--	select * from UniTrac..PROCESS_DEFINITION
WHERE   STATUS_CD = 'Error'

--------- Reset Process Definitions (Except Cycle)
--UPDATE  UniTrac..PROCESS_DEFINITION
SET     LAST_RUN_DT = GETDATE() ,
        LAST_SCHEDULED_DT = GETDATE() ,
        LOCK_ID = CASE WHEN LOCK_ID < 255 THEN LOCK_ID + 1
                       ELSE 1
                  END ,
        STATUS_CD = 'Complete'
WHERE   ACTIVE_IN = 'Y'
        AND STATUS_CD = 'Error'
        and PROCESS_TYPE_CD <> 'CYCLEPRC'


-------  Reset Process Definition by Id

--UPDATE dbo.PROCESS_DEFINITION
SET ACTIVE_IN = 'Y', STATUS_CD = 'InQueue'
--SELECT STATUS_CD,* FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'GOODTHRUDT'
AND ID = XXXX



SELECT *
FROM dbo.PROCESS_LOG PL
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE CAST(PL.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE)
AND PL.PROCESS_DEFINITION_ID = 1656

SELECT *
FROM dbo.PROCESS_LOG PL
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PL.STATUS_CD = 'Error'
AND   CAST(PL.UPDATE_DT AS DATE) = CAST(GETDATE()-1AS DATE) and pl.update_user_tx <> 'UBSDist'

select * from UniTrac..PROCESS_DEFINITION
WHERE STATUS_CD = 'Error' AND ACTIVE_IN = 'Y'



--Lender Payment Increase Process



SELECT *
FROM vut..lkuVINLookup v
where vin= 'SAJWA01T85FN51900'