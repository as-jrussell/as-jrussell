SELECT * FROM UniTrac..TRADING_PARTNER
WHERE EXTERNAL_ID_TX in ('13100')

------------ Get Tax ID # for Lender in Question ------------------
SELECT * FROM UniTrac..LENDER
WHERE CODE_TX IN ('13100')

-------------- Check the Messages for Non-Processing ---------------
SELECT
      M.id AS 'InboundMessageId',
      M1.ID AS 'OutboundMessageId',
      T.id AS 'TransactionId',
      T.STATUS_CD AS 'TransactionStatus',
      T.CREATE_DT
FROM
      dbo.[TRANSACTION] T (NOLOCK)
      JOIN
      dbo.DOCUMENT D (NOLOCK)
            ON T.document_id = D.id
      JOIN
      dbo.message M (NOLOCK)
            ON D.message_id = M.id
      JOIN
      dbo.TRADING_PARTNER TP (NOLOCK)
            ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.id
      JOIN dbo.MESSAGE M1 ON M1.RELATE_ID_TX = M.ID
WHERE
      M.DELIVER_TO_TRADING_PARTNER_ID = 2046
      AND M.MESSAGE_DIRECTION_CD = 'I'
      AND M1.MESSAGE_DIRECTION_CD = 'O'
      AND M.CREATE_DT >= (GETDATE() - 120)
      AND TP.TYPE_CD IN ('EDI_TP', 'IDR_TP', 'BSS_TP')
      AND T.STATUS_CD <> 'SENT'
      AND T.DATA.value('(/Transaction/InsuranceDocument/LienHolder/@Id)[1]', 'varchar(20)') = '310568628'
ORDER BY
      M.CREATE_DT DESC
      
---------- Set Re-Process Transactions and Messages, then Watch UTL_QUEUE
--BEGIN

--    SELECT  M.ID AS 'InboundMessageId' ,
--            M1.ID AS 'OutboundMessageId' ,
--            T.ID AS 'TransactionId' ,
--            T.STATUS_CD AS 'TransactionStatus'
--    INTO    #TMP_STATUS
--    FROM    dbo.[TRANSACTION] T ( NOLOCK )
--            JOIN dbo.DOCUMENT D ( NOLOCK ) ON T.DOCUMENT_ID = D.ID
--            JOIN dbo.Message M ( NOLOCK ) ON D.MESSAGE_ID = M.ID
--            JOIN dbo.TRADING_PARTNER TP ( NOLOCK ) ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
--            JOIN dbo.Message M1 ON M1.RELATE_ID_TX = M.ID
--    WHERE   M.DELIVER_TO_TRADING_PARTNER_ID = 2046
--            AND M.MESSAGE_DIRECTION_CD = 'I'
--            AND M1.MESSAGE_DIRECTION_CD = 'O'
--            AND M.CREATE_DT >= ( GETDATE() - 120 )
--            AND TP.TYPE_CD IN ( 'EDI_TP', 'IDR_TP', 'BSS_TP' )
--            AND T.STATUS_CD <> 'SENT'
--            AND T.DATA.value('(/Transaction/InsuranceDocument/LienHolder/@Id)[1]',
--                             'varchar(20)') = '310568628'
--    ORDER BY M.CREATE_DT DESC

--    UPDATE  [TRANSACTION]
--    SET     STATUS_CD = 'INIT' ,
--            PROCESSED_IN = 'N'
--    WHERE   ID IN ( SELECT  ts.TransactionID
--                    FROM    #TMP_STATUS ts )

--    UPDATE  Message
--    SET     RECEIVED_STATUS_CD = 'INIT' ,
--            SENT_STATUS_CD = 'PEND' ,
--            PROCESSED_IN = 'N'
--    WHERE   ID IN ( SELECT  ts.OutboundMessageId
--                    FROM    #TMP_STATUS ts )

 

--END

--GO

----------- Checkee UTL Queueeee ---------------
SELECT * FROM UniTrac..UTL_QUEUE
WHERE LENDER_ID = 2100
AND EVALUATION_DT < '2014-09-10 09:28:20.873'
      

      

SELECT * FROM UniTrac..[TRANSACTION] WHERE ID = 57568008

SELECT * FROM UniTrac..DOCUMENT WHERE ID = 5960250