SET NOCOUNT ON
BEGIN 

DECLARE @ErrorMessage AS VARCHAR(100)
DECLARE @ErrorCount AS INT
DECLARE @CheckDuration as int--Minutes
SET @CheckDuration = -10

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

      SELECT @ErrorCount = count(DISTINCT MsgId) FROM #TMPMsg t  
      SELECT @ErrorMessage = 'The current error count is ' + CONVERT(VARCHAR(20), count(DISTINCT MsgId)) FROM #TMPMsg t   

	SELECT * FROM #TMPMsg ORDER BY MsgId

       DROP TABLE #TMPMsg

END 
