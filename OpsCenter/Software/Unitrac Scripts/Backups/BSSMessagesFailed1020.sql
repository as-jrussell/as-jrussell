--BSS
SET NOCOUNT ON
BEGIN 

DECLARE @ErrorMessage AS VARCHAR(100)
DECLARE @ErrorCount AS INT
DECLARE @CheckDuration as int--Minutes
SET @CheckDuration = -240

DECLARE @TPType VARCHAR(10)
SET @TPType = 'BSS_TP'

 
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
            AND MI.CREATE_DT <= (SELECT DATEADD(minute,@CheckDuration, getdate()))        

      INSERT INTO #TMPMsg    

      SELECT MI.ID
      FROM
            MESSAGE MI (NOLOCK)
            JOIN DELIVERY_INFO DI (NOLOCK) ON DI.ID = MI.DELIVERY_INFO_ID
            JOIN TRADING_PARTNER TP (NOLOCK) ON TP.ID = DI.TRADING_PARTNER_ID 
      WHERE
            TP.TYPE_CD = @TPType
            AND (MI.SENT_STATUS_CD = 'ERR' OR MI.RECEIVED_STATUS_CD = 'ERR')
            AND MI.CREATE_DT <= (SELECT DATEADD(minute,@CheckDuration, getdate()))       

 
        INSERT INTO #TMPMsg   

      SELECT MI.ID
      FROM
            MESSAGE MI (NOLOCK)
            JOIN DELIVERY_INFO DI (NOLOCK) ON DI.ID = MI.DELIVERY_INFO_ID
            JOIN TRADING_PARTNER TP (NOLOCK) ON TP.ID = DI.TRADING_PARTNER_ID 
      WHERE
            TP.TYPE_CD = @TPType
            AND PROCESSED_IN = 'N'
            AND MI.CREATE_DT <= (SELECT DATEADD(minute,@CheckDuration, getdate()))     
   

      SELECT TPL.RELATE_ID_TX 
      FROM TRADING_PARTNER_LOG TPL (NOLOCK) 
            JOIN [TRANSACTION] T (NOLOCK) ON T.id = TPL.RELATE_ID_TX 
            JOIN DOCUMENT D (NOLOCK) ON T.document_id = D.id 
            JOIN message M (NOLOCK) ON D.message_id = M.id 
            JOIN TRADING_PARTNER TP (NOLOCK) ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.id 
      WHERE T.STATUS_CD = 'ERR' 
           AND TP.TYPE_CD = 'BSS_TP' 
          AND TPL.CREATE_DT <= (SELECT DATEADD(minute,@CheckDuration, getdate()))        
          --AND CAST(TPL.CREATE_DT AS date) = CAST(GETDATE() AS date) 
          AND TPL.LOG_MESSAGE LIKE '%LenderTaxIDNotFoundException%' 


	  SELECT * FROM #TMPMsg
--*/

SELECT *  --INTO UniTracHDStorage..BSSMessage102015 
FROM dbo.MESSAGE WHERE id IN (SELECT DISTINCT MsgId FROM #TMPMsg) AND RECEIVED_STATUS_CD <> 'err'

SELECT * FROM UniTracHDStorage..BSSMessage102015

SELECT * --INTO UniTracHDStorage..BSSDocument102015
FROM dbo.DOCUMENT
WHERE MESSAGE_ID IN (SELECT ID FROM UniTracHDStorage..BSSMessage102015)


SELECT * FROM UniTracHDStorage..BSSDocument102015


SELECT * FROM dbo.MESSAGE
WHERE ID IN (4748870)

UPDATE dbo.MESSAGE
SET SENT_STATUS_CD = 'PEND'
WHERE ID IN (SELECT ID  --INTO UniTracHDStorage..BSSMessage102015 
FROM dbo.MESSAGE WHERE id IN (SELECT DISTINCT MsgId FROM #TMPMsg) AND SENT_STATUS_CD <> 'PEND')






 SELECT @ErrorCount = count(DISTINCT MsgId) FROM #TMPMsg t)  
--      SELECT @ErrorMessage = 'The current error count is ' + CONVERT(VARCHAR(20), count(DISTINCT MsgId)) FROM #TMPMsg t   

--       DROP TABLE #TMPMsg

END 

    --IF @ErrorCount > 100 
    --    BEGIN
    --        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-Monitor',
    --            @recipients = 'UT-Prod-SysAdmin@alliedsolutions.net',
    --            @subject = 'BSS WARNING MESSAGE: BSS Latency 4 Plus Hours',
    --            @body = @ErrorMessage
    --        RETURN
    --    END
