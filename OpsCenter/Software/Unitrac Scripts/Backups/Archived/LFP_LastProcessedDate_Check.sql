------ Check the Cycle Processing for Specific Lender (#### is LenderID in Process Definition Name)
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'CYCLEPRC'
AND NAME_TX LIKE '%1832%'
------ if this sql returns a date greater than the lastprocessed for the lender, than the lender will be reprocessed otherwise skipped
SELECT  TP.EXTERNAL_ID_TX ,
        MAX(CONVERT(DATETIME2, VALUE_TX)) AS VALUE_TX
FROM    RELATED_DATA RD
        JOIN RELATED_DATA_DEF RDD ON RDD.ID = RD.DEF_ID
        JOIN DELIVERY_INFO DI ON DI.ID = RD.RELATE_ID
        JOIN TRADING_PARTNER TP ON TP.ID = DI.TRADING_PARTNER_ID
WHERE   RDD.NAME_TX = 'LastMsgCompleted'
        AND TP.EXTERNAL_ID_TX IN ( '####')
GROUP BY EXTERNAL_ID_TX
ORDER BY VALUE_TX DESC

-------- ON ('####') ENTER IN ALL MANUAL LENDERS BY CODE_TX TO FIND LFP LAST COMPLETED DATE ---------