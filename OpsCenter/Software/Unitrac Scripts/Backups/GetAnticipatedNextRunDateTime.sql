USE QCModule
GO





SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 1  
ORDER BY UPDATE_DT DESC 



SELECT * FROM dbo.PROCESS_LOG
WHERE STATUS_CD = 'Error'
AND MSG_TX = 'GetAnticipatedNextRunDateTime, LastScheduledDate cannot be calculated, Reached the Threshold'
AND PURGE_DT IS NULL  AND 
CREATE_DT >= DateAdd(MINUTE, -75, getdate())


USE QCModule

SELECT PROCESS_DEFINITION_ID INTO #tmpPD FROM dbo.PROCESS_LOG
WHERE STATUS_CD = 'Error'
AND MSG_TX = 'GetAnticipatedNextRunDateTime, LastScheduledDate cannot be calculated, Reached the Threshold'
AND PURGE_DT IS NULL  AND 
CREATE_DT >= DateAdd(MINUTE, -75, getdate())

--SELECT * FROM #tmpPD


update PD set
STATUS_CD = 'Complete',
LAST_RUN_DT = DATEADD(n,-1,getdate()),
LAST_SCHEDULED_DT = DATEADD(n,1,getdate()),
ANTICIPATED_NEXT_SCHEDULED_DT = DATEADD(n,1,getdate())
--SELECT * 
FROM dbo.PROCESS_DEFINITION PD
where id IN (SELECT PROCESS_DEFINITION_ID FROM #tmpPD )



UPDATE PD SET PD.STATUS_CD = 'Error'
--SELECT * 
FROM dbo.PROCESS_DEFINITION PD 
WHERE ID IN (1)


INSERT	dbo.PROCESS_LOG
(
    PROCESS_DEFINITION_ID,
    START_DT,
    END_DT,
    STATUS_CD,
    MSG_TX,
    PURGE_DT,
    CREATE_DT,
    UPDATE_DT,
    UPDATE_USER_TX,
    LOCK_ID
)
VALUES
(   1,         -- PROCESS_DEFINITION_ID - bigint
    GETDATE(), -- START_DT - datetime
    GETDATE(), -- END_DT - datetime
    N'Error',       -- STATUS_CD - nvarchar(10)
    N'GetAnticipatedNextRunDateTime, LastScheduledDate cannot be calculated, Reached the Threshold',       -- MSG_TX - nvarchar(4000)
    NULL, -- PURGE_DT - datetime
    GETDATE(), -- CREATE_DT - datetime
    GETDATE(), -- UPDATE_DT - datetime
    N'suser',       -- UPDATE_USER_TX - nvarchar(15)
    1         -- LOCK_ID - tinyint
    )



	SELECT COUNT(ID)
FROM dbo.PROCESS_LOG
WHERE STATUS_CD = 'Error'
AND MSG_TX = ''
AND PURGE_DT IS NULL  AND 
CREATE_DT >= DateAdd(MINUTE, -75, getdate())