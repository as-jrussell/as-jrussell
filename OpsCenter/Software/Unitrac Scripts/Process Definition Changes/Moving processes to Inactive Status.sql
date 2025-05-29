use UniTrac


--Moving processes to Inactive Status
								
UPDATE  PD
SET    LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        ACTIVE_IN = 'N' ,
        ONHOLD_IN = 'Y'
--SELECT * 
FROM    dbo.PROCESS_DEFINITION PD
WHERE   ID IN ()