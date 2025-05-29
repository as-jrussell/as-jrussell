--EDI
USE UniTrac

SET NOCOUNT ON
BEGIN 

DECLARE @ErrorMessage AS VARCHAR(100)
DECLARE @ErrorCount AS INT
DECLARE @CheckDuration as int--Minutes
SET @CheckDuration = -60

DECLARE @TPType VARCHAR(10)
SET @TPType = 'EDI_TP'

CREATE TABLE #TMPMsg ( MsgId BIGINT NOT NULL)        

        INSERT INTO #TMPMsg
      SELECT  MI.ID
      FROM
            MESSAGE MI (NOLOCK)
            JOIN DELIVERY_INFO DI (NOLOCK) ON DI.ID = MI.DELIVERY_INFO_ID
            JOIN TRADING_PARTNER TP (NOLOCK) ON TP.ID = DI.TRADING_PARTNER_ID  

      WHERE

            MI.ID NOT IN (SELECT RELATE_ID_TX
                           FROM
                                 MESSAGE MO (NOLOCK)
                           WHERE
                                 MO.MESSAGE_DIRECTION_CD = 'O') 

            AND MI.MESSAGE_DIRECTION_CD = 'I'
            AND MI.PROCESSED_IN = 'Y'
            AND MI.RECEIVED_STATUS_CD <> 'PRSD'
            AND TP.TYPE_CD = @TPType
            AND MI.CREATE_DT <= (SELECT DATEADD(minute,@CheckDuration, getdate())) AND MI.PURGE_DT IS NULL    

      INSERT INTO #TMPMsg  
      SELECT MI.ID
      FROM
            MESSAGE MI (NOLOCK)
            JOIN DELIVERY_INFO DI (NOLOCK) ON DI.ID = MI.DELIVERY_INFO_ID
            JOIN TRADING_PARTNER TP (NOLOCK) ON TP.ID = DI.TRADING_PARTNER_ID 
      WHERE
            TP.TYPE_CD = @TPType
            AND (MI.SENT_STATUS_CD = 'ERR' OR MI.RECEIVED_STATUS_CD = 'ERR')
            AND MI.CREATE_DT <= (SELECT DATEADD(minute,@CheckDuration, getdate()))  AND MI.PURGE_DT IS NULL         

         INSERT INTO #TMPMsg  
      SELECT MI.ID
      FROM
            MESSAGE MI (NOLOCK)
            JOIN DELIVERY_INFO DI (NOLOCK) ON DI.ID = MI.DELIVERY_INFO_ID
            JOIN TRADING_PARTNER TP (NOLOCK) ON TP.ID = DI.TRADING_PARTNER_ID 
      WHERE

            TP.TYPE_CD = @TPType
            AND PROCESSED_IN = 'N'
            AND MI.CREATE_DT <= (SELECT DATEADD(minute,@CheckDuration, getdate()))   AND MI.PURGE_DT IS NULL       
			SELECT * FROM #TMPMsg

SELECT * FROM dbo.MESSAGE
WHERE ID IN (SELECT * FROM #TMPMsg)

--      SELECT @ErrorCount = count(DISTINCT MsgId) FROM #TMPMsg t  
--      SELECT @ErrorMessage = 'The current error count is ' + CONVERT(VARCHAR(20), count(DISTINCT MsgId)) FROM #TMPMsg t   

       --DROP TABLE #TMPMsg

END 

    --IF @ErrorCount > 5 
    --    BEGIN
    --        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
    --            @recipients = 'UT-Prod-SysAdmin@alliedsolutions.net',
    --            @subject = 'EDI WARNING MESSAGE: EDI Error Submissions',
    --            @body = @ErrorMessage
    --        RETURN
    --    END
 
SELECT * FROM dbo.MESSAGE WHERE ID IN (SELECT * FROM #TMPMsg)

SELECT TOP 5 * FROM dbo.MESSAGE
WHERE RECIPIENT_TRADING_PARTNER_ID = '1991'
AND SENT_STATUS_CD <> 'ERR' AND PROCESSED_IN = 'N'
AND MESSAGE_DIRECTION_CD = 'o' AND PURGE_DT IS NULL

UPDATE dbo.MESSAGE
SET SENT_STATUS_CD = 'PEND', RECEIVED_STATUS_CD = 'INIT',
LOCK_ID = LOCK_ID+1, PROCESSED_IN = 'N'
--SELECT * FROM dbo.MESSAGE
WHERE ID IN (SELECT * FROM #TMPMsg)

