USE [UniTrac]
GO 

--Total Pending

SELECT  COUNT(*) TotalPending
FROM    report_history
WHERE   STATUS_CD = 'pend'


--Pending based on created date

SELECT  CAST(rh.create_dt AS DATE) CreateDate ,
        COUNT(*) AS TotalPending
FROM    REPORT_HISTORY RH
WHERE   RH.STATUS_CD = 'pend'
GROUP BY CAST(rh.create_dt AS DATE)
ORDER BY CAST(rh.create_dt AS DATE)


SELECT COUNT(*) [Report Errors]
FROM    REPORT_HISTORY
WHERE   STATUS_CD = 'err'
        AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
        AND GENERATION_SOURCE_CD = 'u'
        AND MSG_LOG_TX IS NOT NULL

--Total Completed
SELECT  COUNT(*) TotalCompleted
FROM    report_history
WHERE   STATUS_CD = 'COMP'
        AND CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)


-- Inbound (Message Server)


SELECT  COUNT(*) [USD Messages]
FROM    message M ( NOLOCK )
        JOIN TRADING_PARTNER TP ( NOLOCK ) ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
        JOIN DELIVERY_INFO DI ON M.DELIVERY_INFO_ID = DI.id
        JOIN RELATED_DATA RD ON DI.id = RD.RELATE_ID
        JOIN RELATED_DATA_DEF RDD ON RDD.id = RD.DEF_ID
        LEFT JOIN WORK_ITEM WI ON WI.RELATE_ID = M.ID
                                  AND WI.WORKFLOW_DEFINITION_ID = 1
WHERE   M.PROCESSED_IN = 'N' 
        AND M.RECEIVED_STATUS_CD = 'RCVD'
        AND M.MESSAGE_DIRECTION_CD = 'I'
        AND TYPE_CD = 'LFP_TP'
        AND RDD.NAME_TX = 'UniTracDeliveryType'
        AND TP.EXTERNAL_ID_TX NOT IN ( '2771', '3400', '1771', '1574', '5350' )
        AND m.DELIVER_TO_TRADING_PARTNER_ID = '2046'
        AND rd.VALUE_TX = 'IMPORT'
        AND M.PURGE_DT IS NULL



SELECT  COUNT(*) [Adhoc Messages]
FROM    message M ( NOLOCK )
        JOIN TRADING_PARTNER TP ( NOLOCK ) ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
        JOIN DELIVERY_INFO DI ON M.DELIVERY_INFO_ID = DI.id
        JOIN RELATED_DATA RD ON DI.id = RD.RELATE_ID
        JOIN RELATED_DATA_DEF RDD ON RDD.id = RD.DEF_ID
        LEFT JOIN WORK_ITEM WI ON WI.RELATE_ID = M.ID
                                  AND WI.WORKFLOW_DEFINITION_ID = 1
WHERE   M.PROCESSED_IN = 'N'
        AND M.RECEIVED_STATUS_CD = 'ADHOC' 
        AND M.MESSAGE_DIRECTION_CD = 'I'
        AND TYPE_CD = 'LFP_TP'
        AND RDD.NAME_TX = 'UniTracDeliveryType'
        AND TP.EXTERNAL_ID_TX NOT IN ( '2771', '3400', '1771', '1574', '5350' )
        AND m.DELIVER_TO_TRADING_PARTNER_ID = '2046'
        AND rd.VALUE_TX = 'IMPORT'
        AND M.PURGE_DT IS NULL

SELECT COUNT(*) [MSG Completed] 
FROM MESSAGE M
WHERE M.RECEIVED_STATUS_CD = 'RCVD' --AND UPDATE_USER_TX IN ('MsgSrvrEXTUSD' )
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND PROCESSED_IN = 'Y'


SELECT   COUNT(*) [MSG Errors] FROM MESSAGE M
                           WHERE    M.RECEIVED_STATUS_CD = 'ERR'
                  AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)



