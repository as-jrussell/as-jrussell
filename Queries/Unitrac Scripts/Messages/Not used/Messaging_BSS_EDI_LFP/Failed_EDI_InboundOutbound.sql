--------- EDI ERROR JOB FROM SQL ----------------------
--EDI

SET NOCOUNT ON
BEGIN 

DECLARE @ErrorMessage AS VARCHAR(100)
DECLARE @ErrorCount AS INT
DECLARE @CheckDuration as int--Minutes
SET @CheckDuration = -30

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

      SELECT @ErrorCount = count(DISTINCT MsgId) FROM #TMPMsg t  
      SELECT @ErrorMessage = 'The current error count is ' + CONVERT(VARCHAR(20), count(DISTINCT MsgId)) FROM #TMPMsg t   

	SELECT * FROM #TMPMsg

       DROP TABLE #TMPMsg

END 

----- Check for 10 Minute Scenario (MessageServer Not Working)
SELECT * FROM dbo.TRADING_PARTNER_LOG WHERE CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND PROCESS_CD = 'MS' ORDER BY CREATE_DT DESC 
  
  
SELECT * FROM dbo.TRADING_PARTNER_LOG WHERE MESSAGE_ID IN (3318150, 3318151, 3318176, 3318178, 3318180, 3303294, 3303295,
                3308911, 3308912) AND (LOG_TYPE_CD = 'ERROR' OR LOG_SEVERITY_CD = 'ERROR')
  
  
SELECT  *
FROM    dbo.MESSAGE (NOLOCK)
WHERE   ID IN ( 3318150, 3318151, 3318176, 3318178, 3318180, 3303294, 3303295,
                3308911, 3308912 )

SELECT * FROM dbo.MESSAGE WHERE PROCESSED_IN = 'N' AND RECEIVED_STATUS_CD = 'RCVD'

----- CHECK FOR RECORD
SELECT * FROM dbo.MESSAGE (NOLOCK) WHERE RELATE_ID_TX IN (2310533)

SELECT  *
FROM    dbo.[TRANSACTION] T ( NOLOCK )
        JOIN dbo.DOCUMENT D ( NOLOCK ) ON D.ID = T.DOCUMENT_ID
        JOIN dbo.MESSAGE M ( NOLOCK ) ON M.ID = D.MESSAGE_ID
WHERE   M.ID IN (918801)

--- RESET FOR PICK UP BY MESSAGE SERVER
UPDATE  dbo.MESSAGE
SET     RECEIVED_STATUS_CD = 'RCVD' ,
        PROCESSED_IN = 'N'
WHERE   ID IN ( 3318176, 3318178, 3318180 )

-----
SELECT * FROM dbo.DOCUMENT WHERE MESSAGE_ID IN (619822)


----- KILL THE MESSAGES IF XML MALFORMED -----------

--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 1272787 )

----- 5/20/13 HANGING EDI OUTBOUND MESSAGES --------
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 1182186,1184161,1184291 )

SELECT * FROM UniTrac..TRADING_PARTNER
WHERE ID = 1805

------ 2/3/2014 Progressing Insurance Malformed XML
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2003779,2003780 )

--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2005556,2005557 )

--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2006260,2006261 )

------ 2/24/2014 Progressing Insurance Malformed XML
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2074933,2074935 )

------ 12/15/2014 Peerless/Netherlands (TP #990)
UPDATE  dbo.[MESSAGE]
SET     PROCESSED_IN = 'Y' ,
        RECEIVED_STATUS_CD = 'PRSD'
WHERE   ID IN ( 3303294, 3303295, 3308911, 3308912, 3318150, 3318151 )






