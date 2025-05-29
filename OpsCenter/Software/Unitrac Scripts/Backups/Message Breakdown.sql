USE UniTrac	



     SELECT ISNULL(COUNT(TP.EXTERNAL_ID_TX), 0) AS BSS_MSG_COUNT ,
            MAX(m.UPDATE_DT) AS Newest_Date ,
            MIN(m.UPDATE_DT) AS Oldest_Date
     FROM   message M 
            JOIN TRADING_PARTNER TP ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
            JOIN DELIVERY_INFO DI ON M.DELIVERY_INFO_ID = DI.id
            LEFT JOIN WORK_ITEM WI ON WI.RELATE_ID = M.ID
                                      AND WI.WORKFLOW_DEFINITION_ID = 1
     WHERE  M.PROCESSED_IN = 'N'
            AND M.RECEIVED_STATUS_CD NOT IN ( 'PRSD', 'ADHOC', 'HOLD' )
            AND M.MESSAGE_DIRECTION_CD = 'I'
            AND TYPE_CD = 'BSS_TP'
            AND M.PURGE_DT IS NULL
          --and TP.EXTERNAL_ID_TX not in ('2771', '3400', '1771', '1574', '5350')


SELECT MAX(M.UPDATE_DT) [Last BSS Message Completed]
     FROM   message M 
            JOIN TRADING_PARTNER TP ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
            JOIN DELIVERY_INFO DI ON M.DELIVERY_INFO_ID = DI.id
            LEFT JOIN WORK_ITEM WI ON WI.RELATE_ID = M.ID
                                      AND WI.WORKFLOW_DEFINITION_ID = 1
     WHERE  M.PROCESSED_IN = 'Y'
            AND M.RECEIVED_STATUS_CD NOT IN ( 'PRSD', 'ADHOC', 'HOLD' )
            AND M.MESSAGE_DIRECTION_CD = 'I'
            AND TYPE_CD = 'BSS_TP'
            AND M.PURGE_DT IS NULL