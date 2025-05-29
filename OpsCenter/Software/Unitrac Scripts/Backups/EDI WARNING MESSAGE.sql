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


			SELECT PROCESSED_IN, * FROM dbo.MESSAGE
			WHERE ID IN (
			SELECT * FROM #TMPMsg) AND PROCESSED_IN <> 'Y' AND PURGE_DT IS NULL
			-- AND RECEIVED_STATUS_CD= 'ERR'
			
			END 
		--	DROP TABLE #TMPMsg

		--6119975

			SELECT * FROM dbo.PROCESS_LOG
		WHERE PROCESS_DEFINITION_ID = '39'
		AND UPDATE_DT >= '2016-11-09 '
		

	